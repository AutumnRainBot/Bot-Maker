repeat wait() until game:IsLoaded()
wait(2)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Bot Maker Universal", "BloodTheme")
--Page
local main = Window:NewTab("Main")
local boted = Window:NewTab("Bot")
local FileSave = Window:NewTab("Save File")
--Section
local mainsection = main:NewSection("Bot Maker Made By Momo.#2706")
local botedsection = boted:NewSection("Make your own auto farm bot")
local paramssection = boted:NewSection("Parameters")
local filesection = FileSave:NewSection("Import/Export bot files")
--variables
local waittime = 0
local tweenspeed = 200 --default speed
local savename = "exported bot config"
local bottxtimport = nil
local launched = false
local loopspeed = 2 --default speed
local posi = {}
--config for save and load file 
local file_name = "config.json"
--basic table for saving config
local ConfigTable = {
    IsLooped = false,
    canServerhop = false,
    AutoTrinkets= false,
    ServerHopPos = false,
}
--load config function
function loadSettings()
    print("Loading config")
    local HttpService = game:GetService("HttpService")
    if (readfile and isfile and isfile(file_name)) then
        ConfigTable = HttpService:JSONDecode(readfile(file_name));
        --reading temp pos file for bot
        posi = {}
        local file = readfile("TempPos"..".json")
        for word in string.gmatch(file, '([^a]+)') do
            table.insert(posi,(word))
        end
        print("Loaded config")
    else
        print("Error while loading config")
    end
end
--save config function
function saveSettings()
    print("saving config")
    local json;
    local HttpService = game:GetService("HttpService");
    if(writefile) then
        json = HttpService:JSONEncode(ConfigTable);
        writefile(file_name, json);
    --saving position table in a separate file
    writefile("TempPos"..".json","")
    for i , v in pairs(posi)do
        if i == #posi - 0 then 
            appendfile("TempPos"..".json",tostring(v).."a")
            else
            appendfile("TempPos"..".json",tostring(v).."a".."\n")
        end
    end
        else
            print("Error while saving co nfig")
    end
end

loadSettings()

--wait between
paramssection:NewSlider("Wait time position","", 45, 1, function(s)
    waittime = s
end)
--loop speed
paramssection:NewSlider("Loop speed","", 45, 1, function(s)
    loopspeed = s
end)
--tween speed 
paramssection:NewSlider("Tween Speed","", 750, 1, function(s)
    tweenspeed = s
end)

--server hopping esssentials
function servhop()
    game:GetService("TeleportService"):Teleport(game.PlaceId)
end

local TweenPlayer
--main functions
local function farm()
    launched = true
    function tweenplayer(cframe)
        TweenPlayer = game:GetService("TweenService"):Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(((cframe.p - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)/tweenspeed, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false), {CFrame = cframe})
        TweenPlayer:Play()
        TweenPlayer.Completed:Wait() wait(1)
    end
    for i,v in pairs(posi) do
        print(v)
    end
    if posi ~= nil then
        for i , v in pairs(posi)do
            game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = true
            if type(v) =="string" then
            tweenplayer(CFrame.new(unpack(v:split(", "))))
            else
                tweenplayer(CFrame.new(v))
                wait(waittime)
                game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
                wait(waittime)
                game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
            end
            wait(waittime)
            game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
        end
    end
    launched = false
    if ConfigTable.canServerhop then
        servhop()
    end
    wait(2)
end
--save position    
botedsection:NewButton("Save Position","",function()
    local pos = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
    table.insert(posi,pos)
    saveSettings()
end)
--start bot
botedsection:NewButton("Load Position","",function()
    farm()
end)
--remove all position
botedsection:NewButton("Clear All Position","",function()
    posi = {}
    saveSettings()
end)
--loop
botedsection:NewToggle("Loop Bot On/Off (Single Server)", "", function(state)
   ConfigTable.IsLooped = state
   saveSettings()
end)

--server hop mode
botedsection:NewToggle("Bot Then Server Hop","nil",function(state)
    ConfigTable.ServerHopPos = state
    ConfigTable.canServerhop = state
    saveSettings()
 end)

--auto trinkets fim
 botedsection:NewToggle("Auto Pickup (fim)","nil",function(state)
    ConfigTable.AutoTrinkets = state
    saveSettings()
 end)
--server hop
botedsection:NewButton("Server Hop","", function()
    game:GetService("TeleportService"):Teleport(game.PlaceId)
 end)
--export file name
filesection:NewTextBox("Export File Name", "FILE NAME", function(txt)
    savename = txt
    print(savename)
    saveSettings()
end)
--import file name
filesection:NewTextBox("Import File Name", "FILE NAME", function(txt)
    bottxtimport = txt
    print(savename)
    saveSettings()
end)
--export file button
filesection:NewButton("Export bot file","",function(txt)
    writefile(tostring(savename)..".json","")
    for i , v in pairs(posi)do
        if i == #posi - 0 then 
            appendfile(tostring(savename)..".json",tostring(v).."a")
            else
            appendfile(tostring(savename)..".json",tostring(v).."a".."\n")
        end
    end
    saveSettings()
end)
--import file bot config
filesection:NewButton("Import Bot file","",function(txt)
    posi = {}
    local file = readfile(tostring(bottxtimport)..".json")
    for word in string.gmatch(file, '([^a]+)') do
        table.insert(posi,(word))
    end
    for i,v in pairs(posi)do
        print(v)
    end
    saveSettings()
end)
--auto loop farm
game:GetService("RunService").RenderStepped:Connect(function()
	if ConfigTable.IsLooped then
		if not launched then
            launched = true
            wait(loopspeed)
            farm()
        end
	end
end)
local deb = false
--loop for server hop bot (momo was here :p)
game:GetService("RunService").RenderStepped:Connect(function()
	if ConfigTable.ServerHopPos and not deb then
        if not launched then
            deb = true
            farm()
        end
    end
end)

--auto pickup trinkets
game:GetService("RunService").RenderStepped:Connect(function()
	if ConfigTable.AutoTrinkets then
        for i,v in pairs(game:GetService("Workspace").Trinkets:GetDescendants())do
            if v.ClassName == "ClickDetector" then
                local distance = (v.Parent.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                if distance < 13 then
                    fireclickdetector(v)
                end
            end
        end
	end
end)
