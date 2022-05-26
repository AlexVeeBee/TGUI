#include "./TGUI_ui_library.lua"
#include "./TGUI_manager.lua"

--[[

    How to get TGUI working

    please include TGUI_manager.lua and TGUI_ui_library.lua with #include "./"
    how to create your own window
    1. type talbe.insert() to insert
    2. use any name to have your windows created stored like: myWindowsTable = {}
    3. type your table name into the first parameter of talbe.insert()
    here is a liminal window settings table for the second parameter of talbe.insert(myWindowsTable, {})
        `{
            firstFrame = true,
            title = "Hello title",
            padding = 0,
            pos = {x = 180, y = 200},
            size = {w = 628, h = 458},
            clip = false, content = function(window)
            end ,
        },
    4. you are now done creating your window

    --- OPTIONS ---
    -- closeWindow = false, close window
    -- startMiddle = false
    -- allowResize = true, allow the window to resize

    final code:

    table.insert(myWindowsTable ,{
        firstFrame = true,
        title = "Hello title",
        padding = 0,
        pos = {x = 180, y = 200},
        size = {w = 628, h = 458},
        clip = false, content = function(window)
        end ,
    })
]]

function init()
    
    compass_ui_assets = "MOD/ui/TGUI_resources"
    tgui_ui_assets = "MOD/ui/TGUI_resources"
    globalWindowOpacity = 1
    camera = FindLocation('camera_test',true)
    activeWindows = 
    { 
        -- {
        --     firstFrame = true,
        --     title = "Hello title",
        --     padding = 12,
        --     opacity = 12,
        --     pos = {x = 180, y = 200},
        --     size = {w = 628, h = 458},
        --     clip = false, content = function(window)
        --         -- UiText('Hello world')
        --         if uic_button(1,"Hello World from the button",UiWidth(),32, false, "Tool tip hello world") then
        --             window.closeWindow = true
        --         end
        --         UiTranslate(0,36)
        --         uic_slider("test.slider", 0, 250)
        --     end ,
        -- },
        -- {
        --     firstFrame = true,
        --     title = "Hello title",
        --     padding = 2,
        --     opacity = 1,
        --     pos = {x = 800, y = 200},
        --     size = {w = 128, h = 72},
        --     clip = false,
        --     content = function(window)
        --         if uic_button(2,"Close window",UiWidth(),32, false, "Tool tip hello world") then
        --             window.closeWindow = true
        --         end
        --     end ,
        -- }
    }
    
    -- SetString('TGUI.stringViewer.path','game')
    regExplorer_doubleclick_timer = 0
end

uic_debug_checkHit = false
uic_debug_buttontextWidth = false
isFirstFrame = true
NewWindowPopup = false

function GlobalWindowAddTest()
    table.insert(activeWindows ,{
        firstFrame = true,
        title = "Hello title",
        padding = 2,
        opacity = 1,
        pos = {x = 800, y = 200},
        size = {w = 128, h = 72},
        clip = false,
        allowResize = false,
        content = function(window)
            if uic_button(2,"Close window",UiWidth(),32, false, "Tool tip hello world") then
                window.closeWindow = true
            end
        end ,
    })
end

function draw(dt)
    -- UiPush()
    --     UiTranslate(10,UiMiddle())
    --     UiImageBox('./ui/TGUI_resources/bars/bar_background.png',500,22,5,0)
    --     UiTranslate(4,3)
    --     UiImageBox('./ui/TGUI_resources/bars/health_bar.png',250,13,1,1)
    -- UiPop()
    initDrawTGUI(activeWindows)

    -- COMPASS
    if (GetBool('hpTD.compass')) then
        UiPush()
            -- player        
            local t = GetPlayerCameraTransform().rot
            local _, t_el_y, _ = GetQuatEuler( t )

            player_r_y = t_el_y*2
            UiTranslate(UiCenter(),15)
            UiAlign('center top')
            UiPush()
                UiTranslate(0,20)
                UiAlign('bottom center')
                UiPush()
                    UiTranslate(0,20)
                    UiImage(compass_ui_assets..'/compass/compass_shading.png')
                UiPop()
                UiPush()
                    UiTranslate(0,33)
                    UiImage(compass_ui_assets..'/compass/compass_line.png')
                UiPop()
            UiPop()
            UiPush()
                function mathZoneArea(x,z)
                    if x< 0 then return x+100  end
                    if x> 0 then return -x+100 end
                end

                -- mathZoneArea(t_el_y,200)
                UiTranslate( player_r_y ,0)

                UiPush()
                    UiColor(0,1,1,mathZoneArea(t_el_y,200))
                    UiTranslate( 0  ,0)
                    UiRect(5,30)
                UiPop()
                -- 180
                UiPush()
                    UiColor(1,0,1,mathZoneArea(t_el_y+180,200))
                    UiTranslate( 180*2  ,0)
                    UiRect(5,30)
                UiPop()
                UiPush()
                    UiColor(1,0,1,mathZoneArea(t_el_y-180,200))
                    UiTranslate( -180*2  ,0)
                    UiRect(5,30)
                UiPop()
                -- 90
                UiPush()
                    UiColor(1,0,0,mathZoneArea(t_el_y+90,200))
                    UiTranslate( 90*2  ,0)
                    UiRect(5,30)
                UiPop()
                UiPush()
                    UiColor(1,0,0,mathZoneArea(t_el_y-90,200))
                    UiTranslate( -90*2  ,0)
                    UiRect(5,30)
                UiPop()
                -- 90 arround
                UiPush()
                    UiColor(1,0,0,mathZoneArea(t_el_y+260,200))
                    UiTranslate( 360+180  ,0)
                    UiRect(5,30)
                UiPop()
                UiPush()
                    UiColor(1,0,0,mathZoneArea(t_el_y-260,200))
                    UiTranslate( -360-180  ,0)
                    UiRect(5,30)
                UiPop()
            UiPop()
        UiPop()
    end

    function regExplorer( prePath )
        if prePath == nil then
            prePath = "game"
        end

        table.insert(activeWindows ,{
            testFirstFrame = true,
            -- DATA
                StringViewer={
                    itemSelectedNum = 0,
                    tableView_width = {
                        regName = 0,
                        regString = 0,
                        regInt = 0,
                    },
                    directPath = "",
                    path = prePath,
                    lastpath = "",
                    openDeletePathWindow = false,
                    openEditReghWindow = false,
                    doubleCLickTimer = 0,
                    BackHistoryNumber = 1,
                    historyPos = 0,
                    history = {
                        {
                            path = "game",
                            viewing = true,
                        }
                    }
                },
                ListScrollContainer = {scrollfirstFrame = true,},
                regEditTextBox = {focused = false},
                regNewTextbox = {focused = false},
            --
            scrollHeight = 1500,
            scrollConHeight = 500,
            firstFrame = true,
            title = "REGISTRY EXPLORER",
            padding = 0,
            pos = {x = 180, y = 200},
            size = {w = 600, h = 628},
            minSize = {w = 600, h = 300},
            startMiddle = true,
            doNotHide = false,
            clip = false,
            content = function(window)
                function buttonIcon(path, disabled , action)
                    UiPush()
                        local ico_w, ico_h = UiGetImageSize(path)
                        local padding = 8
                        UiWindow(ico_w+padding, ico_h+padding, false)
                        UiAlign("left top")
                        if not disabled then
                            if UiBlankButton(ico_w+padding, ico_h+padding) then
                                action()
                            end
                            if UiIsMouseInRect(ico_w+padding, ico_h+padding) then
                                if not InputDown('lmb') then
                                    UiImageBox("MOD/ui/TGUI_resources/textures/outline_outer_normal.png",ico_w+padding, ico_h+padding,1,1,1,1)
                                else
                                    UiImageBox("MOD/ui/TGUI_resources/textures/outline_inner_normal.png",ico_w+padding, ico_h+padding,1,1,1,1)
                                    UiTranslate(1,1)
                                end
                            else
                                UiImageBox("MOD/ui/TGUI_resources/textures/outline_outer_normal.png",ico_w+padding, ico_h+padding,1,1,1,1)
                            end
                            UiColor(1,1,1,1)
                        else
                            UiImageBox("MOD/ui/TGUI_resources/textures/outline_outer_normal.png",ico_w+padding, ico_h+padding,1,1,1,1)
                            UiColor(0.1,0.1,0.1,0.8)
                        end
                        UiTranslate((ico_w+padding)/2, (ico_h+padding)/2)
                        UiAlign("center middle")
                        UiImage(path)
                    UiPop()
                end
                if window.StringViewer.path == window.StringViewer.lastpath then
                else
                    window.StringViewer.tableView_width.regName = 0
                    window.StringViewer.tableView_width.regString = 0
                    window.StringViewer.tableView_width.regInt = 0
                    window.StringViewer.lastpath = window.StringViewer.path
                end
                local listKeys = ListKeys(window.StringViewer.path)
                UiTranslate(12,0)
                uic_container( UiWidth()-24, UiHeight()-148 , true, true, false, function(window)
                    window.title = "REGISTRY EXPLORER ["..window.StringViewer.path.."]"
                    local scrollHeight = 0
                    UiTranslate(6,6)
                    for i, v in ipairs(listKeys) do scrollHeight = scrollHeight + 14 end
                    UiPush()
                        local AllowBack = false
                        DebugWatch("BackHistoryNumber",window.StringViewer.BackHistoryNumber)
                        for i, v in pairs(window.StringViewer.history) do
                            if window.StringViewer.historyPos == i then
                                window.StringViewer.historyPos = i
                            end
                            if i > 1 then
                                AllowBack = true
                                DebugWatch("BackHistoryNumber path",window.StringViewer.history[#window.StringViewer.history].path)
                                window.StringViewer.BackHistoryNumber = #window.StringViewer.history
                            else
                                AllowBack = false
                            end
                        end
                        buttonIcon("./ui/TGUI_resources/textures/arrow_left.png", true, function()
                            window.StringViewer.path = window.StringViewer.history[#window.StringViewer.history-1].path
                            -- DebugPrint('go to: '.. window.StringViewer.history[#window.StringViewer.history-1].path)
                        end)
                        UiTranslate(24,0)
                        buttonIcon("./ui/TGUI_resources/textures/arrow_right.png", true, function() end)
                        UiTranslate(24,0)
                        uic_text(window.StringViewer.path,14)
                        UiTranslate(UiWidth() - 62,0)
                        UiAlign('top right')
                        uic_text(#listKeys.." Items",14)
                    UiPop()
                    UiTranslate(0,21)
                    uic_container( UiWidth()-12, UiHeight()-36 , true, false, false, function()
                        UiImageBox('./ui/TGUI_resources/textures/outline_inner_normal_dropdown.png',UiWidth(), UiHeight(),1,1)
                        if #listKeys == 0 then
                            SetInt('TGUI.regExplorer.HoveringItem',0)
                        end
                        uic_scroll_Container(window.ListScrollContainer, UiWidth(), UiHeight(), false, scrollHeight, function()
                            SetBool('TGUI.regExplorer.itemHover',false)
                            if window.StringViewer.openNewReghWindow then
                                window.StringViewer.openNewReghWindow = false
                                window.focused = false
                                    table.insert(activeWindows ,{
                                        firstFrame = true,
                                        title = "New registry/key",
                                        -- DATA
                                            editVal = {focused = false},
                                        -- 
                                        padding = 0,
                                        pos = {x = 180, y = 200},
                                        size = {w = 400, h = 150},
                                        minSize = {w = 0, h = 0},
                                        startMiddle = true,
                                        allowResize = false,
                                        doNotHide = true,
                                        clip = false,
                                        content = function(editWindow)
                                            UiTranslate(12,0)
                                            UiPush()
                                                uic_text( 'REG: '..GetString("TGUI.regExplorer.newDirPath"), 19)
                                                UiTranslate(0,24)
                                                uic_text( "Name: ", 19)
                                                UiPush()
                                                    UiTranslate(50,0)
                                                    local textin = uic_textbox("TGUI.regExplorer.regNew",UiWidth()-72,editWindow.editVal )
                                                UiPop()
                                                -- end
                                            UiPop()
                                            UiTranslate(0,UiHeight())
                                            UiAlign('bottom right')
                                            UiTranslate(UiWidth()-24,-12)
                                            local txtBoxDoesNotHaveCharacters = false
                                            if #textin == 0 then
                                                txtBoxDoesNotHaveCharacters = true
                                            end
                                            uic_button_func(0, "Close", 75, 24, false, "", function()
                                                editWindow.closeWindow = true
                                            end)
                                            UiTranslate(-80,0)
                                            uic_button_func(0, "Create", 75, 24, txtBoxDoesNotHaveCharacters, "", function()
                                                SetString(GetString("TGUI.regExplorer.newDirPath").."."..GetString('TGUI.regExplorer.regNew'),' ')
                                                SetString('TGUI.regExplorer.regNew','')
                                                editWindow.closeWindow = true
                                            end)
                                        end
                                    })
                                -- end)
                            end
                            if GetInt('TGUI.regExplorer.HoveringItem') == 0 and InputPressed('rmb') then
                                if window.StringViewer.blockedReg == false then
                                    uic_cursor_contextMenu({
                                        {type = "button", text="Create registry/Key here", action=function()
                                            SetString('TGUI.regExplorer.newDirPath',window.StringViewer.path)
                                            window.StringViewer.openNewReghWindow = true
                                        end},
                                    }, window)
                                else
                                    uic_cursor_contextMenu({
                                        {type = "", text="Editing Disabled"},
                                    }, window)
                                end
                            end

                            for i, v in ipairs(listKeys) do
                                scrollHeight = scrollHeight + 14
                                UiPush()
                                    if window.StringViewer.openDeletePathWindow then
                                        -- uic_button_func(0, "Open path", 100, 24, false, "", function()
                                            window.StringViewer.openDeletePathWindow = false
                                            window.focused = false
                                            table.insert(activeWindows ,{
                                                firstFrame = true,
                                                title = "Delete path",
                                                padding = 0,
                                                pos = {x = 180, y = 200},
                                                size = {w = 400, h = 130},
                                                minSize = {w = 0, h = 0},
                                                startMiddle = true,
                                                allowResize = false,
                                                doNotHide = true,
                                                clip = false,
                                                content = function(warningWindow)
                                                    UiTranslate(12,0)
                                                    UiPush()
                                                        UiText('Are you sure you want to delete this registry?\nYou wont be able to undo',move)
                                                        UiTranslate(0,32)
                                                        UiText('REG: '..GetString('TGUI.regExplorer.deletePath'))
                                                    UiPop()
                                                    UiAlign('bottom right')
                                                    UiTranslate(0,UiHeight())
                                                    UiTranslate(UiWidth()-24,-12)
                                                    uic_button_func(0, "No", 60, 24, false, "", function()
                                                        warningWindow.closeWindow = true
                                                    end)
                                                    UiTranslate(-75,0)
                                                    uic_button_func(0, "Yes", 60, 24, false, "", function()
                                                        ClearKey(window.StringViewer.directPath)
                                                        warningWindow.closeWindow = true
                                                    end)
                                                end
                                            })
                                        -- end)
                                    end
                                    if window.StringViewer.openEditReghWindow then
                                        window.StringViewer.openEditReghWindow = false
                                        window.focused = false
                                            table.insert(activeWindows ,{
                                                firstFrame = true,
                                                title = "Edit registry",
                                                -- DATA
                                                    editRegFirstFrame = true,
                                                    editVal = {focused = false},
                                                    checkBox_see_live = false,
                                                -- 
                                                padding = 0,
                                                pos = {x = 180, y = 200},
                                                size = {w = 400, h = 150},
                                                minSize = {w = 0, h = 0},
                                                startMiddle = true,
                                                allowResize = false,
                                                doNotHide = true,
                                                clip = false,
                                                content = function(editWindow)
                                                    UiTranslate(12,0)
                                                    UiPush()
                                                        if editWindow.editRegFirstFrame then
                                                            SetString('TGUI.regExplorer.regEdit', GetString( window.StringViewer.directPath))
                                                            editWindow.editRegFirstFrame = false
                                                        end
                                                        uic_text( 'REG: '..window.StringViewer.directPath, 19)
                                                        UiTranslate(0,24)
                                                        uic_text( "Value:", 19)
                                                        UiPush()
                                                        UiTranslate(50,0)
                                                        local textin = uic_textbox("TGUI.regExplorer.regEdit",UiWidth()-72,editWindow.editVal )
                                                        UiPop()
                                                        local str = GetString(window.StringViewer.directPath)
                                                        local isNumber = not (str == "" or str:find("%D"))
                                                        UiTranslate(0,24)
                                                        UiPush()
                                                            UiAlign('top right')
                                                            UiTranslate(UiWidth()-24,-48)
                                                            if isNumber then
                                                                uic_text( "int", 24)
                                                            elseif not isNumber then
                                                                uic_text( "string", 24)
                                                            end
                                                        UiPop()
                                                        UiTranslate(0,0)
                                                        -- if editWindow.checkBox_see_live then
                                                        UiPush()
                                                            uic_text( "Prev:", 24)
                                                            UiTranslate(50,0)
                                                            uic_text( GetString(window.StringViewer.directPath), 24)
                                                        UiPop()
                                                        -- end
                                                    UiPop()
                                                    UiTranslate(0,UiHeight())
                                                    UiPush()
                                                        UiTranslate(12,-28)
                                                        editWindow.checkBox_see_live=uic_checkbox("Live", editWindow.checkBox_see_live, 75)
                                                    UiPop()
                                                    UiAlign('bottom right')
                                                    UiTranslate(UiWidth()-24,-12)
                                                    uic_button_func(0, "Close", 75, 24, false, "", function()
                                                        editWindow.closeWindow = true
                                                    end)
                                                    UiTranslate(-80,0)
                                                    uic_button_func(0, "Apply", 75, 24, editWindow.checkBox_see_live, "", function()
                                                        if isNumber then
                                                            SetInt(window.StringViewer.directPath,textin*1)
                                                        elseif not isNumber then
                                                            SetString(window.StringViewer.directPath,textin)
                                                        end
                                                        editWindow.closeWindow = true
                                                    end)
                                                    if editWindow.checkBox_see_live then
                                                        if isNumber then
                                                            SetInt(window.StringViewer.directPath,textin*1)
                                                        elseif not isNumber then
                                                            SetString(window.StringViewer.directPath,textin)
                                                        end
                                                    end
                                                end
                                            })
                                        -- end)
                                    end
            
                                    if UiIsMouseInRect(UiWidth(),14) then
                                        UiPush()
                                            UiColor(c255(255),c255(156),c255(0),1)
                                            UiRect(UiWidth(),14)
                                        UiPop()
                                        SetInt('TGUI.regExplorer.HoveringItem',i)
                                    else
                                        if GetInt('TGUI.regExplorer.HoveringItem') == i then
                                            SetInt('TGUI.regExplorer.HoveringItem',0)
                                        end
                                    end
                                    if i == window.StringViewer.itemSelectedNum and not GetBool('TGUI.regExplorer.itemHighlight') then
                                        UiPush()
                                            UiColor(c255(65),c255(65),c255(65),0.5)
                                            UiRect(UiWidth(),14)
                                        UiPop()
                                        if InputPressed('lmb') or InputPressed("rmb") then
                                            window.StringViewer.itemSelectedNum = 0
                                        end
                                    end
                                    if GetBool('TGUI.regExplorer.itemHighlight') == true and GetString('TGUI.regExplorer.deletePath') == window.StringViewer.path.."."..v then
                                        UiPush()
                                            UiColor(c255(65),c255(65),c255(65),0.5)
                                            UiRect(UiWidth(),14)
                                        UiPop()
                                    end
                                    if UiBlankButton(UiWidth(),14) then
                                        if regExplorer_doubleclick_timer == 0 then
                                            regExplorer_doubleclick_timer = 1
                                            window.StringViewer.itemSelectedNum = i
                                        else
                                            window.StringViewer.path = window.StringViewer.path.."."..v
                                            table.insert(window.StringViewer.history ,{
                                                path = window.StringViewer.path,
                                                viewing = true,
                                            })
                                            regExplorer_doubleclick_timer = 0
                                        end
                                    end
                                    if regExplorer_doubleclick_timer == 1 then
                                        SetValue('regExplorer_doubleclick_timer',0,"linear",0.3)
                                    end
                                    if UiIsMouseInRect(UiWidth(),14) and InputPressed('rmb') then
                                        SetString('TGUI.regExplorer.deletePath',window.StringViewer.path.."."..v)
                                        SetBool('TGUI.regExplorer.itemHighlight', true)
                                        if window.StringViewer.blockedReg == false then
                                            uic_cursor_contextMenu({
                                                -- {type = "", text="PATH:"..GetString('TGUI.regExplorer.deletePath')},
                                                {type = "button", text="Open registry in new window", action=function()
                                                    SetString('TGUI.regExplorer.openNew',window.StringViewer.path.."."..v)
                                                end},
                                                {type = "button", text="Edit", action=function()
                                                    window.StringViewer.directPath = window.StringViewer.path.."."..v
                                                    window.StringViewer.openEditReghWindow = true
                                                end},
                                                {type = "button", text="Delete registry", action=function()
                                                    SetString('TGUI.regExplorer.deletePath',window.StringViewer.path.."."..v)
                                                    window.StringViewer.directPath = window.StringViewer.path.."."..v
                                                    window.StringViewer.openDeletePathWindow = true
                                                end},
                                                {type="divider"},
                                                {type = "button", text="Create registry/Key in selected registry", action=function()
                                                    SetString('TGUI.regExplorer.newDirPath',window.StringViewer.path.."."..v)
                                                    window.StringViewer.openNewReghWindow = true
                                                end},
                                                {type = "button", text="Create registry/Key in current registry", action=function()
                                                    SetString('TGUI.regExplorer.newDirPath',window.StringViewer.path)
                                                    window.StringViewer.openNewReghWindow = true
                                                end},
                                            }, window)
                                        else
                                            uic_cursor_contextMenu({
                                                {type = "button", text="Open registry in new window", action=function()
                                                    SetString('TGUI.regExplorer.openNew',window.StringViewer.path.."."..v)
                                                end},
                                            }, window)
                                        end
                                    end
                                    if uic_draw_contextmenu == false then
                                        SetBool('TGUI.regExplorer.itemHighlight', false)
                                    end
                                    UiDisableInput()    
                                    uic_text(v,14)
                                    local txt_w, _ = UiGetTextSize(v)
                                    if txt_w >= window.StringViewer.tableView_width.regName then
                                        window.StringViewer.tableView_width.regName = txt_w
                                    end
                                    local txt_w, _ = UiGetTextSize(GetString( window.StringViewer.path.."."..v ))
                                    if txt_w >= window.StringViewer.tableView_width.regString then
                                        window.StringViewer.tableView_width.regString = txt_w
                                    end
                                    UiPush()
                                        UiTranslate(window.StringViewer.tableView_width.regName+20,0)
                                        uic_text( GetString( window.StringViewer.path.."."..v ),14)
                                    UiPop()
                                    UiTranslate((window.StringViewer.tableView_width.regName+30)+window.StringViewer.tableView_width.regString,0)
                                    uic_text( GetInt( window.StringViewer.path.."."..v ),14)
                            -- end
                                UiPop()
                                UiTranslate(0,14)
                            end

                        end )
                    end,false)
                end, window)
                uic_container( UiWidth()-24, 100 , true, true, false, function(window)
                    UiDisableInput()
                    UiTranslate(12,12)
                    -- UiTextButton( type( GetString(GetString('TGUI.stringViewer.path')) ),UiWidth(),14)
                    local pathMatch = window.StringViewer.path
                    local bypassBlockedReg = GetBool('TGUI.regExplorer.bypass')
                    local blockedReg = false
                    -- if string.match(pathMatch, "savegame.mod", 1) then
                    if bypassBlockedReg then
                        window.StringViewer.blockedReg = false
                    else
                        if string.match(pathMatch, "game", 1)  then
                        if string.find(pathMatch, "savegame.mod", 1) then window.StringViewer.blockedReg = false else window.StringViewer.blockedReg = true end
                        else window.StringViewer.blockedReg = false end
                    end
                    if window.StringViewer.blockedReg == false then
                        UiEnableInput()
                        UiTranslate(0,4)
                        UiPush()
                            uic_text("current registry value",24)
                            UiTranslate(150,0)
                            uic_textbox(window.StringViewer.path,UiWidth()-(208),window.regEditTextBox)
                        UiPop()
                        UiTranslate(0,26)
                        UiPush()
                            uic_text("New registry",24)
                            UiTranslate(150,0)
                            uic_textbox("TGUI.regExplorer.newDir",145,window.regNewTextbox)
                            UiTranslate(150,0)
                            uic_button_func(0, "Create a new registry",130, 24, false, "", function()
                                SetString(window.StringViewer.path.."."..GetString('TGUI.regExplorer.newDir'),'')
                                SetString('TGUI.regExplorer.newDir','')
                            end)
                        UiPop()
                    else
                        blockedReg = true
                        uic_text("Editing Disabled",14)
                        window.StringViewer.editMode = false
                        UiTranslate(0,20)
                        uic_text(window.StringViewer.path,14)
                    end
                end, window)
                UiPush()
                    UiTranslate(0,12)
                    uic_checkbox("Keep editing enabled", "TGUI.regExplorer.bypass", 140, false, "Edit everywhere")
                    UiTranslate(150,0)
                    window.doNotHide=uic_checkbox("Keep Window visible", window.doNotHide, 140, false, "Keep window visible")
                UiPop()
                UiPush()
                    UiTranslate(UiWidth()-24,8)
                    UiAlign('top right')
                    uic_button_func(0, "Open path", 100, 24, false, "", function()
                        window.focused = false
                        table.insert(activeWindows ,{
                            testFirstFrame = true,
                            firstFrame = true,
                            title = "Open path",
                            txtbox_regOpenPath = {focused = false},
                            padding = 0,
                            pos = {x = 180, y = 200},
                            size = {w = 350, h = 300},
                            minSize = {w = 0, h = 0},
                            startMiddle = true,
                            allowResize = false,
                            doNotHide = true,
                            clip = false,
                            content = function(openPathWindow)
                                UiPush()
                                    UiTranslate(12,0)
                                    uic_button_func(0, "game", 150 - 24, 24, false, "", function()
                                        window.StringViewer.path = 'game'
                                        table.insert(window.StringViewer.history ,{
                                            path = "game",
                                            viewing = true,
                                        })
                                        openPathWindow.closeWindow = true
                                    end)
                                    UiTranslate(0,30)
                                    uic_button_func(0, "options", 150 - 24, 24, false, "", function()
                                        window.StringViewer.path = 'options'
                                        table.insert(window.StringViewer.history ,{
                                            path = "options",
                                            viewing = true,
                                        })
                                        openPathWindow.closeWindow = true
                                    end)
                                    UiTranslate(0,30)
                                    uic_button_func(0, "savegame", 150 - 24, 24, false, "", function()
                                        window.StringViewer.path = 'savegame'
                                        table.insert(window.StringViewer.history ,{
                                            path = "savegame",
                                            viewing = true,
                                        })
                                        openPathWindow.closeWindow = true
                                    end)
                                    UiTranslate(0,30)
                                    uic_button_func(0, "TGUI", 150 - 24, 24, false, "", function()
                                        window.StringViewer.path = 'TGUI'
                                        table.insert(window.StringViewer.history ,{
                                            path = "TGUI",
                                            viewing = true,
                                        })
                                        openPathWindow.closeWindow = true
                                    end, window)
                                UiPop()
                                UiPush()
                                    UiTranslate(160,0)
                                    uic_text("Custom Path", 18)
                                    UiTranslate(0,20)
                                    uic_textbox("TGUI.regExplorer.openPath", 160, openPathWindow.txtbox_regOpenPath )
                                    UiTranslate(0,26)
                                    local disableButton = false
                                    if #GetString('TGUI.regExplorer.openPath') == 0 then
                                        disableButton = true
                                    end

                                    uic_button_func(0, "Open", 60, 24, disableButton, "", function()
                                        window.StringViewer.path = GetString('TGUI.regExplorer.openPath')
                                        table.insert(window.StringViewer.history ,{
                                            path = GetString('TGUI.regExplorer.openPath'),
                                            viewing = true,
                                        })
                                        openPathWindow.closeWindow = true
                                    end, window)
                                    UiTranslate(70,0)
                                    uic_text("items in registry: "..#ListKeys(GetString('TGUI.regExplorer.openPath')),24)
                                UiPop()
                            end
                        })
                    end)
                    UiTranslate(-110,0)
                    uic_button_func(0, "Help", 100, 24, false, "", function()
                        window.focused = false
                        table.insert(activeWindows ,{
                            testFirstFrame = true,
                            firstFrame = true,
                            title = "Help",
                            txtbox_regOpenPath = {focused = false},
                            helpSectionsView = 1,
                            helpSections = {
                                {
                                    title = "Why cant i see savegame.mod registry",
                                    content = function( ... )
                                        local t = uic_text("It is only accessible by the mod itself")
                                        UiTranslate(0,0+t.height)
                                        local t = uic_text("to access the registry, copy this mod to your project directory")
                                        UiTranslate(0,0+t.height)
                                        local t = uic_text("you need the regExplorer code in your project ui code")
                                        UiTranslate(0,12+t.height)
                                        local t = uic_text("1. Make a local copy")
                                        UiTranslate(0,0+t.height)
                                        local t = uic_text("2. Copy all 3 files and the ui folder. MOD/ui/TGUI_resources are all the textures")
                                        UiPush()
                                            UiTranslate(12,0+t.height)
                                            local t = uic_text("TGUI_main.lua")
                                            UiTranslate(0,0+t.height)
                                            local t = uic_text("TGUI_manager.lua")
                                            UiTranslate(0,0+t.height)
                                            local t = uic_text("TGUI_ui_library.lua")
                                        UiPop()
                                        -- UiTranslate(0,0+t.height)
                                        -- local t = uic_text("")
                                    end
                                }
                            },
                            padding = 0,
                            pos = {x = 180, y = 200},
                            size = {w = 600, h = 550},
                            minSize = {w = 300, h = 400},
                            startMiddle = true,
                            -- allowResize = false,
                            -- doNotHide = true,
                            clip = false,
                            content = function(Helpindow)
                                UiPush()
                                    UiTranslate(12,0)
                                    uic_button_func(0, "savegame.mod not opening", 180, 24, false, "", function()
                                        Helpindow.helpSectionsView = 1
                                    end)
                                    UiTranslate(0,30)
                                UiPop()
                                UiTranslate(219,0)
                                UiPush()
                                    UiWindow(UiWidth()-229,UiHeight()-2,true)
                                        UiWordWrap(UiWidth())
                                        local titleText = uic_text(Helpindow.helpSections[Helpindow.helpSectionsView].title, 24, 20)
                                    
                                    UiTranslate(0,0+titleText.height)
                                    Helpindow.helpSections[Helpindow.helpSectionsView].content()
                                UiPop()
                            end
                        })
                    end)

                UiPop()
            end
        })
    end
    -- End of registry explorer code
    if HasKey('TGUI.regExplorer.openNew') then
        regExplorer(GetString('TGUI.regExplorer.openNew'))
        ClearKey('TGUI.regExplorer.openNew')
    end
    if NewWindowPopup then
        UiPush()
        UiMakeInteractive()
        UiAlign('top left')
        UiTranslate(UiCenter()-160/2,UiMiddle()-150)
        UiCreateWindow(160,300,false,"New Window",8,function()
            UiPush()
                UiAlign('bottom left ')
                UiTranslate(0,UiHeight())
                if uic_button(0,"Close",UiWidth(),24) then
                    NewWindowPopup = false
                end
            UiPop()
            UiPush()
                if uic_button(0,"Tiny window",UiWidth(),24) then
                        NewWindowPopup = false
                        table.insert(activeWindows ,{
                            firstFrame = true,
                            title = "Hello title",
                            padding = 2,
                            opacity = 1,
                            pos = {x = 800, y = 200},
                            size = {w = 128, h = 72},
                            clip = false,
                            allowResize = false,
                            content = function(window)
                                if uic_button(2,"Close window",UiWidth(),32, false, "Tool tip hello world") then
                                    window.closeWindow = true
                                end
                            end ,
                        })
            
                end
                UiTranslate(0,28);
                if uic_button(0,"Big window",UiWidth(),24) then
                    NewWindowPopup = false
                    table.insert(activeWindows ,{
                        tabFirstFrame = true,
                        firstFrame = true,
                        title = "Debuging Window",
                        padding = 0,
                        pos = {x = 180, y = 200},
                        size = {w = 628, h = 458},
                        allowResize = false,
                        startMiddle = true,
                        clip = false, content = function(window)
                                UiTranslate(12,0)
                                uic_tab_container(window, UiWidth()-24,UiHeight()-35,false,true,{
                                    ["open_default"] = 1,
                                    {
                                        ["title"] = "UI Settings",
                                        ["Content"] = function ()
                                            UiTranslate(10,10)
                                            uic_checkbox("enable compass", "hpTD.compass", 100)
                                            -- UiText('I am tab 2, THIS WORKS, YAY')
                                            -- fds.lol()
                                        end
                                    },
                                    {
                                        ["title"] = "Corner Test",
                                        ["Content"] = function ()
                                            UiPush()
                                                UiRect(30,30)
                                                UiAlign('bottom left')
                                                UiTranslate(0, UiHeight())
                                                UiRect(30,30)
                                            UiPop()
                                            UiPush()
                                                UiAlign('top right')
                                                UiTranslate(UiWidth(), 0)
                                                UiRect(30,30)
                                                UiAlign('bottom right')
                                                UiTranslate(0, UiHeight())
                                                UiRect(30,30)
                                            UiPop()
                                            UiPush()
                                                UiAlign('center middle')
                                                UiTranslate(UiCenter(), UiMiddle())
                                                UiRect(30,30)
                                            UiPop()
            
                                        end
                                    },
                                    {
                                        ["title"] = "tab 2",
                                        ["Content"] = function ()
                                            UiText('I am tab 3')
                                        end
                                    },
                                })
                                UiPush()
                                    UiTranslate(UiWidth()-32,3)
                                    UiAlign('top right')
                                    if uic_button(100,"Close",128,28) then
                                        window.closeWindow = true
                                    end
                                UiPop()
                                UiPush()
                                    UiTranslate(4,3)
                                    UiAlign('top left')
                                    uic_button_func(100,"About TGUI",128,28,false,"",function(activeWindows)
                                        aboutTGUI(activeWindows)
                                    end , activeWindows)
                                UiPop()
                        end ,
                    })
                end
                UiTranslate(0,28);
                if uic_button(0,"Double tab container",UiWidth(),24) then
                    NewWindowPopup = false
                    table.insert(activeWindows ,{
                        testFirstFrame = true,
                        -- DATA
                            tab1 = {tabFirstFrame = true, },
                            tab2 = {tabFirstFrame = true, },
                            scrollArea = {scrollfirstFrame = true,},
                            dropdown_1 = {firstFrame = true, tooltipId = 1, open = false},
                            dropdown_2 = {firstFrame = true, tooltipId = 2, open = false},
                            textBox_test = {focused = false},
                            textBox_test2 = {focused = false},
                            tableContainer = {
                                tableColumnNames = {
                                    {label="Test 1",w=0}, {label="column test 2",w=0},
                                    {label="Test 3",w=0}, {label="column test 4",w=0},
                                },
                                table = {
                                    {
                                        24,
                                        "test"
                                    },
                                    {
                                        "test",
                                        24
                                    },
                                    {
                                        "EEEEEEEEEEE",
                                        24,
                                        {},
                                        "eee",
                                    },
                                    {
                                        "EEEEEEEEEEE",
                                        24,
                                        {},
                                        "eee",
                                    },{
                                        "EEEEEEEEEEE",
                                        24,
                                        {},
                                        "eee",
                                    },{
                                        "EEEEEEEEEEE",
                                        24,
                                        {},
                                        "eee",
                                    },{
                                        "EEEEEEEEEEE",
                                        24,
                                        {},
                                        "eee",
                                    },{
                                        "EEEEEEEEEEE",
                                        24,
                                        {},
                                        "eee",
                                    },{
                                        "EEEEEEEEEEE",
                                        24,
                                        {},
                                        "eee",
                                    },{
                                        "EEEEEEEEEEE",
                                        24,
                                        {},
                                        "eee",
                                    },{
                                        "EEEEEEEEEEE",
                                        24,
                                        {},
                                        "eee",
                                    },{
                                        "EEEEEEEEEEE",
                                        24,
                                        {},
                                        "eee",
                                    },{
                                        "EEEEEEEEEEE",
                                        24,
                                        {},
                                        "eee",
                                    },{
                                        "EEEEEEEEEEE",
                                        24,
                                        {},
                                        "eee",
                                    },
                                },
                            },
                        --
                        scrollHeight = 1500,
                        scrollConHeight = 500,
                        firstFrame = true,
                        title = "Test Window",
                        padding = 0,
                        pos = {x = 180, y = 200},
                        size = {w = 1026, h = 628},
                        startMiddle = true,
                        clip = false,
                        content = function(window)
                            UiTranslate(12,0)
                            UiPush()
                            uic_tab_container(window.tab1,UiWidth()-24-300, UiHeight()-12, false, true, {
                                ["open_default"] = 1,
                                {
                                    title = "UI component: Container",
                                    ["Content"] = function()
                                        UiTranslate(10,10)
                                        uic_container(300, UiHeight()-20, false, true, true, function(window) 
                                            UiPush()
                                                UiTranslate(0,UiHeight() - 26)
                                                UiPush()
                                                    UiTranslate(24,-24)
                                                    uic_checkbox("Exit window? ","iam.key", 100,false)
                                                UiPop()
                                        
                                                uic_divider(UiWidth(),false)
                                                UiTranslate(UiWidth(),6)
                                                UiAlign("right top")
                                                if uic_button(0,"Yes",150,20,not GetBool('iam.key')) then 
                                                    window.closeWindow = true
                                                end
                                            UiPop()
                                        end, window)
                                    end
                                },
                                {
                                    title = "UI component: Table container",
                                    ["Content"] = function(MainWindow)
                                        UiTranslate(10,10)
                                        uic_table_container(MainWindow.tableContainer, 300, UiHeight()-20, false, true, true, MainWindow.tableContainer)
                                        UiTranslate(320,0)
                                        uic_button_func(0, "Empty Table", 100, 24, false, "", function ()
                                            MainWindow.tableContainer.table = {}
                                            MainWindow.tableContainer.tableColumnNames = {}
                                            -- for i, v in ipairs(MainWindow.tableContainer) do

                                            -- end
                                        end)
                                        UiTranslate(0,28)
                                        uic_button_func(0, "Small Table", 100, 24, false, "", function ()
                                            MainWindow.tableContainer.tableColumnNames = {
                                                {label="1",w=0}, {label="2",w=0},
                                            }
                                            MainWindow.tableContainer.table = {
                                                {
                                                    24,
                                                    "test"
                                                }
                                            }
                                        end)
                                        UiTranslate(0,28)
                                        uic_button_func(0, "Testing Table", 100, 24, false, "", function ()
                                            MainWindow.tableContainer.tableColumnNames = {
                                                {label="Test 1",w=0}, {label="column test 2",w=0},
                                                {label="Test 3",w=0}, {label="column test 4",w=0},
                                                {label="Test 5",w=0}, {label="column test 6",w=0},
                                            }
                                            MainWindow.tableContainer.table = {
                                                {
                                                    24,
                                                    "test"
                                                },
                                                {
                                                    "test",
                                                    24
                                                },
                                                {
                                                    "EEEEEEEEEEE",
                                                    24,
                                                    {},
                                                    "eee",
                                                },
                                                {
                                                    "EEEEEEEEEEE",
                                                    24,
                                                    {},
                                                    "eee",
                                                },{
                                                    "EEEEEEEEEEE",
                                                    24,
                                                    {},
                                                    "eee",
                                                },{
                                                    "EEEEEEEEEEE",
                                                    24,
                                                    {},
                                                    "eee",
                                                },{
                                                    "EEEEEEEEEEE",
                                                    24,
                                                    {},
                                                    "eee",
                                                },{
                                                    "EEEEEEEEEEE",
                                                    24,
                                                    {},
                                                    "eee",
                                                },{
                                                    "EEEEEEEEEEE",
                                                    24,
                                                    {},
                                                    "eee",
                                                },{
                                                    "EEEEEEEEEEE",
                                                    24,
                                                    {},
                                                    "eee",
                                                },{
                                                    "EEEEEEEEEEE",
                                                    24,
                                                    {},
                                                    "eee",
                                                },{
                                                    "EEEEEEEEEEE",
                                                    24,
                                                    {},
                                                    "eee",
                                                },{
                                                    "EEEEEEEEEEE",
                                                    24,
                                                    {},
                                                    "eee",
                                                },{
                                                    "EEEEEEEEEEE",
                                                    24,
                                                    {},
                                                    "eee",
                                                },
                                            }
                                            -- for i, v in ipairs(MainWindow.tableContainer) do

                                            -- end
                                        end)
                                    end
                                },
                                {
                                    title = "Dropdown Container",
                                    ["Content"] = function(MainWindow)
                                        UiTranslate(20,20)
                                        UiTranslate(0,32)
                                        uic_dropdown(MainWindow.dropdown_1, 100, "TGUI.dropdown.lol", {
                                            "1", "2", "3"
                                        }, {
                                            "tiem_1",
                                            "tiem_2",
                                            "tiem_3",
                                        }, false, "")
                                        -- UiTranslate(120,0)
                                        UiTranslate(0,-32)
                                        uic_dropdown(MainWindow.dropdown_2, 100, "TGUI.dropdown.lol2", {
                                            "january", "february", "march", "april", "may", "june", "july", "august", "september", "octeober" , "november", "december"
                                        }, {
                                            "m1",
                                            "m2",
                                            "m3",
                                            "m4",
                                            "m5",
                                            "m6",
                                            "m7",
                                            "m8",
                                            "m9",
                                            "m10",
                                            "m11",
                                            "m12",
                                            
                                        }, false, "")
                                    end
                                },
                                {
                                    title = "TextBox",
                                    ["Content"] = function(window)
                                        UiTranslate(20,20)
                                        local textbox_text = uic_textbox("TGUI.textbox.test", 300, window.textBox_test)
                                        UiPush()
                                            UiTranslate(0,25)
                                            _ = uic_textbox("TGUI.textbox.test2", 300, window.textBox_test2)
                                            UiTranslate(0,25)
                                            uic_dropdown(window.dropdown_1, 100, "TGUI.dropdown.lol", {
                                                "1", "2", "3",
                                                -- "1", "2", "3",
                                            }, {
                                                "Update to textobx",
                                                "Stop",
                                                "PLEASE STOP DAMNIT",
                                            }, false, "")
                                        UiPop()
                                        UiTranslate(310,0)
                                        uic_button_func(0, "Print", 100, 24, false, "", function()
                                            DebugPrint(textbox_text)
                                        end, textbox_text)
                                    end
                                },
                            }, window)
                            UiPop()
                            UiPush()
                            UiTranslate(UiWidth()-290,0)
                            uic_tab_container(window.tab2,260, UiHeight()-12, false, true, {
                                ["open_default"] = 1,
                                {
                                    ["title"] = "Scroll container test",
                                    ["Content"] = function()
                                        UiTranslate(12,12)
                                        uic_scroll_Container(window.scrollArea,UiWidth()-24,window.scrollConHeight, true, window.scrollHeight ,function(extraContent)
                                            UiTranslate(12,0)
                                            UiText('i am at the top')
                                            UiPush()
                                                UiTranslate(12,UiHeight()-200)
                                                UiPush()
                                                    UiTranslate(0,25)
                                                    UiText("Sroll height: "..extraContent.scrollHeight)
                                                    UiTranslate(0,32)
                                                    if (uic_button(0,"Add", 75, 24)) then
                                                        extraContent.scrollHeight = extraContent.scrollHeight + 100
                                                    end
                                                    UiTranslate(80,0)
                                                    if (uic_button(0,"Remove", 75, 24)) then
                                                        extraContent.scrollHeight = extraContent.scrollHeight - 100
                                                    end
                                                UiPop()
                                                UiPush()
                                                    UiTranslate(0,100)
                                                    UiText("Window height: "..extraContent.scrollConHeight)
                                                    UiTranslate(0,32)
                                                    if (uic_button(0,"Add", 75, 24)) then
                                                        extraContent.scrollConHeight = extraContent.scrollConHeight + 25
                                                    end
                                                    UiTranslate(80,0)
                                                    if (uic_button(0,"Remove", 75, 24)) then
                                                        extraContent.scrollConHeight = extraContent.scrollConHeight - 25
                                                    end
                                                UiPop()
                                            UiPop()

                                            UiTranslate(0,UiHeight()-24)
                                            UiText('i am at the bottom')
                                            UiTranslate(0,-60)
                                            if uic_button(0,"Close window", 100, 24) then
                                                extraContent.closeWindow = true
                                            end
                                        end, window) 
                                    end
                                },
                                {
                                    ["title"] = "short",
                                    ["Content"] = function()

                                    end
                                },
                                {
                                    ["title"] = "Tab 3",
                                    ["Content"] = function()

                                    end
                                },
                                {
                                    ["title"] = "Tab 4",
                                    ["Content"] = function()

                                    end
                                }
                            }, false)
                            UiPop()
                        end
                    })
                end
                UiTranslate(0,28);
                if uic_button(0,"String viewer",UiWidth(),24) then
                    NewWindowPopup = false
                    regExplorer()
                end
                UiTranslate(0,28);
                -- uic_button_func(0,"function button",UiWidth(),24, false, "", function(contents)
                --     DebugPrint(contents.win);
                --     DebugPrint(contents.pop);
                -- end, {win = activeWindows, pop = NewWindowPopup} )
            UiPop()
                return true
        end)
        UiPop()
    end
    if InputDown('ctrl') and InputPressed('c') then
        if GetBool('tgui.disableInput') then
            SetBool('tgui.disableInput',false)
        else
            NewWindowPopup = true
        end
    end
    if (#activeWindows > 0) then 
        UiPush()  
            UiTranslate(30,100)
            UiCreateWindow(120,100,false,"Window settings",8,function()
                if uic_button(0,"New window",UiWidth(),24) then
                    NewWindowPopup=true
                end
                UiTranslate(0,28)
                uic_checkbox("disable input", "tgui.disableInput", 100)
            end)
        UiPop()
    end
    
    uic_tooltip()
    uic_drawContextMenu()





    --     if (isFirstFrame) then
--         isFirstFrame = false

--     end
--     local mouse = { x = 0, y = 0 }
--     mouse.x, mouse.y = UiGetMousePos()
--     DebugWatch('mouse x',mouse.x)
--     DebugWatch('mouse y',mouse.y)

--     -- DebugWatch('test.values',GetString("test.values"))
--     UiDisableInput()
--     UiMakeInteractive()
--     SetCameraTransform(GetLocationTransform(camera),80,0)
--     -- UiImage('MOD/ui/Half-Life_2_Screenshot_2022.02.06_-_19.28.56.42.png',image)
--     -- UiTranslate(UiWidth()- 779,200)

    
--     if uic_button("lol", 100, 32 ) then 
--         UiCreateWindow( 100, 300, false, "lol", 12, function() end)
--     end
    
--     DrawAllWindows()
--     -- UiCreateWindow(500,600,false,"Window",8,function()
--     --     -- UiRect(UiWidth(),50)
--     --     uic_button("No if statement",150,20)
--     --     -- try.uic_test()
--     --     UiTranslate(0,30)
--     --     if uic_button("if statement",150,30) then
--     --         DebugPrint('return from the function')
--     --     end
--     --     UiTranslate(0,40)
--     --     uic_container(300,100,true,true,function() 
--     --         -- UiRect(UiWidth(),UiHeight())
--     --         UiText('Lol, Fart')
--     --         -- uic_button("I am fart in a best way",100,UiWidth())
--     --         UiPush()
--     --             UiTranslate(0,UiHeight() - 26)
--     --             UiPush()
--     --                 UiTranslate(24,-24)
--     --                 uic_checkbox("WRDFDafdsafdsaf ","iam.key", 100,false)
--     --             UiPop()
    
--     --             uic_divider(UiWidth(),false)
--     --             UiTranslate(UiWidth(),6)
--     --             UiAlign("right top")
--     --             if uic_button("No if statement",150,20,not GetBool('iam.key')) then  end
--     --         UiPop()
--     --     end)
--     --     UiTranslate(0,8)
--     --     uic_divider(UiWidth(),false)
--     --     UiTranslate(0,8)
--     --     UiText("Dock widget container")
--     --     UiTranslate(0,24)
--     --     uic_docking_container(UiWidth(),200,false,true,{
--     --         ["widget_id"] = 1,
--     --         ["open_default"] = 1,
--     --         [1] = {
--     --             ["title"] = "lol",
--     --             ["Content"] = function ()
--     --                 UiText('I am tab 1')
--     --                 UiPush()
--     --                     UiRect(30,30)
--     --                     UiAlign('bottom left')
--     --                     UiTranslate(0, UiHeight())
--     --                     UiRect(30,30)
--     --                 UiPop()
                    
--     --                 UiPush()
--     --                     UiAlign('top right')
--     --                     UiTranslate(UiWidth(), 0)
--     --                     UiRect(30,30)
--     --                     UiAlign('bottom right')
--     --                     UiTranslate(0, UiHeight())
--     --                     UiRect(30,30)
--     --                 UiPop()

--     --                 UiPush()
--     --                     UiAlign('center middle')
--     --                     UiTranslate(UiCenter(), UiMiddle())
--     --                     UiRect(30,30)
--     --                 UiPop()

--     --             end
--     --         },
--     --         [2] = {
--     --             ["title"] = "tab 2",
--     --             ["Content"] = function ()
--     --                 UiText('I am tab 2, ffs')
--     --             end
--     --         }
--     --     })
--     --     UiTranslate(0,8)
--     --     uic_divider(UiWidth(),false)
--     --     UiTranslate(0,8)
--     --     uic_dropdown(1,120 ,"savegame.mod.test.values",{
--     --         "value 1", "value 2", "value 3", "value 4", "value 5"
--     --     }, {
--     --         "val1", "val2", "val3", "val4", "val5"
--     --     }, false, "btuhhhhhhhhhhhhhhhhhhhhhh,\nnothing is changed right now")
--     --     -- UiTranslate(140,0)
--     --     UiTranslate(0,27)
--     --     uic_dropdown(2,200 ,"test.values2",{
--     --         "I AM TOOOOOOO BIG", "small"
--     --     }, {
--     --         "big", "small"
--     --     }, false, "i am tooltip dammit")
--     -- end)
--     lastMouse = mouse
end