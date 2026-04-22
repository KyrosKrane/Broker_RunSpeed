local brsRunSpeed = _G.LibStub("LibDataBroker-1.1"):NewDataObject("Broker_RunSpeed", {
	type = "data source",
	icon = "Interface\\Icons\\Inv_boots_02.blp",
	label = "Broker_RunSpeed",
	OnTooltipShow = function() end,
	text = "", -- this gets updated later
})

local isGliding, canGlide, forwardSpeed, UnitSpeed

local function SpeedIsSecret()
	brsRunSpeed.value = string.format("n/a (In combat)")
	brsRunSpeed.text = string.format("n/a (In combat)")
end

local function UpdateOldWorld()
	brsRunSpeed.value = string.format("%.0f", UnitSpeed / BASE_MOVEMENT_SPEED * 100) .. "%"
	brsRunSpeed.text = string.format("%.0f", UnitSpeed / BASE_MOVEMENT_SPEED * 100) .. "%"
end

local function UpdateDragonriding()
	local base = isGliding and forwardSpeed or UnitSpeed
	local movespeed = Round(base / BASE_MOVEMENT_SPEED * 100)
	brsRunSpeed.value = string.format("%.0f%% [%.0f%%]", movespeed, forwardSpeed)
	brsRunSpeed.text = string.format("%.0f%% [%.0f%%]", movespeed, forwardSpeed)
end

local function UpdateRunSpeed(frame, elapsed)
	UnitSpeed = GetUnitSpeed("player")

	-- Update 2026-04-22: Blizzard has decided that movement speed is now secret as of 12.0.5. So check for this.
	if issecretvalue and issecretvalue(UnitSpeed) then
		SpeedIsSecret()
		return
	end

	if C_PlayerInfo and C_PlayerInfo.GetGlidingInfo then
		-- We're in retail. Check if we're dragonriding, and if update speed appropriately.
		isGliding, canGlide, forwardSpeed = C_PlayerInfo.GetGlidingInfo()

		-- I can't really test these values easily, so I'm adding an additional sanity check just in case.
		if issecretvalue(isGliding) or issecretvalue(forwardSpeed) then
			SpeedIsSecret()
			return
		end

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
