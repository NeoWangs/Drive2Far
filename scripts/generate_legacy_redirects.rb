# frozen_string_literal: true

require "cgi"
require "fileutils"
require "find"
require "json"
require "set"

site_dir = ARGV[0] || "_site"
base_path = (ARGV[1] || ENV.fetch("PAGES_BASE_PATH", "")).to_s
base_path = "" if base_path == "/"
base_path = "/#{base_path}" unless base_path.empty? || base_path.start_with?("/")
base_path = base_path.delete_suffix("/")
abort "Missing site directory: #{site_dir}" unless Dir.exist?(site_dir)

def local_url(path, base_path)
  normalized = "/#{path}".squeeze("/")
  return normalized if base_path.empty?

  "#{base_path}#{normalized}"
end

def redirect_html(target)
  target_json = JSON.generate(target)
  escaped_target = CGI.escapeHTML(target)

  <<~HTML
    <!doctype html>
    <html lang="zh-CN">
    <head>
      <meta charset="utf-8">
      <meta name="robots" content="noindex">
      <meta http-equiv="refresh" content="0; url=#{escaped_target}">
      <link rel="canonical" href="#{escaped_target}">
      <title>Redirecting...</title>
      <script>
        (function () {
          var target = #{target_json};
          window.location.replace(target + window.location.search + window.location.hash);
        })();
      </script>
    </head>
    <body>
      <p>Redirecting to <a href="#{escaped_target}">#{escaped_target}</a>.</p>
    </body>
    </html>
  HTML
end

def write_redirect(site_dir, source_path, target)
  normalized = source_path.to_s.sub(%r{\A/}, "")
  output_path =
    if normalized.end_with?("/")
      File.join(site_dir, normalized, "index.html")
    else
      File.join(site_dir, normalized)
    end

  FileUtils.mkdir_p(File.dirname(output_path))
  File.write(output_path, redirect_html(target))
  output_path
end

redirects = {}
redirects["/blog/"] = "/"

{
  "/blog/about/" => "/about/",
  "/blog/archives/" => "/archives/",
  "/blog/developer/" => "/developer/",
  "/blog/scientist/" => "/scientist/",
  "/blog/economic/" => "/economic/",
  "/blog/essay/" => "/essay/"
}.each { |source, target| redirects[source] = target }
redirects.transform_values! { |target| target.start_with?("/") ? local_url(target, base_path) : target }

Find.find(site_dir) do |path|
  next unless path.end_with?("/index.html")

  relative = path.delete_prefix("#{site_dir}/")
  next unless relative.match?(%r{\A\d{4}/\d{2}/\d{2}/.+/index\.html\z})

  target = "/#{relative.delete_suffix("index.html")}"
  redirects["/blog#{target}"] = local_url(target, base_path)
end

show_paths = Set["/show/"]
Find.find(site_dir) do |path|
  next unless path.end_with?(".html")

  File.read(path).scan(%r{(?:"|')(/show/[^"']+)(?:"|')}) do |match|
    show_paths << match.first
  end
end

show_paths.each do |source|
  target_path = source.sub(%r{\A/show/?}, "")
  redirects[source] = "https://show.cssass.com/#{target_path}"
end

redirects.sort.each do |source, target|
  write_redirect(site_dir, source, target)
end

puts "Generated #{redirects.size} legacy redirect pages in #{site_dir}"
