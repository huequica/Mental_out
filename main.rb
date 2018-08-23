require 'mastodon'

MASTODON_HOST = 'https://mstdn.jp'      #この中身変えればインスタンス変更できます。サポートはしませんがご自由にどうぞ

connection = Mastodon::REST::Client.new(base_url: MASTODON_HOST, bearer_token: ENV['MASTODON_ACCESS_TOKEN'])

puts "** 接続に成功しました: #{connection.base_url} **" 

res = connection.destroy_status(100600540323155842)
if res == true then
    puts '** トゥートが消えました **'
else 
    puts '** エラーかなにかで消えてないとおもいます **'
end