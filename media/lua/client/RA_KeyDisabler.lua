
-- from Pao: we're alreading doing this in RA_InitPlayer
function unBanZedKeys()
	getCore():reinitKeyMaps()
end
function banZedKeys()
	local banKeys = {
	"Forward",
	"Left",
	"Backward",
	"Right",
	"Toggle Info Panel",
	"Toggle Skill Panel",
	"Toggle Survival Guide",
	"Toggle Inventory",
	"Toggle Health Panel",
	"Toggle Clothing Protection Panel",
	"Toggle Moveable Panel Mode",
	"Crafting UI",
	"Toggle UI",
	"Interact",
	"Map",
	"ReloadWeapon",
	"Rack Firearm",
	"Toggle mode",
	"VehicleHorn",
	"VehicleRadialMenu",
	"VehicleMechanics",
	"StartVehicleEngine",
	"VehicleHeater",
	"VehicleSwitchSeat",
	"ToggleVehicleHeadlights",
	"Equip/Turn On/Off Light Source",
	"Equip/Unequip Handweapon",
	"Rotate building",
	"Hotbar 1",
	"Hotbar 2",
	"Hotbar 3",
	"Hotbar 4",
	"Hotbar 5",
	"Toggle Lua Debugger",
	"ToggleGodModeInvisible",
	"WalkTo",
	"Toggle mode",
	}

	for k, v in pairs(banKeys) do
		getCore():addKeyBinding(tostring(v), nil);
	end
end