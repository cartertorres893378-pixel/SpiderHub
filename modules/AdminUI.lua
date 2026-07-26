-- modules/AdminUI.lua
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local function CreateMenu()
	local player = Players.LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui")
	
	-- Clear older builds to prevent UI duplication
	local oldGui = playerGui:FindFirstChild("SpiderHub")
	if oldGui then oldGui:Destroy() end
	
	-- Root ScreenGui Container
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "SpiderHub"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = playerGui
	
	-- Main Display Frame
	local mainFrame = Instance.new("Frame")
	mainFrame.Size = UDim2.new(0, 450, 0, 300)
	mainFrame.Position = UDim2.new(0.5, -225, 0.5, -150)
	mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 22)
	mainFrame.BorderSizePixel = 0
	mainFrame.Active = true
	mainFrame.Draggable = true
	mainFrame.ClipsDescendants = true
	mainFrame.Parent = screenGui
	
	-- Visual Polish: Rounded Corners and Neon Border
	local mainCorner = Instance.new("UICorner")
	mainCorner.CornerRadius = UDim.new(0, 8)
	mainCorner.Parent = mainFrame
	
	local mainStroke = Instance.new("UIStroke")
	mainStroke.Thickness = 1.5
	mainStroke.Color = Color3.fromRGB(163, 0, 0) -- Dark Red Accent
	mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	mainStroke.Parent = mainFrame
	
	-- Sidebar Navigation Panel
	local sidebar = Instance.new("Frame")
	sidebar.Size = UDim2.new(0, 130, 1, 0)
	sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 17)
	sidebar.BorderSizePixel = 0
	sidebar.Parent = mainFrame
	
	local sidebarCorner = Instance.new("UICorner")
	sidebarCorner.CornerRadius = UDim.new(0, 8)
	sidebarCorner.Parent = sidebar
	
	-- Logo Banner
	local hubTitle = Instance.new("TextLabel")
	hubTitle.Size = UDim2.new(1, 0, 0, 40)
	hubTitle.BackgroundColor3 = Color3.fromRGB(25, 12, 12)
	hubTitle.Text = "🕷️ SpiderHub"
	hubTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
	hubTitle.Font = Enum.Font.GothamBold
	hubTitle.TextSize = 16
	hubTitle.Parent = sidebar
	
	-- Tab Layout Auto-Formatting
	local tabLayout = Instance.new("UIListLayout")
	tabLayout.Padding = UDim.new(0, 4)
	tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
	tabLayout.Parent = sidebar
	
	-- Dynamic Page Content Frame
	local contentFrame = Instance.new("Frame")
	contentFrame.Size = UDim2.new(0, 310, 1, -10)
	contentFrame.Position = UDim2.new(0, 135, 0, 5)
	contentFrame.BackgroundTransparency = 1
	contentFrame.Parent = mainFrame
	
	-- Navigation Pages
	local movementPage = Instance.new("Frame")
	movementPage.Size = UDim2.new(1, 0, 1, 0)
	movementPage.BackgroundTransparency = 1
	movementPage.Visible = true
	movementPage.Parent = contentFrame
	
	local itemPage = Instance.new("Frame")
	itemPage.Size = UDim2.new(1, 0, 1, 0)
	itemPage.BackgroundTransparency = 1
	itemPage.Visible = false
	itemPage.Parent = contentFrame
	
	local mLayout = Instance.new("UIListLayout")
	mLayout.Padding = UDim.new(0, 8)
	mLayout.Parent = movementPage
	
	local iLayout = Instance.new("UIListLayout")
	iLayout.Padding = UDim.new(0, 8)
	iLayout.Parent = itemPage

	-- Helper function to generate standardized module feature buttons
	local function createContentButton(text, parent, order)
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(1, -10, 0, 40)
		btn.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
		btn.TextColor3 = Color3.fromRGB(230, 230, 230)
		btn.Font = Enum.Font.Gotham
		btn.TextSize = 13
		btn.Text = "   " .. text
		btn.TextXAlignment = Enum.TextXAlignment.Left
		btn.LayoutOrder = order
		btn.Parent = parent
		
		local btnCorner = Instance.new("UICorner")
		btnCorner.CornerRadius = UDim.new(0, 6)
		btnCorner.Parent = btn
		
		local btnStroke = Instance.new("UIStroke")
		btnStroke.Thickness = 1
		btnStroke.Color = Color3.fromRGB(40, 40, 45)
		btnStroke.Parent = btn
		
		btn.MouseEnter:Connect(function()
			TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 45)}):Play()
		end)
		btn.MouseLeave:Connect(function()
			TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(28, 28, 32)}):Play()
		end)
		
		return btn
	end

	-- Helper function to create Sidebar Tabs
	local function createTabButton(text, targetPage, order)
		local tab = Instance.new("TextButton")
		tab.Size = UDim2.new(0, 120, 0, 35)
		tab.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
		tab.TextColor3 = Color3.fromRGB(180, 180, 180)
		tab.Font = Enum.Font.GothamSemibold
		tab.TextSize = 12
		tab.Text = text
		tab.LayoutOrder = order
		tab.Parent = sidebar
		
		local tabCorner = Instance.new("UICorner")
		tabCorner.CornerRadius = UDim.new(0, 6)
		tabCorner.Parent = tab
		
		tab.MouseButton1Click:Connect(function()
			movementPage.Visible = false
			itemPage.Visible = false
			targetPage.Visible = true
		end)
		
		return tab
	end

	-- Initialize Navigation Menu Elements
	createTabButton("Movement Mods", movementPage, 1)
	createTabButton("Item Dupe", itemPage, 2)

	---------------------------------------------------------
	-- MOVEMENT MODS IMPLEMENTATION
	---------------------------------------------------------
	local stealBtn = createContentButton("Humanized Insta-Steal", movementPage, 1)
	local isTraveling = false
	
	stealBtn.MouseButton1Click:Connect(function()
		local character = player.Character
		if not character or isTraveling then return end
		local root = character:FindFirstChild("HumanoidRootPart")
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if not root or not humanoid then return end
		
		local bases = Workspace:FindFirstChild("Bases")
		if bases then
			for _, base in ipairs(bases:GetChildren()) do
				if base:GetAttribute("Owner") == player.Name then
					local zone = base:FindFirstChild("DepositZone")
					if zone then
						isTraveling = true
						stealBtn.Text = "   Traveling Safely..."
						
						-- Calculate velocity limits to bypass server-side traps
						local distance = (zone.Position - root.Position).Magnitude
						local legalTime = distance / 15.5 -- Simulates physical movement vector speeds
						
						local originalSpeed = humanoid.WalkSpeed
						humanoid.WalkSpeed = 0 -- Disables player inputs during transit
						
						local tweenInfo = TweenInfo.new(legalTime, Enum.EasingStyle.Linear)
						local movementTween = TweenService:Create(root, tweenInfo, {CFrame = zone.CFrame * CFrame.new(0, 3, 0)})
						
						movementTween:Play()
						movementTween.Completed:Connect(function()
							humanoid.WalkSpeed = originalSpeed
							isTraveling = false
							stealBtn.Text = "   Humanized Insta-Steal"
						end)
					end
					break
				end
			end
		end
	end)
	
	local noclipBtn = createContentButton("Phasing (NoClip): OFF", movementPage, 2)
	local phasingActive = false
	local phasingLoop = nil
	
	noclipBtn.MouseButton1Click:Connect(function()
		phasingActive = not phasingActive
		if phasingActive then
			noclipBtn.Text = "   Phasing (NoClip): ON"
			noclipBtn.TextColor3 = Color3.fromRGB(163, 0, 0)
			
			-- Uses spatial calculations to dynamically phase obstacles ahead
			phasingLoop = RunService.PreSimulation:Connect(function()
				local character = player.Character
				if character and character:FindFirstChild("HumanoidRootPart") then
					local root = character.HumanoidRootPart
					
					local raycastParams = RaycastParams.new()
					raycastParams.FilterDescendantsInstances = {character}
					raycastParams.FilterType = Enum.RaycastFilterType.Exclude
					
					local result = Workspace:Raycast(root.Position, root.CFrame.LookVector * 3, raycastParams)
					if result and result.Instance and result.Instance:IsA("BasePart") then
						if result.Instance.CanCollide == true then
							local hitPart = result.Instance
							hitPart.CanCollide = false
							task.delay(0.5, function()
								if hitPart then hitPart.CanCollide = true end
							end)
						end
					end
				end
			end)
		else
			noclipBtn.Text = "   Phasing (NoClip): OFF"
			noclipBtn.TextColor3 = Color3.fromRGB(230, 230, 230)
			if phasingLoop then
				phasingLoop:Disconnect()
				phasingLoop = nil
			end
		end
	end)

	---------------------------------------------------------
	-- ITEM DUPLICATION IMPLEMENTATION
	---------------------------------------------------------
	local dupeBtn = createContentButton("Safe Dupe", itemPage, 1)
	local sourceItem = nil
	
	dupeBtn.MouseButton1Click:Connect(function()
		local character = player.Character
		if not character then return end
		
		local targetItem = Workspace:FindFirstChild("BrainrotItem")
		if targetItem and targetItem:FindFirstChild("CarryingWeld") then
			if not sourceItem then
				sourceItem = targetItem:Clone()
				local oldWeld = sourceItem:FindFirstChild("CarryingWeld")
				if oldWeld then oldWeld:Destroy() end
				
				dupeBtn.Text = "   Place Duplicate (Ready)"
				dupeBtn.TextColor3 = Color3.fromRGB(0, 163, 0)
			end
		elseif sourceItem then
			task.wait(0.25) -- Safe structural layout packet replication delay
			sourceItem.Parent = Workspace
			sourceItem:PivotTo(character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5))
			if sourceItem.PrimaryPart then
				sourceItem.PrimaryPart.Anchored = true
				sourceItem.PrimaryPart.CanCollide = true
			end
			sourceItem = nil
			dupeBtn.Text = "   Safe Dupe"
			dupeBtn.TextColor3 = Color3.fromRGB(230, 230, 230)
		end
	end)

	---------------------------------------------------------
	-- INTERFACE ANIMATION & ACCESSIBILITY CONFIG
	---------------------------------------------------------
	local menuVisible = true
	local toggleDebounce = false
	
	local function toggleMenu()
		if toggleDebounce then return end
		toggleDebounce = true
		menuVisible = not menuVisible
		
		if menuVisible then
			mainFrame.Visible = true
