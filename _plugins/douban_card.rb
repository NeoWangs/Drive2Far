# frozen_string_literal: true

require "cgi"
require "json"
require "net/http"
require "fileutils"
require "uri"

# Usage:
#   {% douban book 4894485 %}
#   {% douban movie 24745500 %}
#   {% douban music 35099703 %}
#
# Obsidian-friendly equivalent:
#   > [!douban] book 4894485
#   > [!douban]+ movie 24745500
#
# The tag fetches a subject only the first time it is rendered, then stores the
# parsed fields in .jekyll-cache/douban_cards.json. Delete that file (or set
# douban_card.refresh: true) to refresh every cached card.
# When cache_images is enabled (the default), its cover is downloaded into the
# post's same-named asset directory during the build.
module Jekyll
  module DoubanCard
    TYPES = {
      "book" => { host: "book.douban.com", label: "书名", status: "见字如晤" },
      "movie" => { host: "movie.douban.com", label: "电影名", status: "灯影绰约" },
      "music" => { host: "music.douban.com", label: "音乐名", status: "余音绕梁" }
    }.freeze
    CACHE_VERSION = 3
    OBSIDIAN_CALLOUT_PATTERN = /^>\s*\[!douban\][+-]?\s+(.+?)\s*$/i.freeze
    TAG_PATTERN = /\{%\s*douban\s+(.+?)\s*%\}/.freeze

    module_function

    def config(site)
      site.config.fetch("douban_card", {})
    end

    def parse_args(markup)
      args = markup.to_s.split
      type, subject_id = args
      unless args.length == 2 && TYPES.key?(type) && subject_id&.match?(/\A\d+\z/)
        raise Jekyll::Errors::FatalException,
              "douban 标签格式应为 {% douban book|movie|music SUBJECT_ID %}"
      end

      [type, subject_id]
    end

    def expand_obsidian_callouts(markdown)
      markdown.to_s.gsub(OBSIDIAN_CALLOUT_PATTERN) do
        type, subject_id = parse_args(Regexp.last_match(1))
        "{% douban #{type} #{subject_id} %}"
      end
    end

    def subject_url(type, subject_id)
      "https://#{TYPES.fetch(type).fetch(:host)}/subject/#{subject_id}/"
    end

    def cache_path(site)
      configured = config(site).fetch("cache_path", ".jekyll-cache/douban_cards.json")
      path = File.expand_path(configured, site.source)
      source = File.expand_path(site.source)
      unless path == source || path.start_with?("#{source}/")
        raise Jekyll::Errors::FatalException, "douban_card.cache_path 必须位于站点目录中"
      end

      path
    end

    def read_cache(site)
      path = cache_path(site)
      return {} unless File.file?(path)

      parsed = JSON.parse(File.read(path))
      return {} unless parsed.is_a?(Hash)

      cards = parsed.fetch("cards", {})
      return cards if parsed["version"] == CACHE_VERSION
      return migrate_v2_cards(cards) if parsed["version"] == 2

      {}
    rescue JSON::ParserError => error
      Jekyll.logger.warn("douban-card:", "忽略损坏的缓存 #{path} (#{error.message})")
      {}
    end

    def write_cache(site, cards)
      path = cache_path(site)
      FileUtils.mkdir_p(File.dirname(path))
      File.write(path, JSON.pretty_generate({ "version" => CACHE_VERSION, "cards" => cards }) + "\n")
    end

    # Version 2 stored the already-proxied cover URL. Keep that cache useful
    # after moving proxy selection to render time.
    def migrate_v2_cards(cards)
      cards.transform_values do |card|
        image = card["image"].to_s
        prefix = "https://images.weserv.nl/?url="
        image = URI.decode_www_form_component(image.delete_prefix(prefix)) if image.start_with?(prefix)
        card.merge("image" => image)
      end
    end

    def fetch_card(site, type, subject_id)
      key = "#{type}:#{subject_id}"
      cards = read_cache(site)
      cached = cards[key]
      return cached if cached && !config(site)["refresh"]

      Jekyll.logger.info("douban-card:", "抓取 #{type} #{subject_id}")
      card = parse_subject(
        fetch_html(site, subject_url(type, subject_id)),
        type,
        subject_id
      )
      cards[key] = card
      write_cache(site, cards)
      card
    rescue StandardError => error
      return cached if cached

      raise Jekyll::Errors::FatalException,
            "无法获取豆瓣 #{type} #{subject_id}: #{error.message}。可配置 douban_card.cookie 或稍后重试。"
    end

    def fetch_html(site, url)
      uri = URI(url)
      request = Net::HTTP::Get.new(uri)
      request["User-Agent"] = "Mozilla/5.0 (compatible; Jekyll Douban Card)"
      request["Accept-Language"] = "zh-CN,zh;q=0.9"
      cookie = config(site)["cookie"] || ENV["DOUBAN_COOKIE"]
      request["Cookie"] = cookie if cookie && !cookie.empty?

      timeout = config(site).fetch("request_timeout", 15).to_i
      response = Net::HTTP.start(uri.host, uri.port, use_ssl: true, open_timeout: timeout, read_timeout: timeout) do |http|
        http.request(request)
      end
      unless response.is_a?(Net::HTTPSuccess)
        raise "HTTP #{response.code}"
      end

      # Net::HTTP returns an ASCII-8BIT string even when Douban responds with
      # UTF-8 HTML. Normalize it before applying Chinese regular expressions.
      response.body.force_encoding(Encoding::UTF_8).encode(Encoding::UTF_8, invalid: :replace, undef: :replace)
    end

    def parse_subject(html, type, subject_id)
      title = extract_title(html)
      raise "页面中没有找到作品标题" if title.empty?

      info = info_text(html)
      rating = first_match(html, /(?:property=["']v:average["'][^>]*>|class=["'][^"']*rating_num[^"']*["'][^>]*>)(.*?)<\//im)
      image = first_match(html, /id=["']mainpic["'][^>]*>.*?<img\b[^>]*\bsrc=["']([^"']+)/im)

      {
        "title" => title,
        "url" => subject_url(type, subject_id),
        "image" => image,
        "rating" => rating.empty? ? "暂无评分" : rating,
        "status" => extract_status(html, TYPES.fetch(type).fetch(:status)),
        "meta" => metadata(type, info)
      }
    end

    def proxied_image(proxy, image)
      return "" if image.empty?
      return image if proxy.to_s.empty?

      "#{proxy}#{URI.encode_www_form_component(image)}"
    end

    def cached_image_url(site, document, type, subject_id, card)
      return proxied_image(config(site).fetch("img_proxy", ""), card.fetch("image", "")) unless cache_images?(site)

      source_image = card.fetch("image", "")
      return "" if source_image.empty?

      source_path = File.expand_path(document.path, site.source)
      slug = document.data.fetch("slug", "").to_s
      if slug.empty? || slug.include?("..")
        raise Jekyll::Errors::FatalException, "豆瓣卡片无法确定文章资源目录"
      end

      extension = File.extname(URI(source_image).path).downcase
      extension = ".jpg" unless %w[.avif .gif .jpeg .jpg .png .webp].include?(extension)
      filename = "douban-#{type}-#{subject_id}#{extension}"
      asset_dir = File.join(File.dirname(source_path), slug)
      asset_path = File.join(asset_dir, filename)

      download_cover(site, source_image, card.fetch("url"), asset_path) unless File.file?(asset_path)
      register_post_asset(site, document, asset_path)
      File.join(document.url, filename)
    rescue URI::InvalidURIError => error
      raise Jekyll::Errors::FatalException, "豆瓣封面地址无效: #{error.message}"
    end

    def cache_images?(site)
      config(site).fetch("cache_images", true)
    end

    def download_cover(site, image_url, referer, path)
      uri = URI(image_url)
      request = Net::HTTP::Get.new(uri)
      request["User-Agent"] = "Mozilla/5.0 (compatible; Jekyll Douban Card)"
      request["Referer"] = referer
      timeout = config(site).fetch("request_timeout", 15).to_i
      response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https", open_timeout: timeout, read_timeout: timeout) do |http|
        http.request(request)
      end

      unless response.is_a?(Net::HTTPSuccess) && response["content-type"].to_s.start_with?("image/")
        raise Jekyll::Errors::FatalException, "无法下载豆瓣封面 #{image_url} (HTTP #{response.code})"
      end

      FileUtils.mkdir_p(File.dirname(path))
      File.binwrite(path, response.body)
      Jekyll.logger.info("douban-card:", "缓存封面 #{path.delete_prefix("#{site.source}/")}")
    end

    def register_post_asset(site, document, path)
      return if site.static_files.any? { |file| file.path == path }

      relative_path = path.delete_prefix("#{site.source}/")
      site.static_files << Jekyll::PostAssetFile.new(
        site,
        site.source,
        File.dirname(relative_path),
        File.basename(relative_path),
        File.join(document.url, File.basename(path))
      )
    end

    def extract_title(html)
      first_match(html, /<h1\b[^>]*>.*?<span\b[^>]*>(.*?)<\/span>.*?<\/h1>/im)
    end

    def info_text(html)
      block = html[/<div\b[^>]*id=["']info["'][^>]*>(.*?)<\/div>/im, 1].to_s
      CGI.unescapeHTML(
        block.gsub(/<br\s*\/?>/i, "\n")
             .gsub(/<[^>]*>/, " ")
             .gsub(/[\t\r\f\v ]+/, " ")
             .gsub(/ *\n */, "\n")
             .gsub(/\n{2,}/, "\n")
             .strip
      )
    end

    def extract_status(html, fallback)
      status = first_match(html, /id=["']interest_sect_level["'][^>]*>.*?<span\b[^>]*class=["'][^"']*mr10[^"']*["'][^>]*>(.*?)<\/span>/im)
      status.empty? ? fallback : status
    end

    def metadata(type, info)
      fields = case type
               when "book"
                 [value_for(info, "作者"), value_for(info, "出版年")]
               when "movie"
                 [value_for(info, "导演"), value_for(info, "主演", 2), value_for(info, "上映日期", 1, "首播")]
               when "music"
                 [value_for(info, "表演者", 2), value_for(info, "发行时间")]
               end
      fields.reject(&:empty?)
    end

    def value_for(info, label, limit = nil, alternate_label = nil)
      labels = [label, alternate_label].compact.map { |item| Regexp.escape(item) }.join("|")
      value = info[/(?:\A|\n)\s*(?:#{labels})\s*[:：]\s*(.+?)(?=\n|\z)/, 1].to_s.strip
      return value unless limit

      value.split(%r{\s*/\s*}).first(limit).join("/")
    end

    def first_match(html, pattern)
      strip_html(html[pattern, 1].to_s)
    end

    def strip_html(value)
      CGI.unescapeHTML(value.to_s.gsub(/<[^>]*>/, " ").gsub(/\s+/, " ").strip)
    end

    def render(site, type, subject_id, document = nil)
      card = fetch_card(site, type, subject_id)
      image_url = document ? cached_image_url(site, document, type, subject_id, card) : proxied_image(config(site).fetch("img_proxy", ""), card.fetch("image", ""))

      <<~HTML
        <div class="douban-card-wrap">
          <a class="douban-card douban-card--#{type}" href="#{escape(card.fetch("url"))}" target="_blank" rel="noopener noreferrer">
            #{backdrop_html(image_url)}
            #{image_html(card, image_url)}
            <span class="douban-card__body">
              #{info_line(TYPES.fetch(type).fetch(:label), card.fetch("title"), true)}
              #{detail_lines(type, card)}
              #{info_line("评分", card.fetch("rating"))}
            </span>
          </a>
        </div>
      HTML
    end

    def backdrop_html(image)
      return "" if image.empty?

      %(<span class="douban-card__backdrop" style="background-image: url('#{escape(image)}')"></span>)
    end

    def detail_lines(type, card)
      labels = case type
               when "book" then ["作者", "出版年份"]
               when "movie" then ["导演", "主演", "上映时间"]
               when "music" then ["表演者", "发行时间"]
               end
      card.fetch("meta", []).zip(labels).map do |value, label|
        info_line(label, value) unless value.to_s.empty?
      end.compact.join("\n")
    end

    def info_line(label, value, strong = false)
      value_html = strong ? "<strong>#{escape(value)}</strong>" : escape(value)
      %(<span class="douban-card__line"><span class="douban-card__label">#{escape(label)}：</span>#{value_html}</span>)
    end

    def image_html(card, image)
      return "" if image.empty?

      %(<img class="douban-card__cover" src="#{escape(image)}" alt="#{escape(card.fetch("title"))}" loading="lazy">)
    end

    def escape(value)
      CGI.escapeHTML(value.to_s)
    end
  end

  class DoubanCardTag < Liquid::Tag
    def initialize(tag_name, markup, tokens)
      super
      @type, @subject_id = DoubanCard.parse_args(markup)
    end

    def render(context)
      DoubanCard.render(context.registers.fetch(:site), @type, @subject_id)
    end
  end
end

Liquid::Template.register_tag("douban", Jekyll::DoubanCardTag)

%i[documents pages].each do |owner|
  Jekyll::Hooks.register owner, :pre_render do |doc|
    content = Jekyll::DoubanCard.expand_obsidian_callouts(doc.content)
    doc.content = content.gsub(Jekyll::DoubanCard::TAG_PATTERN) do
      type, subject_id = Jekyll::DoubanCard.parse_args(Regexp.last_match(1))
      Jekyll::DoubanCard.render(doc.site, type, subject_id, doc).rstrip
    end
  end
end
