local res, version = pcall(getMoonloaderVersion)
if not res or version < 26 then
    print('Запуск скрипта невозможен. Скрипт работает на версии MoonLoader 0.26 или выше!')
end

script_name('Arizona Helper')
script_author('ne ya')
script_version('0.0.1')
script_url('tg: @konoplya49')

local imgui = require('mimgui')
local key = require('vkeys')
local fa = require('fAwesome5')
local wm = require 'windows.message'
local memory = require('memory')
local sampev = require('samp.events')
local enconing = require('encoding')
enconing.default = 'CP1251'
local u8 = enconing.UTF8
-- local mylib = require('!mylibtest')

local renderWindow = imgui.new.bool()
local tab = 1
local tabs = 0
local test = imgui.new.bool()
local serverTime = imgui.new.bool()
local moneySeperator = imgui.new.bool()
local calcOn = imgui.new.bool()

local calculator = imgui.new.bool()
local imguiInferface = {
    --renderWindow = imgui.new.bool(false),
    
    fontData = {
        base, big = nil
    },
    
    AI_PAGE = {},
    AI_HEADERBUT = {},
    AI_TOGGLE = {},
    AI_PICTURE = {},
}


local ComboTest = imgui.new.int() -- создаём буфер для комбо
--local item_list = {u8'Армия ЛС', u8'Армия СФ', u8'Тюрьма строгого режима', u8'Полиция ЛС', u8'Полиция ЛВ', u8'Полиция СФ', u8'Полиция РКШД', u8'Больница ЛС', u8'Больница ЛВ', u8'Больница СФ', u8'Сми ЛС', u8'Сми ЛВ', u8'Сми СФ', u8'Центр лицензирования', u8'Правительство'} -- создаём таблицу с содержимым списка
local item_list = {u8'Армия', u8'Полиция', u8'Больница', u8'СМИ', u8'Центр лицензирования', u8'Правительство', u8'Страховая компания', u8'Пожарный департамент'}
local ImItems = imgui.new['const char*'][#item_list](item_list)
local _, id = nil, nil
local newFrame = imgui.OnFrame(
    function() return renderWindow[0] end, -- ss9404357@gma
    function (player)

        local resX, resY = getScreenResolution()
        imgui.SetNextWindowPos(imgui.ImVec2(resX / 2, resY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(800, 600), imgui.Cond.FirstUseEver)
        imgui.Begin('qwe', renderWindow, imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoTitleBar)
        
            imgui.BeginChild('#Menu', imgui.ImVec2(180, -1), true)
                if imgui.Button(fa.ICON_FA_HOME .. u8' Основное', imgui.ImVec2(170, 40)) then
                    tab = 1
                    tabs = 0
                end
                if imgui.Button(fa.ICON_FA_USER .. u8' Игрок', imgui.ImVec2(170, 40)) then
                    tab = 2
                    tabs = 0
                end
                if imgui.Button(fa['ICON_FA_H_SQUARE'] .. u8' Хелперы', imgui.ImVec2(170, 40)) then
                    tab = 3
                    tabs = 0
                end
                if imgui.Button(fa.ICON_FA_BUILDING .. u8' Организации', imgui.ImVec2(170, 40)) then
                    tab = 4
                    tabs = 1
                end
                if imgui.Button(fa['ICON_FA_ELLIPSIS_H'] .. u8' Другое', imgui.ImVec2(170, 40)) then
                    tab = 5
                    tabs = 0
                end
                if imgui.Button(fa.ICON_FA_COG .. u8' Настройки', imgui.ImVec2(170, 40)) then
                    tab = 6
                    tabs = 0
                end
                if imgui.Button(fa['ICON_FA_SYNC'] .. ' Reload script', imgui.ImVec2(170, 40)) then
                    reloadScripts()
                end
                if imgui.Button(u8("Slap Up ") .. fa.ICON_FA_ARROW_UP, imgui.ImVec2(176, 27.5)) then
                    local x, y, z = getCharCoordinates(PLAYER_PED)
                    local slap = z + 3
                    setCharCoordinates(PLAYER_PED, x, y, slap)
                end
                if imgui.Button(fa.ICON_FA_COG .. u8' Обновить', imgui.ImVec2(170, 40)) then
                    autoupdate('https://raw.githubusercontent.com/Vis-Stu/lua-samp/refs/heads/main/update.json', thisScript().name, 'kek')
                end
                imgui.Text(u8'Никнейм: ' .. sampGetPlayerNickname(id))
                imgui.Text(u8'Ид: ' .. id)
                imgui.Text(u8'Пинг: ' .. sampGetPlayerPing(id))
                imgui.Text(thisScript().version)
            imgui.EndChild()

            imgui.SameLine()
            imgui.BeginChild('Act', imgui.ImVec2(-1,-1), true)

                if tab == 1 then
                    imgui.CenterText(u8'Основное')
                    imgui.Checkbox('Server time', serverTime)
                    imgui.Checkbox('Money seperator', moneySeperator)
                    imgui.Checkbox('Calculator', calcOn)
                    imgui.Checkbox('AntiLagInven', test)
                    imgui.Checkbox('Quit notification', test)
                    imgui.Checkbox('ReloadScripts', test)
                    imgui.SameLine()
                    imgui.TextQuestion('help')
                elseif tab == 2 then
                    imgui.CenterText(u8'Игрок')
                    
                elseif tab == 3 then
                    imgui.CenterText(u8'Хелперы')
                elseif tab == 4 then
                    imgui.Combo(u8' Организация',ComboTest,ImItems, #item_list)
                elseif tab == 5 then
                    imgui.CenterText(u8'Другое')
                elseif tab == 6 then
                    imgui.CenterText(u8'Настройки')
                end
                
                if tab == 4 and tabs == 1 then
                    imgui.BeginChild('ww', imgui.ImVec2(-1,-1), true)
                        if ComboTest[0] == 0 then -- комбо возвращает значение, поэтому следует указывать при каком пункте выполняется условие
                            imgui.CenterText(u8'Тюрьма строгого режима')
                            imgui.Text(u8'Имя и Фамилия: ')
                            imgui.Text(u8'Пол: ')
                            imgui.Text(u8'Организация: ')
                            imgui.Text(u8'Должность: ')
                            imgui.Text(u8'Выговоры: ')
                            
                        elseif ComboTest[0] == 1 then
                            imgui.CenterText(u8'Полиция ЛВ')
                            imgui.Text('combo2')
                        elseif ComboTest[0] == 2 then
                            imgui.CenterText(u8'Больница ЛС')
                        elseif ComboTest[0] == 3 then
                            imgui.CenterText(u8'СМИ ЛС')
                        elseif ComboTest[0] == 4 then
                            imgui.CenterText(u8'Центр лицензирования')
                        elseif ComboTest[0] == 5 then
                            imgui.CenterText(u8'Правительство')
                        elseif ComboTest[0] == 6 then
                            imgui.CenterText(u8'Страховая компания')
                        elseif ComboTest[0] == 7 then
                            imgui.CenterText(u8'Пожарный департамент')
                        end
                        imgui.EndChild()
                elseif tab == 4 and tabs == 2 then
                    imgui.BeginChild('ww', imgui.ImVec2(-1,-1), true)
                    imgui.Text('2')
                end
                imgui.SetCursorPos(imgui.ImVec2(555, 0))
                if imgui.Button(fa.ICON_FA_TIMES, imgui.ImVec2(46, 25)) then
                    renderWindow[0] = not renderWindow[0]
                end
            imgui.EndChild()
        imgui.End()
    end
)

-- imgui.OnFrame(
--     function () return calculator[0] end,
--         function(player)
--             if calcOn[0] then
--             if sampIsChatInputActive() and ok then
--                 local input = sampGetInputInfoPtr()
--                 local input = getStructElement(input, 0x8, 4)
--                 local windowPosX = getStructElement(input, 0x8, 4)
--                 local windowPosY = getStructElement(input, 0xC, 4)
--                 imgui.SetNextWindowPos(imgui.ImVec2(windowPosX, windowPosY + 30 + 15), imgui.Cond.FirstUseEver)
--                 imgui.SetNextWindowSize(imgui.ImVec2(result:len()*10, 30))
--                 imgui.Begin('Solve', calculator, imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove)
--                 imgui.PushFont(imguiInferface.fontData.base)
--                 imgui.CenterText(u8(number_separator(result)))
--                 imgui.End()
--             end
--         end

--     end
-- ).HideCursor = true

imgui.OnFrame(
    function() return calculator[0] end,
        function(player)
            if calcOn[0] then
            if sampIsChatInputActive() then
                local input = sampGetInputInfoPtr()
                local input = getStructElement(input, 0x8, 4)
                local windowPosX = getStructElement(input, 0x8, 4)
                local windowPosY = getStructElement(input, 0xC, 4)
                imgui.SetNextWindowPos(imgui.ImVec2(windowPosX, windowPosY + 30 + 15), imgui.Cond.FirstUseEver)
                imgui.SetNextWindowSize(imgui.ImVec2(result:len()*10, 30))
                imgui.Begin('Solve', calculator, imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove)
                imgui.CenterText(u8(number_separator(result)))
                imgui.End()
            end
        end
    end
).HideCursor = true

function imgui.CenterText(text)
    local width = imgui.GetWindowWidth()
    local calc = imgui.CalcTextSize(text)
    imgui.SetCursorPosX( width / 2 - calc.x / 2 )
    imgui.Text(text)
end
imgui.OnInitialize(function()
    imgui.GetIO().IniFilename = nil
    imguiInferface.fontData.base = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/EagleSans Regular Regular.ttf', 18.0, nil, glyph_ranges)
    local glyph_ranges = imgui.GetIO().Fonts:GetGlyphRangesCyrillic()
    local path = getFolderPath(0x14) .. '\\trebucbd.ttf'
    imgui.GetIO().Fonts:Clear() -- Удаляем стандартный шрифт на 14
    imgui.GetIO().Fonts:AddFontFromFileTTF(path, 16.0, nil, glyph_ranges)
    -- local config = imgui.ImFontConfig()
    -- config.MergeMode = true
    -- config.PixelSnapH = true
    -- iconRanges = imgui.new.ImWchar[3](faicons.min_range, faicons.max_range, 0)
    -- imgui.GetIO().Fonts:AddFontFromMemoryCompressedBase85TTF(faicons.get_font_data_base85('solid'), 16, config, iconRanges)
    local config = imgui.ImFontConfig()
    config.MergeMode = true
    local glyph_ranges = imgui.GetIO().Fonts:GetGlyphRangesCyrillic()
    local iconRanges = imgui.new.ImWchar[3](fa.min_range, fa.max_range, 0)
    imgui.GetIO().Fonts:AddFontFromFileTTF('trebucbd.ttf', 14.0, nil, glyph_ranges)
    icon = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/fa-solid-900.ttf', 14.0, config, iconRanges)
    theme()
end)

function imgui.TextQuestion(text)
    imgui.TextDisabled("?")
    if imgui.IsItemHovered() then
        imgui.BeginTooltip()
        imgui.PushTextWrapPos(450)
        imgui.TextUnformatted(text)
        imgui.PopTextWrapPos()
        imgui.EndTooltip()
    end
end

function main()
    while not isSampAvailable() do wait(0) end
    --local _, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
    lua_thread.create(function ()
        while true do
            connectPlayerisServer = sampIsPlayerConnected(PLAYER_PED)
            _, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
            wait(1000)
        end
    end)
    -- sampRegisterChatCommand('mylib', function ()
    --     mylib.show(mylib.IconTypes.Information, 'Zagolovok', 'text')
    -- end)
    while true do
        if isKeyJustPressed(key.VK_DELETE) then
            renderWindow[0] = not renderWindow[0]
        end

        --- Calculator
        local text = sampGetChatInputText()

        if text:find('%d+') and text:find('[-+/*^%%]') and not text:find('%a+') and text ~= nil then
            ok, number = pcall(load('return '..text))
            result = 'Результат: '..number
        end

        if text == '' then
            ok = false
        end

        calculator[0] = ok

        -- Sevrver Time
        if serverTime[0] then
            local oX = 250
            local oY = 430
            local piska = 0
            sampTextdrawCreate(221, "Server_time:", oX, oY)
		    sampTextdrawSetLetterSizeAndColor(221, 0.3, 1.7, 0xFFe1e1e1)
		    sampTextdrawSetOutlineColor(221, 0.5, 0xFF000000)
		    sampTextdrawSetAlign(221, 1)
		    sampTextdrawSetStyle(221, 2)
		    timer = os.time() + piska
		    sampTextdrawCreate(222, os.date("%H:%M:%S", timer), oX + 90, oY)
		    sampTextdrawSetLetterSizeAndColor(222, 0.3, 1.7, 0xFFff6347)
		    sampTextdrawSetOutlineColor(222, 0.5, 0xFF000000)
		    sampTextdrawSetAlign(222, 1)
		    sampTextdrawSetStyle(222, 2)
        else
            sampTextdrawDelete(221)
            sampTextdrawDelete(222)
        end
        wait(0)
    end
end

function comma_value(n)
	local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
	if moneySeperator[0] then
		return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
	else
		return left..(num:reverse():gsub('(%d%d%d)','%1.'):reverse())..right
	end
end

function separator(text) -- by Royan_Millans
	if text:find("$") then 
	    for S in string.gmatch(text, "%$%d+") do
	    	local replace = comma_value(S)
	    	text = string.gsub(text, S, replace)
	    end
	    for S in string.gmatch(text, "%d+%$") do
	    	S = string.sub(S, 0, #S-1)
	    	local replace = comma_value(S)
	    	text = string.gsub(text, S, replace)
	    end
	end
	return text
end

function sampev.onSetObjectMaterialText(objectId, data)
	if moneySeperator[0] then
		local object = sampGetObjectHandleBySampId(objectId)
		if object and doesObjectExist(object) then
			if getObjectModel(object) == 18663 then
				data.text = separator(data.text)
			end
		end
		return {objectId, data}
	end
end
function sampev.onShowDialog(dialogId, style, title, button1, button2, text)
	if moneySeperator[0] then
		text = separator(text)
		title = separator(title)
		return {dialogId, style, title, button1, button2, text}
	end
end
function sampev.onServerMessage(color, text)
	if moneySeperator[0] then
		text = separator(text)
		return {color, text}
	end
end
function sampev.onCreate3DText(id, color, position, distance, testLOS, attachedPlayerId, attachedVehicleId, text)
	if moneySeperator[0] then
		text = separator(text)
		return {id, color, position, distance, testLOS, attachedPlayerId, attachedVehicleId, text}
	end
end
function sampev.onTextDrawSetString(id, text)
	if moneySeperator[0] then
		text = separator(text)
		return {id, text}
	end
end
function sampev.onDisplayGameText(style,time,text)
	if moneySeperator[0] then
    	text = separator(text)
    	return {style,time,text}
	end
end
function sampev.onShowTextDraw(id, data)
    if moneySeperator[0] then
		if id == 2070 or id == 2077  then -- разделение цен в трейде
			if tonumber(data.text) then
				data.text = comma_value(data.text)
			end
		else
			data.text = separator(data.text)
		end
		return {id,data}
	end
end

function number_separator(n)
	local left, num, right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1 '):reverse())..right
end

-- addEventHandler('onWindowMessage', function(msg, wparam, lparam) -- Сама функция, в которой будем обрабатывать горячие клавиши. Обратите внимание, что данный способ является наиболее верным в плане оптимизации.
--     if msg == wm.WM_KEYDOWN or msg == wm.WM_SYSKEYDOWN then -- Если клавиша нажата
--         if wparam == key.VK_ESCAPE then -- И если это клавиша X
--             setVirtualKeyDown(VK_ESCAPE, true)
--             renderWindow[0] = not renderWindow[0] -- Переключаем состояние рендера
--         end
--     end
-- end)

addEventHandler('onWindowMessage', function(msg, wparam, lparam) -- local wm = require('window.message')?
    if wparam == 27 then
        if renderWindow[0]  then -- почему бы не копировать код, не смотря в код сниппета/функции?
            if msg == wm.WM_KEYDOWN then
                consumeWindowMessage(true, false)
            end
            if msg == wm.WM_KEYUP then
                renderWindow[0] = false
            end
        end
    end
end)

function theme()
    imgui.SwitchContext()
    local ImVec4 = imgui.ImVec4
    imgui.GetStyle().WindowPadding = imgui.ImVec2(5, 5)
    imgui.GetStyle().FramePadding = imgui.ImVec2(5, 6)
    imgui.GetStyle().ItemSpacing = imgui.ImVec2(5, 5)
    imgui.GetStyle().ItemInnerSpacing = imgui.ImVec2(2, 2)
    imgui.GetStyle().TouchExtraPadding = imgui.ImVec2(0, 0)
    imgui.GetStyle().IndentSpacing = 0
    imgui.GetStyle().ScrollbarSize = 10
    imgui.GetStyle().GrabMinSize = 10
    imgui.GetStyle().WindowBorderSize = 1
    imgui.GetStyle().ChildBorderSize = 1

    imgui.GetStyle().PopupBorderSize = 1
    imgui.GetStyle().FrameBorderSize = 1
    imgui.GetStyle().TabBorderSize = 1
    imgui.GetStyle().WindowRounding = 8
    imgui.GetStyle().ChildRounding = 8
    imgui.GetStyle().FrameRounding = 8
    imgui.GetStyle().PopupRounding = 8
    imgui.GetStyle().ScrollbarRounding = 8
    imgui.GetStyle().GrabRounding = 8
    imgui.GetStyle().TabRounding = 8

    imgui.GetStyle().Colors[imgui.Col.Text]                   = ImVec4(1.00, 1.00, 1.00, 1.00);
    imgui.GetStyle().Colors[imgui.Col.TextDisabled]           = ImVec4(1.00, 1.00, 1.00, 0.43);
    imgui.GetStyle().Colors[imgui.Col.WindowBg]               = ImVec4(0.00, 0.00, 0.00, 0.90);
    imgui.GetStyle().Colors[imgui.Col.ChildBg]                = ImVec4(1.00, 1.00, 1.00, 0.07);
    imgui.GetStyle().Colors[imgui.Col.PopupBg]                = ImVec4(0.00, 0.00, 0.00, 0.94);
    imgui.GetStyle().Colors[imgui.Col.Border]                 = ImVec4(1.00, 1.00, 1.00, 0.00);
    imgui.GetStyle().Colors[imgui.Col.BorderShadow]           = ImVec4(1.00, 0.00, 0.00, 0.32);
    imgui.GetStyle().Colors[imgui.Col.FrameBg]                = ImVec4(1.00, 1.00, 1.00, 0.09);
    imgui.GetStyle().Colors[imgui.Col.FrameBgHovered]         = ImVec4(1.00, 1.00, 1.00, 0.17);
    imgui.GetStyle().Colors[imgui.Col.FrameBgActive]          = ImVec4(1.00, 1.00, 1.00, 0.26);
    imgui.GetStyle().Colors[imgui.Col.TitleBg]                = ImVec4(0.19, 0.00, 0.00, 1.00);
    imgui.GetStyle().Colors[imgui.Col.TitleBgActive]          = ImVec4(0.46, 0.00, 0.00, 1.00);
    imgui.GetStyle().Colors[imgui.Col.TitleBgCollapsed]       = ImVec4(0.20, 0.00, 0.00, 1.00);
    imgui.GetStyle().Colors[imgui.Col.MenuBarBg]              = ImVec4(0.14, 0.03, 0.03, 1.00);
    imgui.GetStyle().Colors[imgui.Col.ScrollbarBg]            = ImVec4(0.19, 0.00, 0.00, 0.53);
    imgui.GetStyle().Colors[imgui.Col.ScrollbarGrab]          = ImVec4(1.00, 1.00, 1.00, 0.11);
    imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabHovered]   = ImVec4(1.00, 1.00, 1.00, 0.24);
    imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabActive]    = ImVec4(1.00, 1.00, 1.00, 0.35);
    imgui.GetStyle().Colors[imgui.Col.CheckMark]              = ImVec4(1.00, 1.00, 1.00, 1.00);
    imgui.GetStyle().Colors[imgui.Col.SliderGrab]             = ImVec4(1.00, 0.00, 0.00, 0.34);
    imgui.GetStyle().Colors[imgui.Col.SliderGrabActive]       = ImVec4(1.00, 0.00, 0.00, 0.51);
    imgui.GetStyle().Colors[imgui.Col.Button]                 = ImVec4(1.00, 0.00, 0.00, 0.19);
    imgui.GetStyle().Colors[imgui.Col.ButtonHovered]          = ImVec4(1.00, 0.00, 0.00, 0.31);
    imgui.GetStyle().Colors[imgui.Col.ButtonActive]           = ImVec4(1.00, 0.00, 0.00, 0.46);
    imgui.GetStyle().Colors[imgui.Col.Header]                 = ImVec4(1.00, 0.00, 0.00, 0.19);
    imgui.GetStyle().Colors[imgui.Col.HeaderHovered]          = ImVec4(1.00, 0.00, 0.00, 0.30);
    imgui.GetStyle().Colors[imgui.Col.HeaderActive]           = ImVec4(1.00, 0.00, 0.00, 0.50);
    imgui.GetStyle().Colors[imgui.Col.Separator]              = ImVec4(1.00, 0.00, 0.00, 0.41);
    imgui.GetStyle().Colors[imgui.Col.SeparatorHovered]       = ImVec4(1.00, 1.00, 1.00, 0.78);
    imgui.GetStyle().Colors[imgui.Col.SeparatorActive]        = ImVec4(1.00, 1.00, 1.00, 1.00);
    imgui.GetStyle().Colors[imgui.Col.ResizeGrip]             = ImVec4(0.19, 0.00, 0.00, 0.53);
    imgui.GetStyle().Colors[imgui.Col.ResizeGripHovered]      = ImVec4(0.43, 0.00, 0.00, 0.75);
    imgui.GetStyle().Colors[imgui.Col.ResizeGripActive]       = ImVec4(0.53, 0.00, 0.00, 0.95);
    imgui.GetStyle().Colors[imgui.Col.Tab]                    = ImVec4(1.00, 0.00, 0.00, 0.27);
    imgui.GetStyle().Colors[imgui.Col.TabHovered]             = ImVec4(1.00, 0.00, 0.00, 0.48);
    imgui.GetStyle().Colors[imgui.Col.TabActive]              = ImVec4(1.00, 0.00, 0.00, 0.60);
    imgui.GetStyle().Colors[imgui.Col.TabUnfocused]           = ImVec4(1.00, 0.00, 0.00, 0.27);
    imgui.GetStyle().Colors[imgui.Col.TabUnfocusedActive]     = ImVec4(1.00, 0.00, 0.00, 0.54);
    imgui.GetStyle().Colors[imgui.Col.PlotLines]              = ImVec4(0.61, 0.61, 0.61, 1.00);
    imgui.GetStyle().Colors[imgui.Col.PlotLinesHovered]       = ImVec4(1.00, 0.43, 0.35, 1.00);
    imgui.GetStyle().Colors[imgui.Col.PlotHistogram]          = ImVec4(0.90, 0.70, 0.00, 1.00);
    imgui.GetStyle().Colors[imgui.Col.PlotHistogramHovered]   = ImVec4(1.00, 0.60, 0.00, 1.00);
    imgui.GetStyle().Colors[imgui.Col.TextSelectedBg]         = ImVec4(1.00, 1.00, 1.00, 0.35);
    imgui.GetStyle().Colors[imgui.Col.DragDropTarget]         = ImVec4(1.00, 1.00, 0.00, 0.90);
    imgui.GetStyle().Colors[imgui.Col.NavHighlight]           = ImVec4(0.26, 0.59, 0.98, 1.00);
    imgui.GetStyle().Colors[imgui.Col.NavWindowingHighlight]  = ImVec4(1.00, 1.00, 1.00, 0.70);
    imgui.GetStyle().Colors[imgui.Col.NavWindowingDimBg]      = ImVec4(0.80, 0.80, 0.80, 0.20);
    imgui.GetStyle().Colors[imgui.Col.ModalWindowDimBg]       = ImVec4(0.80, 0.80, 0.80, 0.35);
end

function autoupdate(json_url, prefix, url)
  local dlstatus = require('moonloader').download_status
  local json = getWorkingDirectory() .. '\\'..thisScript().name..'-version.json'
  if doesFileExist(json) then os.remove(json) end
  downloadUrlToFile(json_url, json,
    function(id, status, p1, p2)
      if status == dlstatus.STATUSEX_ENDDOWNLOAD then
        if doesFileExist(json) then
          local f = io.open(json, 'r')
          if f then
            local info = decodeJson(f:read('*a'))
            updatelink = info.updateurl
            updateversion = info.latest
            f:close()
            os.remove(json)
            if updateversion ~= thisScript().version then
              lua_thread.create(function(prefix)
                local dlstatus = require('moonloader').download_status
                local color = -1
                sampAddChatMessage((prefix..'Обнаружено обновление. Пытаюсь обновиться c '..thisScript().version..' на '..updateversion), color)
                wait(250)
                downloadUrlToFile(updatelink, thisScript().path,
                  function(id3, status1, p13, p23)
                    if status1 == dlstatus.STATUS_DOWNLOADINGDATA then
                      print(string.format('Загружено %d из %d.', p13, p23))
                    elseif status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
                      print('Загрузка обновления завершена.')
                      sampAddChatMessage((prefix..'Обновление завершено!'), color)
                      goupdatestatus = true
                      lua_thread.create(function() wait(500) thisScript():reload() end)
                    end
                    if status1 == dlstatus.STATUSEX_ENDDOWNLOAD then
                      if goupdatestatus == nil then
                        sampAddChatMessage((prefix..'Обновление прошло неудачно. Запускаю устаревшую версию..'), color)
                        update = false
                      end
                    end
                  end
                )
                end, prefix
              )
            else
              update = false
              print('v'..thisScript().version..': Обновление не требуется.')
            end
          end
        else
          print('v'..thisScript().version..': Не могу проверить обновление. Смиритесь или проверьте самостоятельно на '..url)
          update = false
        end
      end
    end
  )
  while update ~= false do wait(100) end
end

-- function check_update()
-- 	print('[Justice Helper] Начинаю проверку на наличие обновлений...')
-- 	sampAddChatMessage('[Justice Helper] {ffffff}Начинаю проверку на наличие обновлений...', message_color)
-- 	local path = configDirectory .. "/Update_Info.json"
-- 	os.remove(path)
-- 	local url = 'https://github.com/MTGMODS/lua_scripts/raw/refs/heads/main/justice-helper/Update_Info.json'
-- 	if isMonetLoader() then
-- 		downloadToFile(url, path, function(type, pos, total_size)
-- 			if type == "finished" then
-- 				local updateInfo = readJsonFile(path)
-- 				if updateInfo then
-- 					local uVer = updateInfo.current_version
-- 					local uUrl = updateInfo.update_url
-- 					local uText = updateInfo.update_info
-- 					print("[Justice Helper] Текущая установленная версия:", thisScript().version)
-- 					print("[Justice Helper] Текущая версия в облаке:", uVer)
-- 					if thisScript().version ~= uVer then
-- 						print('[Justice Helper] Доступно обновление!')
-- 						sampAddChatMessage('[Justice Helper] {ffffff}Доступно обновление!', message_color)
-- 						need_update_helper = true
-- 						updateUrl = uUrl
-- 						updateVer = uVer
-- 						updateInfoText = uText
-- 						UpdateWindow[0] = true
-- 					else
-- 						print('[Justice Helper] Обновление не нужно!')
-- 						sampAddChatMessage('[Justice Helper] {ffffff}Обновление не нужно, у вас актуальная версия!', message_color)
-- 					end
-- 				end
-- 			end
-- 		end)
-- 	else
-- 		downloadUrlToFile(url, path, function(id, status)
-- 			if status == 6 then -- ENDDOWNLOADDATA
-- 				local updateInfo = readJsonFile(path)
-- 				if updateInfo then
-- 					local uVer = updateInfo.current_version
-- 					local uUrl = updateInfo.update_url
-- 					local uText = updateInfo.update_info
-- 					print("[Justice Helper] Текущая установленная версия:", thisScript().version)
-- 					print("[Justice Helper] Текущая версия в облаке:", uVer)
-- 					if thisScript().version ~= uVer then
-- 						print('[Justice Helper] Доступно обновление!')
-- 						sampAddChatMessage('[Justice Helper] {ffffff}Доступно обновление!', message_color)
-- 						need_update_helper = true
-- 						updateUrl = uUrl
-- 						updateVer = uVer
-- 						updateInfoText = uText
-- 						UpdateWindow[0] = true
-- 					else
-- 						print('[Justice Helper] Обновление не нужно!')
-- 						sampAddChatMessage('[Justice Helper] {ffffff}Обновление не нужно, у вас актуальная версия!', message_color)
-- 					end
-- 				end
-- 			end
-- 		end)
-- 	end
-- 	function readJsonFile(filePath)
-- 		if not doesFileExist(filePath) then
-- 			print("[Justice Helper] Ошибка: Файл " .. filePath .. " не существует")
-- 			return nil
-- 		end
-- 		local file = io.open(filePath, "r")
-- 		local content = file:read("*a")
-- 		file:close()
-- 		local jsonData = decodeJson(content)
-- 		if not jsonData then
-- 			print("[Justice Helper] Ошибка: Неверный формат JSON в файле " .. filePath)
-- 			return nil
-- 		end
-- 		return jsonData
-- 	end
-- end
-- function downloadToFile(url, path, callback, progressInterval)
-- 	callback = callback or function() end
-- 	progressInterval = progressInterval or 0.1

-- 	local effil = require("effil")
-- 	local progressChannel = effil.channel(0)

-- 	local runner = effil.thread(function(url, path)
-- 	local http = require("socket.http")
-- 	local ltn = require("ltn12")

-- 	local r, c, h = http.request({
-- 		method = "HEAD",
-- 		url = url,
-- 	})

-- 	if c ~= 200 then
-- 		return false, c
-- 	end
-- 	local total_size = h["content-length"]

-- 	local f = io.open(path, "wb")
-- 	if not f then
-- 		return false, "failed to open file"
-- 	end
-- 	local success, res, status_code = pcall(http.request, {
-- 		method = "GET",
-- 		url = url,
-- 		sink = function(chunk, err)
-- 		local clock = os.clock()
-- 		if chunk and not lastProgress or (clock - lastProgress) >= progressInterval then
-- 			progressChannel:push("downloading", f:seek("end"), total_size)
-- 			lastProgress = os.clock()
-- 		elseif err then
-- 			progressChannel:push("error", err)
-- 		end

-- 		return ltn.sink.file(f)(chunk, err)
-- 		end,
-- 	})

-- 	if not success then
-- 		return false, res
-- 	end

-- 	if not res then
-- 		return false, status_code
-- 	end

-- 	return true, total_size
-- 	end)
-- 	local thread = runner(url, path)

-- 	local function checkStatus()
-- 	local tstatus = thread:status()
-- 	if tstatus == "failed" or tstatus == "completed" then
-- 		local result, value = thread:get()

-- 		if result then
-- 		callback("finished", value)
-- 		else
-- 		callback("error", value)
-- 		end

-- 		return true
-- 	end
-- 	end

-- 	lua_thread.create(function()
-- 	if checkStatus() then
-- 		return
-- 	end

-- 	while thread:status() == "running" do
-- 		if progressChannel:size() > 0 then
-- 		local type, pos, total_size = progressChannel:pop()
-- 		callback(type, pos, total_size)
-- 		end
-- 		wait(0)
-- 	end

-- 	checkStatus()
-- 	end)
-- end
-- function downloadFileFromUrlToPath(url, path)
-- 	print('[Justice Helper] Начинаю скачивание файла в ' .. path)
-- 	if isMonetLoader() then
-- 		downloadToFile(url, path, function(type, pos, total_size)
-- 			if type == "downloading" then
-- 				--print(("Скачивание %d/%d"):format(pos, total_size))
-- 			elseif type == "finished" then
-- 				if download_helper then
-- 					sampAddChatMessage('[Justice Helper] {ffffff}Загрузка новой версии хелпера завершена успешно! Перезагрузка..',  message_color)
-- 					reload_script = true
-- 					thisScript():unload()
-- 				elseif download_smartuk then
-- 					sampAddChatMessage('[Justice Helper] {ffffff}Загрузка умной выдачи розыска для сервера ' .. getARZServerName(getARZServerNumber()) .. ' [' .. getARZServerNumber() ..  '] завершена успешно!',  message_color)
-- 					download_smartuk = false
-- 					load_smart_uk()
-- 				elseif download_smartpdd then
-- 					sampAddChatMessage('[Justice Helper] {ffffff}Загрузка умной выдачи штрафов для сервера ' .. getARZServerName(getARZServerNumber()) .. ' [' .. getARZServerNumber() ..  '] завершена успешно!',  message_color)
-- 					download_smartpdd = false
-- 					load_smart_pdd()
-- 				elseif download_arzvehicles then
-- 					sampAddChatMessage('[Justice Helper] {ffffff}Загрузка списка моделей кастом каров аризоны заверешена успешно!',  message_color)
-- 					sampAddChatMessage('[Justice Helper] {ffffff}Повторно используйте нужную команду которая требует определение модели т/c.',  message_color)
-- 					download_arzvehicles = false
-- 					load_arzvehicles()
-- 				end
-- 			elseif type == "error" then
-- 				sampAddChatMessage('[Justice Helper] {ffffff}Ошибка загрузки: ' .. pos,  message_color)
-- 			end
-- 		end)
-- 	else
-- 		downloadUrlToFile(url, path, function(id, status)
-- 			if status == 6 then -- ENDDOWNLOADDATA
-- 				if download_helper then
-- 					sampAddChatMessage('[Justice Helper] {ffffff}Загрузка новой версии хелпера завершена успешно! Перезагрузка..',  message_color)
-- 					reload_script = true
-- 					thisScript():unload()
-- 				elseif download_smartuk then
-- 					sampAddChatMessage('[Justice Helper] {ffffff}Загрузка умной выдачи розыска для сервера ' .. getARZServerName(getARZServerNumber()) .. ' [' .. getARZServerNumber() ..  '] завершена успешно!',  message_color)
-- 					download_smartuk = false
-- 					load_smart_uk()
-- 				elseif download_smartpdd then
-- 					sampAddChatMessage('[Justice Helper] {ffffff}Загрузка умной выдачи штрафов для сервера ' .. getARZServerName(getARZServerNumber()) .. ' [' .. getARZServerNumber() ..  '] завершена успешно!',  message_color)
-- 					download_smartpdd = false
-- 					load_smart_pdd()
-- 				elseif download_arzvehicles then
-- 					sampAddChatMessage('[Justice Helper] {ffffff}Загрузка списка моделей кастом каров аризоны заверешена успешно!',  message_color)
-- 					sampAddChatMessage('[Justice Helper] {ffffff}Повторно используйте нужную команду которая требует определение модели т/c.',  message_color)
-- 					download_arzvehicles = false
-- 					load_arzvehicles()
-- 				end
-- 			end
-- 		end)
-- 	end
-- end
