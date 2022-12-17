--[[
    TGUI UI Library 2.0
    -------------------
    TEARDOWN GRAPHICAL USER INTERFACE LIBRARY
]]
---Convert to float 0 to 1 from 255 range
---@param c integer range of 0 to 255
---@return number c Range of 0 to 1 float
function c255(c)
    return c/255
end

local maintheme = {
    text = {
        height = 15,
        fontsize = 13,
        font = "MOD/ui/TGUI_resources/Fonts/TAHOMA.TTF", -- This will automatically be replaced when the ui lib is created.
    },
    button = {
        color = {r=0,g=0,b=0,a=0},
        bg = {r=0,g=0,b=0,a=0},
        height = 24,
        width = 100,
        border = 0,
    },
    slider = {
        width = 17,
    },
    checkbox = {
        hitwidth =      64,
        enabledColor =  {r=255,g=255,b=255,a=1},
        disabledColor = {r=0.5,g=0.5,b=0.5,a=1},
        disabledColorShadow = {r=60,g=60,b=60,a=0.4},
        hoverColor =    {r=0.95,g=0.95,b=0.95,a=1},
        activeColor =   {r=255,g=255,b=255,a=1},
    },
}
local TGUI = {}

--[[ SIMPLE ELEMENTS ]]--

---Creates a text element: Complex 0.1
---@param options table
---- @field text string
---- @field height integer
---- @field fontsize integer
---@return table {font=string, size=integer, width=integer, height=integer}
function TGUI:createText(options)
    local text = options.text or ""
    local height = options.height or maintheme.text.height
    local fontsize = options.fontsize or maintheme.text.fontsize
    local font = options.font or maintheme.text.font

    if (text == "") then
        error("Text cannot be empty", 0)
    end

    UiPush() 
        UiFont(font, fontsize)
        local txt_w, txt_h = UiGetTextSize(text)
        UiDisableInput()
        if uic_debug_buttontextWidth then
            UiPush()
                UiColor(1,1,0,0.3)
                UiRect(txt_w,height)
            UiPop()
        end
        UiButtonImageBox('MOD',0,0,0,0,0,0)
        UiTextButton(text,txt_w,height)
    UiPop()
    local finalHeight;
    if txt_h >= height then finalHeight = txt_h
    else finalHeight = height end
    return {font=font, size=fontsize, width=txt_w ,height=finalHeight}
end

---Creates a button element: Complex 0.4
---@param options table
---- @field text string
---- @field height integer
---- @field width integer
---- @field color table
---- @field style table styles 
--- ```lua
--- style = {
---     fontPath = "MOD/ui/TGUI_resources/Fonts/TAHOMA.TTF",
---     fontSize = 13,
---     textcolornormal = {r=c255(255),g=c255(255),b=c255(255),a=1},
---     textcolordisabled = {r=c255(255),g=c255(255),b=c255(255),a=1},
--- }
--- ```
---- @field func function
---@return table {width=integer, height=integer}
function TGUI:createButton( options )
    local window = options.window or nil
    local text = options.text or ""
    local disabled = options.disabled or false
    local height = options.height or maintheme.button.height
    local width = options.width or maintheme.button.width
    -- local border = options.border or maintheme.button.border
    -- local bg = options.bg or maintheme.button.bg
    local style = options.style or {
        fontPath = "MOD/ui/TGUI_resources/Fonts/TAHOMA.TTF",
        fontSize = 13,
        textcolornormal = {r=c255(255),g=c255(255),b=c255(255),a=1},
        textcolordisabled = {r=c255(255),g=c255(255),b=c255(255),a=1},
    }
    local func = options.func or function()
        DebugPrint("func: Button pressed")
    end

    if (type(window) == not "table") then
        error("Window must be a table", 0)
    end

    if (text == "") then
        error("Text cannot be empty", 0)
    end
    -- if height is lover than 0 then error
    if (height <= 0) then
        error("Height cannot be 0", 0)
    end
    -- if width is lover than 0 then error
    if (width <= 0) then
        error("Width cannot be 0", 0)
    end

    UiPush()
        UiWindow(width, height, false)
        UiAlign("left top")
        UiFont(style.fontPath, style.fontSize)
        if disabled then
            UiDisableInput()
        end
        UiPush()
            if not disabled then
                if UiIsMouseInRect(width, height) then
                    if not InputDown('lmb') then
                        UiImageBox(tgui_ui_assets.."/textures/outline_outer_normal.png",width, height,1,1,1,1)
                    else
                        UiImageBox(tgui_ui_assets.."/textures/outline_inner_normal.png",width, height,1,1,1,1)
                        UiTranslate(1,1)
                    end
                else
                    UiImageBox(tgui_ui_assets.."/textures/outline_outer_normal.png",width, height,1,1,1,1)
                end
                UiColor(style.textcolornormal.r,style.textcolornormal.g,style.textcolornormal.b,style.textcolornormal.a)
            else
                UiImageBox(tgui_ui_assets.."/textures/outline_outer_normal.png",width, height,1,1,1,1)
                UiColor(style.textcolordisabled.r,style.textcolordisabled.g,style.textcolordisabled.b,style.textcolordisabled.a)
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
            UiDisableInput()
            if UiTextButton(text,w,height) then end
        UiPop()    
        UiButtonImageBox("MOD",1,1,1,1,1,0)
        if UiBlankButton(width, height+1) then func() end
        if type(window) == "table" then
            uic_tooltipHitbox( width,height,window.tooltipActive ,tooltip, dt )
            if allowSpecialKeys == nil then allowSpecialKeys = {enabled = false} end
            if UiIsMouseInRect(width, height) then 
                if tooltip then draw_tooltip_text = tooltip; window.tooltipActive = true end
            else
                if window.tooltipActive then
                    draw_tooltip = false
                    draw_tooltip_params.popInTimer = 0
                    window.tooltipActive = false
                end
            end
        end
    UiPop()

    return {width=width, height=height}
end

--[[
    function uic_checkbox(text, key, hitWidth, beDisabled, toolTipText, style)
    if type( style ) == not "table" then
        error( "style must be a table", 0 )
    end
    if style == nil or style == {} then
        style = {
            font = tgui_ui_assets.."/Fonts/TAHOMA.TTF",
            fontSize = 13,
            enabledColor =  {r=255,g=255,b=255,a=1},
            disabledColor = {r=0.5,g=0.5,b=0.5,a=1},
            disabledColorShadow = {r=60,g=60,b=60,a=0.4},
            hoverColor =    {r=0.95,g=0.95,b=0.95,a=1},
            activeColor =   {r=255,g=255,b=255,a=1},
        }
    else
        if style.font == nil then style.font = tgui_ui_assets.."/Fonts/TAHOMA.TTF" end
        if style.fontSize == nil then style.fontSize = 13 end
        if style.enabledColor == nil then style.enabledColor = {r=255,g=255,b=255,a=1} end
        if style.disabledColor == nil then style.disabledColor = {r=0.5,g=0.5,b=0.5,a=1} end
        if style.disabledColorShadow == nil then style.disabledColorShadow = {r=60,g=60,b=60,a=0.4} end
        if style.hoverColor == nil then style.hoverColor = {r=0.95,g=0.95,b=0.95,a=1} end
        if style.activeColor == nil then style.activeColor = {r=1,g=1,b=1,a=1} end
    end
    UiPush()
        UiWindow(0,12,false	)
        UiAlign('left top')
        UiFont(tgui_ui_assets.."/Fonts/TAHOMA.TTF", 13)
        UiButtonImageBox('',1,1,1,1,1,1)
        UiImageBox(tgui_ui_assets.."/textures/outline_inner_special_checkbox.png",12, 12,1,1,1,1)
        UiButtonImageBox(' ',0,0,0,0,0,0)
        tx_s_w,no_v_h = UiGetTextSize(text)
        -- check if the text is bigger than the hitbox
        if tx_s_w > hitWidth then
            hitWidth = tx_s_w
        end
        UiPush()
            UiColor(1,1,1,1)
            UiTranslate(-6,-4)
            if uic_debug_show_hitboxes_checkbox then
                UiColor(1,1,1,0.2)
                UiRect(6 + no_v_h + hitWidth,20)
                UiColor(1,1,1,1)
            end
            if not beDisabled then 
                if UiBlankButton(6 + no_v_h + hitWidth,20) then
                    if type(key) == "string" then
                        SetBool(key,not GetBool(key))
                    end
                    if type(key) == "boolean" then
                        if key then
                            return false
                        else
                            return true
                        end
                    end
                end
            end
        UiPop()
        if type(key) == "string" then
            if GetBool(key) then
                UiImage(tgui_ui_assets..'/textures/checkmark.png')
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
                UiImage(tgui_ui_assets..'/textures/checkmark.png')
            else
                UiTranslate(-6,-4)
                if UiIsMouseInRect(6 + no_v_h + hitWidth,20) then
                    UiColor(style.hoverColor.r,style.hoverColor.g,style.hoverColor.b,1)
                end
                UiTranslate(6,4)
            end
        end
        UiAlign('left middle')
        UiTranslate(12,5)
        UiDisableInput()
        if beDisabled then
            UiColor(style.disabledColor.r, style.disabledColor.g, style.disabledColor.b, style.disabledColor.a)
        end
        uic_text(text, 24)
        if( beDisabled ) then
            UiPush()
                UiColor(c255(style.disabledColorShadow.r), c255(style.disabledColorShadow.g), c255(style.disabledColorShadow.b), style.disabledColorShadow.a)
                UiTranslate(1,1)
                uic_text(text, 24)
            UiPop()
        end
    UiPop()
    if type(key) == "boolean" then
        return key
]]

---Creates a checkbox element: Complex 0.4
---@param options table
---- @field text string
---- @field width integer
---- @field checked boolean
---- @field disabled boolean
---- @field style table styles
--- ```lua
--- style = {
---     fontPath = "MOD/ui/TGUI_resources/Fonts/TAHOMA.TTF",
---     fontSize = 13,
---     textcolornormal = {r=c255(255),g=c255(255),b=c255(255),a=1},
---     textcolordisabled = {r=c255(255),g=c255(255),b=c255(255),a=1},
--- }
--- ```
---- @field func function
---@return table {width=integer, height=integer}
function TGUI:createCheckbox(options)
    -- text, key, hitWidth, beDisabled, toolTipText, style
    local text = options.text or ""
    local hitWidth = options.hitWidth or maintheme.checkbox.hitWidth
    local toolTipText = options.toolTipText or ""
    local isDisabled = options.disabled or false
    local style = options.style or {
        fontPath = maintheme.text.font,
        fontSize = maintheme.text.fontsize,
        enabled = maintheme.checkbox.enabledColor,
        disabled = maintheme.checkbox.disabledColor,
        hover = maintheme.checkbox.hoverColor,
        active = maintheme.checkbox.activeColor,
    }
    local key = options.key or nil
    if key == nil then
        error("Key cannot be nil", 0)
    end

    if #text == 0 then
        error("Text cannot be empty", 0)
    end

    UiPush()
        UiWindow(0,12,false	)
        UiAlign('left top')
        UiFont(maintheme.text.font , 13)
        UiButtonImageBox('',1,1,1,1,1,1)
        UiImageBox(tgui_ui_assets.."/textures/outline_inner_special_checkbox.png",12, 12,1,1,1,1)
        UiButtonImageBox(' ',0,0,0,0,0,0)
        local tx_s_w,no_v_h = UiGetTextSize(text)
        -- check if the text is bigger than the hitbox
        if tx_s_w > hitWidth then
            hitWidth = tx_s_w
        end
        UiPush()
            UiColor(1,1,1,1)
            UiTranslate(-6,-4)
            if uic_debug_show_hitboxes_checkbox then
                UiColor(1,1,1,0.2)
                UiRect(6 + no_v_h + hitWidth,20)
                UiColor(1,1,1,1)
            end
            if not beDisabled then 
                if UiBlankButton(6 + no_v_h + hitWidth,20) then
                    if type(key) == "string" then
                        SetBool(key,not GetBool(key))
                    end
                    if type(key) == "boolean" then
                        if key then
                            return false
                        else
                            return true
                        end
                    end
                end
            end
        UiPop()
        if type(key) == "string" then
            if GetBool(key) then
                UiImage(tgui_ui_assets..'/textures/checkmark.png')
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
                UiImage(tgui_ui_assets..'/textures/checkmark.png')
            else
                UiTranslate(-6,-4)
                if UiIsMouseInRect(6 + no_v_h + hitWidth,20) then
                    UiColor(style.hoverColor.r,style.hoverColor.g,style.hoverColor.b,1)
                end
                UiTranslate(6,4)
            end
        end
        UiAlign('left middle')
        UiTranslate(12,5)
        UiDisableInput()
        if beDisabled then
            UiColor(style.disabledColor.r, style.disabledColor.g, style.disabledColor.b, style.disabledColor.a)
        end
        TGUI:createText({
            text = text,
            height = 24
        })
        if( beDisabled ) then
            UiPush()
                UiColor(c255(style.disabledColorShadow.r), c255(style.disabledColorShadow.g), c255(style.disabledColorShadow.b), style.disabledColorShadow.a)
                UiTranslate(1,1)
                TGUI:createText({
                    text = text,
                    height = 24
                })        
            UiPop()
        end
    UiPop()
    if type(key) == "boolean" then
        return key
    end


    -- return {width=width, height=style.fontSize}
end







---Creates a new lib
---@param options table
---- @field theme string
---@return table
function NewTGUIuiLibrary(options)
    local theme = options.theme or "default"

--- THEME CONVERTER --------------------------------

  --TODO: Get the thene from the registry and convert it to the maintheme table.

--- MAIN THEME -------------------------------------
    if (theme == "default") then 
        maintheme = { 
            text = {
                height = 15,
                fontsize = 13,
                font = tgui_ui_assets.."/Fonts/TAHOMA.TTF",
            },
            button = {
                color = {r=c255(255),g=c255(255),b=c255(255),a=1},
                bg = {r=c255(0),g=c255(0),b=c255(0),a=1},
                height = 24,
                width = 100,
                border = 0,
            },
            slider = {
                width = 17,
            },
            checkbox = {
                hitwidth =      64,
                enabledColor =  {r=255,g=255,b=255,a=1},
                disabledColor = {r=0.5,g=0.5,b=0.5,a=1},
                disabledColorShadow = {r=60,g=60,b=60,a=0.4},
                hoverColor =    {r=0.95,g=0.95,b=0.95,a=1},
                activeColor =   {r=255,g=255,b=255,a=1},
            },
        };
    end

    return TGUI;
end