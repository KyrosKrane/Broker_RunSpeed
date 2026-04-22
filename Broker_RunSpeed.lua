local brsRunSpeed = _G.LibStub("LibDataBroker-1.1"):NewDataObject("Broker_RunSpeed", {
	type = "data source",
	icon = "Interface\\Icons\\Inv_boots_02.blp",
	label = "Broker_RunSpeed",
	OnTooltipShow = function() end,
	text = "", -- this gets updated later
})

local isGliding, canGlide, forwardSpeed, UnitSpeed

-- general principle is DisplaySpeed = UnitSpeed / BASE_MOVEMENT_SPEED * 100
-- reversed, that would be UnitSpeed = DisplaySpeed / 100 * BASE_MOVEMENT_SPEED

local OldWorldSpeedCurve = C_CurveUtil.CreateCurve()
OldWorldSpeedCurve:SetType(Enum.LuaCurveType.Linear);
OldWorldSpeedCurve:AddPoint(0.0, 0)
OldWorldSpeedCurve:AddPoint(105.0, 1500)
-- I have no idea why this scale works, but it does!
-- Thanks to aa-chrismcfadyen on Github for this curve


local function SpeedIsSecret()
	brsRunSpeed.value = string.format("n/a (In combat)")
	brsRunSpeed.text = string.format("n/a (In combat)")
end



local frame = CreateFrame("Frame", "MyStatefulFrame", UIParent, "SecureHandlerStateTemplate")
RegisterStateDriver(frame, "CombatState", "[combat] combat; nocombat")
frame:SetAttribute("_onstate-CombatState", [[ -- arguments: self, stateid, newstate
    if newstate == "combat" then
        print("In combat")
    elseif newstate == "nocombat" then
        print("not in combat")
    end
]])



local function UpdateOldWorld()
	--print("At run time, secret is ", OldWorldSpeedCurve:HasSecretValues())
	--print(OldWorldSpeedCurve:Evaluate(GetUnitSpeed("player")))
	--print("post run, secret is ", OldWorldSpeedCurve:HasSecretValues())
	brsRunSpeed.value = OldWorldSpeedCurve:Evaluate(GetUnitSpeed("player"))
	brsRunSpeed.text = OldWorldSpeedCurve:Evaluate(GetUnitSpeed("player"))
	-- brsRunSpeed.value = string.format("%.0f%%", OldWorldSpeedCurve:Evaluate(GetUnitSpeed("player")))
	-- brsRunSpeed.text = string.format("%.0f%%", OldWorldSpeedCurve:Evaluate(GetUnitSpeed("player")))
end

local function UpdateDragonriding()
	local base = isGliding and forwardSpeed or UnitSpeed
	local movespeed = Round(base / BASE_MOVEMENT_SPEED * 100)
	brsRunSpeed.value = string.format("%.0f%% [%.0f%%]", movespeed, forwardSpeed)
	brsRunSpeed.text = string.format("%.0f%% [%.0f%%]", movespeed, forwardSpeed)
end

local function UpdateRunSpeed(frame, elapsed)
	UnitSpeed = GetUnitSpeed("player")

	if C_PlayerInfo and C_PlayerInfo.GetGlidingInfo then
		-- We're in retail. Check if we're dragonriding, and if so update speed appropriately.
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
