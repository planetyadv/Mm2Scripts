-- Создаём ScreenGui
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "MegaSuperGUI"
gui.Parent = player:WaitForChild("PlayerGui")

-- Главный фрейм
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 200)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = gui

-- Закругление
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

-- Тень
local shadow = Instance.new("ImageLabel")
shadow.Size = UDim2.new(1, 20, 1, 20)
shadow.Position = UDim2.new(0, -10, 0, -10)
shadow.Image = "rbxassetid://1316045217"
shadow.ImageColor3 = Color3.fromRGB(0,0,0)
shadow.ImageTransparency = 0.5
shadow.BackgroundTransparency = 1
shadow.Parent = mainFrame

-- Заголовок
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
title.Text = "🔥 Mm2 script | t.me/raccoonscriptsbot 🔥"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = title

-- Контейнер кнопок
local buttonFrame = Instance.new("Frame")
buttonFrame.Size = UDim2.new(1, -20, 1, -50)
buttonFrame.Position = UDim2.new(0, 10, 0, 40)
buttonFrame.BackgroundTransparency = 1
buttonFrame.Parent = mainFrame

-- Шаблон кнопки
local function createButton(name, yPos, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 40)
	btn.Position = UDim2.new(0, 0, 0, yPos)
	btn.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
	btn.Text = name
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 16
	btn.Parent = buttonFrame

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = btn

	btn.MouseButton1Click:Connect(callback)
	return btn
end

-- Логика
local Farming = false
local EndRoundActive = false

local function getNearestCoin()
	local nearest, dist = nil, math.huge
	for _, obj in pairs(workspace:GetDescendants()) do
		if obj:IsA("Part") and obj.Name == "Coin_Server" then
			local char = player.Character
			if char and char:FindFirstChild("HumanoidRootPart") then
				local mag = (char.HumanoidRootPart.Position - obj.Position).Magnitude
				if mag < dist then
					nearest, dist = obj, mag
				end
			end
		end
	end
	return nearest
end

-- Кнопка Farm
createButton("💰Фарм", 0, function()
	Farming = not Farming
	if Farming then
		spawn(function()
			while Farming do
				local coin = getNearestCoin()
				if coin and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
					player.Character.HumanoidRootPart.CFrame = coin.CFrame + Vector3.new(0, 3, 0)
				end
				wait(0.5)
			end
		end)
	end
end)

-- Кнопка End round
-- Кнопка End round (через BodyVelocity)
createButton("⚡ Закончить раунд (воможны баги)", 50, function()
	if EndRoundActive then return end
	EndRoundActive = true
	spawn(function()
		while EndRoundActive do
			for _, plr in pairs(game.Players:GetPlayers()) do
				if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
					local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
					if hrp then
						-- создаём BodyVelocity
						local bv = Instance.new("BodyVelocity")
						bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
						bv.Velocity = (plr.Character.HumanoidRootPart.Position - hrp.Position).Unit * 200
						bv.Parent = hrp

						-- тп наверх для наглядности
						hrp.CFrame = plr.Character.HumanoidRootPart.CFrame + Vector3.new(0, 20, 0)

						wait(5)

						bv:Destroy()
					end
				end
			end
		end
	end)
end)

-- Кнопка для остановки
createButton("🛑 Остановить Прекращение раунда", 100, function()
	EndRoundActive = false
end)
