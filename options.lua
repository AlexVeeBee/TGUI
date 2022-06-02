#include "./TGUI_ui_library.lua"
#include "./TGUI_manager.lua"
#include "./regeditWindow.lua"

function init( ... )
    activeWindows = {}
    tgui_ui_assets = "MOD/ui/TGUI_resources"
    globalWindowOpacity = 1

    SetString('TGUI.settings.fonts.startpath',"MOD/ui/TGUI_resources/Fonts/")
    SetString('TGUI.settings.fonts.regular', "TAHOMA.TTF")
    SetString('TGUI.settings.fonts.bold', "TAHOMABD.TTF")

end
-- TGUI_debug_show_windowMinsize = true
isFirstFrame = true
fakew = {
    mainContainer = {firstFrame = true,}
}
function regExplorer( prePath )
    if prePath == nil then
        prePath = "game"
    end

    table.insert(activeWindows ,registerRegedit())
end


function draw()
    UiAlign('top left')

    uic_menubar(UiWidth(), {
        {
            title = "File",
            contents = {
                {type="button", text="Reg Explorer", action=function()
                    regExplorer()
                end},
                {type="button", text="Exit", action=function()
                    Menu()
                end}
            }
        }
    }, false, {
        showBorder = false,
    })
    UiPush()
        UiTranslate(0,24)
        uic_container(UiWidth(), UiHeight()-24, false, false, false, function()
            UiAlign("top left")
            UiImageBox('./ui/TGUI_resources/textures/background_noshadow.png',UiWidth(), UiHeight(),4,4)
            UiTranslate(4,4)
            uic_tab_container(fakew.mainContainer, UiWidth()-8, UiHeight()-8, false, true, {
                ["open_default"] = 1,
                {
                    title = "Main",
                    ["Content"]  = function()
                        uic_text("TGUI Settings", 32, 18)
                        UiTranslate(0,32)
                        uic_text("Colors", 24, 15)
                        UiTranslate(0,24)
                        uic_container(UiWidth(), 300, false, true, true, function()

                        end, false)
                    end
                },
                {
                    title = "Registry Explorer",
                    ["Content"]  = function()
                        -- uic_text("TGUI Settings", 32, 18)
                        -- UiTranslate(0,32)
                        -- uic_text("Colors", 24, 15)
                        -- UiTranslate(0,24)
                        -- uic_container(UiWidth(), 300, false, true, true, function()

                        -- end, false)
                    end
                },
                {
                    title = "Mods",
                    ["Content"]  = function()
                        -- uic_text("TGUI Settings", 32, 18)
                        -- UiTranslate(0,32)
                        -- uic_text("Colors", 24, 15)
                        -- UiTranslate(0,24)
                        -- uic_container(UiWidth(), 300, false, true, true, function()

                        -- end, false)
                    end
                }
            })
        end, false)
    UiPop()

    initDrawTGUI(activeWindows)
    uic_drawContextMenu()
end