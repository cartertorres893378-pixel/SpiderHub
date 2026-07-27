local AdminUI = {}

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")

function AdminUI.CreateMenu()
    local Player = Players.LocalPlayer
    local PlayerGui = Player:WaitForChild("PlayerGui")
    
    if PlayerGui:FindFirstChild("SpiderHubUI") then
        PlayerGui.SpiderHubUI:Destroy()
    end
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SpiderHubUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = PlayerGui
    
    -- Main Window Panel
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 450, 0, 300)
    MainFrame.Position = UDim2.new(0.5, -225, 0.5, -150)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 22)
    MainFrame.BorderSizePixel = 2
    MainFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainFrame
    
    -- Sidebar Menu Tabs
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 130, 1, 0)
    Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 17)
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame
    
    local SidebarCorner = Instance.new("UICorner")
    SidebarCorner.CornerRadius = UDim.new(0, 8)
    SidebarCorner.Parent = Sidebar
    
    local PageContainer = Instance.new("Frame")
    PageContainer.Name = "PageContainer"
    PageContainer.Size = UDim2.new(1, -140, 1, -20)
    PageContainer.Position = UDim2.new(0, 140, 0, 10)
    PageContainer.BackgroundTransparency = 1
    PageContainer.Parent = MainFrame
    
    local ItemPage = Instance.new("Frame")
    ItemPage.Name = "Item Dupe"
    ItemPage.Size = UDim2.new(1, 0, 1, 0)
    ItemPage.BackgroundTransparency = 1
    ItemPage.Visible = true
    ItemPage.Parent = PageContainer
    
    local FileViewPage = Instance.new("Frame")
    FileViewPage.Name = "View Files"
    FileViewPage.Size = UDim2.new(1, 0, 1, 0)
    FileViewPage.BackgroundTransparency = 1
    FileViewPage.Visible = false
    FileViewPage.Parent = PageContainer
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 5)
    UIListLayout.Parent = Sidebar
    
    local UIPadding = Instance.new("UIPadding")
    UIPadding.PaddingTop = UDim.new(0, 10)
    UIPadding.PaddingLeft = UDim.new(0, 5)
    UIPadding.PaddingRight = UDim.new(0, 5)
    UIPadding.Parent = Sidebar
    
    local function CreateTab(name, targetPage)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, 0, 0, 35)
        TabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 28)
        TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabBtn.Text = name
        TabBtn.Font = Enum.Font.SourceSansBold
        TabBtn.TextSize = 14
        TabBtn.Parent = Sidebar
        
        local BtnCorner = Instance.new("UICorner")
        BtnCorner.CornerRadius = UDim.new(0, 4)
        BtnCorner.Parent = TabBtn
        
        TabBtn.MouseButton1Click:Connect(function()
            for _, page in ipairs(PageContainer:GetChildren()) do
                if page:IsA("Frame") then page.Visible = false end
            end
            targetPage.Visible = true
        end)
    end
    
    CreateTab("Item Dupe", ItemPage)
    CreateTab("View Files", FileViewPage)
    
    local function CreateButton(text, parent, callback)
        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(1, 0, 0, 40)
        Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        Btn.Text = text
        Btn.Font = Enum.Font.SourceSans
        Btn.TextSize = 16
        Btn.Parent = parent
        
        local BtnCorner = Instance.new("UICorner")
        BtnCorner.CornerRadius = UDim.new(0, 6)
        BtnCorner.Parent = Btn
        
        local Layout = parent:FindFirstChildOfClass("UIListLayout") or Instance.new("UIListLayout")
        Layout.SortOrder = Enum.SortOrder.LayoutOrder
        Layout.Padding = UDim.new(0, 10)
        Layout.Parent = parent
        
        Btn.MouseButton1Click:Connect(callback)
    end
    
    -- READ-ONLY DATA MODEL GAME EXPLORER (ROBLOX STUDIO REPLICA)
    local ExplorerScroll = Instance.new("ScrollingFrame")
    ExplorerScroll.Size = UDim2.new(1, 0, 1, 0)
    ExplorerScroll.BackgroundTransparency = 1
    ExplorerScroll.CanvasSize = UDim2.new(0, 0, 5, 0)
    ExplorerScroll.ScrollBarThickness = 6
    ExplorerScroll.Parent = FileViewPage
    
    local ExplorerLayout = Instance.new("UIListLayout")
    ExplorerLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ExplorerLayout.Padding = UDim.new(0, 2)
    ExplorerLayout.Parent = ExplorerScroll
    
    local targetsToDisplay = {Workspace, ReplicatedStorage, Lighting, SoundService}
    for _, service in ipairs(targetsToDisplay) do
        local ServiceLabel = Instance.new("TextLabel")
        ServiceLabel.Size = UDim2.new(1, 0, 0, 20)
        ServiceLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
        ServiceLabel.TextColor3 = Color3.fromRGB(255, 220, 100)
        ServiceLabel.Text = "📁 " .. service.Name
        ServiceLabel.Font = Enum.Font.SourceSansBold
        ServiceLabel.TextSize = 14
        ServiceLabel.TextXAlignment = Enum.TextXAlignment.Left
        ServiceLabel.Parent = ExplorerScroll
        
        for _, child in ipairs(service:GetChildren()) do
            local ChildLabel = Instance.new("TextLabel")
            ChildLabel.Size = UDim2.new(1, 0, 0, 18)
            ChildLabel.BackgroundTransparency = 1
            ChildLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
            ChildLabel.Text = "    📄 [" .. child.ClassName .. "] " .. child.Name
            ChildLabel.Font = Enum.Font.SourceSans
            ChildLabel.TextSize = 13
            ChildLabel.TextXAlignment = Enum.TextXAlignment.Left
            ChildLabel.Parent = ExplorerScroll
        end
    end
    
    -- ADMINISTRATIVE STATE DIALOG SYSTEM
    local NotificationBox = Instance.new("TextLabel")
    NotificationBox.Size = UDim2.new(1, 0, 0, 40)
    NotificationBox.BackgroundTransparency = 1
    NotificationBox.TextColor3 = Color3.fromRGB(0, 255, 0)
    NotificationBox.Text = "Status: Operational. Awaiting Selection Sequence..."
    NotificationBox.Font = Enum.Font.SourceSansBold
    NotificationBox.TextSize = 13
    NotificationBox.TextWrapped = true
    NotificationBox.Parent = ItemPage
    
    CreateButton("Initiate Administrative Dupe Sequence", ItemPage, function()
        NotificationBox.Text = "SPIDER HUB ADMIN DUPE WORKING YOU MAY NOW CONTINUE"
        task.wait(1.5)
        
        local DialogFrame = Instance.new("Frame")
        DialogFrame.Name = "PromptFrame"
        DialogFrame.Size = UDim2.new(0, 320, 0, 150)
        DialogFrame.Position = UDim2.new(0.5, -160, 0.5, -75)
        DialogFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 28)
        DialogFrame.BorderSizePixel = 2
        DialogFrame.BorderColor3 = Color3.fromRGB(255, 215, 0)
        DialogFrame.ZIndex = 10
        DialogFrame.Parent = ScreenGui
        
        local DialogCorner = Instance.new("UICorner")
        DialogCorner.CornerRadius = UDim.new(0, 6)
        DialogCorner.Parent = DialogFrame
        
        local MsgLabel = Instance.new("TextLabel")
        MsgLabel.Size = UDim2.new(1, -20, 0, 60)
        MsgLabel.Position = UDim2.new(0, 10, 0, 10)
        MsgLabel.BackgroundTransparency = 1
        MsgLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        MsgLabel.Text = "SPIDER HUB ADMIN DUPE WORKING DO YOU WANT TO CONTINUE?"
        MsgLabel.Font = Enum.Font.SourceSansBold
        MsgLabel.TextSize = 14
        MsgLabel.TextWrapped = true
        MsgLabel.ZIndex = 10
        MsgLabel.Parent = DialogFrame
        
        local YesBtn = Instance.new("TextButton")
        YesBtn.Size = UDim2.new(0, 100, 0, 35)
        YesBtn.Position = UDim2.new(0, 40, 0, 85)
        YesBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
        YesBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        YesBtn.Text = "YES"
        YesBtn.Font = Enum.Font.SourceSansBold
        YesBtn.TextSize = 16
        YesBtn.ZIndex = 10
        YesBtn.Parent = DialogFrame
        
        local YesCorner = Instance.new("UICorner")
        YesCorner.CornerRadius = UDim.new(0, 4)
        YesCorner.Parent = YesBtn
        
        local NoBtn = YesBtn:Clone()
        NoBtn.Position = UDim2.new(0, 180, 0, 85)
        NoBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        NoBtn.Text = "NO"
        NoBtn.Parent = DialogFrame
        
        -- YES Sequence Process: Clones user character configuration locally inside boundaries
        YesBtn.MouseButton1Click:Connect(function()
            DialogFrame:Destroy()
            NotificationBox.Text = "[System Processing]: Base zone targeting confirmed."
            
            local character = Player.Character
            if character then
                character.Archivable = true
                local clonedCharacter = character:Clone()
                clonedCharacter.Parent = Workspace
                
                local rootPart = clonedCharacter:FindFirstChild("HumanoidRootPart")
                if rootPart then
