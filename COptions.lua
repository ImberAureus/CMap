local _G = getfenv(0)
local textureOffset = 0
local minimapX
local minimapY
local getn = table.getn
presetNames = { "Blue Rune Circles", "Blue Rune Diamond", "Burning Sun", "Stargate", "Simple Square", "Ruins", "Emerald Portal", "Shamanism", "LL Corner Rounded", }
shapeNames = { "Round", "Square", "Diamond", "Hexagon", "Octagon", "Heart", "Snowflake", "LL Corner Rounded", "LR Corner Rounded", "UL Corner Rounded", "UR Corner Rounded",}

variableOptionSliders = {
	{ text = "Rotation Speed", func = "CRotSpeedChanged", value = "rotSpeed", minValue = -64, maxValue = 64, valueStep = 1 },
	{ text = "Scale", func = "CScaleChanged", value = "scale", minValue = 0.1, maxValue = 4, valueStep = 0.01 },
	--{ text = "Scale", func = "CScaleChanged", value = "scale", minValue = 0.1, maxValue = 4, valueStep = 0.01 },
	
}

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
	minimapX, minimapY = Minimap:GetCenter()
	Minimap:SetPoint("CENTER", UIParent, "BOTTOMLEFT", xMiddle, yMiddle)
	CTextureOptionFrame:Show()
	CTexture_Update()
	CMinimapOptionFrame:Show()
	CMinimap_Update()
	CVariable_Update()
	CMinimapOptionFrame.menuState = true
end

function CHideMenu()
	Minimap:SetPoint("CENTER", UIParent, "BOTTOMLEFT", minimapX, minimapY)
	CTextureOptionFrame.selectedTexture = nil
	CTextureOptionFrame:Hide()
	CMinimapOptionFrame:Hide()
	CVariableOptionFrame:Hide()
	CMinimapOptionFrame.menuState = false
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
	UIDropDownMenu_SetSelectedValue(CShapeDropDown, CMDB.shape)
end

function CVariable_Update()
	if not CTextureOptionFrame.selectedTexture then
		CVariableOptionFrame:Hide()
		return
	else
		CVariableOptionFrame:Show()
	end
	local texture = CTextureOptionFrame.selectedTexture
	local button
	local slider
	local string
	local thumb
	local high
	local low
	for i,v in ipairs(variableOptionSliders) do
		slider = _G["CVariableSlider"..i]
		string = _G["CVariableSlider"..i.."Text"]
		thumb = _G["CVariableSlider"..i.."Thumb"]
		high = _G["CVariableSlider"..i.."High"]
		low = _G["CVariableSlider"..i.."Low"]
		
		if slider.disabled then
			CDisableSlider(slider)
		else
			CEnableSlider(slider)
		end
		
		slider:SetMinMaxValues(v.minValue, v.maxValue)
		slider:SetValueStep(v.valueStep)
		slider:SetValue(CMDB.borders[texture][v.value] or 0)
		slider:SetScript("OnValueChanged", _G[v.func])
		string:SetText(v.text)
		high:SetText(v.maxValue)
		low:SetText(v.minValue)
		
		
	end
end

function CPresetDropDown_Initialize()
	local info;
	for i=1, getn(presetNames) do
		info = {}
		info.text = presetNames[i]
		info.func = CPresetDropDownButton_OnClick
		info.value = presetNames[i]
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
	CApplyPreset(this.value)
end

function CShapeDropDown_Initialize()
	local info;
	for i=1, getn(shapeNames) do
		info = {}
		info.text = shapeNames[i]
		info.func = CShapeDropDownButton_OnClick
		info.value = shapeNames[i]
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
	CMDB.shape = this.value
	CApplyShape(CMDB.shape)
	CMinimap_Update()
end

function CTextureButton_OnClick(button)
	local id = this.textureIndex
	CTextureOptionFrame.selectedTexture = id
	CTexture_Update()
	CVariable_Update()
end

function CRotSpeedChanged()
	local i = CTextureOptionFrame.selectedTexture
	CMDB.borders[i].rotSpeed = this:GetValue()
	CCreateBorder(CMDB.borders[i])
end

function CScaleChanged()
	local i = CTextureOptionFrame.selectedTexture
	CMDB.borders[i].scale = this:GetValue()
	CCreateBorder(CMDB.borders[i])
end

function CDisableSlider(slider)
	local name = slider:GetName();
	_G[name.."Thumb"]:Hide();
	_G[name.."Text"]:SetVertexColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	_G[name.."Low"]:SetVertexColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	_G[name.."High"]:SetVertexColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
end

function CEnableSlider(slider)
	local name = slider:GetName();
	_G[name.."Thumb"]:Show();
	_G[name.."Text"]:SetVertexColor(NORMAL_FONT_COLOR.r , NORMAL_FONT_COLOR.g , NORMAL_FONT_COLOR.b);
	_G[name.."Low"]:SetVertexColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	_G[name.."High"]:SetVertexColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
end

function GameMenu_AddButton(button)
	if GameMenu_InsertAfter == nil then
		GameMenu_InsertAfter = GameMenuButtonMacros
	end
	if GameMenu_InsertBefore == nil then
		GameMenu_InsertBefore = GameMenuButtonLogout
	end

	button:ClearAllPoints()
	button:SetPoint( "TOP", GameMenu_InsertAfter:GetName(), "BOTTOM", 0, -1 )
	GameMenu_InsertBefore:SetPoint( "TOP", button:GetName(), "BOTTOM", 0, -1 )
	GameMenu_InsertAfter = button
	GameMenuFrame:SetHeight( GameMenuFrame:GetHeight() + button:GetHeight() + 2 )
end
