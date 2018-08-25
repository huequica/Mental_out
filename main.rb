require 'mastodon'
#################################################################################
#########################      定義メソッド置き場      #############################
#################################################################################
def toot_all_delete(connection, account_id, status_count)     #トゥート全消しメソッド

    #消していいのか最終確認
    print "以上のアカウントのトゥートは全て消えますが本当によろしいですか？('y' or 'n')>>"
    ans = readline.chomp
    if ans == "y" then

        while status_count > 0 do
            status_data = connection.statuses(account_id, {"limit": "100"})
            
            status_data.each do |status|
                status_id = status.id
                #content = status.content
                #puts "#{status_id}: #{content}"
                
                res = connection.destroy_status(status_id)
                
                if res == true then
                        puts "** id: #{status_id} deleted.**"
                else
                        puts "** id: #{status_id} delete failed.**"
                end

                sleep(5)
                account_info = connection.verify_credentials
                status_count = account_info.statuses_count
            end
        end
        puts "** トゥートの全削除が完了しました。 **"

    else
        exit
    end

end

def toot_oneday_delete(connection, account_id, status_count)  #トゥート1日だけ消すメソッド、こっちをメインとして動作させる

    print "消したい日付を打ち込んでください(year/month/day)>>"
    delete_date_txt = readline.chomp
    delete_date_data = Time.parse(delete_date_txt)
    delete_date_str = delete_date_data.year.to_s + '/' + delete_date_data.month.to_s + '/' + delete_date_data.day.to_s
    #消していいのか最終確認
    print "以上のアカウントの日付のトゥートは全て消えますが本当によろしいですか？('y' or 'n')>>"
    ans = readline.chomp
    if ans == "y" then
    
        record_id = nil
        loop_flag = true

        while loop_flag

            if record_id == nil then
                status_data = connection.statuses(account_id, {"limit": "100"})
            else
                status_data = connection.statuses(account_id, {"limit": "100", "max_id": record_id})
            end

            if status_data.size == 0
                puts "** 指定の日付のトゥートが見つからないまま最後まで見終わりました **"
                loop_flag = false
                break
            else
                status_data.each do |status|
                    record_id = status.id

                    #取得される時間がUTCでの時間(文字列)なのでparseで変換したのち9時間加算してJSTと同じにする
                    jst_time = Time.parse(status.created_at) + 60 * 60 * 9
                    jst_date_str = jst_time.year.to_s + '/' + jst_time.month.to_s + '/' + jst_time.day.to_s

                    if delete_date_str == jst_date_str then

                        #日付がマッチしてた場合はdestroyに渡す
                        res = connection.destroy_status(status.id)
                        if res == true then
                            puts "** id: #{status.id} deleted.**"
                        else
                            puts "** id: #{status.id} delete failed.**"
                        end
                        sleep(5)
                        
                    elsif delete_date_str > jst_date_str then
                        #指定されたより後ろまで来ちゃった場合
                        puts '** 指定された日付のトゥートはもう無いと思います **'
                        loop_flag = false
                        break
                    end

                end
            end
        end
    else
        exit
    end
end



#################################################################################
#########################      main Method      #################################

puts "インスタンスのアドレス(例:https://mstdn.jp)を入力してください>>"
MASTODON_HOST = readline.chomp      #インスタンスのURL

puts "インスタンスにて取得したアクセストークンを入力してください>>"
access_token = readline.chomp       #アクセストークン

connection = Mastodon::REST::Client.new(base_url: MASTODON_HOST, bearer_token: access_token)
account_info = connection.verify_credentials

puts "** 接続に成功しました: #{connection.base_url} **" 

account_id = account_info.id    #メソッドにぶちこんだりして使う機会多いので変数に格納

account_info = connection.verify_credentials
status_count = account_info.statuses_count  

puts "** 接続しているアカウント **"
puts "** Int id: #{account_id} **"
puts "** username: #{account_info.username} **"
puts "** statuses count: #{status_count} **"

############################################################################
all_delete_flag = false    #全消しに切り替える場合はこちらをtrueに書き換えてください
############################################################################

if all_delete_flag == true then
    toot_all_delete(connection, account_id, status_count)
else
    toot_oneday_delete(connection, account_id, status_count)
end