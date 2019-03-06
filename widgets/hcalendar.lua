hcalbgcolor = {red=0,blue=0,green=0,alpha=0.3}
hcaltitlecolor = {red=1,blue=1,green=1,alpha=0.3}
offdaycolor = {red=255/255,blue=120/255,green=120/255,alpha=1}
hcaltodaycolor = {red=1,blue=1,green=1,alpha=0.2}
midlinecolor = {red=1,blue=1,green=1,alpha=0.5}
midlinetodaycolor = {red=0,blue=1,green=186/255,alpha=0.8}
midlineoffcolor = {red=1,blue=119/255,green=119/255,alpha=0.5}

weeknames = {"Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"}
hcaltitlewh = {180,32}
hcaldaywh = {23.43,24}

hcalendars = {}

function showHCalendar(screen)
    if not hcalendars[screen:id()] then
        hcalendars[screen:id()] = {}
    end
    local hcalendar = hcalendars[screen:id()]
    hcalendar.screen = screen
    hcalendar.mainRes = screen:fullFrame()
    hcalendar.localMainRes = screen:absoluteToLocal(hcalendar.mainRes)
    if not hcaltopleft then
        hcalendar.topleft = {40, hcalendar.localMainRes.h-160-44}
    else
        hcalendar.topleft = hcaltopleft
    end
    local hcaltopleft = hcalendar.topleft

    local titlestr = os.date("%B %Y, Week %W")
    local title_rect = hs.geometry.rect(screen:localToAbsolute(hcaltopleft[1]+10,hcaltopleft[2]+15,hcaltitlewh[1],hcaltitlewh[2]))
    if not hcalendar.title then
        local styledtitle = hs.styledtext.new(titlestr,{font={size=18},color=hcaltitlecolor,paragraphStyle={alignment="left"}})
        hcalendar.title = hs.drawing.text(title_rect,styledtitle)
        hcalendar.title:setBehavior(hs.drawing.windowBehaviors.canJoinAllSpaces)
        hcalendar.title:setLevel(hs.drawing.windowLevels.desktopIcon)
        hcalendar.title:show()
    else
        hcalendar.title:setText(titlestr)
        hcalendar.title:setFrame(title_rect)
    end

    local currentyear = os.date("%Y")
    local currentmonth = os.date("%m")
    local firstdayofnextmonth = os.time{year=currentyear, month=currentmonth+1, day=1}
    local maxdayofcurrentmonth = os.date("*t", firstdayofnextmonth-24*60*60).day
    local weekdayup = ""
    local daydown = ""
    local offday = {}
    for i=1,maxdayofcurrentmonth do
        local weekdayofquery = os.date("*t", os.time{year=currentyear, month=currentmonth, day=i}).wday
        local weekstr = weeknames[weekdayofquery]
        weekdayup = weekdayup .. weekstr .. ' '
        daydown = daydown .. string.format('%2s',i)..' '
        if weekstr == 'Sa' or weekstr == 'Su' then
            table.insert(offday,{i,weekstr..'\n'..string.format('%2s',i)})
        end
    end
    local caltext = weekdayup..'\n'..daydown
    local caltextrect = hs.geometry.rect(screen:localToAbsolute(hcaltopleft[1]+10,hcaltopleft[2]+15+hcaltitlewh[2],hcaldaywh[1]*maxdayofcurrentmonth,43))
    if not hcalendar.textdraw then
        local styledcaltext = hs.styledtext.new(caltext,{font={name="Courier-Bold",size=13},paragraphStyle={lineSpacing=8.0}})
        hcalendar.textdraw = hs.drawing.text(caltextrect,styledcaltext)
        hcalendar.textdraw:setBehavior(hs.drawing.windowBehaviors.canJoinAllSpaces)
        hcalendar.textdraw:setLevel(hs.drawing.windowLevels.desktopIcon)
        hcalendar.textdraw:show()
    else
        hcalendar.textdraw:setText(caltext)
        hcalendar.textdraw:setFrame(caltextrect)
    end

    local midlinerect = hs.geometry.rect(screen:localToAbsolute(hcaltopleft[1]+10,hcaltopleft[2]+15+hcaltitlewh[2]+20,hcaldaywh[1]*maxdayofcurrentmonth-3,4))
    if not hcalendar.midlinedraw then
        hcalendar.midlinedraw = hs.drawing.rectangle(midlinerect)
        hcalendar.midlinedraw:setBehavior(hs.drawing.windowBehaviors.canJoinAllSpaces)
        hcalendar.midlinedraw:setLevel(hs.drawing.windowLevels.desktopIcon)
        hcalendar.midlinedraw:setFillColor(midlinecolor)
        hcalendar.midlinedraw:setStroke(false)
        hcalendar.midlinedraw:show()
    else
        hcalendar.midlinedraw:setFrame(midlinerect)
    end

    local hcalbgrect = hs.geometry.rect(screen:localToAbsolute(hcaltopleft[1],hcaltopleft[2],hcaldaywh[1]*maxdayofcurrentmonth+20-3,102))
    if not hcalendar.bg then
        hcalendar.bg = hs.drawing.rectangle(hcalbgrect)
        hcalendar.bg:setFillColor(hcalbgcolor)
        hcalendar.bg:setStroke(false)
        hcalendar.bg:setRoundedRectRadii(10,10)
        hcalendar.bg:setBehavior(hs.drawing.windowBehaviors.canJoinAllSpaces)
        hcalendar.bg:setLevel(hs.drawing.windowLevels.desktopIcon)
        hcalendar.bg:show()
    else
        hcalendar.bg:setFrame(hcalbgrect)
    end

    if hcalendar.offday_holder and #hcalendar.offday_holder > 0 then
        for i=1,#hcalendar.offday_holder do
            hcalendar.offday_holder[i]:delete()
            hcalendar.offdaymidline_holder[i]:delete()
        end
    end

    local offday_holder = {}
    local offdaymidline_holder = {}
    hcalendar.offday_holder = offday_holder
    hcalendar. offdaymidline_holder = offdaymidline_holder
    for i=1,#offday do
        local offdayrect = hs.geometry.rect(screen:localToAbsolute(hcaltopleft[1]+10+hcaldaywh[1]*(offday[i][1]-1),hcaltopleft[2]+15+hcaltitlewh[2],hcaldaywh[1],43))
        local offdaytext = hs.styledtext.new(offday[i][2],{font={name="Courier-Bold",size=13},color=offdaycolor,paragraphStyle={lineSpacing=8.0}})
        table.insert(offday_holder,hs.drawing.text(offdayrect,offdaytext))
        offday_holder[i]:setBehavior(hs.drawing.windowBehaviors.canJoinAllSpaces)
        offday_holder[i]:setLevel(hs.drawing.windowLevels.desktopIcon)
        offday_holder[i]:show()
        local offdaymidlinerect = hs.geometry.rect(screen:localToAbsolute(hcaltopleft[1]+10+hcaldaywh[1]*(offday[i][1]-1)-3,hcaltopleft[2]+15+hcaltitlewh[2]+20,hcaldaywh[1],4))
        table.insert(offdaymidline_holder,hs.drawing.rectangle(offdaymidlinerect))
        offdaymidline_holder[i]:setBehavior(hs.drawing.windowBehaviors.canJoinAllSpaces)
        offdaymidline_holder[i]:setLevel(hs.drawing.windowLevels.desktopIcon)
        offdaymidline_holder[i]:setFillColor(midlineoffcolor)
        offdaymidline_holder[i]:setStroke(false)
        offdaymidline_holder[i]:show()
    end

    local today = math.tointeger(os.date("%d"))
    local todayrect = hs.geometry.rect(screen:localToAbsolute(hcaltopleft[1]+10+hcaldaywh[1]*(today-1)-3,hcaltopleft[2]+15+hcaltitlewh[2],hcaldaywh[1],43))
    if not hcalendar.todaydraw then
        hcalendar.todaydraw = hs.drawing.rectangle(todayrect)
        hcalendar.todaydraw:setFillColor(hcaltodaycolor)
        hcalendar.todaydraw:setStroke(false)
        hcalendar.todaydraw:setRoundedRectRadii(3,3)
        hcalendar.todaydraw:setBehavior(hs.drawing.windowBehaviors.canJoinAllSpaces)
        hcalendar.todaydraw:setLevel(hs.drawing.windowLevels.desktopIcon)
        hcalendar.todaydraw:show()
    else
        hcalendar.todaydraw:setFrame(todayrect)
    end

    todaymidlinerect = hs.geometry.rect(screen:localToAbsolute(hcaltopleft[1]+10+hcaldaywh[1]*(today-1)-3,hcaltopleft[2]+15+hcaltitlewh[2]+20,hcaldaywh[1],4))
    -- Don't know why the draw order is not correct
    if hcalendar.todaymidlinedraw then
        hcalendar.todaymidlinedraw:delete()
        hcalendar.todaymidlinedraw=nil
    end
    hcalendar.todaymidlinedraw = hs.drawing.rectangle(todaymidlinerect)
    hcalendar.todaymidlinedraw:setFillColor(midlinetodaycolor)
    hcalendar.todaymidlinedraw:setStroke(false)
    hcalendar.todaymidlinedraw:setBehavior(hs.drawing.windowBehaviors.canJoinAllSpaces)
    hcalendar.todaymidlinedraw:setLevel(hs.drawing.windowLevels.desktopIcon)
    hcalendar.todaymidlinedraw:show()
end

function destroyHCalendar(idx)
    if hcalendars[idx] then
        local hcalendar = hcalendars[idx]
        if hs.screen.find(hcalendar.screen:id()) then
            return
        end
        if hcalendar.title then
            hcalendr.title:delete()
            hcalendar.title=nil
        end
        if hcalendar.textdraw then
            hcalendar.textdraw:delete()
            hcalendar.textdraw=nil
        end
        if hcalendar.midlinedraw then
            hcalendar.midlinedraw:delete()
            hcalendar.midlinedraw=nil
        end
        if hcalendar.bg then
            hcalendar.bg:delete()
            hcalendar.bg=nil
        end
        if hcalendar.offday_holder then
            for i=1,#hcalendar.offday_holder do
                if hcalendar.offday_holder[i] then
                    hcalendar.offday_holder[i]:delete()
                    hcalendar.offday_holder[i]=nil
                end
                if hcalendar.offdaymidline_holder[i] then
                    hcalendar.offdaymidline_holder[i]:delete()
                    hcalendar.offdaymidline_holder[i]=nil
                end
            end
        end
        if hcalendar.todaydraw then
            hcalendar.todaydraw:delete()
            hcalendar.todaydraw=nil
        end
        if hcalendar.todaymidlinedraw then
            hcalendar.todaymidlinedraw:delete()
            hcalendar.todaymidlinedraw=nil
        end
        hcalendars[idx]=nil
    end
end

function showHCalendars()
    showHCalendar(hs.screen.primaryScreen())
end

function destroyHCalendars()
    for i in pairs(hcalendars) do
        destroyHCalendar(i)
    end
end

if not launch_hcalendar then launch_hcalendar=true end
if launch_hcalendar == true then
    showHCalendars()
    if hcaltimer == nil then
        hcaltimer = hs.timer.doEvery(1800, function() showHCalendars() end)
    else
        hcaltimer:start()
    end
    hs.screen.watcher.newWithActiveScreen(function(activeChanged)
        if activeChanged then
            destroyHCalendars()
            hs.timer.doAfter(3, function()
                print('Refresh HCalendar')
                showHCalendars()
            end)
        end
    end):start()
end
