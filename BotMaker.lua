local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Bot Gucci 💰", "BloodTheme")
--nofall
--game.Players.LocalPlayer.Character.CharacterHandler.Remotes.ApplyFallDamage:Destroy()
--main tab
local main = Window:NewTab("Main")
local mainsection = main:NewSection("Bot Maker Made By Momo.#2706")
--variables
local posi = {}
local waittime = 0
local tweenspeed = 200 --default speed
local savename = "exported bot config"
local bottxtimport = nil
local launched = false
local loopspeed = 2 --default speed
local IsLooped = false
local canServerhop = false
local AutoTrinkets= false
--Tabs
local boted = Window:NewTab("Bot")
local FileSave = Window:NewTab("Save File")

--Sections
local botedsection = boted:NewSection("Make your own auto farm bot")
local paramssection = boted:NewSection("Parameters")
--for FileSave
local filesection = FileSave:NewSection("Import/Export bot files")
--wait between
paramssection:NewSlider("Wait time pos", "", 45, 1, function(s)
    waittime = s
end)
--loop speed
paramssection:NewSlider("Loop speed", "", 45, 1, function(s)
    loopspeed = s
end)
--tween speed 
paramssection:NewSlider("Tween Speed", "", 750, 1, function(s)
    tweenspeed = s
end)


block_random_player = function()
    local block_player 
    local players_list = game:GetService("Players"):GetPlayers()

    for index = 1, #players_list do
        local target_player = players_list[index]

        if target_player.Name ~= game.Players.LocalPlayer.Name then
            block_player = target_player
            break
        end
    end

    game:GetService("StarterGui"):SetCore("PromptBlockPlayer", block_player)

    local container_frame = game:GetService("CoreGui").RobloxGui:WaitForChild("PromptDialog"):WaitForChild("ContainerFrame")

    local confirm_button = container_frame:WaitForChild("ConfirmButton")
    local confirm_button_text = confirm_button:WaitForChild("ConfirmButtonText")
    
    if confirm_button_text.Text == "Block" then  
        wait()
        
        local confirm_position = confirm_button.AbsolutePosition
        
        game:GetService("VirtualInputManager"):SendMouseButtonEvent(confirm_position.X + 10, confirm_position.Y + 45, 0, true, game, 0)
        task.wait()
        game:GetService("VirtualInputManager"):SendMouseButtonEvent(confirm_position.X + 10, confirm_position.Y + 45, 0, false, game, 0)
    end
end

--server hopping esssentials
servhop = function()
    block_random_player()
    game:GetService("TeleportService"):Teleport(game.PlaceId)
end

local TweenPlayer
--main functions
local function farm()
    launched = true
    local function tweenplayer(cframe)
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
            end
            wait(waittime)
            game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
        end
    end
    launched = false
    wait(1)
    if canServerhop then
        servhop()
    end
end
--save position    
botedsection:NewButton("Save Position","()",function()
    local pos = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
    table.insert(posi,pos)
end)
--start bot
botedsection:NewButton("Load Position","()",function()
    farm()
end)
--remove all position
botedsection:NewButton("Clear All Pos","()",function()
    posi = {}
end)
--loop
botedsection:NewToggle("Loop Bot On/Off","()",function(state)
   IsLooped = state
end)
--set boolean for serverhopping
botedsection:NewToggle("Server Hop On/Off","()",function(state)
    canServerhop = state
 end)
--auto trinkets fim
 botedsection:NewToggle("Auto Pickup (fim)","()",function(state)
    AutoTrinkets = state
 end)
--server hop
botedsection:NewButton("Server Hop", "Server Hop", function()
    block_random_player()
    game:GetService("TeleportService"):Teleport(game.PlaceId)
 end)
--export file name
filesection:NewTextBox("Export File Name", "", function(txt)
    savename = txt
    print(savename)
end)
--import file name
filesection:NewTextBox("Import File Name", "", function(txt)
    bottxtimport = txt
    print(savename)
end)
--export file button
filesection:NewButton("Export bot file", "", function(txt)
    writefile(tostring(savename)..".txt","")
    for i , v in pairs(posi)do
        if i == #posi - 0 then 
            appendfile(tostring(savename)..".txt",tostring(v).."a")
            else
            appendfile(tostring(savename)..".txt",tostring(v).."a".."\n")
        end
    end
end)
filesection:NewButton("Import Bot file", "", function(txt)
    posi = {}
    local file = readfile(tostring(bottxtimport)..".txt")
    for word in string.gmatch(file, '([^a]+)') do
        table.insert(posi,(word))
    end
    for i,v in pairs(posi)do
        print(v)
    end
end)
--auto loop farm
game:GetService("RunService").RenderStepped:Connect(function()
	if IsLooped then
		if not launched then
            launched = true
            wait(loopspeed)
            farm()
        end
	end
end)
game:GetService("RunService").RenderStepped:Connect(function()
	if AutoTrinkets then
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
