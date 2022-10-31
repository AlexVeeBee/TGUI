#include "./TGUI_ui_library.lua"
#include "./TGUI_manager.lua"
#include "./regeditWindow.lua"

function init( ... )
    ALL_WINDOWS_OPEN = {}
    tgui_ui_assets = "MOD/ui/TGUI_resources"
    globalWindowOpacity = 1

    SetString('TGUI.settings.fonts.startpath',"MOD/ui/TGUI_resources/Fonts/")
    SetString('TGUI.settings.fonts.regular', "TAHOMA.TTF")
    SetString('TGUI.settings.fonts.bold', "TAHOMABD.TTF")

end
-- TGUI_debug_show_windowMinsize = true
local windowPopupFirstFrame = false;
isFirstFrame = true
fakew = {
    mainContainer = {firstFrame = true,}
}
function regExplorer( prePath, dt )
    if prePath == nil then
        prePath = "game"
    end

end

function hex2rgb(hex)
    local hex = hex:gsub("#","")
    if hex:len() == 3 then
      return (tonumber("0x"..hex:sub(1,1))*17)/255, (tonumber("0x"..hex:sub(2,2))*17)/255, (tonumber("0x"..hex:sub(3,3))*17)/255
    else
      return tonumber("0x"..hex:sub(1,2))/255, tonumber("0x"..hex:sub(3,4))/255, tonumber("0x"..hex:sub(5,6))/255
    end
end
function draw(dt)

    if HasKey('TGUI.regExplorer.openNew') then
        table.insert(ALL_WINDOWS_OPEN, registerRegedit(GetString('TGUI.regExplorer.openNew')))
        ClearKey('TGUI.regExplorer.openNew')
    end
    if not windowPopupFirstFrame then
        table.insert(ALL_WINDOWS_OPEN, {
            textBox_test = {},
            tabFirstFrame = true,
            firstFrame = true,
            title = "TGUI OPTIONS",
            padding = 0,
            pos = {x = 180, y = 200},
            size = {w = 628, h = 540},
            allowResize = false,
            startMiddle = true,
            disableCloseButton = true,
            
            clip = false, content = function(window, dt_w)
                uic_menubar(UiWidth(), {
                    {
                        label = "File",
                        contents = {
                            {type="button", text="Reg Explorer", action=function()
                                table.insert(ALL_WINDOWS_OPEN ,registerRegedit(prePath, dt))
                            end},
                            {type="button", text="Exit", action=function()
                                Menu()
                            end}
                        }
                    }, {
                        label="Options", contents = {
                            {type="submenu", text="Load Presets", items = {
                                {type="", text="Empty..."}
                            }},
                            {type="button", text="Create New Preset", action=function() end},
                            {type="divider"},
                            {type="button", text="Restore Settings to Default", action=function() end},
                        }
                    }, {
                        label="Help", contents = {
                            {type="button", text="View Help", action=function() end},
                            {type="button", text="Send Feedback", action=function() end},
                            {type="divider"},
                            {type="button", text="About TGUI Options", action=function() end},
                        }
                    }
                }, false, {
                    showBorder = true,
                    borderTop = true,
                })
        
                UiTranslate(12,32)
                uic_tab_container(window, UiWidth()-24,UiHeight()-64,false,true,{
                    ["open_default"] = 1,
                    {
                        title = "Personalization",
                        Content = function ()
                            UiTranslate(24, 24)
                            local textbox_text = uic_textbox("TGUI.textbox.test", dt_w, UiWidth()-48, window.textBox_test, "This textbox does not do anything" )
                            -- UiTranslate(10,10)
                            -- uic_text("HELLO", 24,18);
                            -- uic_checkbox("enable compass", "hpTD.compass", 100)
                            -- UiText('I am tab 2, THIS WORKS, YAY')
                            -- fds.lol()
                        end
                    },
                }, false, {
                }, dt_w)
                UiPush()
                    UiTranslate(UiWidth()-32,3)
                    UiAlign('top right')
                    uic_button_func(_,dt_w,"Close",64,24,false,"",function()
                        window.closeWindow = true;Menu()
                    end)
                UiPop()
                UiPush()
                    UiTranslate(4,3)
                    UiAlign('top left')
                    uic_button_func(_,dt_w,"About TGUI",128,24,false,"",function()
                        aboutTGUI(ALL_WINDOWS_OPEN,dt)
                    end)
                UiPop()
            end ,
        })

        windowPopupFirstFrame = true
    end
    local hexRgb1, hexRgb2, hexRgb3 = hex2rgb('#212121')
    UiAlign('top left')
    -- UiImageBox('./ui/TGUI_resources/textures/background_noshadow.png',UiWidth(), 24,4,4)
    if HasKey('TGUI.regExplorer.openNew') then
        regExplorer(GetString('TGUI.regExplorer.openNew'))
        ClearKey('TGUI.regExplorer.openNew')
    end
    UiPush()
        UiColor(hexRgb1 , hexRgb2 , hexRgb3, 1)

        UiRect(UiWidth(),UiHeight())
    UiPop()

    UiPush()
        UiTranslate(UiWidth(),0)
        UiAlign('right top')
        local t = uic_text(GetString("TGUI.Version"),24)
        UiTranslate(-t.width+-24,0)
        local t = uic_text("Available themes: FIXED THEME",24)
        UiTranslate(-t.width+-24,0)
        uic_text("TGUI Settings",24)
    UiPop()
    UiPush()
    -- DebugPrint(hexRgb1 .." ".. hexRgb2 .." ".. hexRgb3)
        UiPush()
            UiTranslate(UiCenter(),24)
            UiAlign('center top')
            local logo = "MOD/ui/TGUI_resources/textures/TGUI_OPTIONS.png"
            local im_w, im_h = UiGetImageSize(logo)
            UiImageBox(logo, im_w/3, im_h/3, 0,0)
        UiPop()
        UiPush()
            UiTranslate(0,150)
            local colorDividerR, colorDividerG, colorDividerB= hex2rgb('#4D4D4D')
            UiColor(colorDividerR, colorDividerG, colorDividerB,1)
            -- UiRect(UiWidth(),1)
            -- UiColor(1,1,1,1)
            -- UiTranslate(0,1)
            -- UiRect(UiWidth(),1)
        UiPop()
        UiTranslate(0,152)
        -- uic_container(UiWidth(), UiHeight()-152, false, false, false, function()
            -- UiAlign("top left")
            

            -- UiPush()
            --     UiTranslate(12,0)
            --     UiColor(1,1,1,1)
            --     uic_text("TGUI OPTIONS", 32, 12, {
            --         font = tgui_ui_assets.."/Fonts/TAHOMABD.TTF"
            --     })
            -- UiPop()
            
        --     UiTranslate(0,32)
        --     UiTranslate(32,0)
        --     uic_container(UiWidth()-64, UiHeight()-(8+32), false, true, false, function()
        --         uic_menubar(UiWidth(), {
        --             {
        --                 label = "File",
        --                 contents = {
        --                     {type="button", text="Reg Explorer", action=function()
        --                         regExplorer()
        --                     end},
        --                     {type="button", text="Exit", action=function()
        --                         Menu()
        --                     end}
        --                 }
        --             }, {
        --                 label="Options", contents = {
        --                     {type="submenu", text="Load Presets", items = {
        --                         {type="", text="Empty..."}
        --                     }},
        --                     {type="button", text="Create New Preset", action=function() end},
        --                     {type="divider"},
        --                     {type="button", text="Restore Settings to Default", action=function() end},
        --                 }
        --             }, {
        --                 label="Help", contents = {
        --                     {type="button", text="View Help", action=function() end},
        --                     {type="button", text="Send Feedback", action=function() end},
        --                     {type="divider"},
        --                     {type="button", text="About TGUI Options", action=function() end},
        --                 }
        --             }
        --         }, false, {
        --             showBorder = true,
        --             borderTop = false,
        --         })
            
        --     end)
        --     -- uic_tab_container(fakew.mainContainer, UiWidth()-64, UiHeight()-(8+32), false, true, {
        --     --     ["open_default"] = 1,
        --     --     {
        --     --         title = "Main",
        --     --         ["Content"]  = function()
        --     --             uic_text("TGUI Settings", 32, 18)
        --     --             UiTranslate(0,32)
        --     --             uic_text("Colors", 24, 15)
        --     --             UiTranslate(0,24)
        --     --             UiTranslate(32,0)
        --     --             uic_container(UiWidth()-64, 300, false, true, true, function()

        --     --             end, false)
        --     --         end
        --     --     },
        --     --     {
        --     --         title = "Add-ons Privacy",
        --     --         ["Content"]  = function()
        --     --             -- uic_text("TGUI Settings", 32, 18)
        --     --             -- UiTranslate(0,32)
        --     --             -- uic_text("Colors", 24, 15)
        --     --             -- UiTranslate(0,24)
        --     --             -- uic_container(UiWidth(), 300, false, true, true, function()

        --     --             -- end, false)
        --     --         end
        --     --     }
        --     -- })
        -- end, false)
    UiPop()

    initDrawTGUI(ALL_WINDOWS_OPEN, dt)
    uic_drawContextMenu()
end