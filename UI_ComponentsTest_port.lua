-- lastMouse = { x = 0, y = 0 }
-- lastClick = { x = 0, y = 0 }
-- lastClickWindow = 0

-- isFirstFrame = true

-- deleteTimer = 0

-- function DesktopInit(stateName) -- 'stateName' is the input from the tag "state". This is only run on the first run of the draw() function, so you can use UI commands like UiHeight()
--     activeIcons = 
--     {
--     }

--     for i, I in pairs(activeIcons) do
--         activeIcons[i].windowCount = 0
--     end
    
--     activeWindows = 
--     { 
        
--     }
-- end


-- local pos = {}

-- function draw( ... )
--     UiDisableInput()
--     UiMakeInteractive()

--     if (isFirstFrame) then
--         isFirstFrame = false
    
--     end
    
--     local mouse = { x = 0, y = 0 }
--     mouse.x, mouse.y = UiGetMousePos()
--     DebugWatch('mouse x/y',mouse.x.." / "..mouse.y)
--     DebugWatch('lastMouse x/y',lastMouse.x.." / "..lastMouse.y)
--     DebugWatch('lastClick x/y',lastClick.x.." / "..lastClick.y)
--     lastMouse = mouse
-- end

-- -- -- -- -- -- -- -- -- -- -- -- TESTUBG UI -- -- -- -- -- -- -- -- --



--[[
                                                                 
                            █▀▄ █▀▀ █▀ █▄▀ ▀█▀ █▀█ █▀█  █▀ █▀▀ █▀█ █▀▀ █▀▀ █▄ █   █   █ █ ▄▀█
                            █▄▀ ██▄ ▄█ █ █  █  █▄█ █▀▀  ▄█ █▄▄ █▀▄ ██▄ ██▄ █ ▀█ ▄ █▄▄ █▄█ █▀█
                                                                                By MrJaydanOz

This script is used to render a desktop on any screen it is placed in
Any parameters are inputted via the screen's tags
Warning: you need a seperate script to interact with this screen. There already is one in the example scene "MOD/scripts/InteractWithScreen.lua"

Supported Parameters:

- "background"
- "overlay"
- "state"
- "loginBackground"
- "userIcon"
- "username"
- "password"

Required Sprites (all after spriteBasePath):
- "background" .. backgroundIndex .. ".jpg"
- "overlay" .. overlayIndex .. ".png"
- "background" .. loginBackgroundIndex .. ".jpg"
- "profile" .. userIconIndex .. ".png"
- "screenSaver.png"
- "windowExitIcon.png"
- "windowFullscreenIcon.png"
- "windowWindowedIcon.png"
- "windowMinimiseIcon.png"
- "loading.png"
- "taskbarScreenSaverIcon.png"
- "iconLarge_???.png" (75px x 75px)
- "iconSmall_???.png" (14px x 14px)

The main functions you want to edit are all above the area marked "YOUR CODE SHOULD GO ABOVE HERE"

'activeWindows' is a table containing windows at number indexes
Note: Only 'memory' should be written to unless you know what your doing
more about windows at InstantiateWindowFromIcon()

You can use commands like UIWidth() and UiGetMousePos() to get the properties in the content of the window

'windowIndex'     = is the index of this window in 'activeWindows'.
'isUsingComputer' = is whether the player is interacting with this screen. This would be used in the context "if (InputPressed("lmb") and isUsingComputer)".
                    Note: for realistic looking displays, dont use this to draw UI
'allowMouseInput' = is whether the window isnt covered be something at the mouse position. This would be used in the context "DrawButton(w, h, allowMouseInput)".
'isFocused'       = is whether the window is the one that has last been interacted with. Note: at most one window is focused and none will be if the player 
                    clicks on something that's not a window. This would be used in the context "if (not isFocused) then PauseMiniGame() end".
]]
function DoWindowContent(windowIndex, isUsingComputer, allowMouseInput, isFocused) -- Draw and do input for the contents of the window (not including the tab or the borders)
    local window = activeWindows[windowIndex]
    local windowType = window.type -- variable setup

    if (windowType == 1) then -- Text Reader
        UiColor(1, 1, 1, 1)
        UiRect(UiWidth(), UiHeight())

        if (isFocused and isUsingComputer) then -- adjust font size with keyboard input
            if (InputPressed("shift") and window.memory.fontSize < 150) then
                window.memory.fontSize = (window.memory.fontSize * 1.25) + 1
            elseif (InputPressed("ctrl") and window.memory.fontSize > 6) then
                window.memory.fontSize = (window.memory.fontSize - 1) / 1.25
            end
        end

        UiPush()
            UiFont("bold.ttf", 100) -- draw text
            UiScale(window.memory.fontSize / 100, window.memory.fontSize / 100)
            UiWordWrap(UiWidth() / (window.memory.fontSize / 100))
            UiAlign("top left")
            UiColor(0.05, 0.05, 0.05, 1)
            UiText(window.memory.text)
        UiPop()

        UiPush() -- draw help comment
            UiTranslate(UiWidth(), UiHeight())
            UiFont("bold.ttf", 14)
            UiAlign("right bottom")
            UiColor(0, 0, 0, 0.5)
            UiText("'Shift' and 'Ctrl' to Zoom")
        UiPop()
    elseif (windowType == 2) then -- Super Buttoning Buttoner
        if (not window.memory.buttonAnim) then
            window.memory.buttonAnim = 1
        end
        if (not window.memory.buttonAnimVel) then
            window.memory.buttonAnimVel = 0
        end
        if (not window.memory.colour) then
            window.memory.colour = { 0.9, 0.2, 0.2, 1 }
        end
        if (not buttonGameClickSound) then
            buttonGameClickSound = LoadSound(spriteBasePath .. "ButtonGame/click.ogg")
        end
        if (not buttonGameClickCount) then
            buttonGameClickCount = 99769
        end
        if (not buttonGameClickHighCount) then
            buttonGameClickHighCount = 101627
        end

        UiPush()
            UiColour(window.memory.colour)
            UiRect(UiWidth(), UiHeight())
        UiPop()

        window.memory.buttonAnim = window.memory.buttonAnim + (window.memory.buttonAnimVel * GetTimeStep())
        window.memory.buttonAnimVel = (window.memory.buttonAnimVel + ((1 - window.memory.buttonAnim) * GetTimeStep() * 1000)) * 0.75

        UiPush()
            UiTranslate(UiWidth() / 2, UiHeight() / 2)
            UiAlign("center middle")
            local imgSizeX, imgSizeY = UiGetImageSize(spriteBasePath .. "ButtonGame/button.png")
            local scaler = min(UiHeight() / imgSizeY, UiWidth() / imgSizeX) * 0.75
            UiScale(scaler * window.memory.buttonAnim, scaler / window.memory.buttonAnim)
            if (isUsingComputer and ((allowMouseInput and InputPressed("lmb") and UiIsMouseInRect(imgSizeX, imgSizeY)) or (InputPressed("any") and not InputPressed("lmb") and not InputPressed("e") and not InputPressed("escape")))) then
                window.memory.buttonAnimVel = window.memory.buttonAnimVel + (math.random(50, 100) / 100) * 10

                local shiftStrength = 0.2
                window.memory.colour = { lerp(window.memory.colour[1], math.random(0, 100) / 100, shiftStrength), lerp(window.memory.colour[2], math.random(0, 100) / 100, shiftStrength), lerp(window.memory.colour[3], math.random(0, 100) / 100, shiftStrength), 1 }
                buttonGameClickCount = buttonGameClickCount + 1
                buttonGameClickHighCount = max(buttonGameClickHighCount, buttonGameClickCount)
                PlaySound(buttonGameClickSound, GetShapeWorldTransform(GetScreenShape(UiGetScreen())).pos, 1)
            end
            if (isUsingComputer and ((allowMouseInput and InputDown("lmb") and UiIsMouseInRect(imgSizeX, imgSizeY)) or (InputDown("any") and not InputDown("lmb") and not InputDown("e") and not InputDown("escape")))) then
                UiColor(0.8, 0.8, 0.8, 1)
            end
            UiImage(spriteBasePath .. "ButtonGame/button.png")
        UiPop()
        UiPush()
            UiTranslate(UiWidth() / 2, UiHeight() - 25)
            UiFont("bold.ttf", 20)
            UiAlign("center")
            UiText(buttonGameClickCount .. " button presses")
            UiText("\nWorld record:" .. buttonGameClickHighCount)
        UiPop()
    end

    activeWindows[windowIndex] = window
end

--[[
Icon Parameters: [All Required]
    pos (Vec2D)
    windowType (Int)
    windowCount (Int) { = 0 }
    windowSettings (Table) { openSize (Vec2D) }
    iconSettings (Table) { canOpenMultiple (Boolean) }
    data (Table) { }
]]
function DesktopInit(stateName) -- 'stateName' is the input from the tag "state". This is only run on the first run of the draw() function, so you can use UI commands like UiHeight()
    activeIcons = 
    {
        {
            pos = ToIconPos(0),
            windowType = 1,
            windowSettings = { openSize = NewVec2D(600, 400) },
            iconSettings = { canOpenMultiple = true },
            data = { name = "HowToUse", text = 
            "This is a window, I'm sure you've used a desktop before since your using one now.\n" ..
            "There are three buttons in the top right corner;\n" ..
            "- The line minimises the window which means it hides it, the window can be shown again by clicking on its icon on the bar below\n" ..
            "- The square toggles the window being fullscreen or not\n" ..
            "- The cross closes the window and kind of deletes it, for this window you can click on the icon you used already to open more\n" ..
            "\n" ..
            "The moon icon in the bottom left corner puts the screen into screensaver mode (you've already seen what that looks like)\n" ..
            "\n" ..
            "The script MOD/scripts/DesktopScreen.lua has some more explainations on what to do to make your own apps", fontSize = 20 }
        }
    }

        table.insert(activeIcons, {
            pos = ToIconPos(1),
            windowType = 1,
            windowSettings = { openSize = NewVec2D(600, 400) },
            iconSettings = { canOpenMultiple = true },
            data = { name = "Life goals", text = "subscribers", fontSize = 20 }
        })
        table.insert(activeIcons, {
            pos = ToIconPos(1, 0),
            windowType = 2,
            windowSettings = { openSize = NewVec2D(800, 600) },
            iconSettings = { canOpenMultiple = false },
            data = { }
        })


    for i, I in pairs(activeIcons) do
        activeIcons[i].windowCount = 0
    end
    
    activeWindows = 
    { 
        
    }
end

windowFocusedBorderColour = { 1, 1, 1, 1 }
windowUnfocusedBorderColour = { 0.6, 0.6, 0.6, 1 }
windowBorderThickness = 1

windowFocusedTabColour = { 1, 1, 1, 1 }
windowUnfocusedTabColour = { 0.8, 0.8, 0.8, 1 }
windowTabHeight = 16
windowCornerButtonWidth = 30

windowFocusedBackgroundColour = { 1, 1, 1, 1 }
windowUnfocusedBackgroundColour = { 1, 1, 1, 1 }

resizeGrabDistance = 6

windowMinWidth = 100
windowMinHeight = 100 + windowTabHeight

taskbarHeight = 30
taskbarColour = { 0.25, 0.25, 0.25, 0.5 }
taskbarIconWidth = 40

spriteBasePath = "MOD/sprites/Desktop/"

screenSaverTime = 120
screenSaverIcon = spriteBasePath .. "screenSaver.png"
windowExitIcon = spriteBasePath .. "windowExitIcon.png"
windowFullscreenIcon = spriteBasePath .. "windowFullscreenIcon.png"
windowWindowedIcon = spriteBasePath .. "windowWindowedIcon.png"
windowMinimiseIcon = spriteBasePath .. "windowMinimiseIcon.png"
loadingIcon = spriteBasePath .. "loading.png"
taskbarScreenSaverIcon = spriteBasePath .. "taskbarScreenSaverIcon.png"

hightlightColour = { 0.5, 0.75, 1, 0.4 }

--[[
Window Data Parameters: [All Required]
    pos (Vec2D)
    size (Vec2D)
    type (Int) { >= 1 } 
    openedByIcon (Int)
    taskBarIcon (Table) { pos = (Number) }
    animation (Table) { openFrom (Vec2D), timeSinceOpen (Number), closeAnim (Number) { = 0 }, fullscreenAnim (Number) { = 0 }, minimiseAnim (Number) { = 0 } }
    windowSettings (Table) { fullscreen (Boolean), minimised (Boolean) { = false }, 
                             [Optional: borderColour (Colour), unfocusedBorderColour (Colour), borderThickness (Int), tabColour (Colour), unfocusedTabColour (Colour),
                                        tabHeight (Int), cornerButtonWidth (Int), backgroundColour (Colour), unfocusedBackgroundColour (Colour), minWidth (Int), 
                                        minHeight (Int), doClipping (Boolean), resizable (Boolean), canMinimise (Boolean), canFullscreenToggle (Boolean)] }
    stats (Table) { timeSinceStart (Number) }
    memory (Table) { }
    
]]
function InstantiateWindowFromIcon(IconIndex) -- returns new window (Table)
    activeIcons[IconIndex].windowCount = activeIcons[IconIndex].windowCount + 1 -- count up window count, used for restricting opening if one is already open
    local icon = activeIcons[IconIndex] -- variable setup
    local openSize = icon.windowSettings.openSize
    local tempWind = -- this is all you'd realy want to be changing
    { 
        pos = RandomWindowPos(openSize.x, openSize.y), 
        size = NewVec2D(openSize.x, openSize.y), 
        type = icon.windowType,
        animation = { openFrom = icon.pos, timeSinceOpen = 0, closeAnim = 0, fullscreenAnim = 0, minimiseAnim = 0 }, 
        windowSettings = table.shallowCopy(icon.windowSettings), 
        stats = { timeSinceStart = 0 },
        memory = table.shallowCopy(icon.data)
    }
    tempWind.windowSettings.openSize = nil
    tempWind.windowSettings.minimised = false
    if (not tempWind.windowSettings.fullScreen) then
        tempWind.windowSettings.fullScreen = false
    end
    tempWind.openedByIcon = IconIndex
    tempWind.taskBarIcon = { pos = UiWidth() } -- spawns icon moving in from the right
    return tempWind
end

function GetWindowNameAndIcon(windowIndex) -- returns name (string), iconPath (string)
    local windowData = activeWindows[windowIndex]
    local windowType = windowData.type
    local windowMemory = windowData.memory

    if (windowType == 1) then
        return windowMemory.name .. " - Text Reader", spriteBasePath .. "iconSmall_TextFile.png"
    elseif (windowType == 2) then
        return "Super Buttoning Buttoner", spriteBasePath .. "ButtonGame/iconSmall_ButtonGame.png"
    else
        return "", spriteBasePath .. "iconSmall_File.png"
    end
end

function GetIconNameAndIcon(iconIndex) -- returns name (string), iconPath (string)
    local iconData = activeIcons[iconIndex]
    local iconType = iconData.windowType
    local iconMemory = iconData.data

    if (iconType == 1) then
        return iconMemory.name .. ".txt", spriteBasePath .. "iconLarge_TextFile.png"
    elseif (iconType == 2) then
        return "Super Buttoning Buttoner", spriteBasePath .. "ButtonGame/iconLarge_ButtonGame.png"
    else
        return "Unnamed", spriteBasePath .. "iconLarge_File.png"
    end
end

--[[
Type Clarification:
    Vec2D: { x = 0, y = 0 } or NewVec2D(0, 0) Note: this is not the vector Teardown uses. Dont use Vec() or things like VecAdd()
    Colour: { r, g, b, a }, colour = { 1, 0, 0, 1 } -> UiColour(colour) = UiColor(1, 0, 0, 1)
    Boolean: A value that is either 'true' or 'false', this is used for if statements
    Int: An integer, a number that is rounded or has no decimal point (or at least it should)
]]

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------[ YOUR CODE SHOULD GO ABOVE HERE ]--------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Below here gets pretty advanced, all you need is above this

screenSaverTimer = -1 - (math.random(0, 50) / 100)
screenSaverPos = { x = 0, y = 0 }
screenSaverVel = { x = 60, y = 40 }
screenSaverDrawPos = { x = 0, y = 0 }

lastMouse = { x = 0, y = 0 }
lastClick = { x = 0, y = 0 }
lastClickWindow = 0

isFirstFrame = true

writtenPassword = ""
wrongPasswordTimer = 0
deleteTimer = 0

goBackToScreen = false

function draw(dt) 
    UiDisableInput()
    UiMakeInteractive()

    local screen = UiGetScreen()
    if (isFirstFrame) then
        thisScreen = screen
        backgroundIndex = aboutNumber(GetTagValue(screen, "background"), 1)
        backgroundSprite = spriteBasePath .. "background" .. backgroundIndex .. ".jpg"
        overlayIndex = aboutNumber(GetTagValue(screen, "overlay"), 0)
        overlaySprite = spriteBasePath .. "overlay" .. overlayIndex .. ".png"
        desktopStartState = GetTagValue(screen, "state")
        
        local iconSizeX, iconSizeY = UiGetImageSize(screenSaverIcon)
        screenSaverPos.x = math.random(0, UiWidth() - iconSizeX)
        screenSaverPos.y = math.random(0, UiHeight() - iconSizeY)
        screenSaverVel.x = math.random(-1, 1) < 0 and -screenSaverVel.x or screenSaverVel.x
        screenSaverVel.y = math.random(-1, 1) < 0 and -screenSaverVel.y or screenSaverVel.y
        screenSaverDrawPos = { x = screenSaverPos.x, y = screenSaverPos.y } 
        
        loginBackgroundIndex = aboutNumber(GetTagValue(screen, "loginBackground"), 1)
        loginBackgroundSprite = spriteBasePath .. "background" .. loginBackgroundIndex .. ".jpg"
        userIconIndex = aboutNumber(GetTagValue(screen, "userIcon"), 1)
        userIconSprite = spriteBasePath .. "profile" .. userIconIndex .. ".png"
        username = HasTag(screen, "username") and GetTagValue(screen, "username") or "User"
        username = username:gsub("%_", " ")
        password = ""
        isLoggedIn = password == ""
        loginLoadingAnim = isLoggedIn and 1 or 0

        DesktopInit()

        isFirstFrame = false
    end

    if (screenSaverTimer >= 0 and not isLoggedIn and InputPressed("e")) then
        goBackToScreen = true -- Allows the 'e' key to be used without exiting when writing the password
    end

    local isUsing = GetPlayerScreen() == screen
    local mouse = { x = 0, y = 0 }
    mouse.x, mouse.y = UiGetMousePos()
    deltaMouse = { x = mouse.x - lastMouse.x, y = mouse.y - lastMouse.y }
    local mouseMoved = deltaMouse.x ~= 0 or deltaMouse.y ~= 0

    if (isUsing and (mouseMoved or (InputPressed("any") and not InputPressed("e") and not InputPressed("escape")))) then
        screenSaverTimer = 0
    end
    
    if (goBackToScreen and not isUsing) then
        SetPlayerScreen(thisScreen)
        isUsing = true
        goBackToScreen = false
    end
    
    if (screenSaverTimer >= 0) then
        UiPush()
            UiPush()
                local bgx, bgy = UiGetImageSize(backgroundSprite)
                local bgAspectRatio = bgx / bgy
                local screenAspectRatio = UiWidth() / UiHeight()
        
                local scale
                if (bgAspectRatio > screenAspectRatio) then
                    scale = UiHeight() / bgy
                else
                    scale = UiWidth() / bgx
                end
                UiTranslate(UiWidth() / 2, UiHeight() / 2)
                UiScale(scale, scale)
                UiAlign("center middle")
                UiImage(backgroundSprite)
            UiPop()
            
            UiWindow(UiWidth(), UiHeight() - taskbarHeight)
        
            local mouseOverWindow = 0
            for i, I in pairs(activeIcons) do
                UiPush()
                    UiTranslate(I.pos.x, I.pos.y)
                    UiAlign("center middle")
                    local isOnIcon = UiIsMouseInRect(80, 95)
                    if (isOnIcon) then
                        mouseOverWindow = -i
                    end
                UiPop()
            end
            
            local windowCount = 0
            for i, w in pairs(activeWindows) do
                windowCount = windowCount + 1
                activeWindows[i].animation.timeSinceOpen = activeWindows[i].animation.timeSinceOpen + dt
                activeWindows[i].stats.timeSinceStart = activeWindows[i].stats.timeSinceStart + dt
                activeWindows[i].animation.fullscreenAnim = clamp01(activeWindows[i].animation.fullscreenAnim + 4 * (activeWindows[i].windowSettings.fullscreen and dt or -dt))
                activeWindows[i].animation.minimiseAnim = clamp01(activeWindows[i].animation.minimiseAnim + 2 * (activeWindows[i].windowSettings.minimised and dt or -dt))
                if (activeWindows[i].animation.closeAnim > 0) then
                    activeWindows[i].animation.closeAnim = activeWindows[i].animation.closeAnim + GetTimeStep()
                end

                UiPush()
                    local borderThickness = windowBorderThickness
                    if (activeWindows[i].windowSettings.borderThickness) then
                        borderThickness = activeWindows[i].windowSettings.borderThickness
                    end
                    local borderThickness2 = borderThickness

                    local visualPos = slerpVec2D(slerpVec2D(activeWindows[i].pos, NewVec2D(-borderThickness2, -borderThickness2), activeWindows[i].animation.fullscreenAnim), activeWindows[i].animation.openFrom, max(1 - (activeWindows[i].animation.timeSinceOpen * 2), activeWindows[i].animation.minimiseAnim))
                    local visualSize = slerpVec2D(activeWindows[i].size, NewVec2D(UiWidth() + borderThickness2, UiHeight() + borderThickness2), activeWindows[i].animation.fullscreenAnim)

                    UiTranslate(visualPos.x + borderThickness - resizeGrabDistance, visualPos.y + borderThickness - resizeGrabDistance)
                    local isInWindow = UiIsMouseInRect(visualSize.x + ( 2 * (resizeGrabDistance - borderThickness)), visualSize.y + ( 2 * (resizeGrabDistance - borderThickness)))
                    UiTranslate(deltaMouse.x, deltaMouse.y)
                    isInWindow = isInWindow or UiIsMouseInRect(visualSize.x + ( 2 * (resizeGrabDistance - borderThickness)), visualSize.y + ( 2 * (resizeGrabDistance - borderThickness)))
                    if (isInWindow) then
                        mouseOverWindow = i
                    end
                UiPop()
            end

            if (isUsing and InputPressed("lmb")) then
                lastClickWindow = mouseOverWindow
                if (mouseOverWindow > 0 and mouseOverWindow ~= windowCount and windowCount > 1) then
                    local swapWindowData = activeWindows[mouseOverWindow]
                    table.remove(activeWindows, mouseOverWindow)
                    table.insert(activeWindows, swapWindowData)
                    lastClickWindow = windowCount
                end
                lastClick = NewVec2D(mouse.x, mouse.y)
            end

            for i, I in pairs(activeIcons) do
                DoIcon(I, i, isUsing, i == -mouseOverWindow)
            end

            for i, w in pairs(activeWindows) do
                DoWindow(w, i, isUsing, i == mouseOverWindow, i == lastClickWindow)
            end
        UiPop()
        UiPush() -- Taskbar
            UiTranslate(0, UiHeight() - taskbarHeight)
            UiColour(taskbarColour)
            UiRect(UiWidth(), taskbarHeight)
            
            ColouredButtonWithCenteredImage(taskbarHeight, taskbarHeight, { 0, 0, 0, 0 }, { 1, 1, 1, 0.2 }, { 0.7, 0.7, 0.7, 0.2 }, taskbarScreenSaverIcon, { 1, 1, 1, 1 }, { 1, 1, 1, 1 }, { 0.7, 0.7, 0.7, 1 }, true)
            if (isUsing and InputPressed("lmb") and UiIsMouseInRect(taskbarHeight, taskbarHeight)) then
                screenSaverTimer = -1
            end

            UiTranslate(taskbarHeight, 0)
            for i, w in pairs(activeWindows) do
                UiPush()
                    local name, icon = GetWindowNameAndIcon(i)
                    activeWindows[i].taskBarIcon.pos = lerp(activeWindows[i].taskBarIcon.pos, (i - 1) * taskbarIconWidth, 0.2)
                    UiTranslate(activeWindows[i].taskBarIcon.pos, slerp(0, taskbarHeight * 5, activeWindows[i].animation.closeAnim))
                    ColouredButtonWithCenteredImage(taskbarIconWidth, taskbarHeight, i == lastClickWindow and { 1, 1, 1, 0.1 } or (i == mouseOverWindow and { 1, 1, 1, 0.05 } or { 0, 0, 0, 0 }), { 1, 1, 1, 0.2 }, { 0.7, 0.7, 0.7, 0.2 }, 
                                                    icon, activeWindows[i].windowSettings.minimised and { 0.8, 0.8, 0.8, 1 } or { 1, 1, 1, 1 }, activeWindows[i].windowSettings.minimised and { 0.8, 0.8, 0.8, 1 } or { 1, 1, 1, 1 }, { 0.7, 0.7, 0.7, 1 }, true)
                    
                    if (UiIsMouseInRect(taskbarIconWidth, taskbarHeight)) then
                        UiTranslate(taskbarIconWidth / 2, -5)
                        UiColor(1, 1, 1, 1)
                        UiTextShadow(0, 0, 0, 0.3, 1, 0.5)
                        UiTextOutline(0, 0, 0, 0.15, 0.1)
                        UiFont("bold.ttf", 10)
                        UiAlign("center")
                        UiText(name)
                        if (isUsing and InputPressed("lmb")) then
                            if (windowCount > 1) then
                                local swapWindowData = activeWindows[i]
                                table.remove(activeWindows, i)
                                table.insert(activeWindows, swapWindowData)
                                lastClickWindow = windowCount
                            end
                            activeWindows[windowCount].windowSettings.minimised = false
                        end
                    end
                    if (activeWindows[windowCount]) then
                        if (activeWindows[windowCount].animation.timeSinceOpen > 0.5) then
                            activeWindows[windowCount].animation.openFrom = NewVec2D(activeWindows[i].taskBarIcon.pos + (taskbarIconWidth / 2) + taskbarHeight, UiHeight() - (taskbarHeight / 2))
                        end
                    end
                UiPop()
            end
        UiPop()

        local screenSaverDarkTime = screenSaverTime * 0.6
        if (screenSaverTimer > screenSaverDarkTime) then
            UiPush()
                UiColor(0, 0, 0, min(1, screenSaverTimer - screenSaverDarkTime) * 0.5)
                UiRect(UiWidth(), UiHeight())
            UiPop()
        end
        
        local removeIndex = 0
        for i, w in pairs(activeWindows) do
            if (w.animation.closeAnim > 0.25) then
                removeIndex = i
            end
        end
        if (removeIndex > 0) then
            if (activeWindows[removeIndex].openedByIcon > 0) then
                activeIcons[activeWindows[removeIndex].openedByIcon].windowCount = activeIcons[activeWindows[removeIndex].openedByIcon].windowCount - 1
            end
            table.remove(activeWindows, removeIndex)
            lastClickWindow = 0
        end

        screenSaverTimer = screenSaverTimer + dt
        if (screenSaverTimer > screenSaverTime) then
            screenSaverTimer = -1
        end
    else
        local iconSizeX, iconSizeY = UiGetImageSize(screenSaverIcon)

        screenSaverTimer = screenSaverTimer - dt
        screenSaverPos.x = screenSaverPos.x + (screenSaverVel.x * dt)
        screenSaverPos.y = screenSaverPos.y + (screenSaverVel.y * dt)

        if (screenSaverPos.x <= 0) then
            screenSaverVel.x = abs(screenSaverVel.x)
            screenSaverPos.x = 0
        end
        if (screenSaverPos.x >= UiWidth() - iconSizeX) then
            screenSaverVel.x = -abs(screenSaverVel.x)
            screenSaverPos.x = UiWidth() - iconSizeX
        end
        
        if (screenSaverPos.y <= 0) then
            screenSaverVel.y = abs(screenSaverVel.y)
            screenSaverPos.y = 0
        end
        if (screenSaverPos.y >= UiHeight() - iconSizeY) then
            screenSaverVel.y = -abs(screenSaverVel.y)
            screenSaverPos.y = UiHeight() - iconSizeY
        end
        
        if (screenSaverTimer < -1.5) then
            screenSaverTimer = screenSaverTimer + 0.5
            screenSaverDrawPos = { x = screenSaverPos.x, y = screenSaverPos.y } 
        end
        UiPush()
            UiTranslate(screenSaverDrawPos.x, screenSaverDrawPos.y)
            UiImage(screenSaverIcon)
        UiPop()
    end
    
    if (overlayIndex > 0) then
        UiPush()
            local olx, oly = UiGetImageSize(overlaySprite)
            local olAspectRatio = olx / oly
            local screenAspectRatio = UiWidth() / UiHeight()

            local scale
            if (olAspectRatio > screenAspectRatio) then
                scale = UiHeight() / oly
            else
                scale = UiWidth() / olx
            end
            UiScale(scale, scale)
            UiImage(overlaySprite)
        UiPop()
    end

    lastMouse = mouse
end

function DoWindow(windowData, windowIndex, isUsingComputer, allowMouseInput, isFocused) -- Do the function of a window like drawing, primary input, and DoWindowContent()
    if (windowData.animation.minimiseAnim >= 1) then
        return
    end

    local focusedBorderColour = windowFocusedBorderColour
    local unfocusedBorderColour = windowUnfocusedBorderColour
    local borderThickness = windowBorderThickness
    
    if (windowData.windowSettings.borderColour) then
        focusedBorderColour = windowData.windowSettings.borderColour
        unfocusedBorderColour = windowData.windowSettings.borderColour
    end
    if (windowData.windowSettings.unfocusedBorderColour) then
        unfocusedBorderColour = windowData.windowSettings.unfocusedBorderColour
    end
    if (windowData.windowSettings.borderThickness) then
        borderThickness = windowData.windowSettings.borderThickness
    end
    
    local borderColour = isFocused and focusedBorderColour or unfocusedBorderColour
    local borderThickness2 = borderThickness * 2

    local focusedTabColour = windowFocusedTabColour
    local unfocusedTabColour = windowUnfocusedTabColour
    local tabHeight = windowTabHeight
    local cornerButtonWidth = windowCornerButtonWidth
    
    if (windowData.windowSettings.tabColour) then
        focusedTabColour = windowData.windowSettings.tabColour
        unfocusedTabColour = windowData.windowSettings.tabColour
    end
    if (windowData.windowSettings.unfocusedTabColour) then
        unfocusedTabColour = windowData.windowSettings.unfocusedTabColour
    end
    if (windowData.windowSettings.tabHeight) then
        tabHeight = windowData.windowSettings.tabHeight
    end
    if (windowData.windowSettings.cornerButtonWidth) then
        cornerButtonWidth = windowData.windowSettings.cornerButtonWidth
    end

    local tabColour = isFocused and focusedTabColour or unfocusedTabColour

    local focusedBackgroundColour = windowFocusedBackgroundColour
    local unfocusedBackgroundColour = windowUnfocusedBackgroundColour
    
    if (windowData.windowSettings.backgroundColour) then
        focusedBackgroundColour = windowData.windowSettings.backgroundColour
        unfocusedBackgroundColour = windowData.windowSettings.backgroundColour
    end
    if (windowData.windowSettings.unfocusedBackgroundColour) then
        unfocusedBackgroundColour = windowData.windowSettings.unfocusedBackgroundColour
    end

    local backgroundColour = isFocused and focusedBackgroundColour or unfocusedBackgroundColour

    local minWidth = windowMinWidth
    local minHeight = windowMinHeight

    if (windowData.windowSettings.minWidth) then
        minWidth = windowData.windowSettings.minWidth
    end
    if (windowData.windowSettings.minHeight) then
        minHeight = windowData.windowSettings.minHeight
    end

    local doClipping = true
    if (windowData.windowSettings.doClipping) then
        doClipping = windowData.windowSettings.doClipping
    end

    local resizeGrabDistance2 = resizeGrabDistance * 2

    local resizable = true
    if (windowData.windowSettings.resizable) then
        resizable = windowData.windowSettings.resizable
    end
    local canMinimise = true
    if (windowData.windowSettings.canMinimise) then
        canMinimise = windowData.windowSettings.canMinimise
    end
    local canFullscreenToggle = true
    if (windowData.windowSettings.canFullscreenToggle) then
        canFullscreenToggle = windowData.windowSettings.canFullscreenToggle
    end

    UiPush()
        local visualPos = slerpVec2D(slerpVec2D(windowData.pos, NewVec2D(-borderThickness2, -borderThickness2), windowData.animation.fullscreenAnim), windowData.animation.openFrom, max(1 - (windowData.animation.timeSinceOpen * 2), windowData.animation.minimiseAnim))
        local visualSize = slerpVec2D(windowData.size, NewVec2D(UiWidth() + borderThickness2, UiHeight() + borderThickness2), windowData.animation.fullscreenAnim)

        UiPush() -- Tab drag detection
            UiTranslate(visualPos.x + borderThickness + deltaMouse.x, visualPos.y + borderThickness + deltaMouse.y)
            local mouseOnTab = UiIsMouseInRect(visualSize.x - borderThickness2 - (windowCornerButtonWidth * 3), tabHeight)
        UiPop()

        local doGrabTab = allowMouseInput and mouseOnTab and InputDown("lmb") and isUsingComputer and windowData.animation.fullscreenAnim == 0

        local resizeTop = false
        local resizeLeft = false
        local resizeBottom = false
        local resizeRight = false

        if (doGrabTab) then
            activeWindows[windowIndex].pos = Vec2DAdd(activeWindows[windowIndex].pos, deltaMouse)
            visualPos = slerpVec2D(slerpVec2D(windowData.pos, NewVec2D(-borderThickness2, -borderThickness2), windowData.animation.fullscreenAnim), windowData.animation.openFrom, max(1 - (windowData.animation.timeSinceOpen * 2), windowData.animation.minimiseAnim))
        else
            UiPush() -- Resize detection
                local couldResize = allowMouseInput and isUsingComputer and windowData.animation.fullscreenAnim == 0 and resizable
                UiTranslate(visualPos.x + borderThickness - resizeGrabDistance + deltaMouse.x, visualPos.y + borderThickness - resizeGrabDistance + deltaMouse.y)
                resizeTop = couldResize and UiIsMouseInRect(visualSize.x - borderThickness2 + resizeGrabDistance2, resizeGrabDistance)
                resizeLeft = couldResize and UiIsMouseInRect(resizeGrabDistance, visualSize.y - borderThickness2 + resizeGrabDistance2)
    
                UiAlign("right bottom")
            
                UiTranslate(visualSize.x - borderThickness2 + resizeGrabDistance2, visualSize.y - borderThickness2 + resizeGrabDistance2)
                resizeBottom = couldResize and UiIsMouseInRect(visualSize.x - borderThickness2 + resizeGrabDistance2, resizeGrabDistance)
                resizeRight = couldResize and UiIsMouseInRect(resizeGrabDistance, visualSize.y - borderThickness2 + resizeGrabDistance2)
            UiPop()
            
            if (resizeTop or resizeRight or resizeBottom or resizeLeft and InputDown("lmb")) then
                if (resizeTop and InputDown("lmb")) then
                    if (activeWindows[windowIndex].size.y - deltaMouse.y > minHeight) then
                        activeWindows[windowIndex].pos.y = activeWindows[windowIndex].pos.y + deltaMouse.y
                        activeWindows[windowIndex].size.y = activeWindows[windowIndex].size.y - deltaMouse.y
                    end
                end
                if (resizeRight and InputDown("lmb")) then
                    if (activeWindows[windowIndex].size.x + deltaMouse.x > minWidth) then
                        activeWindows[windowIndex].size.x = activeWindows[windowIndex].size.x + deltaMouse.x
                    end
                end
                if (resizeBottom and InputDown("lmb")) then
                    if (activeWindows[windowIndex].size.y + deltaMouse.y > minHeight) then
                        activeWindows[windowIndex].size.y = activeWindows[windowIndex].size.y + deltaMouse.y
                    end
                end
                if (resizeLeft and InputDown("lmb")) then
                    if (activeWindows[windowIndex].size.x - deltaMouse.x > minWidth) then
                        activeWindows[windowIndex].pos.x = activeWindows[windowIndex].pos.x + deltaMouse.x
                        activeWindows[windowIndex].size.x = activeWindows[windowIndex].size.x - deltaMouse.x
                    end
                end

                visualPos = slerpVec2D(slerpVec2D(windowData.pos, NewVec2D(-borderThickness2, -borderThickness2), windowData.animation.fullscreenAnim), windowData.animation.openFrom, max(1 - (windowData.animation.timeSinceOpen * 2), windowData.animation.minimiseAnim))
                visualSize = slerpVec2D(windowData.size, NewVec2D(UiWidth() + borderThickness2, UiHeight() + borderThickness2), windowData.animation.fullscreenAnim)
            end
        end
        
        UiTranslate(visualPos.x, visualPos.y)

        if (windowData.animation.closeAnim > 0 or windowData.animation.minimiseAnim > 0 or windowData.animation.timeSinceOpen < 1) then
            local slerpMinimise = slerp(1, 0, max(1 - (windowData.animation.timeSinceOpen * 2), windowData.animation.minimiseAnim))
            UiTranslate((visualSize.x / 2) * slerpMinimise, (visualSize.y / 2) * slerpMinimise)
            local scaler = ((-16 * sqr(windowData.animation.closeAnim)) + 1) * slerpMinimise
            UiScale(scaler, scaler)
            UiTranslate((visualSize.x / -2) * slerpMinimise, (visualSize.y / -2) * slerpMinimise)
        end

        local shadowCount = 5
        local shadowStrength = 0.4

        UiPush()
            UiTranslate(-1, -1)
            UiColor(0, 0, 0, 0.5 * shadowStrength)
            UiRect(visualSize.x, visualSize.y)
        UiPop()
        
        UiPush()
            UiTranslate(1, visualSize.y)
            for i = 1, shadowCount do
                UiColor(0, 0, 0, (1 - (i / shadowCount)) * shadowStrength)
                UiRect(visualSize.x, 1)
                UiTranslate(1, 1)
            end 
        UiPop()
        UiPush()
            UiTranslate(visualSize.x, 1)
            for i = 1, shadowCount do
                UiColor(0, 0, 0, (1 - (i / shadowCount)) * shadowStrength)
                UiRect(1, visualSize.y - 1)
                UiTranslate(1, 1)
            end 
        UiPop()

        UiPush()
            UiColour(borderColour)
            UIRectHollow(visualSize.x, visualSize.y, borderThickness)

            UiTranslate(borderThickness, borderThickness)
            UiColour(tabColour)
            UiRect(visualSize.x - borderThickness2, tabHeight)

            local canCornerButtons = allowMouseInput and isUsingComputer
            
            UiPush() -- Corner buttons
                UiTranslate(visualSize.x - borderThickness2 - cornerButtonWidth, 0)
                ColouredButtonWithCenteredImage(cornerButtonWidth, tabHeight, { 1, 1, 1, 0 }, { 1, 0, 0, 1 }, { 0.8, 0, 0, 1 }, windowExitIcon, { 0, 0, 0, 1 }, { 1, 1, 1, 1 }, { 0.8, 0.8, 0.8, 1 }, canCornerButtons)
                if (canCornerButtons and UiIsMouseInRect(cornerButtonWidth, tabHeight) and InputReleased("lmb")) then
                    CloseWindow(windowIndex)
                end
                if (canFullscreenToggle) then
                    UiTranslate(-cornerButtonWidth, 0)
                    ColouredButtonWithCenteredImage(cornerButtonWidth, tabHeight, { 1, 1, 1, 0 }, { 0, 0, 0, 0.3 }, { 0, 0, 0, 0.4 }, windowData.windowSettings.fullscreen and windowWindowedIcon or windowFullscreenIcon, { 0, 0, 0, 1 }, { 0, 0, 0, 1 }, { 0, 0, 0, 1 }, canCornerButtons)
                    if (canCornerButtons and UiIsMouseInRect(cornerButtonWidth, tabHeight) and InputReleased("lmb")) then
                        FullscreenToggleWindow(windowIndex)
                    end
                end
                if (canMinimise) then
                    UiTranslate(-cornerButtonWidth, 0)
                    ColouredButtonWithCenteredImage(cornerButtonWidth, tabHeight, { 1, 1, 1, 0 }, { 0, 0, 0, 0.3 }, { 0, 0, 0, 0.4 }, windowMinimiseIcon, { 0, 0, 0, 1 }, { 0, 0, 0, 1 }, { 0, 0, 0, 1 }, canCornerButtons)
                    if (canCornerButtons and UiIsMouseInRect(cornerButtonWidth, tabHeight) and InputReleased("lmb")) then
                        MinimiseWindow(windowIndex, true)
                    end
                end
            UiPop()
            UiPush() -- Window name and icon
                local name, icon = GetWindowNameAndIcon(windowIndex)
                local iconSizeX, iconSizeY = UiGetImageSize(icon)
                local padding = (tabHeight - iconSizeY) / 2
                UiWindow(visualSize.x - borderThickness2 - (windowCornerButtonWidth * 3), tabHeight, true)
                UiTranslate(padding, padding)
                UiColor(1, 1, 1, 1)
                UiImage(icon)
                UiTranslate(iconSizeX + padding, iconSizeY / 2)
                UiColor(0.1, 0.1, 0.1, 1)
                UiFont("bold.ttf", tabHeight)
                UiAlign("left middle")
                UiText(name)
            UiPop()
            

            UiTranslate(0, tabHeight)
            UiColour(backgroundColour)
            UiRect(visualSize.x - borderThickness2, visualSize.y - borderThickness2 - tabHeight)

            UiWindow(visualSize.x - borderThickness2, visualSize.y - borderThickness2 - tabHeight, doClipping)
            UiPush()
                UiColor(1, 1, 1, 1)
                DoWindowContent(windowIndex, isUsingComputer, allowMouseInput and UiIsMouseInRect(visualSize.x - borderThickness2, visualSize.y - borderThickness2 - tabHeight), isFocused)
            UiPop()
        UiPop()

        if (not doGrabTab) then
            local couldResize = allowMouseInput and isUsingComputer and windowData.animation.fullscreenAnim == 0
            if (couldResize) then
                UiPush() -- Resize highlighting 
                    UiColour(hightlightColour)

                    UiTranslate(borderThickness - resizeGrabDistance, borderThickness - resizeGrabDistance)
                    if (resizeTop) then
                        UiRect(visualSize.x - borderThickness2 + resizeGrabDistance2, resizeGrabDistance)
                    end
                    if (resizeLeft) then
                        UiRect(resizeGrabDistance, visualSize.y - borderThickness2 + resizeGrabDistance2)
                    end
        
                    UiAlign("right bottom")
                
                    UiTranslate(visualSize.x - borderThickness2 + resizeGrabDistance2, visualSize.y - borderThickness2 + resizeGrabDistance2)
                    if (resizeBottom) then
                        UiRect(visualSize.x - borderThickness2 + resizeGrabDistance2, resizeGrabDistance)
                    end
                    if (resizeRight) then
                        UiRect(resizeGrabDistance, visualSize.y - borderThickness2 + resizeGrabDistance2)
                    end
                UiPop()
            end
        end
    UiPop()
end

function DoIcon(iconData, iconIndex, isUsingComputer, allowMouseInput)
    local name, icon = GetIconNameAndIcon(iconIndex)
    local iconSizeX, iconSizeY = UiGetImageSize(icon)

    local iconScale = min(1, min(75 / iconSizeY, 115 / iconSizeX))
    UiPush()
        UiTranslate(iconData.pos.x, iconData.pos.y)
        UiPush()
            UiAlign("center middle")
            UiTranslate(0, -20)
            UiScale(iconScale)
            UiImage(icon)
        UiPop()
        UiPush()
            UiAlign("center top")
            UiWordWrap(110)
            UiTranslate(0, 20)
            UiFont("bold.ttf", 16)
            local textSizeX, textSizeY = UiText(name)
        UiPop()
        if (allowMouseInput) then
            UiPush()
                UiAlign("center middle")
                UiColour(hightlightColour)
                local highlight = NewVec2D(max(textSizeX, min(iconSizeX, 115) + 5), 115)
                if (UiIsMouseInRect(highlight.x, highlight.y)) then
                    UiRect(highlight.x, highlight.y)
                    if (isUsingComputer and InputPressed("lmb") and (iconData.windowCount <= 0 or iconData.iconSettings.canOpenMultiple)) then
                        table.insert(activeWindows, InstantiateWindowFromIcon(iconIndex))
                    end
                end
            UiPop()
        end
    UiPop()
end

function CloseWindow(windowIndex)
    activeWindows[windowIndex].animation.closeAnim = max(activeWindows[windowIndex].animation.closeAnim, GetTimeStep())
    lastClickWindow = 0
end

function FullscreenWindow(windowIndex, state)
    activeWindows[windowIndex].windowSettings.fullscreen = state
end

function FullscreenToggleWindow(windowIndex)
    activeWindows[windowIndex].windowSettings.fullscreen = not activeWindows[windowIndex].windowSettings.fullscreen
end

function MinimiseWindow(windowIndex, state)
    activeWindows[windowIndex].windowSettings.minimised = state
end

function UIRectHollow(w, h, t)
    local t2 = t + t
    UiPush()
        UiAlign("left top")
        UiRect(w, t)
        UiTranslate(0, t)
        UiRect(t, h - t2)
        UiTranslate(w - t, 0)
        UiRect(t, h - t2)
        UiTranslate(-w + t, h - t2)
        UiRect(w, t)
    UiPop()
end

function UiColour(c)
    UiColor(c[1], c[2], c[3], c[4])
end

function sqr(v)
    return v * v
end

function ColouredButtonWithCenteredImage(w, h, buttonColourAway, buttonColourHover, buttonColourPress, imagePath, imageColourAway, imageColourHover, imageColourPress, canUseMouse)
    if (canUseMouse == nil) then
        canUseMouse = true
    end
    
    UiPush()
        local buttonColour = buttonColourAway
        if (canUseMouse and UiIsMouseInRect(w, h)) then
            if (InputDown("lmb")) then
                buttonColour = buttonColourPress
            else
                buttonColour = buttonColourHover
            end
        end
        local imageColour = imageColourAway
        if (canUseMouse and UiIsMouseInRect(w, h)) then
            if (InputDown("lmb")) then
                imageColour = imageColourPress
            else
                imageColour = imageColourHover
            end
        end

        UiColour(buttonColour)
        UiRect(w, h)
        UiTranslate(w / 2, h / 2)
        UiAlign("center middle")
        UiColour(imageColour)
        UiImage(imagePath)
    UiPop()
end

function clamp(v, a, b)
    if (a > b) then
        a, b = b, a
    end
    return min(max(v, a), b)
end

function clamp01(v)
    return min(max(v, 0), 1)
end

function min(a, b)
    return a < b and a or b
end

function max(a, b)
    return a > b and a or b
end

function lerp(a, b, t)
    return a + t * (b - a)
end

function slerp(a, b, t)
    t = clamp01(t)
    local st = -2 * (t * t * t) + 3 * (t * t) -- cubic equation that results in a smooth change between 0 and 1

    return a + st * (b - a)
end

function abs(v)
    return v < 0 and -v or v
end

function NewVec2D(x, y)
    return { x = x, y = y }
end

function Vec2DAdd(a, b)
    return { x = a.x + b.x, y = a.y + b.y }
end

function slerpVec2D(a, b, t)
    return { x = slerp(a.x, b.x, t), y = slerp(a.y, b.y, t) }
end

function BoolToString(b) 
    return b and "True" or "False";
end

function trim(s)
   return (s:gsub("^%s*(.-)%s*$", "%1"))
end

function splitString(str, delimiter)
	local result = {}
	for word in string.gmatch(str, '([^'..delimiter..']+)') do
		result[#result+1] = trim(word)
	end
	return result
end

function aboutNumber(s, e)
    return s and tonumber(s) or (e and e or 0)
end

function ToIconPosX(x, y)
    if (y == nil) then
        y = x
        x = 0
    end

    local maxY = 120 * (math.floor((UiHeight() - taskbarHeight) / 120) - 1)
    local maxX = 120 * (math.floor(UiWidth() / 120) - 1)
    local modY = math.fmod(120 * y, maxY)
    local modX = math.fmod(120 * x + (120 * stepNormalised(120 * y, maxY)), maxX)
    return modX + 60
end

function ToIconPosY(x, y)
    if (y == nil) then
        y = x
        x = 0
    end

    local maxY = 120 * (math.floor((UiHeight() - taskbarHeight) / 120) - 1)
    local maxX = 120 * (math.floor(UiWidth() / 120) - 1)
    local modY = math.fmod(120 * y, maxY)
    return modY + 60
end

function ToIconPos(x, y)
    return NewVec2D(ToIconPosX(x, y), ToIconPosY(x, y))
end

function step(x, s)
    return x - math.mod(x, s)
end

function stepNormalised(x, l)
    return (x - math.mod(x, l)) / l
end

function InputPressedToString()
    if (InputDown("shift")) then
        if (InputPressed("a")) then return "A"
        elseif (InputPressed("b")) then return "B"
        elseif (InputPressed("c")) then return "C" 
        elseif (InputPressed("d")) then return "D" 
        elseif (InputPressed("e")) then return "E" 
        elseif (InputPressed("f")) then return "F" 
        elseif (InputPressed("g")) then return "G" 
        elseif (InputPressed("h")) then return "H" 
        elseif (InputPressed("i")) then return "I" 
        elseif (InputPressed("j")) then return "J" 
        elseif (InputPressed("k")) then return "K" 
        elseif (InputPressed("l")) then return "L" 
        elseif (InputPressed("m")) then return "M" 
        elseif (InputPressed("n")) then return "N" 
        elseif (InputPressed("o")) then return "O" 
        elseif (InputPressed("p")) then return "P" 
        elseif (InputPressed("q")) then return "Q" 
        elseif (InputPressed("r")) then return "R" 
        elseif (InputPressed("s")) then return "S" 
        elseif (InputPressed("t")) then return "T" 
        elseif (InputPressed("u")) then return "U" 
        elseif (InputPressed("v")) then return "V" 
        elseif (InputPressed("w")) then return "W" 
        elseif (InputPressed("x")) then return "X" 
        elseif (InputPressed("y")) then return "Y" 
        elseif (InputPressed("z")) then return "Z" 
        elseif (InputPressed("1")) then return "!" 
        elseif (InputPressed("2")) then return "@"
        elseif (InputPressed("3")) then return "#" 
        elseif (InputPressed("4")) then return "$" 
        elseif (InputPressed("5")) then return "%" 
        elseif (InputPressed("6")) then return "^" 
        elseif (InputPressed("7")) then return "&" 
        elseif (InputPressed("8")) then return "*"
        elseif (InputPressed("9")) then return "(" 
        elseif (InputPressed("0")) then return ")" 
        end
    else
        if (InputPressed("a")) then return "a" 
        elseif (InputPressed("b")) then return "b" 
        elseif (InputPressed("c")) then return "c" 
        elseif (InputPressed("d")) then return "d"
        elseif (InputPressed("e")) then return "e" 
        elseif (InputPressed("f")) then return "f" 
        elseif (InputPressed("g")) then return "g" 
        elseif (InputPressed("h")) then return "h" 
        elseif (InputPressed("i")) then return "i" 
        elseif (InputPressed("j")) then return "j" 
        elseif (InputPressed("k")) then return "k" 
        elseif (InputPressed("l")) then return "l" 
        elseif (InputPressed("m")) then return "m" 
        elseif (InputPressed("n")) then return "n" 
        elseif (InputPressed("o")) then return "o" 
        elseif (InputPressed("p")) then return "p" 
        elseif (InputPressed("q")) then return "q" 
        elseif (InputPressed("r")) then return "r" 
        elseif (InputPressed("s")) then return "s" 
        elseif (InputPressed("t")) then return "t" 
        elseif (InputPressed("u")) then return "u" 
        elseif (InputPressed("v")) then return "v" 
        elseif (InputPressed("w")) then return "w" 
        elseif (InputPressed("x")) then return "x" 
        elseif (InputPressed("y")) then return "y" 
        elseif (InputPressed("z")) then return "z" 
        elseif (InputPressed("1")) then return "1" 
        elseif (InputPressed("2")) then return "2"
        elseif (InputPressed("3")) then return "3" 
        elseif (InputPressed("4")) then return "4" 
        elseif (InputPressed("5")) then return "5" 
        elseif (InputPressed("6")) then return "6" 
        elseif (InputPressed("7")) then return "7" 
        elseif (InputPressed("8")) then return "8"
        elseif (InputPressed("9")) then return "9" 
        elseif (InputPressed("0")) then return "0"
        end
    end

    return ""
end

function RandomWindowPos(w, h)
    return NewVec2D(math.floor(math.random(0, UiWidth() - w)), math.floor(math.random(0, UiHeight() - h - taskbarHeight)))
end

function table.shallowCopy(t)
    local t2 = {}
    for k, v in pairs(t) do
        t2[k] = v
    end
    return t2
end
