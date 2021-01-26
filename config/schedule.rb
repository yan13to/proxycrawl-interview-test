env 'URLS', 'https://www.amazon.com/s?k=movie&ref=nb_sb_noss_2'

every :monday, at: '10:00am' do
  rake 'db:seed'
end
