local TargetAreas = {
	function(ret, p1, self)
	for dir = DIR_START, DIR_END do
		local curr = p1 + DIR_VECTORS[dir]
		while Board:GetTerrain(curr) ~= TERRAIN_MOUNTAIN and not Board:IsBuilding(curr) and Board:IsValid(curr) do
			ret:push_back(curr)
			curr = curr + DIR_VECTORS[dir]
		end
		
		if Board:IsValid(curr) then
			ret:push_back(curr)
		end
	end
	end,
	function(ret, p1, self, p2)
		function InDir(dir)
			local curr = (p2 or Clicks[1]) + DIR_VECTORS[dir]

			while Board:GetTerrain(curr) ~= TERRAIN_MOUNTAIN and not Board:IsBuilding(curr) and Board:IsValid(curr) do
				ret:push_back(curr)
				curr = curr + DIR_VECTORS[dir]
			end
		
			if Board:IsValid(curr) then
				ret:push_back(curr)
			end
		end
			ret:push_back(p2)
		InDir((GetDirection((p2 or Clicks[1])-p1)-1)%4)
		InDir((GetDirection((p2 or Clicks[1])-p1)+1)%4)
	end,
	function(ret, p1,self, p2)
		local Inc = nil
		local forced_end = Clicks[1]
		if p2==Clicks[1] then
			Inc = false
			forced_end = nil
		else
			Inc = true

		end
			local dir = GetDirection(Clicks[1]-p1)
			local start = p1
			local point = start+DIR_VECTORS[dir]
			while Board:IsValid(point) do
				local flag = false
				if forced_end == point or Board:IsBuilding(point) or Board:GetTerrain(point) == TERRAIN_MOUNTAIN or not Board:IsValid(point + DIR_VECTORS[dir]) then
					ret:push_back(point)
					flag = true
				else
					ret:push_back(point)
				end
				if flag then break end
				point = point + DIR_VECTORS[dir]	
			end
			if Inc then
			local dir = GetDirection(p2-Clicks[1])
			point = point+DIR_VECTORS[dir]
			while Board:IsValid(point) do
			
				local flag = false
				if forced_end == point or Board:IsBuilding(point) or Board:GetTerrain(point) == TERRAIN_MOUNTAIN or not Board:IsValid(point + DIR_VECTORS[dir]) then
					ret:push_back(point)
					flag = true
				else
					ret:push_back(point)
				end
				if flag then break end
				point = point + DIR_VECTORS[dir]	
			end
			end
	end
}
local SkillEffects = {
	function(ret, p1,p2, self)
		for i = 1, p1:Manhattan(p2) do
			local damage = SpaceDamage(p1+DIR_VECTORS[GetDirection(p2-p1)]*i,DAMAGE_ZERO)
			ret:AddDamage(damage)
		end
	end,
	function(ret, p1,p2, self)
		local Inc = nil
		local forced_end = Clicks[1]
		if p2==Clicks[1] then
			Inc = false
			forced_end = nil
		else
			Inc = true

		end

			local damage = 1
			if Inc then damage = self.Damage end
			local dir = GetDirection(Clicks[1]-p1)
			local start = p1
			local point = start+DIR_VECTORS[dir]
			while Board:IsValid(point) do
			
				local temp_damage = damage
		
				local dam = SpaceDamage(point, temp_damage)
				local flag = false
				if forced_end == point or Board:IsBuilding(point) or Board:GetTerrain(point) == TERRAIN_MOUNTAIN or not Board:IsValid(point + DIR_VECTORS[dir]) then
					ret:AddProjectile(start,dam,self.LaserArt,FULL_DELAY)
					flag = true
				else
					ret:AddDamage(dam)
				end
				if Inc then
					damage = damage - 1
					if damage < 1 then damage = 1 end
				else
					if Board:IsPawnSpace(point) then damage = damage + 1 end
					if damage > self.Damage then damage = self.Damage end
				end
				if flag then break end
				point = point + DIR_VECTORS[dir]	
			end
			if Inc then
			local dir = GetDirection(p2-Clicks[1])
			point = point+DIR_VECTORS[dir]
			while Board:IsValid(point) do
			
				local temp_damage = damage
		
				local dam = SpaceDamage(point, temp_damage)
				local flag = false
				if forced_end == point or Board:IsBuilding(point) or Board:GetTerrain(point) == TERRAIN_MOUNTAIN or not Board:IsValid(point + DIR_VECTORS[dir]) then
					ret:AddProjectile(start,dam,self.LaserArt,FULL_DELAY)
					flag = true
				else
					ret:AddDamage(dam)
				end
				if Inc then
					damage = damage - 1
					if damage < 1 then damage = 1 end
				else
					if Board:IsPawnSpace(point) then damage = damage + 1 end
					if damage > self.Damage then damage = self.Damage end
				end
				if flag then break end
				point = point + DIR_VECTORS[dir]	
			end
			end
	end,
	function(ret, p1,p2, self)
		local Inc = nil
		local forced_end = Clicks[1]
		if Clicks[2]==Clicks[1] then
			Inc = false
			forced_end = nil
		else
			Inc = true

		end

			local damage = 1
			if Inc then damage = self.Damage end
			local dir = GetDirection(Clicks[1]-p1)
			local start = p1
			local point = start+DIR_VECTORS[dir]
			while Board:IsValid(point) do
			
				local temp_damage = damage
		
				local dam = SpaceDamage(point, temp_damage)
				local flag = false
				if forced_end == point or Board:IsBuilding(point) or Board:GetTerrain(point) == TERRAIN_MOUNTAIN or not Board:IsValid(point + DIR_VECTORS[dir]) then
					ret:AddProjectile(start,dam,self.LaserArt,FULL_DELAY)
					if not Inc then dam.iPush = dir end
					flag = true
				else
					dam.iPush = dir
					ret:AddDamage(dam)
				end
				if Inc then
					damage = damage - 1
					if damage < 1 then damage = 1 end
				else
					if Board:IsPawnSpace(point) then damage = damage + 1 end
					if damage > self.Damage then damage = self.Damage end
				end
				if flag then break end
				point = point + DIR_VECTORS[dir]	
			end
			if Inc then
			local dir = GetDirection(Clicks[2]-Clicks[1])
			point = point+DIR_VECTORS[dir]
			while Board:IsValid(point) do
			
				local temp_damage = damage
		
				local dam = SpaceDamage(point, temp_damage, dir)
				local flag = false
				if forced_end == point or Board:IsBuilding(point) or Board:GetTerrain(point) == TERRAIN_MOUNTAIN or not Board:IsValid(point + DIR_VECTORS[dir]) then
					ret:AddProjectile(start,dam,self.LaserArt,FULL_DELAY)
					flag = true
				else
					ret:AddDamage(dam)
				end
				if Inc then
					damage = damage - 1
					if damage < 1 then damage = 1 end
				else
					if Board:IsPawnSpace(point) then damage = damage + 1 end
					if damage > self.Damage then damage = self.Damage end
				end
				if flag then break end
				point = point + DIR_VECTORS[dir]	
			end
			end
	end,

}
Nico_laserboom = NClickSkill:new{
    Name = "K-b00m Beam Mark I",
	LaserArt = "effects/laser1",
	Class = "TechnoVek",
	Icon = "weapons/Nico_laserboom.png",
   	 Description = "Fire a pushing or igniting beam which bends or increases in damage per unit hit.",
	Damage = 3,
    	SelfDamage = 0,
	PowerCost = 0,
    	Phaser=true,
	MinDamage = 0,
	TargetAreas = TargetAreas,
	SkillEffects = SkillEffects,
	Phases = 3,
	FriendlyDamage = true,
	BuildingDamage = false,
	ZoneTargeting = ZONE_DIR,
	Upgrades = 2,
	UpgradeList = { "+1 Damage Each", "Static Damage, Ally Immune" },
	UpgradeCost = { 1,2 },
	KOSound = "/weapons/arachnoid_ko",
	TipImage = {
		Unit = Point(2,4),
		Enemy = Point(2,3),
		Friendly = Point(2,2),
		Target = Point(2,3),
		Mountain = Point(2,1),
		Building = Point(2,0),
        CustomPawn = "Nico_laserboom_mech",
	}
}