modifier_boss_attackspeed = class({})

function modifier_boss_attackspeed:IsHidden()
	return true
end

function modifier_boss_attackspeed:OnCreated()
	if IsServer() then
		self:SetStackCount(math.floor(GameRules.gameDifficulty + 0.5))
		self:StartIntervalThink(5)
	end
end

function modifier_boss_attackspeed:OnIntervalThink()
	if not self:GetParent():IsInvisible() then
		AddFOWViewer(DOTA_TEAM_GOODGUYS, self:GetParent():GetAbsOrigin(), 516, 1, false)
	end
end

function modifier_boss_attackspeed:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
		MODIFIER_EVENT_ON_ABILITY_START
	}
	return funcs
end
--------------------------------------------------------------------------------
function modifier_boss_attackspeed:GetModifierAttackSpeedBonus_Constant( params )
	return 200* (1 + (self:GetStackCount() - 1)* 0.15)
end

function modifier_boss_attackspeed:GetModifierMoveSpeedBonus_Constant( params )
	return (self:GetStackCount() - 1) * 15
end

function modifier_boss_attackspeed:GetModifierConstantManaRegen( params )
	return self:GetStackCount()*2.5
end

function modifier_boss_attackspeed:GetModifierManaBonus( params )
	return self:GetStackCount()*250
end

function modifier_boss_attackspeed:OnAbilityStart( params )
	if params.unit == self:GetParent() then
		AddFOWViewer(DOTA_TEAM_GOODGUYS, self:GetParent():GetAbsOrigin(), 516, 3, false)
	end
end

function modifier_boss_attackspeed:OnAbilityFullyCast( params )
	if params.unit == self:GetParent() then
		AddFOWViewer(DOTA_TEAM_GOODGUYS, self:GetParent():GetAbsOrigin(), 516, 3, false)
	end
end

