local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Knit)
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild('PlayerGui')
local ScreenGui = PlayerGui:WaitForChild('ScreenGui')
local Mouse = require(Knit.Modules.Mouse)
local Structures = ReplicatedStorage.Structures
local camera = workspace.CurrentCamera

local PlacementController = Knit.CreateController { Name = "PlacementController" }

function PlacementController:KnitStart()
    local PlacementService = Knit.GetService("PlacementService")
    local ToolbarFrame = ScreenGui.ToolbarFrame
    local mouse = Mouse.new()
    local placingStructure = false
    local HumanoidRootPart = Player.Character.HumanoidRootPart
    local clientStructure
    local structurePosition
    local raycastParams = RaycastParams.new()
    local yOrientation = 0

    local renderSteppedConnection = RunService.RenderStepped:Connect(function()
        if placingStructure then
                mouse:Raycast(raycastParams):Match {
                    Some = function(raycastResult)
                        local position = raycastResult.Position

                        -- ENHANCEMENT: Add snapping if hit another structure

                        local newCFrameAngle = CFrame.Angles(0, math.rad(yOrientation), 0)
                        local yBuildingOffset = clientStructure.Size.Y / 2
                        local newCFrame = CFrame.new(position.X, position.Y + yBuildingOffset, position.Z) 
                        clientStructure.CFrame = newCFrame * newCFrameAngle
                    end;
                    None = function()
                    end;
                }
        end
    end)

    local startPlacingStructure = function(structureName)
        if not placingStructure then
            placingStructure = true

            clientStructure = Structures:FindFirstChild(structureName):Clone()
            clientStructure.BrickColor = BrickColor.new("Forest green")
            clientStructure.Material = "Neon"
            clientStructure.CanCollide = false
            clientStructure.CastShadow = false
            clientStructure.Transparency = 0.5
            clientStructure.Parent = workspace

            local startingCFrame = CFrame.new(0, 0, -15)
            clientStructure.CFrame = HumanoidRootPart.CFrame:ToWorldSpace(startingCFrame)

            raycastParams.FilterDescendantsInstances = {Player.Character, clientStructure}
        end
    end

    for _, button in pairs(ToolbarFrame:GetChildren()) do
        if button:IsA("TextButton") then
            button.MouseButton1Up:Connect(function()
                startPlacingStructure(button.Name)
            end)
        end
    end

    mouse.LeftDown:Connect(function()
        if placingStructure and clientStructure then
           local placedStructure = PlacementService:RequestPlacement(clientStructure.Name, clientStructure.CFrame)

           if placedStructure then
              placingStructure = false
              clientStructure:Destroy() 
           end
        end
    end)
end

function PlacementController:KnitInit()
    print("PlacementController init")
end

return PlacementController