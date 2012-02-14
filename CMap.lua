local useUiScale = tonumber(GetCVar("useUiScale"))
local uiScale = GetCVar("uiScale")
if useUiScale ~= 1 then uiScale = 1 end
frameWidth = UIParent:GetWidth() / uiScale
xMiddle = frameWidth / 2
frameHeight = UIParent:GetHeight() / uiScale
yMiddle = frameHeight / 2
frameScale = 0.75999999046326
local _G = getfenv(0)
local timeElapsed = 0
local updateTime = 1/60
CTextures = {}
CRotateTextures = {}

local function print(msg)
	if msg and msg ~= "" then
		DEFAULT_CHAT_FRAME:AddMessage(msg, 1, 1, 0)
	end
end

function deepCopyHash(t)
	if t == nil then return nil end
	local nt = {}
	for k, v in pairs(t) do
		if type(v) == "table" then
			nt[k] = deepCopyHash(v)
		else
			nt[k] = v
		end
	end
	return nt
end

function destroyTable(t)
	setmetatable(t, nil)
	for k,v in pairs(t) do
		t[k] = nil
	end
end

function CMap_OnLoad()
	print("[CMap] loaded. Type '/cm' to open the menu.")
	this:SetScript("OnEvent", CMap_OnEvent)
	this:SetScript("OnUpdate", CMap_OnUpdate)
	this:RegisterEvent("PLAYER_ENTERING_WORLD")
end

function CMap_OnEvent()
	if event == "PLAYER_ENTERING_WORLD" then
		this:UnregisterEvent("PLAYER_ENTERING_WORLD")
		--destroyTable(CMDB)
		if not CMDB then 
			CMDB = {}
			--print("CMDB not found, creating new")
		end
		if not CMDB.borders then
			CMDB.borders = deepCopyHash(borderPresets["Blue Rune Circles"].borders) 
		end
		if not CMDB.backdrop then
			CMDB.backdrop = deepCopyHash(borderPresets["Blue Rune Circles"].backdrop) 
		end
		if not CMDB.shape then
			CMDB.shape = "Round"
			--CMDB.shape = "Interface\\AddOns\\CMap\\shapes\\bottomleft"
		end
		if not CMDB.userPresets then
			CMDB.userPresets = {}
		end
		--print(CMDB.shape.." lol")
		CreateFrame("Frame", "CMinimapBackdrop", Minimap)
		CMinimapBackdrop:SetFrameStrata("BACKGROUND")
		CMinimapBackdrop:SetFrameLevel(CMinimapBackdrop:GetFrameLevel() - 1)
		CMinimapBackdrop:SetPoint("CENTER", Minimap, "CENTER")
		CMinimapBackdrop:SetWidth(Minimap:GetWidth())
		CMinimapBackdrop:SetHeight(Minimap:GetHeight())
		--CInitiateMenu()
		CHideAnnoyingStuff()
		CLoadArtwork()
		ToggleFramerate()
		SlashCmdList["CMAP"] = CMap_SlashCmdHandler
		SLASH_CMAP1 = "/cm"
	end
end

function CMap_OnUpdate()
	timeElapsed = timeElapsed + arg1
	if timeElapsed >= updateTime then
		for k,v in pairs(CRotateTextures) do
			CRotateTexture(_G[k], v * timeElapsed)
		end
		timeElapsed = 0
	end
end

function CMap_SlashCmdHandler(msg)
	if not CMinimapOptionFrame.menuState then
		CInitiateMenu()
	else
		CHideMenu()
	end
end

function CHideAnnoyingStuff()
	MinimapBorder:Hide()
	MinimapBorderTop:Hide()
	MinimapToggleButton:Hide()
	GameTimeFrame:Hide()
	MinimapZoneText:Hide()
	MinimapZoomIn:Hide()
	MinimapZoomOut:Hide()
end

function CClearArtwork()
	for k,v in pairs(CTextures) do
		_G[k]:SetTexCoord(0,1,0,1)
		_G[k]:Hide()
	end
	destroyTable(CTextures)
	CTextures = {}
	destroyTable(CRotateTextures)
	CRotateTextures = {}
end

function CLoadArtwork()
	if CMDB.shape then
		CApplyShape(CMDB.shape)
	end
	for k,v in ipairs(CMDB.borders) do
		CCreateBorder(v)
	end
	CUpdateBackdrop()
end

function CUpdateBackdrop()
	if not CMDB.backdrop or not CMDB.backdrop.show then
		CMinimapBackdrop:Hide()
	else
		backdrop = CMinimapBackdrop
		backdrop:Show()
		backdrop:SetWidth(Minimap:GetWidth() * (CMDB.backdrop.scale or 1))
		backdrop:SetHeight(Minimap:GetHeight() * (CMDB.backdrop.scale or 1))
		backdrop:SetBackdrop(CMDB.backdrop.settings)
		local c = CMDB.backdrop.textureColor
		backdrop:SetBackdropColor(c.r or 0, c.g or 0, c.b or 0, c.a or 1)
		c = CMDB.backdrop.borderColor
		backdrop:SetBackdropBorderColor(c.r or 1, c.g or 1, c.b or 1, c.a or 1)
	end
end
