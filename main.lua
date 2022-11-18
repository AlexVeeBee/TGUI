#include "./TGUI_ui_library.lua"
#include "TGUI_manager.lua"
#include "regeditWindow.lua"


--[[

    How to get TGUI working

    please include TGUI_manager.lua and TGUI_ui_library.lua with #include "./"
    how to create your own window
    1. type table.insert() to insert
    2. use any name to have your windows created stored like: myWindowsTable = {}
    3. type your table name into the first parameter of table.insert()
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
    ALL_WINDOWS_OPEN = ALL_WINDOWS_OPEN or { 
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
    SetBool('TGUI.test.ContextMenu.ItemDisabled', true)
    SetString('TGUI.settings.fonts.startpath',"MOD/ui/TGUI_resources/Fonts/")
    SetString('TGUI.settings.fonts.regular', "TAHOMA.TTF")
    SetString('TGUI.settings.fonts.bold', "TAHOMABD.TTF")
    --
    SetInt('TGUI.settings.colors.text.enabled.r', 255)
    SetInt('TGUI.settings.colors.text.enabled.g', 255)
    SetInt('TGUI.settings.colors.text.enabled.b', 255)
    --
    SetInt('TGUI.settings.colors.text.disabled.r', 255)
    SetInt('TGUI.settings.colors.text.disabled.g', 255)
    SetInt('TGUI.settings.colors.text.disabled.b', 255)
    --
    SetInt('TGUI.settings.colors.hover.r', 255)
    SetInt('TGUI.settings.colors.hover.g', 255)
    SetInt('TGUI.settings.colors.hover.b', 255)
    -- 
    SetInt("TGUI.test.listbox.h", 6)
end
TGUI_debug_show_windowMinsize = false
uic_debug_buttontextWidth = false
uic_debug_show_hitboxes_checkbox = false
uic_debug_show_hitboxes_tooltip = true
uic_debug_show_hitboxes_menubar = false
uic_debug_show_hitboxes_gameMenu = true
isFirstFrame = true
NewWindowPopup = false

window_Test_progressBar = 0;
window_Test_progressBar2 = 0;

function GlobalWindowAddTest()
    table.insert(ALL_WINDOWS_OPEN ,{
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
local mainMenuContents = {

}   

SetInt("TGUI.tabStyle.tabHeight", 25)
SetInt("TGUI.tabStyle.paddingRight", 20)
SetInt("TGUI.tabStyle.paddingLeft", 0)
SetString("TGUI.textbox.test", "left")
SetString("TGUI.textbox.test2", "center")
SetString("TGUI.textbox.test3", "right")
-- -- --
buttoncolor_r,buttoncolor_r_enabled,buttoncolor_r_dir = 0, true, "up";
buttoncolor_g,buttoncolor_g_enabled,buttoncolor_g_dir = 0, false, "up";
buttoncolor_b,buttoncolor_b_enabled,buttoncolor_b_dir = 0, false, "up";
function draw(dt)
    if HasKey('TGUI.register.mod') then
        local itemNumber = 1
        --
        DebugPrint('[DEBUG]: Regestering')
        local name = GetString('TGUI.register.mod.name')
        --
        DebugPrint('REGISTER: '..name)
        DebugPrint('ADDING TO LIST OF REGISTERED LIST: '..name)
        local RegisteredMods = ListKeys('savegame.mod.registeredmods')
        --
        -- for k, v in ipairs(RegisteredMods) do
        --     itemNumber = itemNumber + 1
        -- end
        --
        t={}
        options_str = GetString('TGUI.register.mod.options')
        options_str:gsub(".",function(c) table.insert(t,c) end)
        SetBool('savegame.mod.registeredmods.'..name..'.disabled',false)
        SetBool('TGUI.register.set.'..name..'.disabled',false)
        ClearKey('TGUI.register.mod')
    end
    if GetBool('TGUI.menu.show') then
        UiPush()
            UiMakeInteractive()
            UiPush()
                UiColor(0,0,0,0.3)
                UiRect(UiWidth(),UiHeight())
            UiPop()
            UiPush()
                UiTranslate(32,UiMiddle());
                uic_CreateGameMenu_Buttons_list(mainMenuContents, 300, {
                    {
                        text = "RESUME GAME",
                        action = function( ... )
                            SetBool('TGUI.menu.show',false);
                        end
                    },
                    {
                        text = "TGUI UI-LIBRARY CUSTOM WINDOW",
                        action = function( ... )
                            SetBool('TGUI.menu.show',false);
                            NewWindowPopup = false
                            table.insert(ALL_WINDOWS_OPEN ,{
                                testFirstFrame = true,
                                -- DATA
                                    tab1 = {tabFirstFrame = true, },
                                    tab2 = {tabFirstFrame = true, },
                                    scrollArea = {scrollfirstFrame = true,},
                                    dropdown_1 = {firstFrame = true, tooltipId = 1, open = false},
                                    dropdown_2 = {firstFrame = true, tooltipId = 2, open = false},
                                    textBox_test = {focused = false},
                                    textBox_test2 = {focused = false},
                                    textBox_test3 = {focused = false},
                                --
                                scrollHeight = 1500,
                                scrollConHeight = 500,
                                firstFrame = true,
                                title = "TGUI UI-LIBRARY CUSTOM WINDOW",
                                padding = 0,
                                pos = {x = 180, y = 200},
                                size = {w = 1026, h = 628},
                                minSize = {w =600, h= 400},
                                startMiddle = true,
                                clip = true,
                                content = function(window)
                                    uic_menubar(UiWidth(),{
                                        {
                                            title = "Settings",
                                            contents = {
                                                {type="text", text = "Something goes here, idk", items = {
                                                }},
                                            }
                                        },
                                    },window, {});
                                    UiTranslate(0, 24);
                                    uic_tab_container(window.tab1, 100, 500, false, true, {
                                        ["open_default"] = 1,
                                        {
                                            title = "All",
                                            ["Content"] = function(MainWindow)

                                            end
                                        }
                                    }, window)
                                end
                            })
                        end
                    },
                    {
                        text = "OPEN OLD MENU",
                        action = function( ... )
                            SetBool('TGUI.menu.show',false);
                            NewWindowPopup = true;
                        end
                    }})
            UiPop()
        UiPop()
    end

    if HasKey('TGUI.regExplorer.openNew') then
        table.insert(ALL_WINDOWS_OPEN, registerRegedit(GetString('TGUI.regExplorer.openNew')))
        ClearKey('TGUI.regExplorer.openNew')
    end

    -- UiPush()
    --     UiTranslate(10,UiMiddle())
    --     UiImageBox('./ui/TGUI_resources/bars/bar_background.png',500,22,5,0)
    --     UiTranslate(4,3)
    --     UiImageBox('./ui/TGUI_resources/bars/health_bar.png',250,13,1,1)
    -- UiPop()

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

    -- End of registry explorer code
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
        --     UiPush()
        --     UiAlign('bottom left')
        --     UiTranslate(0,-10)
        --     UiImage('./ui/TGUI_resources/textures/menuLogo.png',image)
        -- UiPop()
                -- uic_button_func(0,dt,"DEBUG: show TGUI menu", UiWidth(),24, false, false, function()
                --     SetBool('TGUI.menu.show',true)
                -- end, _ )
                -- UiTranslate(0,28);
                if uic_button(0,"Tiny window",UiWidth(),24, false, "tiny window") then
                   NewWindowPopup = false
                   table.insert(ALL_WINDOWS_OPEN ,{
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
                    table.insert(ALL_WINDOWS_OPEN ,{
                        tabFirstFrame = true,
                        firstFrame = true,
                        title = "Debuging Window",
                        padding = 0,
                        pos = {x = 180, y = 200},
                        size = {w = 628, h = 458},
                        allowResize = false,
                        startMiddle = true,
                        clip = false, content = function(window, dt_w)
                            UiTranslate(12,0)
                            uic_tab_container(window, UiWidth()-24,UiHeight()-35,false,true,{
                                ["open_default"] = 1,
                                {
                                    ["title"] = "UI Settings",
                                    ["Content"] = function ()
                                        UiTranslate(10,10)
                                        uic_checkbox("enable compass", "hpTD.compass", 100)
                                        UiTranslate(0, 24)
                                        uic_button_func(window, dt_w, "Show Error", 96, 24, false, "", function() 
                                            error("This is an error", 0)
                                        end)
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
                                    ["title"] = "Tab Style Test",
                                    ["Content"] = function ()
                                        uic_text('Tab style test', 24 , 15)
                                        UiTranslate(0, 24)
                                        -- tabHeight
                                        uic_text('Tab Height', 18 , 15)
                                        UiTranslate(0, 24)
                                        UiPush()
                                        UiTranslate(5, 0)
                                        uic_slider(window,dt,128,"TGUI.tabStyle.tabHeight",{25,90},1)
                                        UiPop()
                                        UiTranslate(0, 24)
                                        uic_text('Padding Right', 18 , 15)
                                        UiTranslate(0, 24)
                                        UiPush()
                                        UiTranslate(5, 0)
                                        uic_slider(window,dt,128,"TGUI.tabStyle.paddingRight",{0,70},1)
                                        UiPop()
                                        UiTranslate(0, 24)
                                        uic_text('Padding left', 18 , 15)
                                        UiTranslate(0, 24)
                                        UiPush()
                                        UiTranslate(5, 0)
                                        uic_slider(window,dt,128,"TGUI.tabStyle.paddingLeft",{0,70},1)
                                        UiPop()
                                    end
                                },
                            }, false, {
                                tabHeight =         GetInt("TGUI.tabStyle.tabHeight"),
                                tabPaddingRight =   GetInt("TGUI.tabStyle.paddingRight"),
                                tabPaddingLeft =    GetInt("TGUI.tabStyle.paddingLeft"),
                            }, dt)
                            UiPush()
                                UiTranslate(UiWidth()-32,3)
                                UiAlign('top right')
                                uic_button_func(_,dt,"Close",128,28, false, "", function()                                     
                                    window.closeWindow = true
                                end)
                            UiPop()
                            UiPush()
                                UiTranslate(4,3)
                                UiAlign('top left')
                                uic_button_func(_,dt,"About TGUI",128,28,false,"",function(ALL_WINDOWS_OPEN)
                                    aboutTGUI(ALL_WINDOWS_OPEN, dt)
                                end , ALL_WINDOWS_OPEN)
                            UiPop()
                        end ,
                    })
                end
                UiTranslate(0,28);
                if uic_button(0,"Double tab container",UiWidth(),24) then
                    NewWindowPopup = false
                    table.insert(ALL_WINDOWS_OPEN ,{
                        testFirstFrame = true,
                        -- DATA
                            tab1 = {tabFirstFrame = true, },
                            tab2 = {tabFirstFrame = true, },
                            scrollArea = {scrollfirstFrame = true,},
                            button_print = {tooltipActive = true},
                            dropdown_1 = {firstFrame = true, tooltipActive = true, open = false},
                            dropdown_2 = {firstFrame = true, tooltipActive = false, open = false},
                            textBox_test = {focused = false},
                            textBox_test2 = {focused = false},
                            textBox_test3 = {focused = false},
                            sliderTest = {},
                            sliderPaddingTest = {},
                            tableContainer = {
                                tableColumnNames = {
                                },
                                table = {
                                },
                            },
                            listbox = {
                                tableScroll = {
                                    firstFrame = true,
                                    scrollfirstFrame = true,
                                },
                            },
                            treeview = {
                                tableScroll = {
                                    firstFrame = true,
                                    scrollfirstFrame = true,
                                },
                                contents = {
                                    "1",
                                    "2",
                                    {
                                        itemText = "Extras",
                                        "3",
                                        "4",
                                        "5",
                                        {
                                            itemText = "Sub Extras",
                                            "a",
                                            "b",
                                            "c"
                                        },
                                    },
                                    {
                                        itemText = "More Extras",
                                        "6",
                                        "7",
                                        "8"
                                    },
                                    {
                                        itemText = "Even More Extras",
                                        "9",
                                        "10",
                                        "11"
                                    },
                                }
                            },
                        --
                        scrollHeight = 1500,
                        scrollConHeight = 500,
                        firstFrame = true,
                        title = "Test Window",
                        padding = 0,
                        pos = {x = 180, y = 200},
                        size = {w = 1026, h = 628},
                        minSize = {w =600, h= 400},
                        startMiddle = true,
                        clip = false,
                        content = function(window, dt_w)
                            uic_menubar(UiWidth(),{
                                {
                                    title = "File",
                                    contents = {
                                        {type="submenu", text = "Settings", items = {
                                            {type="submenu", text = "Quick", items = {
                                                {type="button", text = "Quick 1", action=function ()
                                                end},
                                                {type="button", text = "Quick 2", action=function ()
                                                end}
                                            }}, 
                                            {type = "divider"},
                                            {type="button", text = "Full", action=function ()
                                                
                                            end}    
                                        }},
                                        {type="button", text = "Registry Explorer", action=function ()
                                            table.insert(ALL_WINDOWS_OPEN ,registerRegedit())
                                        end},
                                        {type = "divider"},
                                        {type="button", text = "Exit", action=function ()
                                            window.closeWindow = true
                                        end}
                                    }
                                },
                                {
                                    title = "View",
                                    contents = {
                                        {type="", text = "lol"}
                                    }
                                }
                            },window, {})
                            UiTranslate(12,32)
                            UiPush()
                            uic_tab_container(window.tab1,UiWidth()-32-300, UiHeight()-(12+32), false, true, {
                                ["open_default"] = 1,
                                -- {
                                --     title = "UI component: Container",
                                --     ["Content"] = function()
                                --         UiTranslate(10,10)
                                --         -- UiTranslate(0,24)
                                --     end
                                -- },
                                {
                                    title = "UI component: Table container",
                                    ["Content"] = function(MainWindow)
                                        UiTranslate(10,10)
                                        uic_tableview_container(window.tableContainer, dt_w,UiWidth()-140, UiHeight()-20, false, true, true, window.tableContainer.tableColumnNames,window.tableContainer.table,{
                                            onItemClick = function (itemNumber,item)
                                                DebugPrint("onItemClick")
                                            end,
                                            onItemRightClick = function (itemNumber,item)
                                                DebugPrint("onItemRightClick")
                                            end,
                                            onItemDoubleClick = function (itemNumber,item)
                                                local s, err = pcall(function() 
                                                    DebugPrint("--- Tableview debug ---")
                                                    for k, v in ipairs(item) do
                                                        local text = "Cant display"
                                                        -- DebugPrint("item: "..k.." "..v)
                                                        if type(v) == "string" then
                                                            text = v
                                                        elseif type(v) == "number" then
                                                            text = tostring(v)
                                                        end
                                                        DebugPrint(k.." "..type(v)..": "..text)
                                                    end
                                                end)

                                                if not s then
                                                    DebugPrint("Error has occurred: "..err)
                                                end
                                            end
                                        })
                                        UiTranslate(UiWidth()-120,0)
                                        uic_button_func(_, dt, "Empty Table", 100, 24, false, "", function ()
                                            window.tableContainer.table = {}
                                            window.tableContainer.tableColumnNames = {}
                                            -- for i, v in ipairs(MainWindow.tableContainer) do

                                            -- end
                                        end)
                                        UiTranslate(0,28)
                                        uic_button_func(_, dt, "Small Table", 100, 24, false, "", function ()
                                            window.tableContainer.tableColumnNames = {
                                                {label="1",w=0}, {label="2",w=0},
                                            }
                                            window.tableContainer.table = {
                                                {
                                                    24,
                                                    "test",
                                                    onClick = function() DebugPrint("On Click") end,
                                                    onRightClick = function() DebugPrint("On Right Click") end,
                                                }
                                            }
                                        end)
                                        UiTranslate(0,28)
                                        uic_button_func(_, dt, "Testing Table", 100, 24, false, "", function ()
                                            window.tableContainer.tableColumnNames = {
                                                {label="Test 1",w=0}, {label="column test 2",w=0},
                                                {label="Test 3",w=0}, {label="column test 4",w=0},
                                                {label="Test 5",w=0}, {label="column test 6",w=0},
                                            }
                                            window.tableContainer.table = {
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
                                    title = "Param Testing",
                                    ["Content"] = function() 
                                        UiPush()
                                            UiTranslate(12, 12)
                                            UiPush()
                                                uic_text("Named Parameters", 16,13);
                                                UiTranslate(0, 3)
                                                local s, e = pcall(function()
                                                    -- if window.runtest == nil then
                                                        -- window.runtest = true
                                                    -- end
                                                    -- if window.runtest == true then 
                                                        UiTranslate(0, 16)
                                                        Testuic_listbox_container{
                                                            window = window, w = 200, h = 4, key = "TGUI.test.listbox",
                                                            style = {
                                                                invertborder = true,
                                                            }
                                                        }
                                                    -- end
                                                end)

                                                if not s then
                                                    UiPop()
                                                    UiPop()
                                                    window.runtest = false
                                                    -- DebugPrint(e)
                                                    uic_text(e, 16,13);
                                                end
                                            UiPop()
                                        UiPop()
                                    end
                                },
                                {
                                    title = "All",
                                    ["Content"] = function(MainWindow)
                                        UiPush()
                                            UiTranslate(12,12)
                                            UiPush()
                                                uic_text("Dropdowns", 24)
                                                UiTranslate(0,24)
                                                uic_dropdown(250, "TGUI.dropdown.test", {
                                                    {
                                                        text = "On top Render Test 1",
                                                        keyVal = "renderTopTest1"
                                                    },
                                                    {
                                                        text = "On top Render Test 2",
                                                        keyVal = "renderTopTest2"
                                                    },
                                                }, false)
                                                UiTranslate(0,26)
                                                uic_dropdown(250, "TGUI.dropdown.test", {
                                                    {
                                                        text = "january",
                                                        keyVal = "m1"
                                                    },
                                                    {
                                                        text = "february",
                                                        keyVal = "m2"
                                                    },                                                
                                                    {
                                                        text = "march",
                                                        keyVal = "m3"
                                                    },
                                                    {
                                                        text = "april",
                                                        keyVal = "m4"
                                                    },

                                                }, false)
                                                -- UiTranslate(20,20)
                                                -- UiTranslate(0,32)
                                                -- uic_dropdown(MainWindow.dropdown_1, 100, "TGUI.dropdown.lol", {
                                                --     "1", "2", "3"
                                                -- }, {
                                                --     "tiem_1",
                                                --     "tiem_2",
                                                --     "tiem_3",
                                                -- }, false, "")
                                                -- -- UiTranslate(120,0)
                                                -- UiTranslate(0,-32)
                                                -- uic_dropdown(MainWindow.dropdown_2, 100, "TGUI.dropdown.lol2", {
                                                --     "january", "february", "march", "april", "may", "june", "july", "august", "september", "octeober" , "november", "december"
                                                -- }, {
                                                --     "m1",
                                                --     "m2",
                                                --     "m3",
                                                --     "m4",
                                                --     "m5",
                                                --     "m6",
                                                --     "m7",
                                                --     "m8",
                                                --     "m9",
                                                --     "m10",
                                                --     "m11",
                                                --     "m12",
                                                    
                                                -- }, false, "")
                                            UiPop()
                                            UiTranslate(260,0)
                                            UiPush()
                                                uic_text("Textboxes", 24)
                                                UiTranslate(0,24)                
                                                local textbox_text = uic_textbox("TGUI.textbox.test", dt, 300, window.textBox_test,  "left align", { textColor = {r=255, g=0, b=0}})
                                                UiPush()
                                                    UiTranslate(0,25)
                                                    _ = uic_textbox("TGUI.textbox.test2", dt, 300, window.textBox_test2, "center align" , {textAlgin = "center", textColor = {r=0, g=255, b=0}})
                                                    UiTranslate(0,25)
                                                    _ = uic_textbox("TGUI.textbox.test3", dt, 300, window.textBox_test3, "right align" , {textAlgin = "right", textColor = {r=0, g=0, b=255}})
                                                    -- UiTranslate(0,25)
                                                --     uic_dropdown( 100, "TGUI.dropdown.lol", {
                                                --         {
                                                --             text = "1"
                                                --         }
                                                --     }, false)
                                                UiPop()
                                                UiTranslate(310,0)
                                                uic_button_func(window.button_print, dt, "Print", 100, 24, false, "Print a text to the debug console\nR: "..math.floor(buttoncolor_r).." G: "..math.floor(buttoncolor_g).." B: "..math.floor(buttoncolor_b).."\nR:"..buttoncolor_r_dir.." G:"..buttoncolor_g_dir.." b:"..buttoncolor_b_dir , function()
                                                    DebugPrint(textbox_text)
                                                end, _, {
                                                    textcolornormal = {r=buttoncolor_r,g=buttoncolor_g,b=buttoncolor_b,a=200}
                                                })
                                                UiTranslate(0, 32)
                                                if buttoncolor_r_enabled then
                                                    if buttoncolor_r_dir == "up" then buttoncolor_r = buttoncolor_r + dt/0.005
                                                    elseif buttoncolor_r_dir == "down" then buttoncolor_r = buttoncolor_r - dt/0.005
                                                    end
                                                    if buttoncolor_r >= 50 then buttoncolor_g_enabled = true end
                                                    if buttoncolor_r >= 255 then buttoncolor_r_dir = "down"
                                                    elseif buttoncolor_r <= 0 then buttoncolor_r_dir = "up"
                                                    end
                                                end
                                                if buttoncolor_g_enabled then
                                                    if buttoncolor_g_dir == "up" then buttoncolor_g = buttoncolor_g + dt/0.007
                                                    elseif buttoncolor_g_dir == "down" then buttoncolor_g = buttoncolor_g - dt/0.005
                                                    end
                                                    if buttoncolor_g >= 82 then buttoncolor_b_enabled = true end
                                                    if buttoncolor_g >= 255 then buttoncolor_g_dir = "down"
                                                    elseif buttoncolor_g <= 0 then buttoncolor_g_dir = "up"
                                                    end
                                                end
                                                if buttoncolor_b_enabled then
                                                    if buttoncolor_b_dir == "up" then buttoncolor_b = buttoncolor_b + dt/0.010
                                                    elseif buttoncolor_b_dir == "down" then buttoncolor_b = buttoncolor_b - dt/0.005
                                                    end
                                                    if buttoncolor_b >= 255 then buttoncolor_b_dir = "down"
                                                    elseif buttoncolor_b <= 0 then buttoncolor_b_dir = "up"
                                                    end
                                                end

                                                -- local d, s = UiTextButton("hello", 24, 128)
                                                -- DebugPrint(s)    
                                            UiPop()
                                            UiTranslate(420,0)
                                            UiPush()
                                            -- math.sin(GetTime())*200+300
                                                uic_container(300, 150, true, true, true, function(window) 
                                                    UiPush()
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
                                                        UiPush()
                                                            uic_slider(window.sliderPaddingTest, dt ,128,"TGUI.containerPadding",{0,64},1)
                                                        UiPop()
                                                    UiPop()
                                                    UiPop()
                                        
                                                    -- UiPush()
                                                    --     if UiIsMouseInRect(UiWidth(),UiHeight()-50) and InputPressed('rmb') then
                                                    --         uic_Register_Contextmenu_at_cursor({
                                                    --             {type = "button", text="Button", action=function()
                                                    --             end},
                                                    --             {type = "button", disabled=true, text="Disabled Button", action=function()
                                                    --             end},
                                                    --             {type = "toggle", key = "TGUI.context.toggleTest",text="Toggle", action=function()
                                                    --             end},
                                                    --             {type = "toggle", disabled=true ,key = "TGUI.context.toggleTest",text="Disabled Toggle", action=function()
                                                    --             end},
                                                    --             {type = "submenu", text="Submenu", items={
                                                    --                 {type = "button", text="Submenu Button", action=function()
                                                    --                 end},
                                                    --                 {type = "button", disabled=true, text="Disabled Submenu Button", action=function()
                                                    --                 end},
                                                    --                 {type="divider"},
                                                    --                 {type = "submenu", text="submenu within a submenu", items={
                                                    --                     {type = "button",disabled=true, text="Submenu Button", action=function()
                                                    --                     end},
                                                    --                     {type="divider"},
                                                    --                     {type = "submenu", text="submenu within a submenu", items={
                                                    --                         {type = "button",disabled=true, text="Submenu Button", action=function()
                                                    --                         end},
                                                    --                     }},
                                                    --                     {type = "submenu", text="submenu within a submenu", items={
                                                    --                         {type = "button",disabled=true, text="Submenu Button", action=function()
                                                    --                         end},
                                                    --                     }},
                                                    --                     {type = "submenu", text="submenu within a submenu", items={
                                                    --                         {type = "button",disabled=true, text="Submenu Button", action=function()
                                                    --                         end},
                                                    --                     }},
                                                    --                     {type = "submenu", text="submenu within a submenu", items={
                                                    --                         {type = "button",disabled=true, text="Submenu Button", action=function()
                                                    --                         end},
                                                    --                     }},
                                                    --                     {type = "submenu", text="submenu within a submenu", items={
                                                    --                         {type = "button",disabled=true, text="Submenu Button", action=function()
                                                    --                         end},
                                                    --                     }},
                                                    --                     {type = "submenu", text="submenu within a submenu", items={
                                                    --                         {type = "button",disabled=true, text="Submenu Button", action=function()
                                                    --                         end},
                                                    --                     }},
                                                    --                     {type = "submenu", text="submenu within a submenu", items={
                                                    --                         {type = "button",disabled=true, text="Submenu Button", action=function()
                                                    --                         end},
                                                    --                         {type = "button",disabled=true, text="Submenu Button", action=function()
                                                    --                         end},
                                                    --                     }},
                                    
                                                    --                 }},
                                                    --                 {type = "submenu",disabled=GetBool('TGUI.test.ContextMenu.ItemDisabled'), text="Disabled submenu", items={
                                                    --                     {type = "button", text="Submenu Button", action=function()
                                                    --                     end},
                                                    --                 }},
                                                    --                 {type="divider"},
                                                    --                 {type = "toggle", key = "TGUI.test.ContextMenu.ItemDisabled",text="Disable submenu", action=function()
                                                    --                 end},
                                                    --             }},
                                                    --             {type = "submenu",disabled=true, text="Disabled Submenu", items={}},

                                                    --             {type="divider"},
                                                    --             {type = "button", disabled=true, text="Disabled Button", action=function()end},
                                                    --             {type = "button", disabled=true, text="Disabled Button", action=function()end},
                                                    --             {type="divider"},
                                                    --             {type = "button", disabled=true, text="Disabled Button", action=function()end},
                                                    --             {type = "button", disabled=true, text="Disabled Button", action=function()end},
                                                    --         }, window)
                                                    --     end
                    
                                                    --     UiTranslate(0,UiHeight() - 26)
                                                    --     UiPush()
                                                    --         UiTranslate(24,-24)
                                                    --         uic_checkbox("Exit window? ","iam.key", 100,false)
                                                    --     UiPop()
                                                
                                                    --     uic_divider(UiWidth(),false)
                                                    --     UiTranslate(UiWidth(),6)
                                                    --     UiAlign("right top")
                                                    --     if uic_button(0,"Yes",150,20,not GetBool('iam.key')) then 
                                                    --         window.closeWindow = true
                                                    --     end
                                                    -- UiPop()
                                                end, window, {
                                                    Padding = GetInt("TGUI.containerPadding")
                                                })
                                            UiPop()
                                        UiPop()
                                        UiTranslate(0,92)
                                        UiPush()
                                            UiTranslate(12,0)
                                            uic_text("Menubar styles", 24)
                                        UiPop()
                                        UiTranslate(0,26)
                                        uic_menubar(UiWidth(), {
                                            {
                                                title = "No Borders",
                                                contents = {{type="", text="Hello there"}}
                                            },
                                            {
                                                title = "With Text Padding",
                                                contents = {{type="", text="Hello there"}}
                                            }

                                        }, false, {
                                            showBorder = false,
                                            textPadding = 8
                                        })
                                        UiTranslate(0,26)
                                        UiPush()
                                            uic_menubar(UiWidth()/2, {
                                                {
                                                    title = "Menubar style 1",
                                                    contents = {
                                                        {type="", text="Hello there"}
                                                    }
                                                }
                                            }, false, {borderTop = true, borderBottom = false})
                                            UiTranslate(UiCenter(),0)
                                            uic_menubar(UiWidth()/2, {
                                                {
                                                    title = "Menubar style 1",
                                                    contents = {
                                                        {type="", text="Hello there"}
                                                    }
                                                }
                                            }, false, {borderBottom = true , borderTop = false})
                                        UiPop()
                                        UiTranslate(0,26)
                                        uic_menubar(UiWidth(), {
                                            {
                                                title = "Menubar style 2",
                                                contents = {
                                                    {type="", text="Hello there"}
                                                }
                                            }
                                        }, false, {
                                            AllBorders = true
                                        })
                                        UiTranslate(0,32)
                                            UiPush()
                                                UiPush()
                                                uic_listBox_container(window.listbox, 160, GetInt("TGUI.test.listbox.h"), false, true, true, {
                                                    -- array with theres keys, keyItem and text
                                                    {
                                                        keyItem = "1",
                                                        text = "Hello there"
                                                    },
                                                    {
                                                        keyItem = "2",
                                                        text = "Hello there"
                                                    },
                                                    {
                                                        keyItem = "3",
                                                        text = "Hello there"
                                                    },
                                                    {
                                                        keyItem = "4",
                                                        text = "Hello there"
                                                    },
                                                    {
                                                        keyItem = "5",
                                                        text = "Hello there"
                                                    },
                                                    {
                                                        keyItem = "6",
                                                        text = "Hello there"
                                                    },
                                                    {
                                                        keyItem = "7",
                                                        text = "Hello there"
                                                    },
                                                    {
                                                        keyItem = "8",
                                                        text = "Hello there"
                                                    },
                                                    {
                                                        keyItem = "9",
                                                        text = "Hello there"
                                                    },
                                                    {
                                                        keyItem = "10",
                                                        text = "Hello there"
                                                    },
                                                    {
                                                        keyItem = "11",
                                                        text = "Hello there"
                                                    },
                                                    {
                                                        keyItem = "12",
                                                        text = "Hello there"
                                                    },
                                                    {
                                                        keyItem = "13",
                                                        text = "Hello 13"
                                                    },
                                                    {
                                                        keyItem = "14",
                                                        text = "Hello 14"
                                                    },
                                                    {
                                                        keyItem = "15",
                                                        text = "Hello 15"
                                                    },
                                                    {
                                                        keyItem = "16",
                                                        text = "Hello 16"
                                                    },
                                                    {
                                                        keyItem = "17",
                                                        text = "Hello 17"
                                                    }
                                                }, {
                                                    key = "savegame.mod.multiSelect_test",
                                                    multiSelect = GetBool("TGUI.listbox.enabledMulty"),
                                                });
                                                UiTranslate(16,24)
                                                uic_checkbox("Enable multiSelect", "TGUI.listbox.enabledMulty", 300, false)
                                                UiTranslate(0,16)
                                                UiPush()
                                                    uic_button_func(_, dt, "Add", 100, 24,false, "", function() 
                                                        local i = GetInt("TGUI.test.listbox.h");
                                                        SetInt("TGUI.test.listbox.h", i+1);
                                                    end, _);
                                                    UiTranslate(0,28)
                                                    uic_button_func(_, dt, "Remove", 100, 24,false, "", function() 
                                                        local i = GetInt("TGUI.test.listbox.h");
                                                        SetInt("TGUI.test.listbox.h", i-1);
                                                    end, _);
                                                UiPop()
                                                UiTranslate(0,64)
                                                UiPush()
                                                    uic_text("Radio selection", 24)
                                                    UiTranslate(0,24)
                                                    uic_radio_button("TGUI.test.radio.t1", "easy", "Easy", 130)
                                                    UiTranslate(0,18)
                                                    uic_radio_button("TGUI.test.radio.t1", "medium", "Medium", 130)
                                                    UiTranslate(0,18)
                                                    uic_radio_button("TGUI.test.radio.t1", "hard", "Hard", 130)
                                                    UiTranslate(0,18)
                                                    uic_radio_button("TGUI.test.radio.t1", "WTF", "WTF", 130, true)
                                                    UiPush()
                                                        UiTranslate(160,0)
                                                        uic_checkbox("Disabled Test", "TGUI.disabledTest.checkbox", 10, true)
                                                    UiPop()
                                                UiPop()
                                            UiPop()
                                            UiPush()
                                            UiTranslate(175, 0)
                                            uic_treeView_container(window.treeview,{key="TGUI.treeview_test",multiSelect=GetBool("TGUI.listbox.enabledMulty")}, 160, GetInt("TGUI.test.listbox.h"),function(c)
                                                DebugPrint(c)
                                            end, window.treeview.contents )
                                            UiPop()
                                        UiPop()
                                        UiTranslate(180,0)
                                        UiPush()
                                            UiPush()
                                                UiTranslate(180,0)
                                                uic_progressBar( 4,window_Test_progressBar, 5, {} )
                                                UiTranslate(0,28)
                                                uic_progressBar( 8,window_Test_progressBar, 5, {} )
                                                UiTranslate(0,28)
                                                uic_progressBar( 12,window_Test_progressBar, 5, {} )
                                                UiTranslate(0,28)
                                                uic_progressBar( 32,window_Test_progressBar, 5, {} )
                                                UiTranslate(0,28)
                                                uic_progressBar( 32,window_Test_progressBar2, 10, {} )
                                            UiPop()
                                            UiPush()
                                            UiTranslate(180+180,0)
                                                uic_progressBar( 4,window_Test_progressBar2, 10, {} )
                                                UiTranslate(0,28)
                                                uic_progressBar( 8,window_Test_progressBar2, 10, {} )
                                                UiTranslate(0,28)
                                                uic_progressBar( 12,window_Test_progressBar2,10, {} )
                                            UiPop()
                                            if window_Test_progressBar == 5 then
                                                window_Test_progressBar = 0
                                            end
                                            if window_Test_progressBar == 0 then
                                                SetValue("window_Test_progressBar", 5, "linear", 5)
                                            end
                                            if  window_Test_progressBar2 == 10 then
                                                window_Test_progressBar2 = 0 
                                            end
                                            if window_Test_progressBar2 == 0 then
                                                SetValue("window_Test_progressBar2", 10, "linear", 1)
                                            end
                                            -- 
                                            UiTranslate(180,140)
                                            uic_checkbox("Disavled spin controls", "TGUI.spin.disable", 300, false)
                                            UiTranslate(0,24)
                                            uic_spinbuttons("TGUI.spinbutton", "", GetBool("TGUI.spin.disable"), function() end, {
                                                min = 0,
                                            })
                                            UiPush()
                                                UiTranslate(24,0)
                                                uic_spinbuttons("TGUI.spinbutton", "", GetBool("TGUI.spin.disable"), function() end, {
                                                    min = 0,
                                                    buttonDirection = "X"
                                                })
                                            UiPop()
                                            -- UiPush()
                                            --     UiTranslate(18,0)
                                            --     -- uic_text(GetInt("TGUI.spinbutton"), 32, 18)
                                            -- UiPop()
                                            UiTranslate(64,0)
                                            uic_spincontrol("TGUI.spinbutton", "", 75, GetBool("TGUI.spin.disable"), function() end, {
                                                max = 3,
                                                min = 0
                                            })
                                            UiTranslate(-64,48)
                                            UiPush()
                                                UiPush()
                                                    uic_container(64,32,true, true, false, function( ... )
                                                        UiTranslate(0, 24)
                                                    end, false, {})
                                                UiPop()
                                                UiTranslate(64,0)
                                                UiPush()
                                                    uic_container(128,32,true, true, false, function( ... )
                                                    end, false, {
                                                        LabelText = "123 123 123"
                                                    })
                                                UiPop()
                                            UiPop()
                                            UiPush()
                                                UiTranslate(0,48)
                                                uic_slider( window.sliderTest ,dt, 128,"TGUI.slider",{0,10},1, "lmao")
                                                UiTranslate(0,8)
                                                uic_text(GetInt("TGUI.slider"), 24,20)
                                            UiPop()
                                        UiPop()
                                    end
                                },
                            }, window, {}, dt)
                            UiPop()
                            UiPush()
                            UiTranslate(UiWidth()-310,0)
                            uic_tab_container(window.tab2,280, UiHeight()-(12+32), false, true, {
                                ["open_default"] = 1,
                                {
                                    ["title"] = "Scroll container test",
                                    ["Content"] = function()
                                        UiTranslate(12,12)
                                        uic_scroll_Container(window.scrollArea,UiWidth()-24,window.scrollConHeight, true, window.scrollHeight, 300 ,function(extraContent)
                                            UiPush()
                                                UiTranslate(0, 0)
                                                UiColor(0, 0, 0, 0.2)
                                                UiRect(500, 24)
                                            UiPop()
                                            UiTranslate(12,0)
                                            UiText('i am at the top')
                                            UiPush()
                                                UiTranslate(12,UiHeight()-200)
                                                UiPush()
                                                    UiTranslate(0,25)
                                                    UiText("Sroll height: "..window.scrollHeight)
                                                    UiTranslate(0,32)
                                                    if (uic_button(0,"Add", 75, 24)) then
                                                        window.scrollHeight = window.scrollHeight + 100
                                                    end
                                                    UiTranslate(80,0)
                                                    if (uic_button(0,"Remove", 75, 24)) then
                                                        window.scrollHeight = window.scrollHeight - 100
                                                    end
                                                UiPop()
                                                UiPush()
                                                    UiTranslate(0,100)
                                                    UiText("Window height: "..window.scrollConHeight)
                                                    UiTranslate(0,32)
                                                    if (uic_button(0,"Add", 75, 24)) then
                                                        window.scrollConHeight = window.scrollConHeight + 25
                                                    end
                                                    UiTranslate(80,0)
                                                    if (uic_button(0,"Remove", 75, 24)) then
                                                        window.scrollConHeight = window.scrollConHeight - 25
                                                    end
                                                UiPop()
                                            UiPop()

                                            UiTranslate(0,UiHeight()-24)
                                            UiText('i am at the bottom')
                                            UiTranslate(0,-60)
                                        end, window) 
                                    end
                                },
                                {
                                    ["title"] = "Colors",
                                    ["Content"] = function()
                                        UiTranslate(12, 12)
                                        local bw,br,bg,bb = 19 ,buttoncolor_r, buttoncolor_g, buttoncolor_b
                                        uic_progressBar(bw, buttoncolor_r, 255, {barColor = {r=255,g=0,b=0,a=1}})
                                        UiTranslate(0, 28)
                                        uic_progressBar(bw, buttoncolor_g, 255, {barColor = {r=0,g=255,b=0,a=1}})
                                        UiTranslate(0, 28)
                                        uic_progressBar(bw, buttoncolor_b, 255, {barColor = {r=0,g=0,b=255,a=1}})
                                        UiTranslate(0, 28)
                                        UiPush()
                                            UiColor(c255(br),c255(bg),c255(bb), 1)
                                            UiRect(32, 32)
                                        UiPop()
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
                    table.insert(ALL_WINDOWS_OPEN, registerRegedit(nil, dt))
                end
                UiTranslate(0,28);
                -- uic_button_func(0,"function button",UiWidth(),24, false, "", function(contents)
                --     DebugPrint(contents.win);
                --     DebugPrint(contents.pop);
                -- end, {win = ALL_WINDOWS_OPEN, pop = NewWindowPopup} )
            UiPop()
                return true
        end)
        UiPop()
    end
    if InputPressed('insert') then
        if GetBool('tgui.disableInput') then
            SetBool('tgui.disableInput',false)
        else
            SetBool('TGUI.menu.show',true);
        end
    end
    if (#ALL_WINDOWS_OPEN > 0) then 
        UiPush()  
            UiTranslate(30,100)
            UiCreateWindow(120,100,false,"Window settings",8,function()
                uic_button_func(_, dt, "New Window", UiWidth(), 24, false, "", function()
                    SetBool('TGUI.menu.show',true);
                end)
                UiTranslate(0,28)
                uic_checkbox("disable input", "tgui.disableInput", 100)
            end)
        UiPop()
    end

    initDrawTGUI(ALL_WINDOWS_OPEN, dt)
    uic_drawContextMenu()
end
-- CLEANUP 