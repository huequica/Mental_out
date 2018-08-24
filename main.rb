require 'mastodon'

MASTODON_HOST = 'https://mstdn.jp'      #この中身変えればインスタンス変更できます。サポートはしませんがご自由にどうぞ

connection = Mastodon::REST::Client.new(base_url: MASTODON_HOST, bearer_token: ENV['MASTODON_ACCESS_TOKEN'])
account_info = connection.verify_credentials

puts "** 接続に成功しました: #{connection.base_url} **" 

account_id = account_info.id    #メソッドにぶちこんだりして使う機会多いので変数に格納

puts "** 接続しているアカウント **"
puts "** Int id: #{account_id} **"
puts "** username: #{account_info.username} **"

status_info = connection.statuses(account_id, {"limit": "3",})

status_info.each do |status|
    status_id = status.id
    content = status.content
    puts "#{status_id}: #{content}"
end    
#res = connection.destroy_status(100600540323155842)
#if res == true then
#    puts '** トゥートが消えました **'
#else 
#    puts '** エラーかなにかで消えてないとおもいます **'
#end