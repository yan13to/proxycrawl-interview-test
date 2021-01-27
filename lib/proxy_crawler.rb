# frozen_string_literal: true

# ProxyCrawler
class ProxyCrawler
  require 'nokogiri'
  require 'net/http'

  attr_accessor :uri, :urls, :opts, :result

  # opts = {area_scope: '', fields: { title: '' }}

  def initialize(urls = [], opts = {})
    @uri = 'https://api.proxycrawl.com'
    @urls = urls
    @opts = opts
    @result = []
  end

  def run
    @urls.each do |url|
      res = get_response(url)
      code = res.code.to_i

      @result = code == 200 ? html_to_json(res.body) : { error: true, code: res.code }
    end
  end

  private

  def html_to_json(body)
    doc = Nokogiri::HTML(body)
    area_scope = @opts[:area_scope]
    fields = @opts[:fields]

    @result = doc.css(area_scope).map do |div|
      fields.keys.inject({}) do |sum, key|
        value = fields[key] == 'img' ? div.css(fields[key]).attr('src').value : div.css(fields[key]).try(:text)

        sum.merge!({ key => value })
      end
    end
  end

  def get_response(url)
    uri = URI(@uri)
    uri.query = URI.encode_www_form(
      {
        token: '4DzICyJsQ9W9tfKaWwmv4w',
        url: url
      }
    )

    Net::HTTP.get_response(uri)
  end
end
