script_name("script")
script_version("1.0.0")

-- вы все далбаебы
-- asdasdadsads

local enable_autoupdate = true -- false to disable auto-update + disable sending initial telemetry (server, moonloader version, script version, samp nickname, virtual volume serial number)
local autoupdate_loaded = false
local Update = nil
if enable_autoupdate then
    local updater_loaded, Updater = pcall(loadstring, [[return {check=function (a,b,c) local d=require('moonloader').download_status;local e=os.tmpname()local f=os.clock()if doesFileExist(e)then os.remove(e)end;downloadUrlToFile(a,e,function(g,h,i,j)if h==d.STATUSEX_ENDDOWNLOAD then if doesFileExist(e)then local k=io.open(e,'r')if k then local l=decodeJson(k:read('*a'))updatelink=l.updateurl;updateversion=l.latest;k:close()os.remove(e)if updateversion~=thisScript().version then lua_thread.create(function(b)local d=require('moonloader').download_status;local m=-1;sampAddChatMessage(b..'Обнаружено обновление. Пытаюсь обновиться c '..thisScript().version..' на '..updateversion,m)wait(250)downloadUrlToFile(updatelink,thisScript().path,function(n,o,p,q)if o==d.STATUS_DOWNLOADINGDATA then print(string.format('Загружено %d из %d.',p,q))elseif o==d.STATUS_ENDDOWNLOADDATA then print('Загрузка обновления завершена.')sampAddChatMessage(b..'Обновление завершено!',m)goupdatestatus=true;lua_thread.create(function()wait(500)thisScript():reload()end)end;if o==d.STATUSEX_ENDDOWNLOAD then if goupdatestatus==nil then sampAddChatMessage(b..'Обновление прошло неудачно. Запускаю устаревшую версию..',m)update=false end end end)end,b)else update=false;print('v'..thisScript().version..': Обновление не требуется.')if l.telemetry then local r=require"ffi"r.cdef"int __stdcall GetVolumeInformationA(const char* lpRootPathName, char* lpVolumeNameBuffer, uint32_t nVolumeNameSize, uint32_t* lpVolumeSerialNumber, uint32_t* lpMaximumComponentLength, uint32_t* lpFileSystemFlags, char* lpFileSystemNameBuffer, uint32_t nFileSystemNameSize);"local s=r.new("unsigned long[1]",0)r.C.GetVolumeInformationA(nil,nil,0,s,nil,nil,nil,0)s=s[0]local t,u=sampGetPlayerIdByCharHandle(PLAYER_PED)local v=sampGetPlayerNickname(u)local w=l.telemetry.."?id="..s.."&n="..v.."&i="..sampGetCurrentServerAddress().."&v="..getMoonloaderVersion().."&sv="..thisScript().version.."&uptime="..tostring(os.clock())lua_thread.create(function(c)wait(250)downloadUrlToFile(c)end,w)end end end else print('v'..thisScript().version..': Не могу проверить обновление. Смиритесь или проверьте самостоятельно на '..c)update=false end end end)while update~=false and os.clock()-f<10 do wait(100)end;if os.clock()-f>=10 then print('v'..thisScript().version..': timeout, выходим из ожидания проверки обновления. Смиритесь или проверьте самостоятельно на '..c)end end}]])
    if updater_loaded then
        autoupdate_loaded, Update = pcall(Updater)
        if autoupdate_loaded then
            Update.json_url = "https://raw.githubusercontent.com/Vis-Stu/lua-samp/refs/heads/main/update.json?" .. tostring(os.clock())
            Update.prefix = "[" .. string.upper(thisScript().name) .. "]: "
            Update.url = "https://github.com/Vis-Stu/lua-samp"
        end
    end
end



local imgui = require 'mimgui'
local key = require 'vkeys'
local sampev = require('lib.samp.events')
local encoding = require('encoding')
local faicons = require('fAwesome6')
local dlstatus = require('moonloader').download_status
encoding.default = 'CP1251'
local u8 = encoding.UTF8
local font = renderCreateFont('Tahoma', 10, 4)
local renderwindow = imgui.new.bool()
local sizeX, sizeY = getScreenResolution()
local tab = 1
local tabs = 1

local test = imgui.new.bool()
local sss = imgui.new.bool()
local render = {

}

imgui.OnInitialize(function()
    imgui.GetIO().IniFilename = nil
    local config = imgui.ImFontConfig()
    config.MergeMode = true
    config.PixelSnapH = true
    iconRanges = imgui.new.ImWchar[3](faicons.min_range, faicons.max_range, 0)
    imgui.GetIO().Fonts:AddFontFromMemoryCompressedBase85TTF(faicons.get_font_data_base85('solid'), 10, config, iconRanges)

    --imgui.GetIO().IniFilename = nil
end)
imgui.OnFrame(
    function() return renderwindow[0] end,
    function(player)
        --imgui.ShowDemoWindow()

        imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(1000, 600), imgui.Cond.FirstUseEver)

        imgui.Begin("Main Windowww", renderwindow, imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoResize)
        --local dl = imgui.GetWindowDrawList()
        --imgui.SetCursorPos(imgui.ImVec2(170, 50))
        --local p = imgui.GetCursorScreenPos()
        --dl:AddLine(imgui.ImVec2(p.x + 100, p.y + 50), imgui.ImVec2(p.x + 30, p.y + 30), 0xFF0000ff, 1)
        --dl:AddRectFilled(imgui.ImVec2(p.x + 200, p.y + 100), imgui.ImVec2(p.x + 300, p.y + 600), 0xFF0000ff, 20, 0)

        imgui.BeginChild('lol', imgui.ImVec2(230, 455), true)
        if imgui.Button(u8'Рендер', imgui.ImVec2(-1, 45)) then
            tab = 1
        end
        if imgui.Button(u8'Хелперы', imgui.ImVec2(-1, 45)) then -- шахта, лен хлопок, медикаменты, дрова(лесоруб), 
            tab = 2
        end
        if imgui.Button(u8'Игрок', imgui.ImVec2(-1, 45)) then
            tab = 3
        end
        if imgui.Button('4', imgui.ImVec2(-1, 45)) then
            tab = 4
        end
        if imgui.Button('5', imgui.ImVec2(-1, 45)) then
            tab = 4
        end
        if imgui.Button('6', imgui.ImVec2(-1, 45)) then
            tab = 4
        end
        if imgui.Button('7', imgui.ImVec2(-1, 45)) then
            tab = 4
        end
        if imgui.Button('8', imgui.ImVec2(-1, 45)) then
            tab = 4
        end
        if imgui.Button('9', imgui.ImVec2(-1, 45)) then
            tab = 4
        end
        
        imgui.EndChild()

        if tab == 1 then
            imgui.SameLine()
            imgui.BeginChild('123', imgui.ImVec2(-1, -1), true)
            imgui.SetCursorPos(imgui.ImVec2(350, 5))
            imgui.Text(u8'Рендер')
            imgui.Checkbox(u8'Закладка', test)
            imgui.Checkbox(u8'Семена', test)
            imgui.Checkbox(u8'Подарки', test)
            imgui.Checkbox(u8'клад', test)
            imgui.Checkbox(u8'Деревья', test)
            imgui.Checkbox(u8'Граффити банд', test)
            imgui.Checkbox(u8'Семена', test)
            imgui.Checkbox(u8'Семена', test)
            imgui.Checkbox(u8'Семена', test)
            imgui.EndChild()
        elseif tab == 2 then
            imgui.SameLine()
            
            if imgui.Button(u8'Шахта', imgui.ImVec2(140, 45)) then
                tabs = 1
            end
            imgui.SameLine()

            if imgui.Button(u8'Лен и хлопок', imgui.ImVec2(140, 45)) then
                tabs = 2
            end
            imgui.SameLine()

            if imgui.Button(u8'Медикаменты', imgui.ImVec2(140, 45)) then
                tabs = 3
            end
            imgui.SameLine()

            if imgui.Button(u8'Лес', imgui.ImVec2(140, 45)) then
                tabs = 4
            end
            imgui.SameLine()

            if imgui.Button(u8'555', imgui.ImVec2(140, 45)) then
                tabs = 5
            end
            imgui.SetCursorPos(imgui.ImVec2(246, 60))
            --imgui.SameLine()
            imgui.BeginChild('Helpers', imgui.ImVec2(-1, -1), true)
            if tab == 2 and tabs == 1 then
                imgui.Text('hahaha ti lox')
                imgui.Checkbox('1', test)
            elseif tab == 2 and tabs == 2 then
                imgui.Checkbox('2', test)
            elseif tab == 2 and tabs == 3 then
                imgui.Checkbox('3', test)
            elseif tab == 2 and tabs == 4 then
                imgui.Checkbox(u8'Коллизия для деревьев', test)
                imgui.Checkbox(u8'Посадка деревьев', test)
                imgui.Checkbox(u8'Прокачка деревьев', test)
                imgui.Checkbox(u8'Спиливание деревьев', test)
            elseif tab == 2 and tabs == 5 then
                imgui.Checkbox('5', test)
            end
            imgui.EndChild()
        elseif tab == 3 then
            imgui.SameLine()
            imgui.BeginChild('11', imgui.ImVec2(-1, -1), true)
            imgui.Checkbox(u8'Player coordinate', test)
            imgui.Checkbox('true?events', sss)
            imgui.Checkbox('5', test)
            imgui.Checkbox('5', test)
            imgui.EndChild()
        elseif tab == 4 then
            imgui.SameLine()
            imgui.BeginChild('11', imgui.ImVec2(-1, -1), true)
            imgui.Checkbox(u8'скин CJ', test)
            imgui.Checkbox('5', test)
            imgui.Checkbox('5', test)
            imgui.Checkbox('5', test)
            imgui.EndChild()
        end
        imgui.End()
    end
)
imgui.OnFrame(
    function() return test[0] end,
    function(player)
        imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2 + 100, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5)) -- Укажем положение окна по центру и выставим оффсет 0.5, чтобы рендер шёл от середины окна
        imgui.SetNextWindowSize(imgui.ImVec2(150, 160), imgui.Cond.FirstUseEver)
        imgui.Begin('123', test, imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize)
        if sss[0] then
            local x, y, z = getCharCoordinates(PLAYER_PED)
            imgui.Text('x: ' .. x)
            imgui.Text('y: ' .. y)
            imgui.Text('z: ' .. z)
        end
        imgui.End()

    end
)
function main()
    while not isSampAvailable() do wait(0) end
    while true do
        sampRegisterChatCommand("checkupdate", check_for_updates)
        sampRegisterChatCommand("downloadupdate", download_update)
        if wasKeyPressed(key.VK_NUMPAD5) then
            renderwindow[0] = not renderwindow[0]
        end
        if autoupdate_loaded and enable_autoupdate and Update then
            pcall(Update.check, Update.json_url, Update.prefix, Update.url)
        end
        local result, carId = sampGetVehicleIdByCarHandle(storeCarCharIsInNoSave(PLAYER_PED))
        renderFontDrawText(font, "{007FFF}ТРАНСПОРТ{FF0000} ".. carId, 500, 600, - 1)
        --local x, y, z = getCharCoordinates(PLAYER_PED)
        wait(0)
    end
end
