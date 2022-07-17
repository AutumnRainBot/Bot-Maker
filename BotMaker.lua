repeat task.wait() until game:IsLoaded()
wait(3)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/GreenDeno/Venyx-UI-Library/main/source.lua"))()
local Window = Library.new("Bot Maker", 5013109572)
--nofall fim
--game.Players.LocalPlayer.Character.CharacterHandler.Remotes.ApplyFallDamage:Destroy()
--main tab
local main = Window:addPage("Main", 5012544693)

local mainsection = main:addSection("Bot Maker Made By Momo.#2706")
--variables
local waittime = 0
local tweenspeed = 200 --default speed
local savename = "exported bot config"
local bottxtimport = nil
local launched = false
local loopspeed = 2 --default speed
local posi = {}
--config for save and load file 
local file_name = "config.txt"
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
        local file = readfile("TempPos"..".txt")
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
    writefile("TempPos"..".txt","")
    for i , v in pairs(posi)do
        if i == #posi - 0 then 
            appendfile("TempPos"..".txt",tostring(v).."a")
            else
            appendfile("TempPos"..".txt",tostring(v).."a".."\n")
        end
    end
        else
            print("Error while saving config")
    end
end
--on join we load the config
loadSettings()

--Tabs
local boted = Window:addPage("Bot")
local FileSave = Window:addPage("Save File")

--Sections
local botedsection = boted:addSection("Make your own auto farm bot")
local paramssection = boted:addSection("Parameters")
--for FileSave
local filesection = FileSave:addSection("Import/Export bot files")
--wait between
paramssection:addSlider("Wait time pos",0, 45, 1, function(s)
    waittime = s
end)
--loop speed
paramssection:addSlider("Loop speed",0, 45, 1, function(s)
    loopspeed = s
end)
--tween speed 
paramssection:addSlider("Tween Speed",0, 750, 1, function(s)
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
botedsection:addButton("Save Position",function()
    local pos = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
    table.insert(posi,pos)
    saveSettings()
end)
--start bot
botedsection:addButton("Load Position",function()
    farm()
end)
--remove all position
botedsection:addButton("Clear All Pos",function()
    posi = {}
    saveSettings()
end)
--loop
botedsection:addToggle("Loop Bot On/Off (Single Server)", nil, function(state)
   ConfigTable.IsLooped = state
   saveSettings()
end)

--server hop mode
botedsection:addToggle("Bot Then Server Hop",nil,function(state)
    ConfigTable.ServerHopPos = state
    ConfigTable.canServerhop = state
    saveSettings()
 end)

--auto trinkets fim
 botedsection:addToggle("Auto Pickup (fim)",nil,function(state)
    ConfigTable.AutoTrinkets = state
    saveSettings()
 end)
--server hop
botedsection:addButton("Server Hop", function()
    game:GetService("TeleportService"):Teleport(game.PlaceId)
 end)
--export file name
filesection:addTextbox("Export File Name", "ENTER HERE FILE NAME", function(txt)
    savename = txt
    print(savename)
    saveSettings()
end)
--import file name
filesection:addTextbox("Import File Name", "ENTER HERE FILE NAME", function(txt)
    bottxtimport = txt
    print(savename)
    saveSettings()
end)
--export file button
filesection:addButton("Export bot file", function(txt)
    writefile(tostring(savename)..".txt","")
    for i , v in pairs(posi)do
        if i == #posi - 0 then 
            appendfile(tostring(savename)..".txt",tostring(v).."a")
            else
            appendfile(tostring(savename)..".txt",tostring(v).."a".."\n")
        end
    end
    saveSettings()
end)
--import file bot config
filesection:addButton("Import Bot file",function(txt)
    posi = {}
    local file = readfile(tostring(bottxtimport)..".txt")
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
--save settings on join
saveSettings()
Window:SelectPage(venyx.pages[1], true)
