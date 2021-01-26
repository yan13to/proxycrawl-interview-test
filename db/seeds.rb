require 'nokogiri'
require 'net/http'

urls = if ENV['URLS'].present?
         ENV['URLS'].split(',')
       else
         ['https://www.amazon.com/s?k=movie&ref=nb_sb_noss_2']
       end

def parse_html(body)
  doc = Nokogiri::HTML(body)

  doc.css('div.s-result-item.s-asin').each do |div|
    img_url = div.css('img').attr('src')
    title = div.css('.a-size-medium').text
    year = div.css('.a-size-base').children[0].text
    stars = div.css('.a-size-small').children[0].text
    rating = div.css('.a-size-small').children[1].text
    price = div.css('.a-price')

    item = Item.where(title: title).first
    attrs = {
      img_url: img_url,
      title: title,
      year: year,
      stars: stars,
      rating: rating,
      price: price
    }

    if item
      saved = Item.update(attrs)
    else
      saved = Item.create(attrs)
    end

    putc '#' if saved
  end
end

urls.each do |url|
  uri = URI('https://api.proxycrawl.com')
  uri.query = URI.encode_www_form(
    {
      token: '4DzICyJsQ9W9tfKaWwmv4w',
      url: url
    }
  )

  res = Net::HTTP.get_response(uri)

  if res.code.to_i == 200
    parse_html(res.body)
    puts
  end
end
