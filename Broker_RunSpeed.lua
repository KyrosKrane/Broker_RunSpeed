local _G = _G
local HowRunning

local brsRunSpeed = _G.LibStub("LibDataBroker-1.1"):NewDataObject("Broker_RunSpeed", {
	type = "data source",
	icon = "Interface\\Icons\\Inv_boots_02.blp",
	label = "Broker_RunSpeed",
	OnTooltipShow = function()end,
})

local string = string

local function UpdateRunSpeed(frame,elapsed)
	HowRunning = "player"
	brsRunSpeed.value = string.format("%.0f",  GetUnitSpeed(HowRunning) / 7 * 100 ) .. "%"
	brsRunSpeed.text = string.format("%.0f",  GetUnitSpeed(HowRunning) / 7 * 100 ) .. "%"
end

local brsFrame = CreateFrame("Frame")
brsFrame:SetScript("OnUpdate", UpdateRunSpeed)
