mapShapes = {
	["Round"] = "Textures\\MinimapMask",
	["Square"] = "Interface\\BUTTONS\\WHITE8X8",
	["Diamond"] = "Interface\\AddOns\\CMap\\shapes\\diamond",
	["Hexagon"] = "Interface\\AddOns\\CMap\\shapes\\hexagon",
	["Octagon"] = "Interface\\AddOns\\CMap\\shapes\\octagon",
	["Heart"] = "Interface\\AddOns\\CMap\\shapes\\heart",
	["Snowflake"] = "Interface\\AddOns\\CMap\\shapes\\snowflake",
	["LL Corner Rounded"] = "Interface\\AddOns\\CMap\\shapes\\topright",
	["LR Corner Rounded"] = "Interface\\AddOns\\CMap\\shapes\\topleft",
	["UL Corner Rounded"] = "Interface\\AddOns\\CMap\\shapes\\bottomright",
	["UR Corner Rounded"] = "Interface\\AddOns\\CMap\\shapes\\bottomleft",
}

function CApplyShape(shape)
	if mapShapes[shape] then
		Minimap:SetMaskTexture(mapShapes[shape])
	end
end
