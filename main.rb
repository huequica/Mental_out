require 'mastodon'

MASTODON_HOST = ''      #インスタンスのURLはここに入れてな  例)https://mstdn.jp  だとか  https://knzk.me

connection = Mastodon::REST::Client.new(base_url: MASTODON_HOST, bearer_token: ENV['MASTODON_ACCESS_TOKEN'])
account_info = connection.verify_credentials

puts "** 接続に成功しました: #{connection.base_url} **" 

account_id = account_info.id    #メソッドにぶちこんだりして使う機会多いので変数に格納

account_info = connection.verify_credentials
status_count = account_info.statuses_count  

puts "** 接続しているアカウント **"
puts "** Int id: #{account_id} **"
puts "** username: #{account_info.username} **"
puts "** statuses count: #{status_count} **"

#消していいのか最終確認
print "以上のアカウントのトゥートは全て消えますがよろしいですか？('y' or 'n')>>"
ans = readline.chomp
if ans == "y" then

    while status_count > 0 do
    
        status_data = connection.statuses(account_id, {"limit": "100",})
    
        status_data.each do |status|
            status_id = status.id
            #content = status.content
            #puts "#{status_id}: #{content}"
        
            res = connection.destroy_status(status_id)
        
            if res == true then
                puts "** id: #{status_id} deleted.**"
            else
                puts "** id: #{status_id} can`t deleted.**"
            end
        end
        puts "**  API規制回避のために居眠り中  **"
        
        puts "**  起きたので再開します  **"
        account_info = connection.verify_credentials
        status_count = account_info.statuses_count
    end
    puts "** トゥートの全削除が完了しました。 **"
else
    exit
end

