local _G = getfenv(0)
local defaultSize = 180
local math = math
local sin = math.sin
local cos = math.cos
local rad = math.rad
borderTextures = {
	["AURARUNE256.BLP"] = "SPELLS\\AURARUNE256.BLP",
	["AuraRune256b.blp"] = "SPELLS\\AuraRune256b.blp",
	["AuraRune_A.blp"] = "SPELLS\\AuraRune_A.blp",
	["AuraRune_B.blp"] = "SPELLS\\AuraRune_B.blp",
	["Elite"] = "Interface\\TargetingFrame\\UI-TargetingFrame-Elite",
	["GENERICGLOW5.BLP"] = "PARTICLES\\GENERICGLOW5.BLP",
	["GENERICGLOW64.BLP"] = "SPELLS\\GENERICGLOW64.BLP",
	["gradientCircle.blp"] = "Interface\\GLUES\\MODELS\\UI_Tauren\\gradientCircle.blp",
	["Nature_Rune_128.blp"] = "SPELLS\\Nature_Rune_128.blp",
	["Rare"] = "Interface\\TargetingFrame\\UI-TargetingFrame-Rare",
	["ShamanStoneAir.blp"] = "World\\GENERIC\\PASSIVEDOODADS\\ShamanStone\\ShamanStoneAir.blp",
	["SHAMANSTONEEARTH.blp"] = "World\\GENERIC\\PASSIVEDOODADS\\ShamanStone\\SHAMANSTONEEARTH.blp",
	["ShamanStoneFlame.blp"] = "World\\GENERIC\\PASSIVEDOODADS\\ShamanStone\\ShamanStoneFlame.blp",
	["ShamanStoneWater.blp"] = "World\\GENERIC\\PASSIVEDOODADS\\ShamanStone\\ShamanStoneWater.blp",
	["Shockwave4.blp"] = "SPELLS\\Shockwave4.blp",
	["Shockwave_blue.blp"] = "World\\ENVIRONMENT\\DOODAD\\GENERALDOODADS\\ELEMENTALRIFTS\\Shockwave_blue.blp",
	["SHOCKWAVE_INVERTGREY.BLP"] = "SPELLS\\SHOCKWAVE_INVERTGREY.BLP",
	["TREANTLEAVES.BLP"] = "SPELLS\\TREANTLEAVES.BLP",
	["T_VFX_HERO_CIRCLE.BLP"] = "SPELLS\\T_VFX_HERO_CIRCLE.BLP",
}

function CCreateBorder(t)
	texture = _G[t.name] or Minimap:CreateTexture(t.name)
	texture:Show()
	texture:SetBlendMode(t.blendMode or "ADD")
	texture:SetTexture(borderTextures[t.texture])
	texture:SetWidth(defaultSize * (t.scale or 1))
	texture:SetHeight(defaultSize * (t.scale or 1))
	texture:SetVertexColor(t.r or 1, t.g or 1, t.b or 1)
	texture:SetAlpha(t.a or 1)
	texture:SetPoint(t.anchorPoint or "CENTER", 
		t.relativeTo or Minimap, 
		t.relativePoint or "CENTER",
		t.xOffset or 0, t.yOffset or 0)
	texture:SetDrawLayer(t.drawLayer or "ARTWORK")
	texture.settings = t
	texture.angle = 0
	CTextures[t.name] = t.name
	if t.rotSpeed and t.rotSpeed ~= 0 and not t.disableRotation then
		CRotateTextures[t.name] = t.rotSpeed
	end
	if t.rotatation then
		CRotateTexture(texture, t.rotation)
	end
end

function CRotateTexture(self, change)
	self.angle = (self.angle or 0) - change
	if self.angle < 0 then self.angle = self.angle + 360 end
	if self.angle > 360 then self.angle = self.angle - 360 end
	--self.angle = self.angle % 360
	s = sin(rad(self.angle))
	c = cos(rad(self.angle))
	self:SetTexCoord(
		0.5 - s, 0.5 + c, --Top Left Corner
		0.5 + c, 0.5 + s, --Bottom Left Corner
		0.5 - c, 0.5 - s, --Top Right Corner
		0.5 + s, 0.5 - c  --Bottom Right Corner
	)
end

