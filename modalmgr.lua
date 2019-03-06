modalmgr_keys = modalmgr_keys or {{"alt"}, "space"}
modalmgr = hs.hotkey.modal.new(modalmgr_keys[1], modalmgr_keys[2], 'Enter Main Mode')
local modalpkg = {}
modalpkg.id = "mainM"
modalpkg.modal = modalmgr
table.insert(modal_list, modalpkg)

function modalmgr:entered()
    for i=1,#modal_list do
        if modal_list[i].id == "mainM" then
            table.insert(activeModals, modal_list[i])
        end
    end
    showavailableHotkey()
end

function modalmgr:exited()
    if modal_tray then modal_tray:hide() end
    if hotkeytext then
        hotkeytext:delete()
        hotkeytext=nil
        hotkeybg:delete()
        hotkeybg=nil
    end
end

-- modalmgr:bind("", "space", "Alfred 3", function() exit_others() activateApp("Alfred 3") end)
modalmgr:bind("", "escape", "Exit Main Mode", function() modalmgr:exit() end)
modalmgr:bind("", "Q", "Exit Main Mode", function() modalmgr:exit() end)

if appM then
    appM_keys = appM_keys or {"", "A"}
    if string.len(appM_keys[2]) > 0 then
        appM:bind(modalmgr_keys[1], modalmgr_keys[2], "Enter Main Mode", function() exit_others() modalmgr:enter() end)
        modalmgr:bind(appM_keys[1], appM_keys[2], 'Enter Application Mode', function() exit_others() appM:enter() end)
    end
end

if clipboardM then
    clipboardM_keys = clipboardM_keys or {"", "C"}
    if string.len(clipboardM_keys[2]) > 0 then
        clipboardM:bind(modalmgr_keys[1], modalmgr_keys[2], "Enter Main Mode", function() exit_others() modalmgr:enter() end)
        modalmgr:bind(clipboardM_keys[1], clipboardM_keys[2], 'Enter Clipboard Mode', function() exit_others() clipboardM:enter() end)
    end
end

if aria2_loaded then
    aria2_keys = aria2_keys or {"", "D"}
    if string.len(aria2_keys[2]) > 0 then
        modalmgr:bind('', 'D', 'Launch aria2 Frontend', function()
            exit_others()
            if aria2_drawer then aria2_drawer:delete() aria2_drawer = nil end
            aria2_Init()
        end)
    end
end

if hsearch_loaded then
    hsearch_keys = hsearch_keys or {"", "G"}
    if string.len(hsearch_keys[2]) > 0 then
        modalmgr:bind(hsearch_keys[1], hsearch_keys[2], 'Launch Hammer Search', function() exit_others() launchChooser() end)
    end
end

if timerM then
    timerM_keys = timerM_keys or {"", "I"}
    if string.len(timerM_keys[2]) > 0 then
        timerM:bind(modalmgr_keys[1], modalmgr_keys[2], "Enter Main Mode", function() exit_others() modalmgr:enter() end)
        modalmgr:bind(timerM_keys[1], timerM_keys[2], 'Enter Timer Mode', function() exit_others() timerM:enter() end)
    end
end

if resizeM then
    resizeM_keys = resizeM_keys or {"", "R"}
    if string.len(resizeM_keys[2]) > 0 then
        resizeM:bind(modalmgr_keys[1], modalmgr_keys[2], "Enter Main Mode", function() exit_others() modalmgr:enter() end)
        modalmgr:bind(resizeM_keys[1], resizeM_keys[2], 'Enter Resize Mode', function() exit_others() resizeM:enter() end)
    end
end

if cheatsheetM then
    cheatsheetM_keys = cheatsheetM_keys or {"", "S"}
    if string.len(cheatsheetM_keys[2]) > 0 then
        cheatsheetM:bind(modalmgr_keys[1], modalmgr_keys[2], "Enter Main Mode", function() exit_others() modalmgr:enter() end)
        modalmgr:bind(cheatsheetM_keys[1], cheatsheetM_keys[2], 'Enter Cheatsheet Mode', function() exit_others() cheatsheetM:enter() end)
    end
end

showtime_keys = showtime_keys or {"", "T"}
if string.len(showtime_keys[2]) > 0 then
    modalmgr:bind(showtime_keys[1], showtime_keys[2], 'Show Digital Clock', function() exit_others() show_time() end)
end

show_screen_numbers_keys = show_screen_numbers_keys or {"", "N"}
if string.len(show_screen_numbers_keys[2]) > 0 then
    modalmgr:bind(show_screen_numbers_keys[1], show_screen_numbers_keys[2], 'Show Screen Numbers', function() exit_others() show_screen_numbers() end)
end

if viewM then
    viewM_keys = viewM_keys or {"", "V"}
    if string.len(viewM_keys[2]) > 0 then
        viewM:bind(modalmgr_keys[1], modalmgr_keys[2], "Enter Main Mode", function() exit_others() modalmgr:enter() end)
        modalmgr:bind(viewM_keys[1], viewM_keys[2], 'Enter View Mode', function() exit_others() viewM:enter() end)
    end
end

toggleconsole_keys = toggleconsole_keys or {"", "Z"}
if string.len(toggleconsole_keys[2]) > 0 then
    modalmgr:bind(toggleconsole_keys[1], toggleconsole_keys[2], 'Toggle Hammerspoon Console', function() exit_others() hs.toggleConsole() end)
end

winhints_keys = winhints_keys or {"", "tab"}
if string.len(winhints_keys[2]) > 0 then
    modalmgr:bind(winhints_keys[1], winhints_keys[2], 'Show Windows Hint', function() exit_others() hs.hints.windowHints() end)
end
