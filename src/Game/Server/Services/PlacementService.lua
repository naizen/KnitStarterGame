local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Knit)
local Structures = ReplicatedStorage.Structures 

local PlacementService = Knit.CreateService {
	Name = "PlacementService";
	Client = {};
}

function PlacementService.Client:RequestPlacement(player, structureName, structureCFrame)
	local structure = Structures:FindFirstChild(structureName):Clone()
	local placed = false

	if structure then
		structure.CFrame = structureCFrame
		structure.Parent = workspace
		placed = true
	end 

	return placed
end

function PlacementService:KnitStart()
	
end

function PlacementService:KnitInit()
	print("PlacementService initialized")
end

return PlacementService