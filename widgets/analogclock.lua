seccolor = {red=158/255,blue=158/255,green=158/255,alpha=0.5}
tofilledcolor = {red=1,blue=1,green=1,alpha=0.1}
secfillcolor = {red=158/255,blue=158/255,green=158/255,alpha=0.1}
mincolor = {red=24/255,blue=195/255,green=145/255,alpha=0.75}
hourcolor = {red=236/255,blue=39/255,green=109/255,alpha=0.75}

clocks = {}

function showAnalogClock(screen)
    if not clocks[screen:id()] then
        clocks[screen:id()] = {} 
    end
    local clock = clocks[screen:id()]
    clock.screen = screen
    clock.mainRes = screen:fullFrame()
    clock.localMainRes = screen:absoluteToLocal(clock.mainRes)
    if not aclockcenter then
        clock.center = {x=160,y=200}
    else
        clock.center = aclockcenter
    end
    local aclockcenter = clock.center

    local imagerect = hs.geometry.rect(screen:localToAbsolute(aclockcenter.x-100,aclockcenter.y-100,200,200))
    if not clock.imagedisp then
        clock.imagedisp = hs.drawing.image(imagerect,hs.fs.pathToAbsolute(hs.configdir..'/resources/watchbg.png'))
        clock.imagedisp:setBehavior(hs.drawing.windowBehaviors.canJoinAllSpaces)
        clock.imagedisp:setLevel(hs.drawing.windowLevels.desktopIcon)
        clock.imagedisp:show()
    else
        clock.imagedisp:setFrame(imagerect)
    end

    local bgcircle = hs.drawing.arc(screen:localToAbsolute(aclockcenter),80,0,360)
    if clock.bgcircle then
        clock.bgcircle:delete()
        clock.bgcircle = nil
    end
    if not clock.bgcircle then
        clock.bgcircle = bgcircle
        clock.bgcircle:setFill(false)
        clock.bgcircle:setStrokeWidth(1)
        clock.bgcircle:setStrokeColor(seccolor)
        clock.bgcircle:setBehavior(hs.drawing.windowBehaviors.canJoinAllSpaces)
        clock.bgcircle:setLevel(hs.drawing.windowLevels.desktopIcon)
        clock.bgcircle:show()
    end

    local mincircle = hs.drawing.arc(screen:localToAbsolute(aclockcenter),55,0,360)
    if clock.mincircle then
        clock.mincircle:delete()
        clock.mincircle = nil
    end
    if not clock.mincircle then
        clock.mincircle = mincircle
        clock.mincircle:setFill(false)
        clock.mincircle:setStrokeWidth(3)
        clock.mincircle:setStrokeColor(tofilledcolor)
        clock.mincircle:setBehavior(hs.drawing.windowBehaviors.canJoinAllSpaces)
        clock.mincircle:setLevel(hs.drawing.windowLevels.desktopIcon)
        clock.mincircle:show()
    end

    local hourcircle = hs.drawing.arc(screen:localToAbsolute(aclockcenter),40,0,360)
    if clock.hourcircle then
        clock.hourcircle:delete()
        clock.hourcircle = nil
    end
    if not clock.hourcircle then
        clock.hourcircle = hourcircle
        clock.hourcircle:setFill(false)
        clock.hourcircle:setStrokeWidth(3)
        clock.hourcircle:setStrokeColor(tofilledcolor)
        clock.hourcircle:setBehavior(hs.drawing.windowBehaviors.canJoinAllSpaces)
        clock.hourcircle:setLevel(hs.drawing.windowLevels.desktopIcon)
        clock.hourcircle:show()
    end

    local sechand = hs.drawing.arc(screen:localToAbsolute(aclockcenter),80,0,0)
    if clock.sechand then
        clock.sechand:delete()
        clock.sechand = nil
    end
    if not clock.sechand then
        clock.sechand = sechand
        clock.sechand:setFillColor(secfillcolor)
        clock.sechand:setStrokeWidth(1)
        clock.sechand:setStrokeColor(seccolor)
        clock.sechand:setBehavior(hs.drawing.windowBehaviors.canJoinAllSpaces)
        clock.sechand:setLevel(hs.drawing.windowLevels.desktopIcon)
        clock.sechand:show()
    end

    local minhand1 = hs.drawing.arc(screen:localToAbsolute(aclockcenter),55,0,0)
    if clock.minhand1 then
        clock.minhand1:delete()
        clock.minhand1 = nil
    end
    if not clock.minhand1 then
        clock.minhand1 = minhand1
        clock.minhand1:setFill(false)
        -- minhand:setStrokeWidth(3)
        clock.minhand1:setStrokeColor(mincolor)
        clock.minhand1:setBehavior(hs.drawing.windowBehaviors.canJoinAllSpaces)
        clock.minhand1:setLevel(hs.drawing.windowLevels.desktopIcon)
        clock.minhand1:show()
    end

    local minhand2 = hs.drawing.arc(screen:localToAbsolute(aclockcenter),54,0,0)
    if clock.minhand2 then
        clock.minhand2:delete()
        clock.minhand2 = nil
    end
    if not clock.minhand2 then
        clock.minhand2 = minhand2
        clock.minhand2:setFill(false)
        clock.minhand2:setStrokeColor(mincolor)
        clock.minhand2:setBehavior(hs.drawing.windowBehaviors.canJoinAllSpaces)
        clock.minhand2:setLevel(hs.drawing.windowLevels.desktopIcon)
        clock.minhand2:show()
    end

    local minhand3 = hs.drawing.arc(screen:localToAbsolute(aclockcenter),53,0,0)
    if clock.minhand3 then
        clock.minhand3:delete()
        clock.minhand3 = nil
    end
    if not clock.minhand3 then
        clock.minhand3 = minhand3
        clock.minhand3:setFill(false)
        clock.minhand3:setStrokeColor(mincolor)
        clock.minhand3:setBehavior(hs.drawing.windowBehaviors.canJoinAllSpaces)
        clock.minhand3:setLevel(hs.drawing.windowLevels.desktopIcon)
        clock.minhand3:show()
    end

    local hourhand1 = hs.drawing.arc(screen:localToAbsolute(aclockcenter),40,0,0)
    if clock.hourhand1 then
        clock.hourhand1:delete()
        clock.hourhand1 = nil
    end
    if not clock.hourhand1 then
        clock.hourhand1 = hourhand1
        clock.hourhand1:setFill(false)
        clock.hourhand1:setStrokeColor(hourcolor)
        clock.hourhand1:setBehavior(hs.drawing.windowBehaviors.canJoinAllSpaces)
        clock.hourhand1:setLevel(hs.drawing.windowLevels.desktopIcon)
        clock.hourhand1:show()
    end

    local hourhand2 = hs.drawing.arc(screen:localToAbsolute(aclockcenter),39,0,0)
    if clock.hourhand2 then
        clock.hourhand2:delete()
        clock.hourhand2 = nil
    end
    local hourhand2 = hs.drawing.arc(aclockcenter,39,0,0)
    if not clock.hourhand2 then
        clock.hourhand2 = hourhand2
        clock.hourhand2:setFill(false)
        clock.hourhand2:setStrokeColor(hourcolor)
        clock.hourhand2:setBehavior(hs.drawing.windowBehaviors.canJoinAllSpaces)
        clock.hourhand2:setLevel(hs.drawing.windowLevels.desktopIcon)
        clock.hourhand2:show()
    end

    local hourhand3 = hs.drawing.arc(screen:localToAbsolute(aclockcenter),38,0,0)
    if clock.hourhand3 then
        clock.hourhand3:delete()
        clock.hourhand3 = nil
    end
    if not clock.hourhand3 then
        clock.hourhand3 = hourhand3
        clock.hourhand3:setFill(false)
        clock.hourhand3:setStrokeColor(hourcolor)
        clock.hourhand3:setBehavior(hs.drawing.windowBehaviors.canJoinAllSpaces)
        clock.hourhand3:setLevel(hs.drawing.windowLevels.desktopIcon)
        clock.hourhand3:show()
    end

    if clock.clocktimer == nil then
        clock.clocktimer = hs.timer.doEvery(1,function() updateClock(clock) end)
    else
        clock.clocktimer:start()
    end
end

function destroyAnalogClock(idx)
    if clocks[idx] then
        local clock = clocks[idx]
        if hs.screen.find(clock.screen:id()) then
            return
        end
        clock.clocktimer:stop()
        clock.clocktimer=nil
        clock.imagedisp:delete()
        clock.imagedisp=nil
        clock.bgcircle:delete()
        clock.bgcircle=nil
        clock.mincircle:delete()
        clock.mincircle=nil
        clock.hourcircle:delete()
        clock.hourcircle=nil
        clock.sechand:delete()
        clock.sechand=nil
        clock.minhand1:delete()
        clock.minhand1=nil
        clock.minhand2:delete()
        clock.minhand2=nil
        clock.minhand3:delete()
        clock.minhand3=nil
        clock.hourhand1:delete()
        clock.hourhand1=nil
        clock.hourhand2:delete()
        clock.hourhand2=nil
        clock.hourhand3:delete()
        clock.hourhand3=nil
        clocks[idx]=nil
    end
end

function updateClock(clock)
    local secnum = math.tointeger(os.date("%S"))
    local minnum = math.tointeger(os.date("%M"))
    local hournum = math.tointeger(os.date("%I"))
    local seceangle = 6*secnum
    local mineangle = 6*minnum+6/60*secnum
    local houreangle = 30*hournum+30/60*minnum+30/60/60*secnum

    clock.sechand:setArcAngles(0,seceangle)
    clock.minhand1:setArcAngles(0,mineangle)
    clock.minhand2:setArcAngles(0,mineangle)
    clock.minhand3:setArcAngles(0,mineangle)
    if houreangle >= 360 then
        houreangle = houreangle - 360
    end
    clock.hourhand1:setArcAngles(0,houreangle)
    clock.hourhand2:setArcAngles(0,houreangle)
    clock.hourhand3:setArcAngles(0,houreangle)
end

function showAnalogClocks()
    showAnalogClock(hs.screen.primaryScreen())
end

function destroyAnalogClocks()
    for i in pairs(clocks) do
        destroyAnalogClock(i)
    end
end

if not launch_analogclock then launch_analogclock = true end
if launch_analogclock == true then
    showAnalogClocks()
    hs.screen.watcher.newWithActiveScreen(function(activeChanged)
            if activeChanged then
                destroyAnalogClocks()
                hs.timer.doAfter(3, function()
                                     print('Refresh Analog Clock')
                                     showAnalogClocks()
                end)
            end
    end):start()
end
