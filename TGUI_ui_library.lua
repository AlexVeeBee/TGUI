--[[

████████╗░██████╗░██╗░░░██╗██╗  ██╗░░░██╗██╗  ██╗░░░░░██╗██████╗░██████╗░░█████╗░██████╗░██╗░░░██╗
╚══██╔══╝██╔════╝░██║░░░██║██║  ██║░░░██║██║  ██║░░░░░██║██╔══██╗██╔══██╗██╔══██╗██╔══██╗╚██╗░██╔╝
░░░██║░░░██║░░██╗░██║░░░██║██║  ██║░░░██║██║  ██║░░░░░██║██████╦╝██████╔╝███████║██████╔╝░╚████╔╝░
░░░██║░░░██║░░╚██╗██║░░░██║██║  ██║░░░██║██║  ██║░░░░░██║██╔══██╗██╔══██╗██╔══██║██╔══██╗░░╚██╔╝░░
░░░██║░░░╚██████╔╝╚██████╔╝██║  ╚██████╔╝██║  ███████╗██║██████╦╝██║░░██║██║░░██║██║░░██║░░░██║░░░
░░░╚═╝░░░░╚═════╝░░╚═════╝░╚═╝  ░╚═════╝░╚═╝  ╚══════╝╚═╝╚═════╝░╚═╝░░╚═╝╚═╝░░╚═╝╚═╝░░╚═╝░░░╚═╝░░░

Name: TGUI UI Library
Version: 0.4
Author: AlexVeeBee
Credit: iaobardar (Help with the dropdown menu being on top)
How it works:
Requirements:
How to import:
]]
function init()
    nextid = 1
    currentid = 0
    CreatedWindows = {
    }
end

function tick( ... )
    -- DebugWatch('nextid',nextid)
    -- DebugWatch('currentid',currentid)
end

local showDropDown,id_open = false, 0

---DEBUG: enable checkbox hitbox
uic_debug_checkHit = false

---Tooltip
uic_tooltip_text,uic_tooltip_enabled = "-",false
---Tooltip hover
uic_tooltip_hover_timer,uic_tooltip_hover_id = 1,0
---context menu
uic_draw_contextmenu,uic_contextMenu_getCursor,uic_isCursorInside = false, false, false
        --  {
        --      w=0,h=0,x=0,y=0,
        --      c = {

        --      }
        --      d = {

        --      }
        --  }
        

uic_contextMenu_contents = {
    submenuItems = {
    },
    items = {
    }
}

local function luic_createSubMenu( x, y, contents )
    local cm = table.insert(uic_contextMenu_contents.items, {
        w=200, h=0, x=x, y=y ,checkIfCutting = true, useSubemenu = true, getCursor = false,
        c = contents
    })

    DebugPrint("create new submenu")
end

-- function DrawAllWindows()
--     for i=1, #CreatedWindows do
--         UiPush()
--             UiEnableInput()
--             UiWindow(CreatedWindows[i]["size"].w ,CreatedWindows[i]["size"].h ,CreatedWindows[i]["clip"])
--             UiPush()
--                 UiAlign("top left")
--                 UiColor(c255(160), c255(160), c255(160),c200(128))
--                 UiRect(CreatedWindows[i]["size"].w ,CreatedWindows[i]["size"].h)
--                 UiFont("MOD/ui/Fonts/arialnovabd.ttf", 12)
--                 UiTranslate(16,8)
--                 UiColor(1,1,1,1)
--                 UiText(CreatedWindows[i]["title"])
--             UiPop()
--             -- UiTranslate(0,32)
--             -- UiWindow(width,height-32,clip)
--             -- -- UiRect(UiWidth(),padding)
--             -- -- UiRect(padding,UiHeight())
--             -- UiFont("MOD/ui/Fonts/arialnova.ttf", 15)
--             -- UiTranslate(padding,padding)
--             -- UiWindow(width-padding/2*4,height-32+padding/2*-4,clip)
--             -- -- UiColor(1,0,0,1)
--             -- -- UiRect(UiWidth(),UiHeight())
--             -- UiColor(1,1,1,1)
--             -- UiPush()
--             --     UiAlign("top left")
--             --     content()
--             -- UiPop()
--         UiPop()
--     end
-- end

-- 

function tick( ... )
    -- DebugWatch('showDropDown',showDropDown)
    -- DebugWatch('id_open',id_open)
end

---Convert to float 0 to 1 from 255 range
---@param c integer range of 0 to 255
---@return float c Range of 0 to 1 float
function c255(c)
    return c/255
end
---Convert to float 0 to 1 from 200 range
---@param c integer range of 0 to 200
---@return float c Range of 0 to 1 float
function c200(c)
    return c/200
end

---Convert to float 0 to 1 from 100 range
---@param c integer range of 0 to 100
---@return float c Range of 0 to 1 float
function c100(c)
    return c/100
end
winfake = {
    tableColumnNames = {
        {label="1",w=0}, {label="2",w=0},
        {label="3",w=0}, {label="4",w=0},
        {label="5",w=0}, {label="6",w=0},
        {label="7",w=0}, {label="8",w=0},
    }
}

---This function must be called after all of the ui
function uic_tooltip()
    UiPush()
        if not uic_tooltip_enabled then
            mouse_x,mouse_y = UiGetMousePos()
        end
        if uic_tooltip_enabled then
            UiFont("MOD/ui/TGUI_resources/Fonts/TAHOMABD.TTF", 12)
            local t_text_w,t_text_h = UiGetTextSize(uic_tooltip_text)
            UiAlign('top left')
            UiTranslate(mouse_x,mouse_y +20)
            UiImageBox('MOD/ui/TGUI_resources/textures/hint.png',t_text_w,t_text_h,1,1)
            UiColor(c255(136),c255(84),c255(30),1)
            UiText(uic_tooltip_text)
        end
    UiPop()
end
function uic_tooltip_hover(id, open)
    if open then
        if uic_tooltip_hover_id == id then
            if uic_tooltip_hover_timer == 1 then
                SetValue('uic_tooltip_hover_timer',0,"linear",1)
            end
            if uic_tooltip_hover_timer == 0 then
                uic_tooltip_enabled = true
            end
        else
            uic_tooltip_enabled = false
            uic_tooltip_hover_timer = 1
            uic_tooltip_hover_id = id
        end
    else 
        uic_tooltip_enabled = false
        uic_tooltip_hover_timer = 1
    end
end

-- local function luic_drawContextMenu_contents( itemsTable, extraContent )
--     local c = extraContent
--     -- UiPush() -- HEIGHT DEBUGBING
--     --     UiTranslate(-30,0)
--     --     uic_text(c.h)
--     -- UiPop()
--     -- UiPush() -- ITEM HOVER DEBUGBING
--     --     UiTranslate(-30,0)
--     --     uic_text(c.itemHover)
--     -- UiPop()
--     for i, v in pairs(itemsTable) do
--         UiMakeInteractive()
--         UiEnableInput()
--         local txt_w, _ = UiGetTextSize(v.text)
--         if c.itemHover == nil then
--             c.itemHover = 0
--         end
--         if not c.hoverOnce and not c.keepSubmenuOpen then 
--             c.hoverOnce = false
--             c.keepSubmenuOpen = false
--         end
--         if not v.widthChecked then
--             if uic_draw_contextmenu_row then
--                 c.w = c.w + txt_w
--             else
--                 if c.w < txt_w then c.w = txt_w 
--                     v.widthChecked = true
--                 else v.widthChecked = false
--                 end
--             end
--         end
--         if v.height == nil then
--             v.height = 0
--         end
--         UiPush()
--             if(v.disabled and v.type == 'button') then UiDisableInput() end
--             UiTranslate(-24,0)
--             if UiBlankButton(c.w+24,24) then
--                 if v.type == 'button' then
--                    v.action()
--                    uic_contextMenu_contents.items={}
--                    uic_draw_contextmenu = false
--                end
--                if v.type == "toggle" then
--                    v.action()
--                    if type(v.key) == "string" then
--                        if GetBool(v.key) then
--                            SetBool(v.key,false)
--                        else
--                            SetBool(v.key,true)
--                        end
--                    end
--                    uic_contextMenu_contents.items={}
--                    uic_draw_contextmenu = false
--                end
--             end
--         UiPop()
--         if c.h >= 4 then
--         -- 
--         if c.drawRow then
--             if UiIsMouseInRect(txt_w,24) then
--                 if v.type == 'button' then
--                     UiPush()
--                         UiTranslate(-24,0)
--                         UiColor(c255(255),c255(156),c255(0),1)
--                         UiTranslate(1,0)
--                         UiRect(txt_w,24)
--                     UiPop()
--                 end
--             end
--         else
--             UiPush()
--                 UiTranslate(-24,0)
--                 if UiIsMouseInRect(c.w+24,24) then
--                     if v.type == 'button' or v.type == "toggle" or v.type == "submenu" then
--                         c.itemsHovering = c.itemsHovering + 1
--                         if not c.keepSubmenuOpen then
--                         c.itemHover = i
--                         end
--                         if(not v.disabled) then
--                             UiColor(c255(255),c255(156),c255(0),1)
--                         else
--                             UiColor(c255(55),c255(55),c255(55),0.21)
--                         end
--                         UiTranslate(1,0)
--                         UiRect(c.w-2+24,24)
--                     end
--                     if v.type == "button" or v.type == "toggle" then
--                         c.hoverOnce = false
--                         c.keepSubmenuOpen = false
--                     end
--                     if(v.disabled) then
--                         if v.type == "submenu" then
--                             c.hoverOnce = false
--                             c.keepSubmenuOpen = false
--                         end
--                     end
--                 end
--             UiPop()
--             if v.type == 'divider' then
--                 UiPush()
--                     if uic_debug_contextMenu then
--                     UiPush()
--                         UiColor(1,0,0,1)
--                         UiRect(c.w-2,8)
--                     UiPop()
--                     end
--                     UiTranslate(1,3)
--                     uic_divider(c.w-2,false)
--                 UiPop()
--             end
--             if v.type == "toggle" then
--                 if type(v.key) == "string" then if GetBool(v.key) then
--                     UiPush()
--                         UiAlign('center middle')
--                         UiTranslate(-12,12)
--                         UiImage('MOD/ui/TGUI_resources/textures/checkmark.png')
--                     UiPop()
--                 end end
--             end
--             if v.type == "submenu" then
--                 UiPush()
--                     UiPush()
--                         UiAlign('center middle')
--                         UiTranslate(c.w-12,12)
--                         UiImage('MOD/ui/TGUI_resources/textures/arrow_right.png')
--                     UiPop()

--                     UiTranslate(-24,0)
--                     -- UiRect(c.w+24,24)
--                     if c.keepSubmenuOpen == nil then
--                         c.keepSubmenuOpen = false
--                     end
--                     -- local ItemHoverCount 
--                     -- for it, c in pairs(uic_contextMenu_contents.items) do
--                     --     pcall(function ()
--                     --         ItemHoverCount = uic_contextMenu_contents.items[it-1].itemsHovering
--                     --         DebugPrint(it.." | "..ItemHoverCount)
--                     --     end)
        
--                     -- end

--                     if v.hoverOnce == nil then v.subButtonId = i ; v.hoverOnce = false end
--                     if v.submenuH == nil then  v.submenuH = c.h end
--                     if not v.disabled then
--                         if UiIsMouseInRect(c.w+24,24) and c.hoverOnce == false then
--                             if c.itemHover == v.subButtonId  then
--                                 DebugPrint('DONT RENDER IN CONTEXT NEMNU: '..BoolToString(c.dontRender))
--                                 if c.itemsHovering == 1 and c.dontRender ==false or c.dontRender==nil then
--                                     table.insert(uic_contextMenu_contents.items, {
--                                         w=200, h=0, x=c.w+24, y=v.submenuH , useSubemenu = true, getCursor = false,
--                                         c = v.items
--                                     })
--                                     -- DebugPrint(c.w)
--                                     c.hoverOnce = true
--                                     c.keepSubmenuOpen = true
--                                 end
--                             end
--                         end
--                         if UiIsMouseInRect(c.w+24,24) and c.hoverOnce == true then
--                             if c.itemHover == v.subButtonId  then
--                             else
--                                 c.hoverOnce = false
--                                 c.keepSubmenuOpen = false
--                             end
--                         end
--                     end
--                 UiPop()
--             end
--         UiPush()
--             if(v.disabled ) then UiColor(c255(24),c255(24),c255(24),1) end
--             uic_text(v.text, 24)
--         UiPop()
--         -- 
--         end
--         if(v.disabled ) then
--             UiPush()
--                 UiColor(0.1,0.1,0.1,0.4)
--                 UiTranslate(1,1)
--                 uic_text(v.text, 24)
--             UiPop()
--         end

--         end
--         -- UiPush()
--         --     UiColor(1,1,1,0.3)
--         --     UiRect(c.w,v.height)
--         -- UiPop()

--         if v.heightCheck == nil then
--             -- if v.type == "button" or v.type == "toggle" or v.type == "submenu"then
--             --     c.h = c.h + 24
--             --     v.height = 24
--             -- elseif v.type == "divider" then
--             --     c.h = c.h + 8
--             --     v.height = 8
--             -- else
--             --     c.h = c.h + 24
--             --     v.height = 24
--             -- end
--             -- v.heightCheck = true

--         else
--             if c.h == 0 then
--                 for i, v in ipairs(c.c) do
--                     v.heightCheck = nil
--                     -- DebugPrint("Item "..i.." heightCheck was set to false")
--                 end
--             end
--         end
--         -- DebugPrint("height check: " .. v.height)
--         -- DebugPrint("item: " .. i .. " c: " .. c .. " height check: " .. v.height)
--         if c.drawRow then
--             UiTranslate(txt_w,0)
--         else
--             UiTranslate(0,v.height)
--         end
--     end
-- end
_globalContextMenu_isCursorInside = false;
-- ---Draw a context when value to draw the context menu is true. Keep this outside all the ui code but inside the draw function
-- function uic_drawContextMenu()
--     UiPush()
--     _globalContextMenu_isCursorInside = false
--     SetBool('TGUI.contextMenu.isCursorInside', false)
--     if uic_draw_contextmenu then
--         UiEnableInput()
--         UiFont("MOD/ui/TGUI_resources/Fonts/TAHOMA.TTF", 15)
--         UiAlign('top left')
--         UiPush()
--         for it, c in pairs(uic_contextMenu_contents.items) do
--             -- if c.dontRender == false or c.dontRender == nil then
--             c.itemsHovering = 0
--             if c.getCursor == nil then
--                     local cursor_x, cursor_y = UiGetMousePos()
--                     c.x = math.floor(cursor_x)
--                     c.y = math.floor(cursor_y)
--                     c.getCursor = false
--             end
--             UiTranslate(c.x,c.y)
--             -- if c.keepSubmenuOpen then
--             -- end
            
--             if c.h >= 4 then
--                 UiPush()
--                     UiColor(c255(162),c255(162),c255(162),1)
--                     if c.drawRow then
--                             UiRect(c.w+2,26)    
--                     else
--                             UiRect(c.w+24,c.h+2)    
--                     end
--                 UiPop()
--                 UiPush()
--                     UiColor(1,1,1,1)
--                     if c.drawRow then
--                             UiImageBox('MOD/ui/TGUI_resources/textures/outline_outer_normal.png',c.w+2,26,1,1)
--                     else
--                             UiImageBox('MOD/ui/TGUI_resources/textures/outline_outer_normal.png',c.w+24,c.h+2,1,1)
--                     end
--                 UiPop()
--             end
--             UiPush()
--                 UiTranslate(24,1)
--                     if c.h >= 4 then
--                         luic_drawContextMenu_contents(c.c,c)
--                     end
--                     for i, v in pairs(c.c) do
--                         if v.heightCheck == nil then
--                             if v.type == "button" or v.type == "toggle" or v.type == "submenu"then
--                                 c.h = c.h + 24
--                                 v.height = 24
--                             elseif v.type == "divider" then
--                                 c.h = c.h + 8
--                                 v.height = 8
--                             else
--                                 c.h = c.h + 24
--                                 v.height = 24
--                             end
--                             v.heightCheck = true
--                         else
--                             if c.h == 0 then for i, v in ipairs(c.c) do
--                                 v.heightCheck = nil
--                             end end
--                         end
--                     end
--                 DebugPrint(c.itemsHovering)
--             UiPop()
--             UiPush()
--                 UiColor(1,1,1,0.3)
--                 -- UiRect(c.w+24,c.h)
--                 if UiIsMouseInRect(c.w+24,c.h+2) then
--                     _globalContextMenu_isCursorInside = true
--                     c.isCursorInside = true
--                     SetBool('TGUI.contextMenu.isCursorInside', true)
--                 end
--                 if not UiIsMouseInRect(c.w+24,c.h+2) then
--                     c.isCursorInside = false
--                 end
--             UiPop()
--             UiPush()
--                 UiTranslate(-2,-2)
--                 UiAlign('top left')
--                 UiColor(1,1,1,0.3)
--                 local isCursorInside;
--                 pcall(function ()
--                     isCursorInside = uic_contextMenu_contents.items[it].isCursorInside
--                     if isCursorInside then
--                         _globalContextMenu_isCursorInside = true
--                     end
--                 end)
--                 -- UiRect(c.w+26,c.h+4)
--                 -- DebugPrint(BoolToString(v.isCursorInside))
--                     -- if not globalContextMenu_isCursorInside then
--                 -- DebugPrint("BEFORE CHECK IF CURSOR IS IN: "..BoolToString(_globalContextMenu_isCursorInside))
--                 if c.useSubemenu == nil then
--                     -- if not UiIsMouseInRect(c.w+26,c.h+4) then
--                     --     DebugPrint("NOT IN RECT: "..BoolToString(_globalContextMenu_isCursorInside))
--                     --     if _globalContextMenu_isCursorInside == false then
--                     --         DebugPrint('CURSOR NOT IN RECT: '..BoolToString(_globalContextMenu_isCursorInside))
--                     --         if InputPressed('lmb') then uic_draw_contextmenu = false end
--                     --         if InputPressed('rmb') then uic_draw_contextmenu = false end
--                     --     end
--                     -- end
--                     -- -- end
--                 else 
--                     -- if uic_contextMenu_contents.items ==not nil then
--                     -- for i, v in uic_contextMenu_contents.items do

--                     -- end
--                     -- local SubMenuId = uic_contextMenu_contents.items[it-1].keepSubmenuOpen
--                     -- uic_contextMenu_contents.items[it-1].keepSubmenuOpen == false
--                     pcall(function ()
--                         local keepSubmenuOpen = uic_contextMenu_contents.items[it-1].keepSubmenuOpen
--                         if keepSubmenuOpen == false or keepSubmenuOpen == nil then
--                             table.remove(uic_contextMenu_contents.items, it)
--                         end
--                         -- local ItemHoverCount = uic_contextMenu_contents.items[it-1].itemsHovering
--                         -- if ItemHoverCount == 2 then
--                         --     uic_contextMenu_contents.items[it].dontRender = true
--                         -- else
--                         --     uic_contextMenu_contents.items[it].dontRender = false
--                         -- end
--                     end)
--                 --     if keepSubmenuOpen == true and SubMenuId == it then
--                     --         UiRect(c.w+26,c.h+4)
--                     --         if not UiIsMouseInRect(c.w+26,c.h+4) then
--                     --             if InputPressed('lmb') then uic_draw_contextmenu = false end
--                     --             if InputPressed('rmb') then uic_draw_contextmenu = false end
--                     --         end
--                     --     end
--                     -- end
--                 end
--             UiPop()
--             local PosX, PosY = c.x,c.y
--             if c.checkIfCutting == nil then
--                 if UiWidth()-c.w-60 < PosX then
--                     c.x = c.x - c.w
--                 end
--                 if UiHeight()-c.h-60 < PosY then
--                     c.y = c.y - c.h
--                     if c.y < 0 then
--                         c.y = 0
--                     end
--                 end
--                 c.checkIfCutting = false
--             end
--             -- else
--             --     DebugPrint('DONT RENDER')
--             -- end
--         end
--         for it, c in pairs(uic_contextMenu_contents.items) do
--             UiTranslate(-2,-2)
--             if c.useSubemenu == nil then
--                 if not UiIsMouseInRect(c.w+26,c.h+4) then
--                     if _globalContextMenu_isCursorInside == false then
--                         if InputPressed('lmb') then uic_draw_contextmenu = false end
--                         if InputPressed('rmb') then uic_draw_contextmenu = false end
--                     end
--                 end
--             end
--         end
--         UiPop()
--             -- UiPush()
--         --     UiAlign('top right')
--         --     -- UiTranslate(100,64)
--         --     UiTranslate(-30,0)
--         --     for it, c in pairs(uic_contextMenu_contents.items) do
--         --         uic_text(c.itemHover,24)
--         --     end
--         -- UiPop()
--     else
--         uic_contextMenu_contents.items = {}
--     end
--     -- DebugWatch('ContextMenu open',_globalContextMenu_isCursorInside)
--     -- DebugPrint(uic_contextMenu_itemsHovered)
--     UiPop()
-- end
local _itemsHovering = 0
function uic_drawContextMenu()
    if uic_draw_contextmenu then
        UiEnableInput()
        UiFont("MOD/ui/TGUI_resources/Fonts/TAHOMA.TTF", 15)
        UiAlign('top left')
        UiPush()
        for it, c in pairs(uic_contextMenu_contents.items) do
            if c.getCursor == nil then
                local cursor_x, cursor_y = UiGetMousePos()
                c.x = math.floor(cursor_x)
                c.y = math.floor(cursor_y)
                c.getCursor = false
            end
            local aling_y, align_x = "top", "left"
            if c.Cuttin_alignRight then
                align_x = "right"
            end
            if c.Cuttin_alignBottom then
                aling_y = "bottom"
            end
            UiTranslate(c.x,c.y)
            UiAlign(aling_y .. " " .. align_x) 
            UiPush()
                if c.h >= UiHeight() then
                    UiWindow(c.w,UiHeight()-2,false)
                else
                    UiWindow(c.w,c.h,false)
                end
                UiAlign("top left")
                if UiBlankButton(c.w,c.h) then end
                if c.h >= 4 then
                    if c.itemsHovering == nil then
                        c.itemsHovering=0
                    end
                    UiPush()
                        UiColor(c255(162),c255(162),c255(162),1)
                        UiRect(c.w+24,c.h+2)    
                    UiPop()
                    UiPush()
                        UiColor(1,1,1,1)
                        UiImageBox('MOD/ui/TGUI_resources/textures/outline_outer_normal.png',c.w+24,UiHeight()+2,1,1)
                    UiPop()
                    UiPush()
                        UiTranslate(0,1)
                        for i, v in ipairs(c.c) do
                            local txt_w, _ = UiGetTextSize(v.text)
                            if c.itemHover == nil then c.itemHover = 0 end
                            if c.hoverOnce == nil then c.hoverOnce = false end
                            if v.height == nil then v.height = 0 end
                            if not v.widthChecked then
                                if uic_draw_contextmenu_row then
                                    c.w = c.w + txt_w
                                else
                                    if c.w < txt_w then c.w = txt_w 
                                        v.widthChecked = true
                                    else v.widthChecked = false
                                    end
                                end
                            end
                            -- UI RENDER 
                            if(not UiIsMouseInRect(c.w,24))then
                                if v.type == "button" or v.type == "toggle" or v.type == "submenu"then
                                    v.IsMouseHovering = false
                                end
                            end
                            if(UiIsMouseInRect(c.w+24,24)) then
                                if v.type == "button" or v.type == "toggle" or v.type == "submenu"then
                                    v.IsMouseHovering = true
                                    if not c.keepSubmenuOpen then
                                    c.itemHover = i
                                    end
                                    UiPush()
                                        if(not v.disabled) then
                                            UiColor(c255(255),c255(156),c255(0),1)
                                        else
                                            UiColor(c255(55),c255(55),c255(55),0.21)
                                        end
                                        UiTranslate(1,0)
                                        UiRect(c.w-2+24,24)
                                    UiPop()
                                    if v.type == "button" or v.type == "toggle" then
                                        c.hoverOnce = false
                                        c.keepSubmenuOpen = false
                                    end
                                    if v.disabled then
                                        if v.type == "submenu" then
                                            c.hoverOnce = false
                                            c.keepSubmenuOpen = false
                                        end
                                    end
                                end
                            end
                            -- uic_text(_itemsHovering)
                            if not v.disabled then
                                UiPush()
                                    -- UiTranslate(24,0)
                                    if UiBlankButton(c.w+24,24) then
                                        if v.type == "button" then
                                            v.action()
                                            uic_contextMenu_contents.items={}
                                            uic_draw_contextmenu = false
                                        end
                                        if v.type == "toggle" then
                                            v.action()
                                            if type(v.key) == "string" then
                                                if GetBool(v.key) then
                                                    SetBool(v.key,false)
                                                else
                                                    SetBool(v.key,true)
                                                end
                                            end
                                            uic_contextMenu_contents.items={}
                                            uic_draw_contextmenu = false
                                        end
                                    end
                                    if v.type == "submenu" then
                                        if v.hoverOnce == nil then v.subButtonId = i ; v.hoverOnce = false end
                                        if v.submenuH == nil then  v.submenuH = c.h end
                                        if UiIsMouseInRect(c.w+24,24) then
                                            if _itemsHovering == 1 and c.hoverOnce == false then
                                                table.insert(uic_contextMenu_contents.items, {
                                                    w=200, h=0, x=c.w+24, y=v.submenuHeightPos , useSubemenu = true, getCursor = false,
                                                    c = v.items
                                                })
                                                c.hoverOnce = true
                                                c.keepSubmenuOpen = true
                                            end
                                        end
                                        if UiIsMouseInRect(c.w+24,24) and c.hoverOnce == true then
                                            if c.itemHover == v.subButtonId  then
                                            else
                                                c.hoverOnce = false
                                                c.keepSubmenuOpen = false
                                            end
                                        end
                                    end
                                UiPop()
                            end
                            if v.type == "toggle" then
                                if type(v.key) == "string" then if GetBool(v.key) then
                                    UiPush()
                                        UiAlign('center middle')
                                        UiTranslate(12,12)
                                        if(not v.disabled) then
                                        else
                                            UiColor(c255(55),c255(55),c255(55),1)
                                        end
                                        UiImage('MOD/ui/TGUI_resources/textures/checkmark.png')
                                    UiPop()
                                end end
                            end
                            if v.type == 'divider' then
                                UiPush()
                                    UiTranslate(24,0)
                                    if uic_debug_contextMenu then
                                    UiPush()
                                        UiColor(1,0,0,1)
                                        UiRect(c.w-2,8)
                                    UiPop()
                                    end
                                    UiTranslate(1,3)
                                    uic_divider(c.w-2,false)
                                UiPop()
                            end
                            
                            UiPush()
                                UiTranslate(24,0)
                                if(v.disabled ) then UiColor(c255(24),c255(24),c255(24),1) end
                                uic_text(v.text, 24)
                            UiPop()
                            if(v.disabled ) then
                                UiPush()
                                    UiColor(0.1,0.1,0.1,0.4)
                                    UiTranslate(25,1)
                                    uic_text(v.text, 24)
                                UiPop()
                            end
                            UiTranslate(0,v.height)
                            -- END UI RENDER
                        end
                    UiPop()
                    if UiIsMouseInRect(c.w+24,c.h+2) then
                        _globalContextMenu_isCursorInside = true
                        c.isCursorInside = true
                        SetBool('TGUI.contextMenu.isCursorInside', true)
                    end
                    if not UiIsMouseInRect(c.w+24,c.h+2) then
                        c.isCursorInside = false
                    end

                end
            UiPop()
            for i, v in pairs(c.c) do
                if v.type == "submenu" and v.submenuHeightPos == nil then
                    v.submenuHeightPos = c.h
                end
                if v.heightCheck == nil then
                    if v.type == "button" or v.type == "toggle" or v.type == "submenu" then
                        c.h = c.h + 24
                        v.height = 24
                    elseif v.type == "divider" then
                        c.h = c.h + 8
                        v.height = 8
                    else
                        c.h = c.h + 24
                        v.height = 24
                    end
                    v.heightCheck = true
                else
                    if c.h == 0 then for i, v in ipairs(c.c) do
                        v.heightCheck = nil
                    end end
                end
            end
        end
        _itemsHovering = 0
        for it, c in pairs(uic_contextMenu_contents.items) do
            UiTranslate(-2,-2)
            if c.useSubemenu == nil then
                if not UiIsMouseInRect(c.w+26,c.h+4) then
                    if _globalContextMenu_isCursorInside == false then
                        if InputPressed('lmb') then uic_draw_contextmenu = false end
                        if InputPressed('rmb') then uic_draw_contextmenu = false end
                    end
                end
            else
                pcall(function ()
                    local keepSubmenuOpen = uic_contextMenu_contents.items[it-1].keepSubmenuOpen
                    if keepSubmenuOpen == false or keepSubmenuOpen == nil then
                        table.remove(uic_contextMenu_contents.items, it)
                    end
                end)
            end
            for i, v in ipairs(c.c) do
                if v.IsMouseHovering == true then
                    _itemsHovering = _itemsHovering + 1
                end
            end
            -- if last == i then
            -- end
            local PosX, PosY = c.x,c.y
            -- DebugPrint(last)
            if c.checkIfCutting == nil then
                if UiWidth()-c.w-40 < PosX then
                    c.Cuttin_alignRight = true
                    -- c.x = c.x - c.w-24
                end
                if UiHeight()-c.h-40 < PosY then
                    -- c.Cuttin_alignBottom = true
                    c.y = c.y - c.h
                    if c.y < 0 then
                        c.y = 0
                    end
                end
                c.checkIfCutting = false
            end
        end
        UiPop()
        _globalContextMenu_isCursorInside = false
    else
        uic_contextMenu_contents.items = {}
    end
end

---Creates a window
---@param width integer Width of the window
---@param height integer Height of the window
---@param clip boolean Clip content outside window. Default is false
---@param title string Title of the window
---@param padding integer Adds padding to all sides of the window
---@param content function function: Ui
function UiCreateWindow(width,height,clip,title,padding,content)
    UiPush()
        UiEnableInput()
        UiWindow(width ,height ,clip)
        UiPush()
            UiAlign("top left")
            UiColor(c255(160), c255(160), c255(160),c200(128))
            UiRect(width ,height)
            UiFont("MOD/ui/TGUI_resources/Fonts/TAHOMABD.TTF", 12)
            UiTranslate(16,8)
            UiColor(1,1,1,1)
            UiText(title)
        UiPop()
        UiTranslate(0,32)
        UiWindow(width,height-32,clip)
        -- UiRect(UiWidth(),padding)
        -- UiRect(padding,UiHeight())
        UiFont("MOD/ui/TGUI_resources/Fonts/TAHOMA.TTF", 15)
        UiTranslate(padding,padding)
        UiWindow(width-padding/2*4,height-32+padding/2*-4,clip)
        -- UiColor(1,0,0,1)
        -- UiRect(UiWidth(),UiHeight())
        UiColor(1,1,1,1)
        UiPush()
            UiAlign("top left")
            content()
        UiPop()
    UiPop()
end

--[[ widgets ]]

---Create a container widget
---@note There is a `UiTranslate(0,h)` at the end of the function
---@param width integer Width of the container
---@param height integer Height of the container
---@param clip boolean Clip content outside window. Default is false
---@param border boolean Adds the border to the container
---@param content function function: UI
---@param ectraContent any Additional content to be called to the container
function uic_container(width,height,clip,border,makeinner,content, ectraContent)
    UiPush()
        if(not border) then UiWindow(width,height,clip) end
        if border then
            if makeinner then
                UiImageBox('MOD/ui/TGUI_resources/textures/outline_inner_normal.png',width,height,1,1)
            else
                UiImageBox('MOD/ui/TGUI_resources/textures/outline_outer_normal.png',width,height,1,1)
            end
        end
        if(border) then UiWindow(width-2,height-2,clip) UiTranslate(1,1) end
        -- UiTranslate(1,1)
        UiPush()
            content(ectraContent)
        UiPop()    
    UiPop()    
    UiTranslate(0,height)
end


---Make a scroll container
---@param window table The root window
---@param w integer width of the scroll area
---@param h integer height of the scroll area
---@param border boolean whether to have the border or not
---@param scroll_height integer How much this container can be scrolled
---@param content function Content to the scroll area container
---@param extraContent any Additional content to be called to the container
function uic_scroll_Container(window,w,h,border,scroll_height, content, extraContent)
    if window.scrollfirstFrame then
        window.scrollPos = 0
        
        window.scrollfirstFrame = false
    end
    
    local scroll = window.scrollPos
    UiPush()
        if border then
            UiImageBox('MOD/ui/TGUI_resources/textures/outline_outer_normal.png',w,h,1,1)
        end
        UiPush()
            local max_scroll = 0
            if scroll_height > h then
                max_scroll = h - scroll_height else
                max_scroll = 0
            end
            if UiIsMouseInRect(w,h) then
                local scroll = InputValue('mousewheel')*10
                local scrollTest = 0
                scrollTest = window.scrollPos + scroll
                if window.scrollPos >= 0 then
                    window.scrollPos = 0
                end
                if window.scrollPos <= max_scroll then
                    window.scrollPos = max_scroll
                end
                if scroll > -1 then
                    if scrollTest < 1 then
                        window.scrollPos = window.scrollPos + scroll
                    else
                        window.scrollPos = 0
                    end
                end
                if scroll < 1 then
                    if scrollTest+1 > max_scroll then
                        window.scrollPos = window.scrollPos + scroll
                    else
                        window.scrollPos = max_scroll
                    end
                end
            else
                if window.scrollPos >= 0 then
                    window.scrollPos = 0
                end
                if window.scrollPos <= max_scroll then
                    window.scrollPos = max_scroll
                end
            end
        UiPop()
        local is_overflow = false
        if scroll_height > h then
            is_overflow = true
        end
        if UiIsMouseInRect(w,h) then
        else
            UiDisableInput()
        end
        UiPush()
            UiPush()
                UiPush()    
                    if is_overflow == false then
                        UiColor(1,1,1,0.3)
                    end
                    UiAlign('center middle')
                    UiPush()    
                        UiTranslate(w-(17/2),10)
                        UiImage('MOD/ui/TGUI_resources/textures/arrow_up.png',image)
                    UiPop()
                    UiPush()    
                        UiTranslate(w-(17/2),h-10)
                        UiImage('MOD/ui/TGUI_resources/textures/arrow_doen.png',image)
                    UiPop()
                UiPop()
                if is_overflow then
                    UiPush()    
                        -- scrollAndDrag( w,h, scroll_height, 5, 1, window )
                        -- -- 191 W:17

                        -- NOTE: Scroll bar size will go to one px height if the value goes under 1
                        -- TODO: make the scroll bar really accurate on how big the scroll area is
                        local factor = scroll_height/(h-20)

                        UiAlign('top left')
                        UiTranslate(0,17)
                        UiTranslate(w-17,0)
                        UiColor(c255(191), c255(191), c255(191), 0.5)
                        UiRect(17,h-17-17)
                        local factor;
                        local bar_scroll=scroll*((h-34)/(scroll_height-34))

                        local viewportRatio = h / scroll_height
                         
                        local scroll_bar_height = math.max(12, math.floor((h-34)*viewportRatio))

                        -- local scroll_bar_height=(max_scroll*(h-34)/scroll_height)
                        -- local scroll_bar_height=math.min(scroll_bar_height,h)
                        UiColor(c255(191), c255(191), c255(191), 1)
                        UiTranslate(0,-bar_scroll)
                        UiColor(1,1,1,1)
                        -- if (scroll_bar_height+h-(17*2)) > 1 then
                            UiImageBox('MOD/ui/TGUI_resources/textures/outline_inner_normal.png',17,(scroll_bar_height-7),1,1)
                        -- else
                            -- UiImageBox('MOD/ui/TGUI_resources/textures/outline_inner_normal.png',17,2,1,1)
                        -- end
                    UiPop()
                else
                end
            UiPop()
            UiWindow(w,h-1,true)
            if scroll_height > h then
                UiWindow(w-17,scroll_height-5,false)
                UiTranslate(0,scroll)
            else
                max_scroll = 0
            end
            content(extraContent)
        UiPop()
    UiPop()
end

---Create a tab container widget
---@note There is a `UiTranslate(0,h)` at the end of the function
---@param window function Get the window object for the widget
---@param w integer Width of the container tab
---@param h integer Height of the container tab
---@param clip boolean Clip content outside window. Default is false
---@param border boolean Adds the border of the tab container
---@param contents table Create ui with different tabs: `{["open_default"]=1 [0] = {["title"]="text",["content"]=function() end}, ...}`
---@param extraContent any Additional content to be called to the container and all the available tabs
function uic_tab_container(window, w,h,clip,border,contents, extraContent)
    local line_width = w
    UiPush()
        UiWindow(w,h,clip)
        UiPush()
            UiPush()
                UiTranslate(0,24)
                if border then
                    UiImageBox('MOD/ui/TGUI_resources/textures/outline_outer_tab_container.png',w,h-24,1,1)
                end
            UiPop()
            UiButtonImageBox('MOD',0,0,0,0,0,0)
            
            local all_tab_width = 0
            local tab_height = 25
            local right_padding = 20
            if window.tabFirstFrame == true then
                window.tabOpen = contents["open_default"]
                window.overflow = false
                window.tabScroll = 0
                window.tabFirstFrame = false
            end
            UiPush()
            UiWindow(w,tab_height+1,true)
            if window.overflow then
                if UiIsMouseInRect(w,tab_height+1) then else
                    UiDisableInput()
                end
            end
            UiTranslate(window.tabScroll,0)
            for i=1,#contents do
                UiPush()
                    tab_width = 0 
                    tab_text_w,_ = UiGetTextSize(contents[i]["title"])
                    UiPush()
                        local removeHeight = 3
                        if window.tabOpen == i then
                            removeHeight = 0
                        end
                        UiAlign('bottom left')
                        UiTranslate(0,tab_height)
                        tab_width = tab_text_w+right_padding
                        UiWindow(width,height,clip)
                        UiImageBox('MOD/ui/TGUI_resources/textures/outline_outer_tab.png',tab_width,tab_height-removeHeight,1,1)
                        UiPush()
                            UiDisableInput()
                            UiTextButton(contents[i]["title"],tab_text_w,tab_height-removeHeight)
                        UiPop()
                        if UiBlankButton(tab_width,tab_height-removeHeight) then 
                            window.tabOpen = i
                        end
                        if removeHeight == 3 then
                            UiImageBox('MOD/ui/TGUI_resources/textures/line_white.png',tab_width,1,0,0)
                        end
                        UiAlign('top left')
                        UiPush()
                            -- DebugPrint(#contents.." == "..i)
                            last = #contents - 0
                            if last > i then
                                UiPush()
                                    UiTranslate(tab_width,-1)
                                    UiImageBox('MOD/ui/TGUI_resources/textures/line_white.png',1,1,0,0)
                                UiPop()        
                            end
                            UiPush()
                                UiTranslate(0,0)
                                if window.tabOpen == i then
                                    UiPush()
                                        UiTranslate(tab_width-1,-1)
                                        UiImageBox('MOD/ui/TGUI_resources/textures/line_dark.png',1,1,0,0)
                                    UiPop()
                                    if window.tabOpen >= 2 then
                                        UiPush()
                                            UiTranslate(0,-1)
                                            UiImageBox('MOD/ui/TGUI_resources/textures/line_white.png',1,1,0,0)
                                        UiPop()
                                    end
                                end
                            UiPop()        
                        UiPop()        
                    UiPop()
                UiPop()
                all_tab_width = all_tab_width + (tab_width + 1)
                line_width = line_width - (tab_width + 1)
                UiTranslate(tab_width + 1)
            end
            UiPop()
            if w <= all_tab_width then
                window.overflow = true
                local max_scroll = all_tab_width-2 - w
                if window.tabScroll >= -max_scroll+1 then
                    UiPush()
                        UiAlign('left middle')
                        UiPush()
                            UiTranslate(w+5,tab_height/2)
                            UiImage('MOD/ui/TGUI_resources/textures/tabs_arrow_right.png',image)
                        UiPop()
                        UiAlign('left top')
                        UiTranslate(w,0)
                        if UiBlankButton(10,tab_height) then
                            local scroll = -10
                            window.tabScroll = window.tabScroll + scroll
                        end
                    UiPop()
                end
                if window.tabScroll <= -1 then
                    UiPush()
                    UiAlign('right middle')
                        UiPush()
                            UiTranslate(-5,tab_height/2)
                            UiImage('MOD/ui/TGUI_resources/textures/tabs_arrow_left.png',image)
                        UiPop()
                        UiAlign('right top')
                        if UiBlankButton(10,tab_height) then
                            local scroll = 10
                            window.tabScroll = window.tabScroll + scroll
                        end
                    UiPop()
                end

                if window.tabScroll >= 0 then
                    window.tabScroll = 0
                end
                if window.tabScroll <= -max_scroll then
                    window.tabScroll = -max_scroll
                end
                if UiIsMouseInRect(w,tab_height+1) then
                    local scroll = InputValue('mousewheel')*10
                    window.tabScroll = window.tabScroll + scroll
                end
            end
        UiPop()
        UiPush()
        if w > all_tab_width then
            UiTranslate(all_tab_width-1,24)
            UiImageBox('MOD/ui/TGUI_resources/textures/line_white.png',line_width,1,0,0)
        end
        UiPop()    
        if(border) then
            UiTranslate(1,tab_height)
            UiWindow(w-2,h-tab_height-1,true)
        end
        UiPush()
            contents[window.tabOpen]["Content"](extraContent)
        UiPop()
    UiPop()    
    UiTranslate(0,h)
end

function uic_table_container(window,w,h,clip,border,makeinner,nameContents,itemsContents)
    if window.firstFrame == nil then
        window.totalWidth = 0
        window.firstFrame = false
    end
    window.totalWidth = 0
    UiPush()
        if border then
            UiPush()
                UiColor(c255(93),c255(93),c255(93),0.5)
                UiRect(w,h)
            UiPop()
            if makeinner then
                UiImageBox('MOD/ui/TGUI_resources/textures/outline_inner_normal.png',w,h,1,1)
            else
                UiImageBox('MOD/ui/TGUI_resources/textures/outline_outer_normal.png',w,h,1,1)
            end
        end
        for i, v in ipairs(nameContents) do
            window.totalWidth = window.totalWidth + v.w
        end
        UiTranslate(1,1)
        
        UiPush()
            UiTranslate(0,h-30)
            uic_text(window.totalWidth, 17, 10)
        UiPop()
        if window.totalWidth > w then
            UiWindow(w-2,h-2,true)
        end
        UiPush()
            for k , v in pairs(nameContents) do
                local text = uic_text(v.label, 17, 10)
                UiPush()
                    UiFont(text.font,text.size)
                    local txt_w, _ = UiGetTextSize(v.label)
                UiPop()
                UiImageBox('MOD/ui/TGUI_resources/textures/outline_outer_normal.png',v.w,17,1,1)
                if v.w <= txt_w then v.w = txt_w end
                UiTranslate(v.w,0)
            end
        UiPop()
        UiTranslate(0,17)
        UiPush()
            for i, v in ipairs(itemsContents) do
                local item = v
                
                UiPush()
                    for iInner, vInner in ipairs(item) do
                        local rowWidth = nameContents[iInner].w
                        local text, txtType = {}, type(vInner);
                        
                        UiPush()
                            if txtType == "string" or txtType == "number"  then
                                text = uic_text(vInner, 17, 15)
                            else
                                text = uic_text(type(vInner), 17, 15)
                            end
                        UiPop()
                        UiFont(text.font,text.size)
                        local txt_w, _ = UiGetTextSize(vInner)
                        if rowWidth <= txt_w then
                            nameContents[iInner].w = txt_w
                        end
                        UiTranslate(rowWidth,0)
                    end
                UiPop()
                UiTranslate(0,17)
            end
        UiPop()
    UiPop()
end

---[[ UI ]]

---Display text
---@param Text string Simple, display the text
---@param height integer Height for the the `UiTextButton`
---@param fontSize integer Size of the text
---@return table fontPathAndSize Get the font path and the size that is used
function uic_text( Text, height, fontSize )
    if height == nil then
        height = 15
    end
    if fontSize == nil then
        fontSize = 15
    end
    UiPush()
        UiFont("MOD/ui/TGUI_resources/Fonts/TAHOMA.TTF", fontSize)
        local txt_w, txt_h = UiGetTextSize(Text)
        UiDisableInput()
        if uic_debug_buttontextWidth then
            UiPush()
                UiColor(1,1,0,0.3)
                UiRect(txt_w,height)
            UiPop()
        end
        UiButtonImageBox('MOD',0,0,0,0,0,0)
        UiTextButton(Text,txt_w,height)
    UiPop()
    local finalHeight;
    if txt_h >= height then
        finalHeight = txt_h
    else
        finalHeight = height
    end
    return {font="MOD/ui/TGUI_resources/Fonts/TAHOMA.TTF", size=fontSize, height=finalHeight}
end

---Create a checkbox
---@param text string Display text
---@param key string Key for the checkbox
---@param hitWidth integer Changes width of the hitbox for the checkbox
---@param beDisabled boolean Make it disabled and unchecable
function uic_checkbox(text, key, hitWidth, beDisabled, toolTipText)
    UiPush()
        UiWindow(0,12,false	)
        UiAlign('left top')
        UiFont("MOD/ui/TGUI_resources/Fonts/TAHOMA.TTF", 15)
        UiButtonImageBox('',1,1,1,1,1,1)
        UiImageBox("MOD/ui/TGUI_resources/textures/outline_inner_special_checkbox.png",12, 12,1,1,1,1)
        UiButtonImageBox(' ',0,0,0,0,0,0)
        tx_s_w,no_v_h = UiGetTextSize(text)
        UiPush()
            UiColor(1,1,1,1)
            UiTranslate(-6,-4)
            if uic_debug_checkHit then
                UiColor(1,1,1,0.2)
                UiRect(6 + no_v_h + hitWidth,20)
                UiColor(1,1,1,1)
            end
            if UiBlankButton(6 + no_v_h + hitWidth,20) then
                if type(key) == "string" then
                    if GetBool(key) then
                        SetBool(key,false)
                    else
                        SetBool(key,true)
                    end
                end
                if type(key) == "boolean" then
                    if key then
                        return false
                    else
                        return true
                    end
                end
            end
        UiPop()
        if type(key) == "string" then
            if GetBool(key) then
                UiImage('MOD/ui/TGUI_resources/textures/checkmark.png')
            else
                UiTranslate(-6,-4)
                if UiIsMouseInRect(6 + no_v_h + hitWidth,20) then
                    UiColor(0.95,0.95,0.95,1)
                end
                UiTranslate(6,4)
            end
        end
        if type(key) == "boolean" then
            if key then
                UiImage('MOD/ui/TGUI_resources/textures/checkmark.png')
            else
                UiTranslate(-6,-4)
                if UiIsMouseInRect(6 + no_v_h + hitWidth,20) then
                    UiColor(0.95,0.95,0.95,1)
                end
                UiTranslate(6,4)
            end
        end
        UiAlign('left middle')
        UiTranslate(12,5)
        UiDisableInput()
        if UiTextButton(text,0,12) then end
    UiPop()
    if type(key) == "boolean" then
        return key
    end
end

---Create a button
---@param buttinid integer id of the button
---@param text string Display text on the button
---@param width integer Width of the button
---@param height integer Height of the button
---@param disabled integer Disable the button
---@return boolean boolean Returns true if the button is released, none otherwise
function uic_button(buttinid, text, width, height, disabled, toolTipText)
    UiPush()
        UiWindow(width, height, false)
        UiAlign("left top")
        UiFont("MOD/ui/TGUI_resources/Fonts/TAHOMA.TTF", 14)
        if disabled then
            UiDisableInput()
        end
        UiPush()
            if not disabled then
                if UiIsMouseInRect(width, height) then
                    if not InputDown('lmb') then
                        UiImageBox("MOD/ui/TGUI_resources/textures/outline_outer_normal.png",width, height,1,1,1,1)
                    else
                        UiImageBox("MOD/ui/TGUI_resources/textures/outline_inner_normal.png",width, height,1,1,1,1)
                        UiTranslate(1,1)
                    end
                else
                    UiImageBox("MOD/ui/TGUI_resources/textures/outline_outer_normal.png",width, height,1,1,1,1)
                end
                UiColor(1,1,1,1)
            else
                UiImageBox("MOD/ui/TGUI_resources/textures/outline_outer_normal.png",width, height,1,1,1,1)
                UiColor(0.1,0.1,0.1,0.8)
            end
        
            UiTranslate(6,0)
            local w,h = UiGetTextSize(text)
            UiButtonImageBox('MOD',0,0,0,0,0,0)
            if UiTextButton(text,w,height) then return true end
        UiPop()    
        UiButtonImageBox("MOD",1,1,1,1,1,0)
        if UiBlankButton(width, height) then return true end

        if UiIsMouseInRect(width, height) then
            if toolTipText ~= nil then
                if uic_tooltip_enabled == false then
                    if uic_tooltip_hover_timer == 1 then
                        SetValue('uic_tooltip_hover_timer',0,"linear",0.75)
                        -- currentid = nextid
                        -- nextid = nextid +1

                        uic_tooltip_hover_id = buttinid
                        uic_tooltip_text = toolTipText
                    end
                    if uic_tooltip_hover_timer == 0 then
                        uic_tooltip_enabled = true
                    end
                end
            end
        else
            if not UiIsMouseInRect(width, height) then
                if uic_tooltip_hover_timer == 0 then
                    uic_tooltip_hover_timer = 1
                    uic_tooltip_enabled = false
                end
            end
            if uic_tooltip_hover_id == buttinid then
                if uic_tooltip_hover_timer == 0 then
                    uic_tooltip_hover_timer = 1
                    uic_tooltip_enabled = false
                end
            end
        end
    UiPop()
end
---Create a button
---@param buttinid integer id of the button
---@param text string Display text on the button
---@param width integer Width of the button
---@param height integer Height of the button
---@param disabled integer Disable the button
---@param onClick function Do something when on the button on click
---@param extraContent any Additional content to be called to the button
function uic_button_func(buttinid, text, width, height, disabled, toolTipText, onClick, extraContent)
    UiPush()
        UiWindow(width, height, false)
        UiAlign("left top")
        UiFont("MOD/ui/TGUI_resources/Fonts/TAHOMA.TTF", 14)
        if disabled then
            UiDisableInput()
        end
        UiPush()
            if not disabled then
                if UiIsMouseInRect(width, height) then
                    if not InputDown('lmb') then
                        UiImageBox("MOD/ui/TGUI_resources/textures/outline_outer_normal.png",width, height,1,1,1,1)
                    else
                        UiImageBox("MOD/ui/TGUI_resources/textures/outline_inner_normal.png",width, height,1,1,1,1)
                        UiTranslate(1,1)
                    end
                else
                    UiImageBox("MOD/ui/TGUI_resources/textures/outline_outer_normal.png",width, height,1,1,1,1)
                end
                UiColor(1,1,1,1)
            else
                UiImageBox("MOD/ui/TGUI_resources/textures/outline_outer_normal.png",width, height,1,1,1,1)
                UiColor(0.1,0.1,0.1,0.8)
            end
        
            UiTranslate(6,0)
            local w,h = UiGetTextSize(text)
            UiButtonImageBox('MOD',0,0,0,0,0,0)
            if(disabled) then
                UiPush()
                    UiColor(0.1,0.1,0.1,0.4)
                    UiTranslate(1,1)
                    if UiTextButton(text,w,height) then end
                UiPop()
            end
            if UiTextButton(text,w,height) then onClick(extraContent) end
        UiPop()    
        UiButtonImageBox("MOD",1,1,1,1,1,0)
        if UiBlankButton(width, height) then onClick(extraContent) end
        if UiIsMouseInRect(width, height) then
            if toolTipText ~= nil then
                if uic_tooltip_enabled == false then
                    if uic_tooltip_hover_timer == 1 then
                        SetValue('uic_tooltip_hover_timer',0,"linear",0.75)
                        -- currentid = nextid
                        -- nextid = nextid +1

                        uic_tooltip_hover_id = buttinid
                        uic_tooltip_text = toolTipText
                    end
                    if uic_tooltip_hover_timer == 0 then
                        uic_tooltip_enabled = true
                    end
                end
            end
        else
            if not UiIsMouseInRect(width, height) then
                if uic_tooltip_hover_timer == 0 then
                    uic_tooltip_hover_timer = 1
                    uic_tooltip_enabled = false
                end
            end
            if uic_tooltip_hover_id == buttinid then
                if uic_tooltip_hover_timer == 0 then
                    uic_tooltip_hover_timer = 1
                    uic_tooltip_enabled = false
                end
            end
        end
    UiPop()
end


---Make a divider ( like an hr in html )
---@note This function does not include `UiPush()` and `UiPop()`
---@param width integer Width of the divider
---@param flip boolean Flup the divider texture
function uic_divider(width, flip)
    if flip then return UiImageBox('MOD/ui/TGUI_resources/textures/line_outer.png',width,2,1,1) end
    return UiImageBox('MOD/ui/TGUI_resources/textures/line_inner.png',width,2,1,1)
end

---Create a dropdown menu | id is now window
---@note A registry will be added to the key: `.dropdwon.val`
---@param window table The root window
---@param width integer Width of the dropdown menu and window
---@param key string Key for each dropdown menu (if all keys are the same for all dropdown menus, every one of them will show the same selected item)
---@param items table List of items to display
---@param items_keys table List of items to set the current key value, example "`key.item = 'item 1'` or `savegame.quote = 'I'd like to have a coffee'` "
---@param goUp boolean Instead of the dropdown menu spawning below, it spawns on top. (used if there is no space on the bottom)
---@param toolTipText string Create a tooltip
function uic_dropdown(window, width, key, items, items_keys, goUp, toolTipText)
    UiPush()
        -- DebugWatch('dropdown open'..window.tooltipId,window.open)
        local he = 24
        local scroll_width = 24
        local bu_he = 18 
        w,dropdown_height = he,bu_he
        -- if window.firstFrame then
            for i=1, #items do
                w,dropdown_height = he,bu_he
                window.dropdown_height = (dropdown_height*i)
            end

        --     window.firstFrame = false
        -- end
        UiFont("MOD/ui/TGUI_resources/Fonts/TAHOMA.TTF", 15)
        UiImageBox("MOD/ui/TGUI_resources/textures/outline_inner_normal_dropdown.png",width, he,1,1,1,1)
        UiColor(1,1,1,1)
        UiPush()
            UiAlign('top right')
            UiTranslate(0,0)
            UiTranslate(width-(scroll_width/2),he/2)
            UiAlign('center middle')
            UiImage('MOD/ui/TGUI_resources/textures/dropdown_arrow.png')
        UiPop()
        UiPush()
            UiTranslate(0,he/2)
            UiAlign("left middle")
            UiText(GetString(key..".dropdwon.val"))
        UiPop()    
        UiButtonImageBox("MOD",1,1,1,1,1,0)
        if UiBlankButton(width, he) then
            if window.open then window.open = false else window.open = true end
        end
        if UiIsMouseInRect(width, he) then
            if toolTipText ~= nil then
                if uic_tooltip_enabled == false then
                    if uic_tooltip_hover_timer == 1 then
                        SetValue('uic_tooltip_hover_timer',0,"linear",0.75)
                        uic_tooltip_hover_id = window.tooltipId
                        uic_tooltip_text = toolTipText
                    end
                    if uic_tooltip_hover_timer == 0 then
                        uic_tooltip_enabled = true
                    end
                end
                -- uic_tooltip_hover(0, true)
            end
        else
            -- uic_tooltip_hover(0, false)
            if uic_tooltip_hover_id == window.tooltipId then
                if uic_tooltip_hover_timer == 0 then
                    uic_tooltip_hover_timer = 1
                    uic_tooltip_enabled = false
                end
            end
        end
        if window.open then
            UiWindow(width,he+window.dropdown_height+3,true)
            UiPush()
                if goUp then
                    UiAlign('left top')
                    UiWindow(width,0,false)
                    UiTranslate(0,-window.dropdown_height-he-3)
                    UiPush()
                        UiTranslate(0,he)
                        if not UiIsMouseInRect(width,he+window.dropdown_height) then
                            if InputReleased('lmb') then window.open = false end
                        end
                    UiPop()
                else
                    if not UiIsMouseInRect(width,he+window.dropdown_height) then
                        if InputReleased('lmb') then window.open = false end
                    end
                end
                UiTranslate(0,he+1)
                UiImageBox("MOD/ui/TGUI_resources/textures/outline_outer_special_dropdown.png",width,window.dropdown_height+2,1,1,1,1)
                if goUp then
                    UiAlign('left top')
                end
                UiTranslate(0,1)
                for i=1, #items do
                    w,dropdown_height = he,bu_he
                    if UiIsMouseInRect(width-scroll_width,bu_he) then
                        UiPush()
                            UiTranslate(1,0)
                            UiColor(c255(255),c255(156),c255(0),1)
                            UiRect(width-2-scroll_width,bu_he)
                        UiPop()
                    end
                    UiColor(1,1,1,1)
                    UiPush()
                        -- UiTranslate(0,bu_he/2)
                        -- UiAlign('left middle')
                        -- UiText(items[i])
                        UiDisableInput()
                        local TXT_w, _ = UiGetTextSize(items[i])
                        UiTextButton(items[i],TXT_w,bu_he)
                    UiPop()
                    if UiBlankButton(width,bu_he) then
                        window.open = false
                        SetString(key,items_keys[i])
                        SetString(key..".dropdwon.val",items[i])
                    end
                    -- UiPush()
                    --     UiTranslate(0,-he)
                    --     UiRect(width,dropdown_height+he)
                    -- UiPop()
                    UiTranslate(0,bu_he)
                    dropdown_height = dropdown_height*i+1
                end
            UiPop()
        end
    UiPop()
end
-- 
function uic_slider(key,min,max)
    UiPush()
        SetFloat(key,UiSlider("MOD/ui/TGUI_resources/textures/Slider/Slider.png",'x',GetFloat(key),min,max))
    UiPop()
end

backspace_Timer = 1

function custom_UiInputText( string, w, h, window )
    -- UiRect(w,h)
    local chars = {
        lower = "abcdefghijklmnopqrstuvwxyz1234567890-=[];',./`",
        upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ!@#$%^&*()_+{}:\"<>?~"
    }

    if UiBlankButton(w,h) and window.focused == false then
        window.focused = true
    end
    if not UiIsMouseInRect(w,h) and InputPressed('lmb') and window.focused then
        window.focused = false
    end
    if window.focused then
        if InputDown('backspace') then
            if backspace_Timer == 1 then
                SetValue('backspace_Timer',0,"linear",1)
            end
            if backspace_Timer == 0 then
                return string:sub(1, -2)
                -- DebugPrint(inputReturn:sub(1, -2))
            end
        end
        if not InputDown('backspace') then
            if not backspace_Timer == 1 and not backspace_Timer == 0 then
                backspace_Timer = 1
            end
            backspace_Timer = 1
        end
    end
    if window.focused then
        if InputPressed("delete") or InputPressed('backspace') then
            return string:sub(1, -2)
        end
        if InputPressed("space") then
            return string.." "
        end
        for i = 0, string.len(chars.lower), 1 do
            local currLetter = string.sub(chars.lower, i, i)
    
            if(InputPressed(currLetter)) then
                if(InputDown("shift")) then
                    currLetter = string.sub(chars.upper, i, i)
                end

                return string .. currLetter
                -- lastInputTime = GetTime()
            end
        end 
    end

    return string
end


---Text Input
---@info Hright of textbox is 24
---@param key string Key for the input
---@param width integer width of the input
---@param window table Root window for the textbox
---@return string inputText Text input string
function uic_textbox(key, width, window )
    UiPush()
        if allowSpecialKeys == nil then
            allowSpecialKeys = {enabled = false}
        end
        UiFont("MOD/ui/TGUI_resources/Fonts/TAHOMA.TTF", 15)
        UiImageBox("MOD/ui/TGUI_resources/textures/outline_inner_normal_dropdown.png",width, 24,1,1,1,1)
        local tW,tH = UiGetTextSize(GetString(key))
        UiPush()
            UiDisableInput()
            UiAlign('top right')
            UiTranslate(width,0)
            UiButtonImageBox('MOD',0,0,0,0,0,0)
            UiFont("MOD/ui/TGUI_resources/Fonts/TAHOMABD.TTF", 12)
            UiTranslate(0,1)
            UiColor(0,0,0,1)
            UiRect(13,22)
            UiColor(1,1,1,1)
            UiTextButton('EN',13,22)
        UiPop()
        SetString(key, custom_UiInputText(GetString(key), width , 24 , window))
        if tW >= width-13 then
            UiWindow(width,24,true)
            UiTranslate(width-tW-13,0)
        end
        UiTranslate(0,0)
        UiAlign('top left')
        UiDisableInput()
        uic_text(GetString(key),24)
        local inputReturn = GetString(key)
    UiPop()
    return inputReturn
end

-- function uic_Register_Contextmenu_at_cursor( contents, extraContents, row )
function uic_Register_Contextmenu_at_cursor( contents, extraContents )
    uic_contextMenu_getCursor = true
    uic_draw_contextmenu = true
    uic_draw_contextmenu_row = false
    uic_contextMenu_contents.items = {}
    table.insert(uic_contextMenu_contents.items, {
        w=200, h=0,
        c = contents
    })
end
function uic_local_contextMenu( x, y, contents, minWidth ,window )
    -- dividers
    local w = window.w
    local h = window.h
    window.x = x
    window.y = y
    UiPush()
        for i, v in ipairs(contents) do
            if v.type == "button" then
                UiDisableInput()
                UiTextButton('text',w,h)
                UiEnableInput()
                if UiBlankButton(w,h) then
               end
            end
        end
    UiPop()
end
function BoolToString(b) 
    return b and "True" or "False";
end

-- OLD STUFF

---Create a dropdown menu [OBSOLETE]
---@note A registry will be added to the key: `.dropdwon.val`
---@param id integer Id makes it able to check if other dropdown menus are open and automatically closes one if opened
---@param width integer Width of the dropdown menu and window
---@param key string Key for each dropdown menu (if all keys are the same for all dropdown menus, every one of them will show the same selected item)
---@param items table List of items to display
---@param items_keys table List of items to set the current key value, example "`key.item = 'item 1'` or `savegame.quote = 'I'd like to have a coffee'` "
---@param goUp boolean Instead of the dropdown menu spawning below, it spawns on top. (used if there is no space on the bottom)
---@param toolTipText string Create a tooltip
-- function uic_dropdown(id, width, key, items, items_keys, goUp, toolTipText)
--     UiPush()
--         local he = 24
--         local scroll_width = 12
--         UiFont("MOD/ui/TGUI_resources/Fonts/TAHOMA.TTF", 15)
--         UiImageBox("MOD/ui/TGUI_resources/textures/outline_inner_normal_dropdown.png",width, he,1,1,1,1)
--         UiColor(1,1,1,1)
--         UiPush()
--             UiAlign('top right')
--             UiTranslate(width,0)
--             UiWindow(scroll_width,he,true)
--             UiRect(UiWidth(),UiHeight())
--             UiTranslate(UiCenter(),UiMiddle())
--             UiAlign('center middle')
--             UiImage('MOD/ui/TGUI_resources/textures/dropdown_arrow.png')
--         UiPop()
--         UiPush()
--             UiTranslate(0,he/2)
--             UiAlign("left middle")
--             UiText(GetString(key..".dropdwon.val"))
--         UiPop()    
--         UiButtonImageBox("MOD",1,1,1,1,1,0)
--         if UiBlankButton(width, he) then
--             if showDropDown and id_open == id then showDropDown = false else showDropDown = true end
--             id_open = id
--         end
--         if UiIsMouseInRect(width, he) then
--             if showDropDown == false then
--                 for i=1, #items do
--                     local bu_he = 18 
--                     w,dropdown_height = he,bu_he
--                     dropdown_height = (i+1)+dropdown_height*i
--                 end
--             end
--             if toolTipText ~= nil then
--                 if uic_tooltip_enabled == false then
--                     if uic_tooltip_hover_timer == 1 then
--                         SetValue('uic_tooltip_hover_timer',0,"linear",0.75)
--                         uic_tooltip_hover_id = id
--                         uic_tooltip_text = toolTipText
--                     end
--                     if uic_tooltip_hover_timer == 0 then
--                         uic_tooltip_enabled = true
--                     end
--                 end
--             end
--         else
--             if uic_tooltip_hover_id == id then
--                 if uic_tooltip_hover_timer == 0 then
--                     uic_tooltip_hover_timer = 1
--                     uic_tooltip_enabled = false
--                 end
--             end
--         end
--         if showDropDown then
--             if id_open == id then
--                 UiPush()
--                     if goUp then
--                         UiAlign('left top')
--                         UiWindow(width,0,false)
--                         UiTranslate(0,-dropdown_height-he-3)
--                         UiPush()
--                             UiTranslate(0,he)
--                             if not UiIsMouseInRect(width,he+dropdown_height) then
--                                 if InputReleased('lmb') then showDropDown = false end
--                             end
--                         UiPop()
--                     else
--                         if not UiIsMouseInRect(width,he+dropdown_height) then
--                             if InputReleased('lmb') then showDropDown = false end
--                         end
--                     end
--                     UiTranslate(0,he+1)
--                     UiImageBox("MOD/ui/TGUI_resources/textures/outline_outer_special_dropdown.png",width, dropdown_height+1,1,1,1,1)
--                     if goUp then
--                         UiAlign('left top')
--                     end
--                     UiTranslate(0,1)
--                     for i=1, #items do
--                         local bu_he = 18 
--                         w,dropdown_height = he,bu_he
--                         if UiIsMouseInRect(width-scroll_width,bu_he) then
--                             UiPush()
--                                 UiTranslate(1,0)
--                                 UiColor(c255(255),c255(156),c255(0),1)
--                                 UiRect(width-2-scroll_width,dropdown_height)
--                             UiPop()
--                         end
--                         UiColor(1,1,1,1)
--                         UiText(items[i])
--                         if UiBlankButton(width,bu_he) then
--                             showDropDown = false
--                             SetString(key,items_keys[i])
--                             SetString(key..".dropdwon.val",items[i])
--                         end
--                         UiTranslate(0,bu_he)
--                         dropdown_height = dropdown_height*i+1
--                     end
--                 UiPop()
--             end
--         end
--     UiPop()
-- end