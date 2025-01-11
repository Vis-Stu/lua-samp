script_name("telegramControl")
script_version("1.0.1")

local JsonStatus, Json = pcall(require, 'carbjsonconfig');
assert(JsonStatus, '[TGC] carbJsonConfg lib not found');

local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8


require('lib.strings')
local imgui = require('mimgui')
local sampEvents = require("samp.events")
local ffi = require('ffi')
local effil = require('effil')
local memory = require('memory')
local inicfg = require('inicfg')
local faicons = require('fAwesome6')
local MonetLua = require('MoonMonet')
local key = require 'vkeys'

-- checkbox
local narko = imgui.new.bool()
local semena = imgui.new.bool()
local gifts = imgui.new.bool()
local tree = imgui.new.bool()
local treeplo = imgui.new.bool()
local apple = imgui.new.bool()
local sliv = imgui.new.bool()
local kokos = imgui.new.bool()
local coor = imgui.new.bool()
local gravityGang = imgui.new.bool()
local ryda = imgui.new.bool()
local klad = imgui.new.bool()
local kryg = imgui.new.bool()
local mushroom = imgui.new.bool()

local allTreeplod = imgui.new.bool()
local ripeTreeplod = imgui.new.bool()

local groveG = imgui.new.bool()
local rifaG = imgui.new.bool()
local ballasG = imgui.new.bool()
local nightG = imgui.new.bool()
local aztecG = imgui.new.bool()
local vagosG = imgui.new.bool()

local linen = imgui.new.bool()
local cotton = imgui.new.bool()

local admcheker = imgui.new.bool()
local infRun = imgui.new.bool()
local nofuel = imgui.new.bool()

-- window
local treeplod = imgui.new.bool()
local overlay = imgui.new.bool()
local gravGang = imgui.new.bool()
--local actionItemsList = {"executeCommand", "executeCode"}

local imguiInferface = {
    renderWindow = imgui.new.bool(false),
    
    fontData = {
        base, big = nil
    },
    
    AI_PAGE = {},
    AI_HEADERBUT = {},
    AI_TOGGLE = {},
    AI_PICTURE = {},
}

local menuItemsData = {
    currentPage = 1,

    menuButtons = {
        {name=u8('Рендер'), icon=faicons('MEMO_CIRCLE_INFO'), i = 1},
        {name=u8('Хелперы'), icon=faicons('MESSAGE_CODE'), i = 2},
        {name=u8('Другое'), icon=faicons('GEARS'), i = 3},
        {name=u8('Закрыть'), icon=faicons('TERMINAL'), i = 4},
    }
}

local menuButtons = {
    Buttons = {
        {name=u8('Крутой'), nil, i = 1}
    }
}


local function switch(value)
    -- Утилита для вызова функции, или возврата значения, что функцией не является.
    local function call_or_return(var, ...)
        if type(var) == "function" then
        return var(...)
    else
        return var
    end
end
    
-- Возвращаем "под-функцию" для красоты.
    return function(cases)
      if cases[value] then -- Если есть готовый обработчик, не "хелпер" (называйте, как хотите), дергаем его. 
        return call_or_return(cases[value], value)
      else -- Иначе дергаем все "хелперы"
        for key, fun in pairs(cases) do
          if type(key) == "function" and key(value) then
            return call_or_return(fun, value)
          end
        end
      end
      
      -- Не один из возможных случаев не был вызван, так что если есть default-case, дергаем его.
      local default = cases["default"]
      if default then
        return call_or_return(default)
      end
    end
  end
  
  local function typeof(_type)
    return function(value)
        return type(value) == _type
    end
  end
  
  local function range(min, max)
    return function(value)
      return (type(value) == "number") and (value >= min) and (value <= max)
    end
end

  local function search_for(list, key)
    return function(value)
      return value == list[key]
    end
  end
  
  local function any_of(...)
    local list = {...}
    return function(value)
        for key, variant in pairs(list) do
            if variant == value then
                return true
            end
        end
        return false
    end
end

function main()
    while not isSampAvailable() do wait(0) end
    
    sampRegisterChatCommand('telec', function()
        imguiInferface.renderWindow[0] = not imguiInferface.renderWindow[0]
    end)
    
    while true do
        if wasKeyPressed(key.VK_INSERT) then
            imguiInferface.renderWindow[0] = not imguiInferface.renderWindow[0]
        end
        local pX, pY, pZ = getCharCoordinates(PLAYER_PED)
        for _, v in pairs(getAllObjects()) do
            if semena[0] then
                if getObjectModel(v) == 859 then
                    renderObjId(v, 'Семена', pX, pY, pZ)
                end
            end

            if gifts[0] then
                if getObjectModel(v) >= 19054 and getObjectModel(v) <= 19058 then
                    renderObjId(v, 'Подарок', pX, pY, pZ)
                end
            end
                
            if klad[0] then
                if getObjectModel(v) == 1271 then
                    renderObjId(v, 'Клад', pX, pY, pZ)
                end
            end
        end

        for id = 0, 2048 do
            if sampIs3dTextDefined(id) then
                local text, color, posX, posY, posZ, distance, ignoreWalls, player, vehicle = sampGet3dTextInfoById(id)
                if narko[0] then renderObjectsName('Закладка', text, 'Закладка', posX, posY, posZ) end
                
                if mushroom[0] then
                    if treeplo[0] then renderObjectsName('Срезать гриб', text, 'Гриб', posX, posY, posZ) end
                end
                if tree[0] then 
                    if treeplo[0] then renderObjectsName('Дерево высшего качества', text, 'Дерево высшего качества', posX, posY, posZ) end
                end
                if ripeTreeplod[0] then
                    if treeplo[0] then
                        if apple[0] then renderObjectsName('10 яблок', text, '10 яблок', posX, posY, posZ) end
                        if sliv[0] then renderObjectsName('10 слив', text, '10 слив', posX, posY, posZ) end
                        if kokos[0] then renderObjectsName('10 кокосов', text, '10 кокосов', posX, posY, posZ) end
                    end
                end
                if allTreeplod[0] then
                    if treeplo[0] then
                        if apple[0] then renderObjectsName('Яблочное дерево', text, 'Яблоко', posX, posY, posZ) end
                        if sliv[0] then renderObjectsName('Сливовое дерево', text, 'Сливы', posX, posY, posZ) end
                        if kokos[0] then renderObjectsName('Кокосовое дерево', text, 'Кокосы', posX, posY, posZ) end
                    end
                end
                if gravityGang[0] then
                    if groveG[0] then renderObjectsName('Grove Street', text, 'Grove Street', posX, posY, posZ) end
                    if ballasG[0] then renderObjectsName('East Side Ballas', text, 'East Side Ballas', posX, posY, posZ) end
                    if rifaG[0] then renderObjectsName('The Rifa', text, 'The Rifa', posX, posY, posZ) end
                    if aztecG[0] then renderObjectsName('Varrios Los Aztecas', text, 'Varrios Los Aztecas', posX, posY, posZ) end
                    if nightG[0] then renderObjectsName('Night Wolves', text, 'Night Wolves', posX, posY, posZ) end
                    if vagosG[0] then renderObjectsName('Los Santos Vagos', text, 'Los Santos Vagos', posX, posY, posZ) end
                end
            else
                --print(asdasd)
            end
        end
        if infRun[0] then
            if isSampAvailable() then
                mem.setint8(0xB7CEE4, 1)
            end
        end
        if nofuel[0] then
            if isCharInAnyCar(PLAYER_PED) then
                switchCarEngine(storeCarCharIsInNoSave(PLAYER_PED), true)
            --else
                --switchCarEngine(storeCarCharIsInNoSave(PLAYER_PED), false)
            end
        end
        wait(0)
    end
end

function renderObjId(v, textRender, pX, pY, pZ)
    if isObjectOnScreen(v) then
        local res, x, y, z = getObjectCoordinates(v)
        if res then
            local x1, y2 = convert3DCoordsToScreen(x, y, z)
            local s1, s2 = convert3DCoordsToScreen(pX, pY, pZ)
            renderDrawLine(s1, s2, x1, y2, 2.0, 0xFF00FF00)
            renderDrawPolygon(x1,y2, 10, 10, 10, 0, 0xFF52FF4D)
            renderFontDrawText(font, textRender, x1, y2, 0xFFFFFFFF)
        end
    end
end

function renderObjectsName(object, text, textRender, posX, posY, posZ)
    if text:find(object) then
        if isPointOnScreen(posX, posY, posZ, 1) then
            local x, y, z = getCharCoordinates(PLAYER_PED)
            local x1, y1 = convert3DCoordsToScreen(x, y, z)
            local x2, y2 = convert3DCoordsToScreen(posX, posY, posZ)
            renderDrawLine(x1, y1, x2, y2, 2.0, 0xFF00FF00)
            renderDrawPolygon(x2, y2, 10, 10, 10, 0, 0xFF52FF4D)
            renderFontDrawText(font, textRender, x2, y2, 0xFFFFFFFF)
        end
    end
end

-------------------
-- Функционал ImGui
-------------------
  
local newFrame = imgui.OnFrame(
    function() return imguiInferface.renderWindow[0] end,
    function(player)
        local resX, resY = getScreenResolution()
        imgui.SetNextWindowPos(imgui.ImVec2(resX / 2, resY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(900, 405), imgui.Cond.FirstUseEver)
        imgui.Begin('Main Window', imguiInferface.renderWindow, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoTitleBar)

        if imgui.BeginChild('##MenuBar', imgui.ImVec2(195, -1), false, imgui.WindowFlags.AlwaysAutoResize) then
            imgui.SetCursorPosY(10)
            imgui.PushFont(imguiInferface.fontData.big)
            imgui.CenterText("LOX")
            imgui.PopFont()
            imgui.PushFont(imguiInferface.fontData.base)

            imgui.SetCursorPosX(imgui.GetWindowWidth() / 2 - (imgui.CalcTextSize(u8'Неадекватная сова')).x / 2 )
            --imgui.Link('https://www.blast.hk/members/209662/', u8'Неадекватная сова')
            imgui.Text('LOX')

            imgui.SetCursorPosY(120)
            Menu(menuItemsData.menuButtons, menuItemsData.currentPage)
            imgui.SetCursorPosY(370)
            imgui.CenterText(u8"Версия: " .. thisScript().version)
            imgui.SetCursorPosX(20)
            imgui.EndChild()
        end

        imgui.SetCursorPosX(215)
        imgui.SetCursorPosY(0)
        if imgui.BeginChild('##RightBar', imgui.ImVec2(900, 400), false, imgui.WindowFlags.NoScrollbar) then
            VerticalSeparator()
            imgui.SetCursorPosX(10) imgui.SetCursorPosY(10)

            switch(menuItemsData.currentPage) {
                [1] = function() -- Уведомления
                    imgui.SetCursorPosX(10)
                    imgui.Checkbox(u8'Закладки', narko)
                    imgui.SetCursorPosX(10)
                    imgui.Checkbox(u8'Семена', semena)
                    imgui.SetCursorPosX(10)
                    imgui.Checkbox(u8'Подарки', gifts)
                    imgui.SetCursorPosX(10)
                    imgui.Checkbox(u8'Клад', klad)
                    imgui.SetCursorPosX(10)
                    imgui.Checkbox(u8'Деревья', treeplo) imgui.SameLine()
                    if imgui.Button(u8'Д', imgui.ImVec2(20, 25)) then
                        treeplod[0] = not treeplod[0]
                    end
                    imgui.SetCursorPosX(10)
                    imgui.Checkbox(u8'Граффити банд', gravityGang) imgui.SameLine()
                    if imgui.Button(u8'Г', imgui.ImVec2(20, 25)) then
                        gravGang[0] = not gravGang[0]
                    end
                end,
                
                [2] = function() -- Выбор действия
                    imgui.Text(u8'В разработке')
                end,

                [3] = function() -- Настройки
                    imgui.SetCursorPosX(10)
                    imgui.Checkbox(u8'Оверлей', overlay)
                    imgui.SetCursorPosX(10)
                    imgui.Checkbox(u8'Координаты игрока', coor)
                    imgui.SetCursorPosX(10)
                    imgui.Checkbox(u8'Чекер админов', admcheker)
                    imgui.SetCursorPosX(10)
                    imgui.Checkbox(u8'Бесконечный бег', infRun)
                    imgui.SetCursorPosX(10)
                    imgui.Checkbox(u8'Бесконечный двигатель', nofuel)
                    imgui.SetCursorPosX(10)
		    imgui.Checkbox(u8'лох', nofuel)
                    
                end,

                [4] = function() -- Close button
                    menuItemsData.currentPage = 1
                    imguiInferface.renderWindow[0] = false
                end,

                ["default"] = function()
                    imgui.Text("Woops.. :<")
                end
            }

            imgui.EndChild()
        end

        imgui.End()
    end
)

imgui.OnFrame( 
    function() return overlay[0] end,
    function(player)

        imgui.SetNextWindowPos(imgui.ImVec2(100,100), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5)) -- Укажем положение окна по центру и выставим оффсет 0.5, чтобы рендер шёл от середины окна
        imgui.SetNextWindowSize(imgui.ImVec2(150, 100), imgui.Cond.FirstUseEver)
        imgui.Begin('overlay', overlay, imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize)
        if coor[0] then
            local x, y, z = getCharCoordinates(PLAYER_PED)
            imgui.Text('x: ' .. x)
            imgui.Text('y: ' .. y)
            imgui.Text('z: ' .. z)
        end
        imgui.End()
    end
).HideCursor = true

imgui.OnFrame(
    function() return treeplod[0] end,
    function(player)
        --local col = imgui.GetStyle().Colors[imgui.Col.WindowBg]
        imgui.PushStyleColor(imgui.Col.WindowBg, imgui.ImVec4(0.11, 0.13, 0.15, 1))
        local resX, resY = getScreenResolution()
        imgui.SetNextWindowPos(imgui.ImVec2(resX / 2, resY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5)) -- Укажем положение окна по центру и выставим оффсет 0.5, чтобы рендер шёл от середины окна
        imgui.SetNextWindowSize(imgui.ImVec2(-1, -1), imgui.Cond.FirstUseEver)
        imgui.Begin(u8'Деревья плодов', treeplod, imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoResize)
        imgui.Checkbox(u8'Все', allTreeplod)
        imgui.SameLine()
        imgui.Checkbox(u8'Спелые', ripeTreeplod)
        imgui.SetCursorPos(imgui.ImVec2(5, 40))
        imgui.Checkbox(u8'Яблочное дерево', apple)
        imgui.Checkbox(u8'Сливочное дерево', sliv)
        imgui.Checkbox(u8'Кокосовое дерево', kokos)
        imgui.Checkbox(u8'Дерево высшего качества', tree)
        imgui.Checkbox(u8'Грибы', mushroom)
        if imgui.Button(u8'Закрыть', imgui.ImVec2(-1, 25)) then
            treeplod[0] = not treeplod[0]
        end
        imgui.PopStyleColor(1)
        imgui.End()
    end
)
imgui.OnFrame(
    function() return gravGang[0] end,
    function(player)

        imgui.PushStyleColor(imgui.Col.WindowBg, imgui.ImVec4(0.11, 0.13, 0.15, 1))
        local resX, resY = getScreenResolution()
        imgui.SetNextWindowPos(imgui.ImVec2(resX / 2, resY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5)) -- Укажем положение окна по центру и выставим оффсет 0.5, чтобы рендер шёл от середины окна
        imgui.SetNextWindowSize(imgui.ImVec2(-1, -1), imgui.Cond.FirstUseEver)
        imgui.Begin(u8'Граффити банд', gravGang, imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoResize)
        imgui.Checkbox('Grove Street', groveG)
        imgui.Checkbox('East Side Ballas', ballasG)
        imgui.Checkbox('The Rifa', rifaG)
        imgui.Checkbox('Varrios Los Aztecas', aztecG)
        imgui.Checkbox('Night Wolves', nightG)
        imgui.Checkbox('Los Santos Vagos', vagosG)
        if imgui.Button(u8'Закрыть', imgui.ImVec2(-1, 25)) then
            gravGang[0] = not gravGang[0]
        end
        imgui.PopStyleColor(1)
        imgui.End()
    end
)

imgui.OnInitialize(function()
    imgui.GetIO().IniFilename = nil

    local config = imgui.ImFontConfig()
    config.MergeMode = true
    config.PixelSnapH = true

    iconRanges = imgui.new.ImWchar[3](faicons.min_range, faicons.max_range, 0)
    local glyph_ranges = imgui.GetIO().Fonts:GetGlyphRangesCyrillic()
    imgui.GetIO().Fonts:Clear()
    imguiInferface.fontData.big = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/EagleSans Regular Regular.ttf', 64.0, nil, glyph_ranges)
    imguiInferface.fontData.base = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/EagleSans Regular Regular.ttf', 18.0, nil, glyph_ranges)
    imgui.GetIO().Fonts:AddFontFromMemoryCompressedBase85TTF(faicons.get_font_data_base85('regular'), 18, config, iconRanges)

    applyImguiStyle(0, 0.8, false)
end)
 

--------------------------------------
-- Код не относящийся к логике скрипта
--------------------------------------

function executeLuaCode(code, action)
    local luaCode = load(code)
    if not luaCode then
        printMessageInChat(('Ошибка загрузки кода {004bff}%s'):format(action))
        return
    end

    local ok, result = pcall(luaCode)
    if not ok then
        printMessageInChat(('{ffffff}В событии {93ff00}%s {ffffff}произошла ошибка'):format(action))
        printMessageInChat(result)
    end
end

function onExitScript(quitGame)
    telegram.pollingThread:terminate()
end

function handleAsyncHttpRequestThread(runner, resolve, reject)
    local status, err
    repeat
        status, err = runner:status() 
        wait(0)
    until status ~= 'running'
    
    if not err then
        if status == 'completed' then
            local result, response = runner:get()
            if result then
                resolve(response)
            else
                reject(response)
            end
            return
            elseif status == 'canceled' then
            return reject(status)
        end
    else
        return reject(err)
    end
end

function table.assign(target, def, deep)
    for k, v in pairs(def) do
        if target[k] == nil then
            if type(v) == 'table' then
                target[k] = {}
                table.assign(target[k], v)
            else  
                target[k] = v
            end
            elseif deep and type(v) == 'table' and type(target[k]) == 'table' then 
            table.assign(target[k], v, deep)
        end
    end 
    return target
end

function imgui.Link(link, text)
    text = text or link
    local tSize = imgui.CalcTextSize(text)
    local p = imgui.GetCursorScreenPos()
    local DL = imgui.GetWindowDrawList()
    local col = { 0xFFFF7700, 0xFFFF9900 }
    if imgui.InvisibleButton("##" .. link, tSize) then os.execute("explorer " .. link) end
    local color = imgui.IsItemHovered() and col[1] or col[2]
    DL:AddText(p, color, text)
    DL:AddLine(imgui.ImVec2(p.x, p.y + tSize.y), imgui.ImVec2(p.x + tSize.x, p.y + tSize.y), color)
end

function Menu(menuItems)
    for i=1, #menuItems do
        if PageButton(menuItemsData.currentPage == menuItems[i].i, menuItems[i].icon, menuItems[i].name) then
            menuItemsData.currentPage= menuItems[i].i
        end
    end
end

function imgui.ShowHint(description)
    if imgui.IsItemHovered() then
        imgui.BeginTooltip()
            imgui.PushTextWrapPos(600)
                imgui.TextUnformatted(description)
            imgui.PopTextWrapPos()
        imgui.EndTooltip()
    end
end

function TextWithHint(label, description, isDisabled)
    if isDisabled then
        imgui.TextDisabled(label)
    else
        imgui.Text(label)
    end

    if imgui.IsItemHovered() then
        imgui.BeginTooltip()
            imgui.PushTextWrapPos(600)
                imgui.TextUnformatted(description)
            imgui.PopTextWrapPos()
        imgui.EndTooltip()
    end
end

function imgui.CenterText(text)
    local width = imgui.GetWindowWidth()
    local calc = imgui.CalcTextSize(text)
    imgui.SetCursorPosX( width / 2 - calc.x / 2 )
    imgui.Text(text)
end

function TextColoredRGB(text)
    local style = imgui.GetStyle()
    local colors = style.Colors
    local col = imgui.Col
    
    local designText = function(text__)
        local pos = imgui.GetCursorPos()
        if sampGetChatDisplayMode() == 2 then
            for i = 1, 1 --[[Степень тени]] do
                imgui.SetCursorPos(imgui.ImVec2(pos.x + i, pos.y))
                imgui.TextColored(imgui.ImVec4(0, 0, 0, 1), text__) -- shadow
                imgui.SetCursorPos(imgui.ImVec2(pos.x - i, pos.y))
                imgui.TextColored(imgui.ImVec4(0, 0, 0, 1), text__) -- shadow
                imgui.SetCursorPos(imgui.ImVec2(pos.x, pos.y + i))
                imgui.TextColored(imgui.ImVec4(0, 0, 0, 1), text__) -- shadow
                imgui.SetCursorPos(imgui.ImVec2(pos.x, pos.y - i))
                imgui.TextColored(imgui.ImVec4(0, 0, 0, 1), text__) -- shadow
            end
        end
        imgui.SetCursorPos(pos)
    end
    
    local text = text:gsub('{(%x%x%x%x%x%x)}', '{%1FF}')

    local color = colors[col.Text]
    local start = 1
    local a, b = text:find('{........}', start)   
    
    while a do
        local t = text:sub(start, a - 1)
        if #t > 0 then
            designText(t)
            imgui.TextColored(color, t)
            imgui.SameLine(nil, 0)
        end

        local clr = text:sub(a + 1, b - 1)
        if clr:upper() == 'STANDART' then color = colors[col.Text]
        else
            clr = tonumber(clr, 16)
            if clr then
                local r = bit.band(bit.rshift(clr, 24), 0xFF)
                local g = bit.band(bit.rshift(clr, 16), 0xFF)
                local b = bit.band(bit.rshift(clr, 8), 0xFF)
                local a = bit.band(clr, 0xFF)
                color = imgui.ImVec4(r / 255, g / 255, b / 255, a / 255)
            end
        end

        start = b + 1
        a, b = text:find('{........}', start)
    end
    imgui.NewLine()
    if #text >= start then
        imgui.SameLine(nil, 0)
        designText(text:sub(start))
        imgui.TextColored(color, text:sub(start))
    end
end

function PageButton(bool, icon, name, but_wide)
    local ToU32 = imgui.ColorConvertFloat4ToU32
	but_wide = but_wide or 190
	local duration = 0.25
	local DL = imgui.GetWindowDrawList()
	local p1 = imgui.GetCursorScreenPos()
	local p2 = imgui.GetCursorPos()
	local col = imgui.GetStyle().Colors[imgui.Col.ButtonActive]
    local function bringFloatTo(from, to, start_time, duration)
        local timer = os.clock() - start_time
        if timer >= 0.00 and timer <= duration then
            local count = timer / (duration / 100)
            return from + (count * (to - from) / 100), true
        end
        return (timer > duration) and to or from, false
    end
		
	if not imguiInferface.AI_PAGE[name] then
		imguiInferface.AI_PAGE[name] = { clock = nil }
	end
	local pool = imguiInferface.AI_PAGE[name]

	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.00, 0.00, 0.00, 0.00))
    imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.00, 0.00, 0.00, 0.00))
    imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.00, 0.00, 0.00, 0.00))
    local result = imgui.InvisibleButton(name, imgui.ImVec2(but_wide, 35))
    if result and not bool then 
    	pool.clock = os.clock() 
    end
    local pressed = imgui.IsItemActive()
    imgui.PopStyleColor(3)
	if bool then
		if pool.clock and (os.clock() - pool.clock) < duration then
			local wide = (os.clock() - pool.clock) * (but_wide / duration)
			DL:AddRectFilled(imgui.ImVec2(p1.x, p1.y), imgui.ImVec2((p1.x + 190) - wide, p1.y + 35), 0x10FFFFFF, 15, 10)
	       	DL:AddRectFilled(imgui.ImVec2(p1.x, p1.y), imgui.ImVec2(p1.x + 5, p1.y + 35), ToU32(col))
			DL:AddRectFilled(imgui.ImVec2(p1.x, p1.y), imgui.ImVec2(p1.x + wide, p1.y + 35), ToU32(imgui.ImVec4(col.x, col.y, col.z, 0.6)), 15, 10)
		else
			DL:AddRectFilled(imgui.ImVec2(p1.x, (pressed and p1.y + 3 or p1.y)), imgui.ImVec2(p1.x + 5, (pressed and p1.y + 32 or p1.y + 35)), ToU32(col))
			DL:AddRectFilled(imgui.ImVec2(p1.x, p1.y), imgui.ImVec2(p1.x + 190, p1.y + 35), ToU32(imgui.ImVec4(col.x, col.y, col.z, 0.6)), 15, 10)
		end
	else
		if imgui.IsItemHovered() then
			DL:AddRectFilled(imgui.ImVec2(p1.x, p1.y), imgui.ImVec2(p1.x + 190, p1.y + 35), 0x10FFFFFF, 15, 10)
		end
	end
	imgui.SameLine(10); imgui.SetCursorPosY(p2.y + 8)
	if bool then
		imgui.Text((' '):rep(3) .. icon)
		imgui.SameLine(60)
		imgui.Text(name)
	else
		imgui.TextColored(imgui.ImVec4(0.60, 0.60, 0.60, 1.00), (' '):rep(3) .. icon)
		imgui.SameLine(60)
		imgui.TextColored(imgui.ImVec4(0.60, 0.60, 0.60, 1.00), name)
	end
	imgui.SetCursorPosY(p2.y + 40)
	return result
end

function splitStringByLine(string)
    local splitText = {}
    for line in string:gmatch("([^\n]*)\n?") do
        table.insert(splitText, line)
    end
    return splitText
end

function isEmptyString(s)
    return s == nil or s == ''
end

function explode_argb(argb)
    local a = bit.band(bit.rshift(argb, 24), 0xFF)
    local r = bit.band(bit.rshift(argb, 16), 0xFF)
    local g = bit.band(bit.rshift(argb, 8), 0xFF)
    local b = bit.band(argb, 0xFF)
    return a, r, g, b
end

local function ARGBtoRGB(color) return bit.band(color, 0xFFFFFF) end

function ColorAccentsAdapter(color)
    local a, r, g, b = explode_argb(color)
    local ret = {a = a, r = r, g = g, b = b}
    function ret:apply_alpha(alpha) self.a = alpha return self end
    function ret:as_u32() return join_argb(self.a, self.b, self.g, self.r) end
    function ret:as_vec4() return imgui.ImVec4(self.r / 255, self.g / 255, self.b / 255, self.a / 255) end
    function ret:as_vec4_table() return {self.r / 1, self.g / 1, self.b / 1, self.a / 1} end
    function ret:as_argb() return join_argb(self.a, self.r, self.g, self.b) end
    function ret:as_rgba() return join_argb(self.r, self.g, self.b, self.a) end
    function ret:as_chat() return string.format("%06X", ARGBtoRGB(join_argb(self.a, self.r, self.g, self.b))) end
    function ret:argb_to_rgb() return ARGBtoRGB(join_argb(self.a, self.r, self.g, self.b)) end
    return ret
end

function applyImguiStyle(our_color, power, show_shades)
    local vec2, vec4 = imgui.ImVec2, imgui.ImVec4
    imgui.SwitchContext()
    local st = imgui.GetStyle()
    local cl = st.Colors
    local fl = imgui.Col

    local to_vec4 = function(color)
        return ColorAccentsAdapter(color):as_vec4()
    end

    local palette = MonetLua.buildColors(our_color, power, show_shades)

    st.WindowPadding = vec2(5, 5)
    st.WindowRounding = 6.0
    st.WindowBorderSize = 0
    st.WindowTitleAlign = vec2(0.5, 0.5)
    st.ChildRounding = 7.0
    st.ChildBorderSize = 2.0
    st.PopupRounding = 5.0
    st.PopupBorderSize = 1.0
    st.FramePadding = vec2(5, 4)
    st.FrameRounding = 3.0
    st.ItemSpacing = vec2(4, 4)
    st.ScrollbarSize = 20.0
    st.GrabMinSize = 9
    st.GrabRounding = 15
    st.ButtonTextAlign = vec2(0.5, 0.5)
    st.SelectableTextAlign = vec2(0.5, 0.5)
    cl[fl.Text] =                to_vec4(palette.accent2.color_50)
    cl[fl.TextDisabled] =        to_vec4(palette.accent1.color_600)
    cl[fl.WindowBg] =            to_vec4(palette.accent1.color_900)
    cl[fl.ChildBg] =             to_vec4(palette.accent1.color_900)
    cl[fl.PopupBg] =             to_vec4(palette.accent1.color_900)
    cl[fl.Border] =              to_vec4(palette.accent1.color_700)
    cl[fl.BorderShadow] =        to_vec4(palette.neutral2.color_900)
    cl[fl.FrameBg] =             to_vec4(palette.accent1.color_800)
    cl[fl.FrameBgHovered] =      to_vec4(palette.accent1.color_700)
    cl[fl.FrameBgActive] =       to_vec4(palette.accent1.color_600)
    cl[fl.TitleBg] =             to_vec4(palette.accent1.color_600)
    cl[fl.TitleBgActive] =       to_vec4(palette.accent1.color_600)
    cl[fl.TitleBgCollapsed] =    to_vec4(palette.accent1.color_600)
    cl[fl.MenuBarBg] =           to_vec4(palette.accent2.color_700)
    cl[fl.ScrollbarBg] =         to_vec4(palette.accent1.color_800)
    cl[fl.ScrollbarGrab] =       to_vec4(palette.accent1.color_600)
    cl[fl.ScrollbarGrabHovered] =to_vec4(palette.accent1.color_500)
    cl[fl.ScrollbarGrabActive] = to_vec4(palette.accent1.color_400)
    cl[fl.CheckMark] =           to_vec4(palette.neutral1.color_50)
    cl[fl.SliderGrab] =          to_vec4(palette.accent1.color_500)
    cl[fl.SliderGrabActive] =    to_vec4(palette.accent1.color_500)
    cl[fl.Button] =              to_vec4(palette.accent1.color_500)
    cl[fl.ButtonHovered] =       to_vec4(palette.accent1.color_400)
    cl[fl.ButtonActive] =        to_vec4(palette.accent1.color_300)
    cl[fl.Header] =              to_vec4(palette.accent1.color_800)
    cl[fl.HeaderHovered] =       to_vec4(palette.accent1.color_700)
    cl[fl.HeaderActive] =        to_vec4(palette.accent1.color_600)
    cl[fl.Separator] =           to_vec4(palette.accent1.color_600)
    cl[fl.SeparatorHovered] =    to_vec4(palette.accent2.color_100)
    cl[fl.SeparatorActive] =     to_vec4(palette.accent2.color_50)
    cl[fl.ResizeGrip] =          to_vec4(palette.accent2.color_900)
    cl[fl.ResizeGripHovered] =   to_vec4(palette.accent2.color_800)
    cl[fl.ResizeGripActive] =    to_vec4(palette.accent2.color_700)
    cl[fl.Tab] =                 to_vec4(palette.accent1.color_700)
    cl[fl.TabHovered] =          to_vec4(palette.accent1.color_600)
    cl[fl.TabActive] =           to_vec4(palette.accent1.color_500)
    cl[fl.PlotLines] =           to_vec4(palette.accent3.color_300)
    cl[fl.PlotLinesHovered] =    to_vec4(palette.accent3.color_50)
    cl[fl.PlotHistogram] =       to_vec4(palette.accent3.color_300)
    cl[fl.PlotHistogramHovered] =to_vec4(palette.accent3.color_50)
    cl[fl.DragDropTarget] =      to_vec4(palette.accent3.color_700)
end

function VerticalSeparator()
    local p = imgui.GetCursorScreenPos()
    imgui.GetWindowDrawList():AddLine(imgui.ImVec2(p.x, p.y), imgui.ImVec2(p.x, p.y + imgui.GetContentRegionMax().y), imgui.ColorConvertFloat4ToU32(imgui.GetStyle().Colors[imgui.Col.Separator]))
end -- 1318
