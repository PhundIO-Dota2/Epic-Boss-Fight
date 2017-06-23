phoenix_self_immolation = class({})

function phoenix_self_immolation:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_phoenix_kindled_soul_active") then
		return "custom/phoenix_self_immolation_kindled"
	else
		return "custom/phoenix_self_immolation"
	end
end

function phoenix_self_immolation:OnSpellStart()
	local caster = self:GetCaster()
	-- hp cost
	local hpCost = self:GetTalentSpecialValueFor("hp_cost")
	if caster:HasTalent("phoenix_self_immolation_talent_1") then
		hpCost = hpCost * 2
	end
	local hpReduction = caster:GetHealth() - caster:GetMaxHealth() * hpCost / 100
	
	EmitSoundOn("Hero_DragonKnight.DragonTail.DragonFormCast", caster)
	
	if hpReduction < 10 then hpReduction = 1 end
	caster:SetHealth( hpReduction )
	
	caster:AddNewModifier( caster, self,  "modifier_phoenix_self_immolation", { duration = self:GetTalentSpecialValueFor("buff_duration")} )
	if caster:HasModifier("modifier_phoenix_kindled_soul_active") or caster:HasTalent("phoenix_self_immolation_talent_1") then
		caster:AddNewModifier( caster, self,  "modifier_phoenix_self_immolation_kindled", { duration = self:GetTalentSpecialValueFor("buff_duration")} )
	end
	if caster:HasTalent("phoenix_self_immolation_talent_1") then -- talent auto-consumes one stack
		local passive = caster:FindModifierByName("modifier_phoenix_kindled_soul_passive")
		local active = caster:AddNewModifier(caster, caster:FindAbilityByName("phoenix_kindled_soul"), "modifier_phoenix_kindled_soul_active", {})
		
		passive:SetStackCount(0)
		active:SetStackCount(active:GetAbility():GetTalentSpecialValueFor("active_stacks"))
	end
end

LinkLuaModifier( "modifier_phoenix_self_immolation_kindled", "heroes/phoenix/phoenix_self_immolation.lua" ,LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_phoenix_self_immolation", "heroes/phoenix/phoenix_self_immolation.lua" ,LUA_MODIFIER_MOTION_NONE )

modifier_phoenix_self_immolation = class({})

function modifier_phoenix_self_immolation:OnCreated()
	self.damagebonus = self:GetAbility():GetTalentSpecialValueFor("magical_damage_on_hit")
	self:GetParent().selfImmolationDamageBonus = self.damagebonus
	if IsServer() then
		self:GetParent():SetProjectileModel("particles/heroes/phoenix/phoenix_self_immolation_projectile.vpcf")
	end
end

function modifier_phoenix_self_immolation:OnRefresh()
	self.damagebonus = self:GetAbility():GetTalentSpecialValueFor("magical_damage_on_hit")
end

function modifier_phoenix_self_immolation:OnDestroy()
	self.damagebonus = self:GetAbility():GetTalentSpecialValueFor("magical_damage_on_hit")
	self:GetParent().selfImmolationDamageBonus = 0
	if IsServer() then
		self:GetParent():RevertProjectile()
	end
end

function modifier_phoenix_self_immolation:DeclareFunctions()
	return 
	{ 
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end

function modifier_phoenix_self_immolation:OnAttackLanded(params)
	if params.attacker == self:GetParent() then
		print(params.target)
		ApplyDamage({victim = params.target, attacker = params.attacker, damage = self.damagebonus, damage_type = self:GetAbility():GetAbilityDamageType(), ability = self:GetAbility()})
	end
end

function modifier_phoenix_self_immolation:GetEffectName()
	return "particles/units/heroes/hero_jakiro/jakiro_liquid_fire_debuff.vpcf"
end

modifier_phoenix_self_immolation_kindled = class({})

function modifier_phoenix_self_immolation_kindled:OnCreated()
	self.attackspeed = self:GetAbility():GetTalentSpecialValueFor("kindled_attackspeed")
	self.bat = self:GetAbility():GetTalentSpecialValueFor("kindled_bat")
end

function modifier_phoenix_self_immolation_kindled:DeclareFunctions()
	return 
	{ 
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end

function modifier_phoenix_self_immolation_kindled:GetModifierAttackSpeedBonus_Constant(params)
	return self.attackspeed
end

function modifier_phoenix_self_immolation_kindled:GetModifierBaseAttackTimeConstant(params)
	return self.bat
end

function modifier_phoenix_self_immolation_kindled:IsHidden()
	return true
end

function modifier_phoenix_self_immolation_kindled:GetEffectName()
	return "particles/units/heroes/hero_jakiro/jakiro_liquid_fire_debuff.vpcf"
end