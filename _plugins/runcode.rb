# frozen_string_literal: true

require "cgi"
require "securerandom"

module Jekyll
  class RuncodeBlock < Liquid::Block
    def render(context)
      id = "runcode_#{SecureRandom.uuid}"
      escaped = super.to_s.strip.gsub("&", "&amp;").gsub("<", "&lt;")

      <<~HTML
        <div class="runcode">
          <p><textarea class="runcode_text" id="#{CGI.escapeHTML(id)}">#{escaped}</textarea><input type="button" value="Run" class="runcode_button" onclick="runcode.open('#{CGI.escapeHTML(id)}');" />&nbsp;<input type="button" value="Copy" class="runcode_button" onclick="runcode.copy('#{CGI.escapeHTML(id)}');" /></p>
        </div>
      HTML
    end
  end
end

Liquid::Template.register_tag("runcode", Jekyll::RuncodeBlock)
