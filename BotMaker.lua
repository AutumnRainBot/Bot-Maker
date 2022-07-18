repeat wait() until game:IsLoaded()
wait(2)
local Library = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = Library:MakeWindow({Name = "Bot Maker Universal", HidePremium = false, SaveConfig = true, ConfigFolder = "OrionTest"})

--Page
local main = Window:MakeTab({
	Name = "Main",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})
local boted = Window:MakeTab({
	Name = "Bot",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})
local FileSave = Window:MakeTab({
	Name = "Save File",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})
--Section
local mainsection = main:AddSection({
	Name = "Bot Maker Universal Made By Momo.#2706",
})
local botedsection = boted:AddSection({
	Name = "Make your own auto farm bot",
})
local ToggleSection = boted:AddSection({
	Name = "Toggles options",
})
local paramssection = boted:AddSection({
	Name = "Parameters",
})
local filesection = FileSave:AddSection({
	Name = "Files Configurations",
})
local subFilesSection = FileSave:AddSection({
	Name = "Import / Export Bot Files",
})
--constants
local savename = "exported bot config"
local bottxtimport = nil
local launched = false
local loopspeed = 2 
local posi = {}
local TweenPlayer

--config for save and load file temp pos file
local file_name = "config.json"
--basic table for saving config
local ConfigTable = {
    IsLooped = false,
    canServerhop = false,
    ServerHopPos = false,
    WaitTime = 0,
    TweenSpeed = 200,
    LoopSpeed = 1,
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
        LoopSingleToggle:Set(ConfigTable.IsLooped)
        ServerHopToggle:Set(ConfigTable.canServerhop)
        TweenSpeedSlider:Set(ConfigTable.TweenSpeed)
        LoopSpeedSlider:Set(ConfigTable.LoopSpeed)
        WaitTimeSlider:Set(ConfigTable.WaitTime)
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
            print("Error while saving config")
    end
end
--load config function
loadSettings()
--// sliders //--

--wait between
local WaitTimeSlider = paramssection:AddSlider({
	Name = "Wait Time Position",
	Min = 0,
	Max = 20,
	Default = 0,
	Color = Color3.fromRGB(255,255,255),
	Increment = 1,
	ValueName = "Secondes",
	Callback = function(s)
		ConfigTable.WaitTime = s
	end    
})
    

--loop speed
local LoopSpeedSlider = paramssection:AddSlider({
	Name = "Loop Speed",
	Min = 0,
	Max = 45,
	Default = 0,
	Color = Color3.fromRGB(255,255,255),
	Increment = 1,
	ValueName = "Secondes",
	Callback = function(s)
		ConfigTable.LoopSpeed = s
	end    
})
--tween speed 
local TweenSpeedSlider = paramssection:AddSlider({
	Name = "Tween Speed",
	Min = 0,
	Max = 750,
	Default = 200,
	Color = Color3.fromRGB(255,255,255),
	Increment = 1,
	ValueName = "Secondes",
	Callback = function(s)
		ConfigTable.TweenSpeed = s
	end    
})

--// functions //--
function servhop()
    game:GetService("TeleportService"):Teleport(game.PlaceId)
end
--main functions
function farm()
    launched = true
    --the main function of tweening the player
    function tweenplayer(cframe)
        --basic of tweening function for player only
        TweenPlayer = game:GetService("TweenService"):Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(((cframe.p - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)/ConfigTable.TweenSpeed, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false), {CFrame = cframe})
        TweenPlayer:Play()
        TweenPlayer.Completed:Wait() wait(1)--wait for tween to finish
    end
    --Tween the player to the position
    if posi ~= nil then--check if there is a position table
        for i , v in pairs(posi)do--loop through the table
            game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = true--anchor the character
            if type(v) =="string" then--check if the value is a string
            tweenplayer(CFrame.new(unpack(v:split(", "))))--if it is a string, convert it to a table and tween the player
            else
                tweenplayer(CFrame.new(v))--if it is not a string, tween the player
                wait(ConfigTable.WaitTime)--obviously wait before next position
                game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false--unanchor the character
            end
            wait(ConfigTable.WaitTime)--obviously wait before next position
            game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false--unanchor the character in case of error
        end
    end
    if ConfigTable.canServerhop then--here we check if the bot can serverhop (we used the toggle button)
        servhop()--server hop '-'
    end
    launched = false--set the bot to not launched so we can now press the button again
end

--// buttons //--
--save position    
botedsection:AddButton({
	Name = "Save Position",
	Callback = function()
        local pos = game.Players.LocalPlayer.Character.HumanoidRootPart.Position --take our current position
        table.insert(posi,pos)--save it into a table
        saveSettings()--save the table into a table that will be saved into a file later
  	end    
})
--start bot
botedsection:AddButton({
	Name = "Load Position",
	Callback = function()
        if not launched then --check because if not we could just spam load position and it goes crazy x)
            saveSettings()--in case of error while saving config
            farm()--actual bot function that tween our position
        end
  	end    
})
--remove all position
botedsection:AddButton({
	Name = "Remove All Positions",
	Callback = function()
        posi = {}--clearing table position (main table)
        saveSettings()--save to config table our choice so we can load it later because we clear the table
  	end    
})
--server hop
botedsection:AddButton({
	Name = "Server Hop",
	Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId)
  	end    
})

--// toggles //--
--loop bot single server
local LoopSingleToggle = ToggleSection:AddToggle({
	Name = "Loop Bot (Single Server)",
	Default = false,
	Callback = function(state)
		ConfigTable.IsLooped = state--toggle to loop bot (checked in the farm function)
        saveSettings()--save to config table our choice so we can load it later
	end    
})

--server hop mode
local ServerHopToggle = ToggleSection:AddToggle({
	Name = "Bot Then Server Hop (Multiple Server)",
	Default = false,
	Callback = function(state)
		ConfigTable.ServerHopPos = state--if this toggle on => set to the config table (farm fuction check if we checking it to server hop or not)
        ConfigTable.canServerhop = state--same here ,i just could do juste one of them but i prefer to do both
        saveSettings()--save to config table our choice so we can load it later
	end    
})

--export file name
filesection:AddTextbox({
	Name = "Export File Name",
	Default = "Bot File Name Here",
	TextDisappear = true,
	Callback = function(txt)
		savename = txt--set the name of the file to export
        saveSettings()
	end	  
})
--import file name
filesection:AddTextbox({
	Name = "Import File Name",
	Default = "Bot File Name Here",
	TextDisappear = true,
	Callback = function(txt)
		bottxtimport = txt--set the name of the file to import
        saveSettings()
	end	  
})
--export file button
subFilesSection:AddButton({
	Name = "Export Bot File",
	Callback = function()
        writefile(tostring(savename)..".json","")--creating a file with the name we choosed
        for i , v in pairs(posi)do --writing the position table in the file
            if i == #posi - 0 then --if it is the last position
                appendfile(tostring(savename)..".json",tostring(v).."a")--adding the position to the file without a jumping line
                else
                appendfile(tostring(savename)..".json",tostring(v).."a".."\n")--adding the position to the file
            end
        end
        print("Exported "..tostring(savename)..".json successfully")--debugging print
        saveSettings()--saving the config cuz we changed it
  	end    
})

--import file bot config
subFilesSection:AddButton({
	Name = "Import Bot File",
	Callback = function()
        posi = {}--cleaing position table
        local file = readfile(tostring(bottxtimport)..".json")--reading our bot path file
        for word in string.gmatch(file, '([^a]+)') do -- loop in the file txt and split line every time it finds a "a"
            table.insert(posi,(word))--instert the position into the main table
        end
        print("Imported "..tostring(bottxtimport)..".json successfully")--debug print
        saveSettings()--save the fact we closed the button to save posi table
  	end    
})
--auto loop farm
game:GetService("RunService").RenderStepped:Connect(function()
	if ConfigTable.IsLooped then
		if not launched then
            launched = true
            wait(ConfigTable.LoopSpeed)
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
            wait(3.5)--when the game start it wait 3.5 sec before start tweening through all position :d
            farm()
        end
    end
end)
game.StarterGui:SetCore("SendNotification", {Title = "BOT MAKER";Text = "Loaded!";Duration = 3;})
OrionLib:Init()--init the library
