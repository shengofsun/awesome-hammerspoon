user_agent_str = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_5) AppleWebKit/603.2.4 (KHTML, like Gecko) Version/10.1.1 Safari/603.2.4"
json_req_url = "http://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1"
desktop_picture_db = os.getenv("HOME")..'/Library/Application Support/Dock/desktoppicture.db'
bing_image_dir = os.getenv("HOME").."/Library/Caches/org.hammerspoon.Hammerspoon/images/"

function bingDailyRequest()
    hs.http.asyncGet(json_req_url, {["User-Agent"]=user_agent_str}, function(stat,body,header)
                         if stat == 200 then
                             if pcall(function() hs.json.decode(body) end) then
                                 local decode_data = hs.json.decode(body)
                                 local pic_url = decode_data.images[1].url
                                 local pic_name = hs.http.urlParts(pic_url).lastPathComponent
                                 if bing_last_set_pic ~= pic_name then
                                     local full_url = "https://www.bing.com"..pic_url
                                     downloadBingImage(full_url)
                                 end
                             end
                         else
                             print("Bing URL request failed!")
                         end
    end)
end

function downloadBingImage(url)
    local function curl_callback(exitCode,stdOut,stdErr)
        if exitCode == 0 then
            bing_curl_task = nil
            bing_last_set_pic = hs.http.urlParts(url).lastPathComponent
            local localpath = bing_image_dir..hs.http.urlParts(url).lastPathComponent
            bingSetAsWallpaper(localpath)
            os.execute("ls -t "..bing_image_dir.." | tail -n+30 | xargs -I{} rm -f "..bing_image_dir.."/{}")
        else
            print(stdOut,stdErr)
        end
    end
    if bing_curl_task then
        bing_curl_task:terminate()
        bing_curl_task = nil
    end
    local localpath = bing_image_dir..hs.http.urlParts(url).lastPathComponent
    local mkdir_output, mkdir_status = os.execute("mkdir -p "..bing_image_dir)
    if not mkdir_status then
        print("Failed to create directory: "..bing_image_dir)
        return
    end
    bing_curl_task = hs.task.new("/usr/bin/curl",curl_callback,{"-A",user_agent_str,url,"-o",localpath})
    bing_curl_task:start()
end

function setAsWallpaperByApplescript(filepath)
    local applescript = 'tell application "System Events"\nset picture of every desktop to "'..filepath..'"\nend tell'
    local stat, data = hs.osascript.applescript(applescript)
    if not stat then
        print("AppleScript failed.")
    end
end

function setAsWallpaperByShellscript(filepath)
    local query_script = 'sqlite3 "'..desktop_picture_db..
        '" "select value from data" 2>/dev/null | grep -v "'..
        hs.fs.displayName(filepath)..'" 2>/dev/null'
    local to_update, query_status = hs.execute(query_script)
    if not query_status or string.len(to_update) == 0 then
        print("No need to set desktop picture by shell script")
        return
    end

    local shellscript = "sqlite3 \""..desktop_picture_db..
        "\" \"update data set value = '"..
        filepath.."'\" && killall Dock"
    local outout, status, type, rc = hs.execute(shellscript)
    if not status then
        print("ShellScript failed.")
    end
end

function bingSetAsWallpaper(filepath)
    if hs.fs.displayName(desktop_picture_db) then
        setAsWallpaperByShellscript(filepath)
    end
    setAsWallpaperByApplescript(filepath)
end

if bingdaily_timer == nil then
    bingdaily_timer = hs.timer.doEvery(3*60*60, function() bingDailyRequest() end)
    bingdaily_timer:setNextTrigger(5)
else
    bingdaily_timer:start()
end
