require './lib/proxy_crawler'

class ProxyCrawlJob < ApplicationJob
  queue_as :default

  def perform(*args)
    the_urls = urls
    the_opts = opts
    proxy_crawler = ProxyCrawler.new(the_urls, the_opts)
    proxy_crawler.run
    proxy_crawler.result.each do |attrs|
      item = Item.where(title: attrs[:title]).first
      return item.update(attrs) if item

      Item.create(attrs)
    end
  end

  private

  def urls
    if ENV['URLS'].present?
      ENV['URLS'].split(',')
    else
      ['https://www.amazon.com/s?k=movie']
    end
  end

  def opts
    {
      area_scope: 'div.s-result-item.s-asin',
      fields: {
        img_url: 'img',
        title: 'div.a-section.a-spacing-none > h2.a-size-mini.a-spacing-none.a-color-base.s-line-clamp-2 > a.a-link-normal.a-text-normal > span.a-size-medium',
        year: 'div.a-section.a-spacing-none > div.a-row.a-size-base.a-color-secondary > span.a-size-base.a-color-secondary.a-text-normal',
        stars: 'div.a-section.a-spacing-none.a-spacing-top-micro > div.a-row.a-size-small > span > span > a > i > span',
        rating: 'div.a-section.a-spacing-none.a-spacing-top-micro > div.a-row.a-size-small > span > a > span.a-size-base',
        price: 'span.a-price > span.a-offscreen'
      }
    }
  end
end
