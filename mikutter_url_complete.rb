# -*- coding: utf-8 -*-

require 'uri'
require 'open-uri'
require 'nokogiri'

Plugin.create(:mikutter_url_complete) do
  command(:url_complete,
          name: 'URLからタイトルを補完',
          condition: lambda{ |opt| true },
          visible: true,
          role: :postbox
          ) do |opt|
    message = Plugin[:gtk].widgetof(opt.widget).widget_post.buffer.text
    URI.extract(message, %w{http https}).uniq.each do |url|
      unless url.match(/(\.jpg|\.jpeg|\.png)/)
        charset = nil
        html = open(url) do |f|
          charset = f.charset
          f.read
        end
        doc = Nokogiri::HTML.parse(html, nil, charset)
        title = doc.title
        message.gsub!(url, "\"#{title}\"" + " " + url)
        Plugin[:gtk].widgetof(opt.widget).widget_post.buffer.text = message
      end
    end
  end
end
