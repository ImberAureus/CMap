local _G = getfenv(0)
local textureOffset = 0
presetNames = { "Blue Rune Circles", "Blue Rune Diamond", "Burning Sun", "Stargate", "Simple Square", "Ruins", "Emerald Portal", "Shamanism", "LL Corner Rounded", }
shapeNames = { "Round", "Square", "Diamond", "Hexagon", "Octagon", "Heart", "Snowflake", "LL Corner Rounded", "LR Corner Rounded", "UL Corner Rounded", "UR Corner Rounded",}

local function print(msg)
	if msg and msg ~= "" then
		DEFAULT_CHAT_FRAME:AddMessage(msg, 1, 1, 1)
	end
end

function NotImportant_OnLoad()
end

function CApplyPreset(preset)
	local preset = CMDB.userPresets[preset] or borderPresets[preset]
	
	CMDB.borders = deepCopyHash(preset.borders)
	CMDB.backdrop = deepCopyHash(preset.backdrop)
	CMDB.shape = preset.shape
	CTextureOptionFrame.selectedTexture = nil
	
	CClearArtwork()
	CLoadArtwork()
	CTexture_Update()
	CVariable_Update()
	CMinimap_Update()
end

function CInitiateMenu()
	Minimap:SetPoint("CENTER", UIParent, "BOTTOMLEFT", xMiddle, yMiddle)
	CTextureOptionFrame:Show()
	CTexture_Update()
	CMinimapOptionFrame:Show()
	CMinimap_Update()
	CVariableOptionFrame:Show()
	CVariable_Update()
end

function CTexture_Update()
	local button
	--print(CTextureOptionFrame.selectedTexture)
	for i=1,12 do
		button = _G["CTextureButton"..i]
		textureIndex = textureOffset + i
		button.textureIndex = textureIndex
		
		if not CMDB.borders[textureIndex] then
			button:Hide()
		else
			button:Show()
			_G["CTextureButton"..i.."Texture"]:SetText(CMDB.borders[textureIndex].texture)
		end
		
		if CTextureOptionFrame.selectedTexture == textureIndex then
			button:LockHighlight()
		else
			button:UnlockHighlight()
		end
	end
end

function CMinimap_Update()
	for i=1, 11 do
		if CMDB.shape == shapeNames[i] then
			UIDropDownMenu_SetSelectedID(CShapeDropDown, i)
		end
	end
end

function CVariable_Update()
	
end

function CPresetDropDown_Initialize()
	local info;
	for i=1, 9 do
		info = {}
		info.text = presetNames[i]
		info.func = CPresetDropDownButton_OnClick
		info.id = i
		info.notCheckable = true
		UIDropDownMenu_AddButton(info)
	end
end

function CPresetDropDown_OnLoad()
	UIDropDownMenu_Initialize(this, CPresetDropDown_Initialize)
	UIDropDownMenu_SetWidth(80)
	UIDropDownMenu_SetButtonWidth(24)
	UIDropDownMenu_JustifyText("LEFT", CPresetDropDown)
end

function CPresetDropDownButton_OnClick()
	CApplyPreset(presetNames[this:GetID()])
end

function CShapeDropDown_Initialize()
	local info;
	for i=1, 11 do
		info = {}
		info.text = shapeNames[i]
		info.func = CShapeDropDownButton_OnClick
		info.id = i
		UIDropDownMenu_AddButton(info)
	end
end

function CShapeDropDown_OnLoad()
	UIDropDownMenu_Initialize(this, CShapeDropDown_Initialize)
	UIDropDownMenu_SetWidth(80)
	UIDropDownMenu_SetButtonWidth(24)
	UIDropDownMenu_JustifyText("LEFT", CShapeDropDown)
end

function CShapeDropDownButton_OnClick()
	CMDB.shape = shapeNames[this:GetID()]
	CApplyShape(CMDB.shape)
	CMinimap_Update()
end

function CTextureButton_OnClick(button)
	local id = this.textureIndex
	CTextureOptionFrame.selectedTexture = id
	CTexture_Update()
	CVariable_Update()
end
