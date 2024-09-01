local brsRunSpeed = _G.LibStub("LibDataBroker-1.1"):NewDataObject("Broker_RunSpeed", {
	type = "data source",
	icon = "Interface\\Icons\\Inv_boots_02.blp",
	label = "Broker_RunSpeed",
	OnTooltipShow = function() end,
	text = "", -- this gets updated later
})

local isGliding, canGlide, forwardSpeed, UnitSpeed

local function UpdateOldWorld()
	brsRunSpeed.value = string.format("%.0f", UnitSpeed / 7 * 100) .. "%"
	brsRunSpeed.text = string.format("%.0f", UnitSpeed / 7 * 100) .. "%"
end

local function UpdateDragonriding()
	local base = isGliding and forwardSpeed or UnitSpeed
	local movespeed = Round(base / BASE_MOVEMENT_SPEED * 100)
	brsRunSpeed.value = string.format("%.0f%% [%.0f%%]", movespeed, forwardSpeed)
	brsRunSpeed.text = string.format("%.0f%% [%.0f%%]", movespeed, forwardSpeed)
end

local function UpdateRunSpeed(frame,elapsed)

	UnitSpeed = GetUnitSpeed("player")

	if C_PlayerInfo and C_PlayerInfo.GetGlidingInfo then
		-- We're in retail. Check if we're dragonriding, and if update speed appropriately.
		isGliding, canGlide, forwardSpeed = C_PlayerInfo.GetGlidingInfo()
		if isGliding then
			UpdateDragonriding()
		else
			UpdateOldWorld()
		end
	else
		-- We're on a Classic server of some kind.
		UpdateOldWorld()
	end

end

local brsFrame = CreateFrame("Frame")
brsFrame:SetScript("OnUpdate", UpdateRunSpeed)
