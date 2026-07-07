# frozen_string_literal: true

# Let files under _posts omit Jekyll's usual YYYY-MM-DD filename prefix.
# Each post still needs a date in its front matter.
module Jekyll
  DATELESS_POST_FILENAME_MATCHER = %r!^(?:.+/)*(.*)(\.(?:md|markdown|mkd|mkdn|mdown))$!i.freeze

  class PostReader
    def read_posts(dir)
      read_publishable(dir, "_posts", DATELESS_POST_FILENAME_MATCHER)
    end
  end

  class PostAssetFile < StaticFile
    def initialize(site, base, dir, name, post_asset_url)
      super(site, base, dir, name)
      @post_asset_url = post_asset_url
    end

    def url
      @post_asset_url
    end
  end
end

Jekyll::Hooks.register :site, :post_read do |site|
  image_extensions = %w(.apng .avif .gif .jpg .jpeg .png .svg .webp)

  site.posts.docs.each do |post|
    asset_dir = File.join(File.dirname(post.path), post.data["slug"].to_s)
    next unless File.directory?(asset_dir)

    Dir.glob(File.join(asset_dir, "**", "*")).sort.each do |path|
      next if File.directory?(path)
      next if File.basename(path).start_with?(".")
      next unless image_extensions.include?(File.extname(path).downcase)

      relative_to_source = path.delete_prefix("#{site.source}/")
      dir = File.dirname(relative_to_source)
      name = File.basename(path)
      relative_asset_path = path.delete_prefix("#{asset_dir}/")
      url = File.join(post.url, relative_asset_path)

      site.static_files << Jekyll::PostAssetFile.new(site, site.source, dir, name, url)
    end
  end
end
