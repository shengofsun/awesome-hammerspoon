caltodaycolor = hs.drawing.color.white
calcolor = {red=235/255,blue=235/255,green=235/255}
calbgcolor = {red=0,blue=0,green=0,alpha=0.3}
calcmd='cal -h 2>/dev/null || cal'

calendars = {}

function drawToday(calendar)
    local currentmonth = tonumber(os.date("%m"))
    -- local todayyearweek = os.date("%W")
    local todayyearweek = hs.execute("date -v+1d +'%W'")
    -- Year week of last day of last month
    local ldlmyearweek = hs.execute("date -v"..currentmonth.."m -v1d -v+1d +'%W'")
    local rowofcurrentmonth = todayyearweek - ldlmyearweek
    local columnofcurrentmonth = os.date("*t").wday
    local splitw = 205
    local splith = 141
    local todaycoverrect = hs.geometry.rect(
        calendar.screen:localToAbsolute(
            calendar.caltopleft[1]+10+splitw/7*(columnofcurrentmonth-1),
            calendar.caltopleft[2]+10+splith/7*(rowofcurrentmonth+2),
            splitw/7,
            splith/7)
    )
    if not calendar.todaycover then
        calendar.todaycover = hs.drawing.rectangle(todaycoverrect)
        calendar.todaycover:setStroke(false)
        calendar.todaycover:setRoundedRectRadii(3,3)
        calendar.todaycover:setBehavior(hs.drawing.windowBehaviors.canJoinAllSpaces)
        calendar.todaycover:setLevel(hs.drawing.windowLevels.desktopIcon)
        calendar.todaycover:setFillColor(caltodaycolor)
        calendar.todaycover:setAlpha(0.3)
        calendar.todaycover:show()
    else
        calendar.todaycover:setFrame(todaycoverrect)
    end
end

function updateCal(calendar)
    local caltext = hs.styledtext.ansi(hs.execute(calcmd),{font={name="Courier",size=16},color=calcolor})
    calendar.caldraw:setStyledText(caltext)
    drawToday(calendar)
end

function showCalendar(screen)
    if not calendars[screen:id()] then
        calendars[screen:id()] = {}
    end

    local calendar = calendars[screen:id()]
    calendar.screen = screen
    local mainRes = screen:fullFrame()
    local localMainRes = screen:absoluteToLocal(mainRes)
    if not caltopleft then
        calendar.caltopleft = {localMainRes.w-330-20,localMainRes.h-161-84}
    else
        calendar.caltopleft = caltopleft
    end

    local bgrect = hs.geometry.rect(screen:localToAbsolute(calendar.caltopleft[1],calendar.caltopleft[2],230,161))
    if not calendar.calbg then
        calendar.calbg = hs.drawing.rectangle(bgrect)
        calendar.calbg:setFillColor(calbgcolor)
        calendar.calbg:setStroke(false)
        calendar.calbg:setRoundedRectRadii(10,10)
        calendar.calbg:setBehavior(hs.drawing.windowBehaviors.canJoinAllSpaces)
        calendar.calbg:setLevel(hs.drawing.windowLevels.desktopIcon)
        calendar.calbg:show()
    else
        calendar.calbg:setFrame(bgrect)
    end

    local caltext = hs.styledtext.ansi(hs.execute(calcmd),{font={name="Courier",size=16},color=calcolor})
    local calrect = hs.geometry.rect(screen:localToAbsolute(calendar.caltopleft[1]+15,calendar.caltopleft[2]+10,230,161))
    if not calendar.caldraw then
        calendar.caldraw = hs.drawing.text(calrect,caltext)
        calendar.caldraw:setBehavior(hs.drawing.windowBehaviors.canJoinAllSpaces)
        calendar.caldraw:setLevel(hs.drawing.windowLevels.desktopIcon)
        calendar.caldraw:show()
    else
        calendar.caldraw:setFrame(calrect)
    end

    drawToday(calendar)
    if calendar.caltimer == nil then
        calendar.caltimer = hs.timer.doEvery(1800,function() updateCal(calendar) end)
    else
        calendar.caltimer:start()
    end
end

function destroyCalendar(idx)
    if calendars[idx] then
        local calendar = calendars[idx]
        if hs.screen.find(calendar.screen:id()) then
            return
        end
        calendar.caltimer:stop()
        calendar.caltimer=nil
        calendar.todaycover:delete()
        calendar.todaycover=nil
        calendar.calbg:delete()
        calendar.calbg=nil
        calendar.caldraw:delete()
        calendar.caldraw=nil
        calendars[idx] = nil
    end
end

function showCalendars()
    showCalendar(hs.screen.primaryScreen())
end

function destroyCalendars()
    for i in pairs(calendars) do
        destroyCalendar(i)
    end
end

if not launch_calendar then launch_calendar=true end
if launch_calendar == true then
    showCalendars()
    hs.screen.watcher.newWithActiveScreen(function(activeChanged)
            if activeChanged then
                destroyCalendars()
                hs.timer.doAfter(3, function()
                                     print('Refresh Calendar')
                                     showCalendars()
                end)
            end
    end):start()
end
