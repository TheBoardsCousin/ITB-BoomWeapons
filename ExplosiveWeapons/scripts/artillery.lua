--[[
To anyone attempting to read or edit this code, I, as an atheist, highly reccomend a lot of prayer.
]]--

TargetAreasB = {
	function(ret, p1, self, p2)
		for dir = DIR_START, DIR_END do
			for i = 2, 8 do
				if Board:IsValid(p1 + DIR_VECTORS[dir]*i) then
					ret:push_back(p1 + DIR_VECTORS[dir]*i)
				end
			end
		end
	end,
	function(ret, p1, self, p2)
		ret:push_back(p2 or Clicks[1])
	end,
	function(ret, p1, self, p2)
		local dir = GetDirection(Clicks[#Clicks]-p1)
		if ((#(PhaseClicks[2] or {})%self.Types)+1) == 3 then
			local curr = Clicks[#Clicks] + DIR_VECTORS[dir]
	
			while Board:IsValid(curr) do
				ret:push_back(curr)
				curr = curr + DIR_VECTORS[dir]
			end
		else
			for j = 1, 3 do
				for i = 2, 8 do
					local curr = Point(p1 + DIR_VECTORS[(dir+j)%4] * i)
					if not Board:IsValid(Point(p1 + DIR_VECTORS[(dir+j)%4] * i)) then  
						break
					end
					ret:push_back(curr)
				end
			end
		end
	end,
	function(ret, p1, self, p2)
		dir = GetDirection(Clicks[1]-p1)
		dir2 = (GetDirection(Clicks[1]-p1)+3)%4
		ret:push_back(Clicks[1]+DIR_VECTORS[dir2])
	end,
	function(ret, p1, self, p2)
		local dir = GetDirection(Clicks[#Clicks]-p1)
		if ((#(PhaseClicks[4] or {})%self.Types)+1) == 3 then
			local curr = Clicks[#Clicks] + DIR_VECTORS[dir]
	
			while Board:IsValid(curr) do
				ret:push_back(curr)
				curr = curr + DIR_VECTORS[dir]
			end
		else
			for j = 1, 3 do
				for i = 2, 8 do
					local curr = Point(p1 + DIR_VECTORS[(dir+j+3)%4] + DIR_VECTORS[(dir+j)%4] * i)
					if not Board:IsValid(curr) then  
						break
					end
					ret:push_back(curr)
				end
			end
		end
	end,
	function(ret, p1, self, p2)
		dir = GetDirection(Clicks[1]-p1)
		dir2 = (GetDirection(Clicks[1]-p1)+1)%4
		ret:push_back(Clicks[1]+DIR_VECTORS[dir2])
	end,
	function(ret, p1, self, p2)
		local dir = GetDirection(Clicks[#Clicks]-p1)
		if ((#(PhaseClicks[6] or {})%self.Types)+1) == 3 then
			local curr = Clicks[#Clicks] + DIR_VECTORS[dir]
	
			while Board:IsValid(curr) do
				ret:push_back(curr)
				curr = curr + DIR_VECTORS[dir]
			end
		else
			for j = 1, 3 do
				for i = 2, 8 do
					local curr = Point(p1 + DIR_VECTORS[(dir+j+1)%4] + DIR_VECTORS[(dir+j)%4] * i)
					if not Board:IsValid(curr) then  
						break
					end
						ret:push_back(curr)
				end
			end
		end
	end,
}
ArtilleryOptionsB = {
function(ret, quadrant, point, dir, self)
	ret:AddArtillery(SpaceDamage(point,0), "effects/shotup_dstrike_missile.png", FULL_DELAY)
	ret:AddDamage(SpaceDamage(point+DIR_VECTORS[dir],self.Damage,dir))
	ret:AddDamage(SpaceDamage(point+DIR_VECTORS[(dir+2)%4],self.Damage,(dir+2)%4))
	if quadrant == -1 then
		ret:AddDamage(SpaceDamage(point+DIR_VECTORS[(dir+3)%4],self.Damage,(dir-1)%4))
	end
	if quadrant == 1 then
		ret:AddDamage(SpaceDamage(point+DIR_VECTORS[(dir+1)%4],self.Damage,(dir+1)%4))
	end
end,
function(ret, quadrant, point, dir, self)
	local damage = SpaceDamage(point + DIR_VECTORS[dir], self.Damage, dir)
	damage.sAnimation = "explopush1_"..dir
	if not self.BuildingDamage and Board:IsBuilding(point + DIR_VECTORS[dir]) then	damage.iDamage = DAMAGE_ZERO 	end 
	damage.bHidePath = true
	damage.sSound = "impact/generic/explosion_multiple"
	ret:AddArtillery(damage,"effects/shotup_tricrack.png", NO_DELAY)
	ret:AddDelay(0.15)
	
	damage = SpaceDamage(point, self.Damage, dir)
	damage.sAnimation = "explopush1_"..dir
	if not self.BuildingDamage and Board:IsBuilding(point) then	damage.iDamage = DAMAGE_ZERO 	end 
	damage.bHidePath = false
	ret:AddArtillery(damage,"effects/shotup_tricrack.png", NO_DELAY)
	ret:AddDelay(0.15)
	
	damage = SpaceDamage(point - DIR_VECTORS[dir], self.Damage, dir)
	damage.sAnimation = "explopush1_"..dir
	if not self.BuildingDamage and Board:IsBuilding(point - DIR_VECTORS[dir]) then	damage.iDamage = DAMAGE_ZERO 	end 
	damage.bHidePath = true
	ret:AddArtillery(damage,"effects/shotup_tricrack.png", NO_DELAY)
	ret:AddDelay(0.5)
	ret:AddBounce(point+DIR_VECTORS[dir], 2)
	ret:AddBounce(point, 2)
	ret:AddBounce(point-DIR_VECTORS[dir], 2)
end,
function(ret, quadrant, point, dir, self)
	local damage = SpaceDamage(point, self.Damage, (dir+2)%4)
	ret:AddArtillery(damage, "effects/shot_artimech.png")  
	ret:AddBounce(point,3)
end,
function(ret, quadrant, point, dir, self)
	local damage = SpaceDamage(point,self.Damage,dir)
	damage.sAnimation = self.QuickExploart
	ret:AddArtillery(damage, "effects/shotup_ignite_fireball.png", NO_DELAY)
end,
function(ret, quadrant, point, dir, self)
	local damage = SpaceDamage(point,self.Damage)
	damage.bKO_Effect = Board:IsDeadly(damage, Pawn)
	ret:AddArtillery(damage,"effects/shot_artimech.png",NO_DELAY)
end
}

ArtilleryOptionsBFinal = {
function(ret, quadrant, point, dir, self)
	local damage = SpaceDamage(point,0)
	damage.sAnimation = "ExploRepulse2",
	ret:AddArtillery(damage, "effects/shotup_dstrike_missile.png", NO_DELAY)
	return nil
end,
function(ret, quadrant, point, dir, self)
	local damage = SpaceDamage(point + DIR_VECTORS[dir], self.Damage, dir)
	damage.sAnimation = "explopush1_"..dir
	damage.bHidePath = true
	damage.sSound = "impact/generic/explosion_multiple"
	ret:AddArtillery(damage,"effects/shotup_tricrack.png", NO_DELAY)
	return nil
end,
function(ret, quadrant, point, dir, self)
	local damage = SpaceDamage(point, self.Damage, (dir+2)%4)
	damage.sAnimation = "ExploArt2"
	ret:AddArtillery(damage, "effects/shot_artimech.png", NO_DELAY)  
	return nil
end,
function(ret, quadrant, point, dir, self)
	local damage = SpaceDamage(point,self.Damage,dir)
	damage.sAnimation = self.QuickExploart
	ret:AddArtillery(damage, "effects/shotup_ignite_fireball.png", NO_DELAY)
	return nil
end,
function(ret, quadrant, point, dir, self)
	local damage = SpaceDamage(point,self.Damage)
	damage.bKO_Effect = Board:IsDeadly(damage, Pawn)
	ret:AddArtillery(damage,"effects/shot_artimech.png",NO_DELAY)
	return Board:IsDeadly(damage, Pawn)
end
}


SkillEffectsB = {
	function(ret, p1, p2, self)
		local dir = GetDirection(p2-p1)
		ret:AddArtillery(SpaceDamage(p2+DIR_VECTORS[(dir+1)%4],0), "", NO_DELAY)
		ret:AddArtillery(SpaceDamage(p2+DIR_VECTORS[(dir+3)%4],0), "", NO_DELAY)
		ret:AddArtillery(SpaceDamage(p2,0), "", NO_DELAY)
		ret:AddDamage(SpaceDamage(p1,self.SelfDamage,(dir+2)%4))
	end,
	function(ret, p1, p2, self)
		local dir = GetDirection(Clicks[1]-p1)
		ret:AddArtillery(SpaceDamage(Clicks[1]+DIR_VECTORS[(dir+1)%4],0), "", NO_DELAY)
		ret:AddArtillery(SpaceDamage(Clicks[1]+DIR_VECTORS[(dir+3)%4],0), "", NO_DELAY)
		ArtilleryOptionsB[(#(PhaseClicks[2] or {})%self.Types)+1](ret,0,Clicks[1],dir,self)
		ret:AddDamage(SpaceDamage(p1,self.SelfDamage,(dir+2)%4))
	end,
	function(ret, p1, p2, self)
		local dir = GetDirection(Clicks[1]-p1)
		ret:AddArtillery(SpaceDamage(Clicks[1]+DIR_VECTORS[(dir+1)%4],0), "", NO_DELAY)
		ret:AddArtillery(SpaceDamage(Clicks[1]+DIR_VECTORS[(dir+3)%4],0), "", NO_DELAY)
		ArtilleryOptionsB[(#(PhaseClicks[2] or {})%self.Types)+1](ret,0,Clicks[1],dir,self)
		ret:AddDamage(SpaceDamage(p1,self.SelfDamage,(dir+2)%4))
		if (#(PhaseClicks[2] or {})%self.Types)+1 == 3 then
			if Board:IsValid(p2) then
				local damage = SpaceDamage(p2, self.Damage, dir)
				ret:AddArtillery(p2, damage, "effects/shot_artimech.png", FULL_DELAY)
			end
		end
		if (#(PhaseClicks[2] or {})%self.Types)+1 == 4 then
			d2 = GetDirection(p2-p1)
			damage = SpaceDamage(p2,self.Damage,d2)
			damage.sAnimation = self.QuickExploart
			ret:AddArtillery(damage, "effects/shotup_ignite_fireball.png", NO_DELAY)
		end
		
	end,
	function(ret, p1, p2, self)
		local dir = GetDirection(Clicks[1]-p1)
		ret:AddArtillery(SpaceDamage(Clicks[1]+DIR_VECTORS[(dir+1)%4],0), "", NO_DELAY)
		ArtilleryOptionsB[(#(PhaseClicks[4] or {})%self.Types)+1](ret,-1,Clicks[1]+DIR_VECTORS[(dir+3)%4],dir,self)
		ArtilleryOptionsB[(#(PhaseClicks[2] or {})%self.Types)+1](ret,0,Clicks[1],dir,self)
		ret:AddDamage(SpaceDamage(p1,self.SelfDamage,(dir+2)%4))
		if (#(PhaseClicks[2] or {})%self.Types)+1 == 3 then
			if PhaseClicks[3] and Board:IsValid(PhaseClicks[3][1]) then
				local damage = SpaceDamage(PhaseClicks[3][1], self.Damage, dir)
				ret:AddArtillery(PhaseClicks[2][1], damage, "effects/shot_artimech.png", FULL_DELAY)
			end
		end
		if (#(PhaseClicks[2] or {})%self.Types)+1 == 4 then
			d2 = GetDirection(PhaseClicks[3][1]-p1)
			damage = SpaceDamage(PhaseClicks[3][1],self.Damage,d2)
			damage.sAnimation = self.QuickExploart
			ret:AddArtillery(damage, "effects/shotup_ignite_fireball.png", NO_DELAY)
		end
	end,
	function(ret, p1, p2, self)
		local dir = GetDirection(Clicks[1]-p1)
		ret:AddArtillery(SpaceDamage(Clicks[1]+DIR_VECTORS[(dir+1)%4],0), "", NO_DELAY)
		ArtilleryOptionsB[(#(PhaseClicks[4] or {})%self.Types)+1](ret,-1,Clicks[1]+DIR_VECTORS[(dir+3)%4],dir,self)
		ArtilleryOptionsB[(#(PhaseClicks[2] or {})%self.Types)+1](ret,0,Clicks[1],dir,self)
		ret:AddDamage(SpaceDamage(p1,self.SelfDamage,(dir+2)%4))
		if (#(PhaseClicks[2] or {})%self.Types)+1 == 3 then
			if PhaseClicks[3] and Board:IsValid(PhaseClicks[3][1]) then
				local damage = SpaceDamage(PhaseClicks[3][1], self.Damage, dir)
				ret:AddArtillery(PhaseClicks[2][1], damage, "effects/shot_artimech.png", FULL_DELAY)
			end
		end
		if (#(PhaseClicks[2] or {})%self.Types)+1 == 4 then
			d2 = GetDirection(PhaseClicks[3][1]-p1)
			damage = SpaceDamage(PhaseClicks[3][1],self.Damage,d2)
			damage.sAnimation = self.QuickExploart
			ret:AddArtillery(damage, "effects/shotup_ignite_fireball.png", NO_DELAY)
		end
		if (#(PhaseClicks[4] or {})%self.Types)+1 == 3 then
			if Board:IsValid(p2) then
				local damage = SpaceDamage(p2, self.Damage, dir)
				ret:AddArtillery(PhaseClicks[4][1], damage, "effects/shot_artimech.png", FULL_DELAY)
			end
		end
		if (#(PhaseClicks[4] or {})%self.Types)+1 == 4 then
			d2 = GetDirection(p2-p1)
			damage = SpaceDamage(p2,self.Damage,d2)
			damage.sAnimation = self.QuickExploart
			ret:AddArtillery(damage, "effects/shotup_ignite_fireball.png", NO_DELAY)
		end
	end,
	function(ret, p1, p2, self)
		local dir = GetDirection(Clicks[1]-p1)
		ArtilleryOptionsBFinal[(#(PhaseClicks[6] or {})%self.Types)+1](ret,1,Clicks[1]+DIR_VECTORS[(dir+1)%4],dir,self)
		ArtilleryOptionsBFinal[(#(PhaseClicks[4] or {})%self.Types)+1](ret,-1,Clicks[1]+DIR_VECTORS[(dir+3)%4],dir,self)
		ArtilleryOptionsBFinal[(#(PhaseClicks[2] or {})%self.Types)+1](ret,0,Clicks[1],dir,self)
		ret:AddDamage(SpaceDamage(p1,self.SelfDamage,(dir+2)%4))
		if (#(PhaseClicks[2] or {})%self.Types)+1 == 4 then
			d2 = GetDirection(PhaseClicks[3][1]-p1)
			damage = SpaceDamage(PhaseClicks[3][1],self.Damage,d2)
			damage.sAnimation = self.QuickExploart
			ret:AddArtillery(damage, "effects/shotup_ignite_fireball.png", NO_DELAY)
		end

		if (#(PhaseClicks[4] or {})%self.Types)+1 == 4 then
			d2 = GetDirection(PhaseClicks[5][1]-p1)
			damage = SpaceDamage(PhaseClicks[5][1],self.Damage,d2)
			damage.sAnimation = self.QuickExploart
			ret:AddArtillery(damage, "effects/shotup_ignite_fireball.png", NO_DELAY)
		end
		ret:AddDelay(0.15)
			damage = SpaceDamage(Clicks[1], self.Damage, dir)
			damage.sAnimation = "explopush1_"..dir
			damage.bHidePath = false
			if (#(PhaseClicks[2] or {})%self.Types)+1 == 2 then
				damage.loc = Clicks[1]
				ret:AddArtillery(damage,"effects/shotup_tricrack.png", NO_DELAY)
			end
			if (#(PhaseClicks[4] or {})%self.Types)+1 == 2 then
				damage.loc = Clicks[1]+DIR_VECTORS[(dir+3)%4]
				ret:AddArtillery(damage,"effects/shotup_tricrack.png", NO_DELAY)
			end
			if (#(PhaseClicks[6] or {})%self.Types)+1 == 2 then
				damage.loc = Clicks[1]+DIR_VECTORS[(dir+1)%4]
				ret:AddArtillery(damage,"effects/shotup_tricrack.png", NO_DELAY)
			end
		ret:AddDelay(0.15)
			damage = SpaceDamage(Clicks[1], self.Damage, dir)
			damage.sAnimation = "explopush1_"..dir
			damage.bHidePath = true
			if (#(PhaseClicks[2] or {})%self.Types)+1 == 2 then
				damage.loc = Clicks[1]+DIR_VECTORS[(dir+2)%4]
				ret:AddArtillery(damage,"effects/shotup_tricrack.png", NO_DELAY)
			end
			if (#(PhaseClicks[4] or {})%self.Types)+1 == 2 then
				damage.loc = Clicks[1]+DIR_VECTORS[(dir+3)%4]+DIR_VECTORS[(dir+2)%4]
				ret:AddArtillery(damage,"effects/shotup_tricrack.png", NO_DELAY)
			end
			if (#(PhaseClicks[6] or {})%self.Types)+1 == 2 then
				damage.loc = Clicks[1]+DIR_VECTORS[(dir+1)%4]+DIR_VECTORS[(dir+2)%4]
				ret:AddArtillery(damage,"effects/shotup_tricrack.png", NO_DELAY)
			end
		ret:AddDelay(0.5)


		function test()
		if (#(PhaseClicks[2] or {})%self.Types)+1 == 1 then
			local dirs = {0,2}
			for i = 1,2 do
				local damage = SpaceDamage(Clicks[1]+DIR_VECTORS[(dir+dirs[i])%4],self.Damage,(dir+dirs[i])%4)
				damage.sAnimation = "explopush1_"..(dir+dirs[i])%4
				ret:AddDamage(damage)
			end
		end
		if (#(PhaseClicks[4] or {})%self.Types)+1 == 1 then
			local dirs = {0,2,3}
			for i = 1,3 do
				local damage = SpaceDamage(Clicks[1]+DIR_VECTORS[(dir+dirs[i])%4]+DIR_VECTORS[(dir+3)%4],self.Damage,(dir+dirs[i])%4)
				damage.sAnimation = "explopush1_"..(dir+dirs[i])%4
				ret:AddDamage(damage)
			end
		end
		if (#(PhaseClicks[6] or {})%self.Types)+1 == 1 then
			local dirs = {0,2,1}
			for i = 1,3 do
				local damage = SpaceDamage(Clicks[1]+DIR_VECTORS[(dir+dirs[i])%4]+DIR_VECTORS[(dir+1)%4],self.Damage,(dir+dirs[i])%4)
				damage.sAnimation = "explopush1_"..(dir+dirs[i])%4
				ret:AddDamage(damage)
			end
		end
		if (#(PhaseClicks[2] or {})%self.Types)+1 == 2 then
			ret:AddBounce(PhaseClicks[2][1]+DIR_VECTORS[dir], 2)
			ret:AddBounce(PhaseClicks[2][1], 2)
			ret:AddBounce(PhaseClicks[2][1]-DIR_VECTORS[dir], 2)
		end
		if (#(PhaseClicks[4] or {})%self.Types)+1 == 2 then
			ret:AddBounce(PhaseClicks[4][1]+DIR_VECTORS[dir], 2)
			ret:AddBounce(PhaseClicks[4][1], 2)
			ret:AddBounce(PhaseClicks[4][1]-DIR_VECTORS[dir], 2)
		end
		if (#(PhaseClicks[6] or {})%self.Types)+1 == 2 then
			ret:AddBounce(PhaseClicks[6][1]+DIR_VECTORS[dir], 2)
			ret:AddBounce(PhaseClicks[6][1], 2)
			ret:AddBounce(PhaseClicks[6][1]-DIR_VECTORS[dir], 2)
		end

		if (#(PhaseClicks[4] or {})%self.Types)+1 == 3 then
			if PhaseClicks[5] and Board:IsValid(PhaseClicks[5][1]) then
				local damage = SpaceDamage(PhaseClicks[5][1], self.Damage, dir)
				damage.sAnimation = "ExploRepulse1"
				ret:AddArtillery(PhaseClicks[4][1], damage, "effects/shot_artimech.png", NO_DELAY)
			end
		end
		if (#(PhaseClicks[2] or {})%self.Types)+1 == 3 then
			if PhaseClicks[3] and Board:IsValid(PhaseClicks[3][1]) then
				local damage = SpaceDamage(PhaseClicks[3][1], self.Damage, dir)
				damage.sAnimation = "ExploRepulse1"
				ret:AddArtillery(PhaseClicks[2][1], damage, "effects/shot_artimech.png", NO_DELAY)
			end
		end
		end
		test()
	end,
--######################################
--######################################
--######################################
--######################################
	function(ret, p1, p2, self)
		local dir = GetDirection(Clicks[1]-p1)
		local KillC = ArtilleryOptionsBFinal[(#(PhaseClicks[6] or {})%self.Types)+1](ret,1,Clicks[1]+DIR_VECTORS[(dir+1)%4],dir,self)
		local KillB = ArtilleryOptionsBFinal[(#(PhaseClicks[4] or {})%self.Types)+1](ret,-1,Clicks[1]+DIR_VECTORS[(dir+3)%4],dir,self)
		local KillA = ArtilleryOptionsBFinal[(#(PhaseClicks[2] or {})%self.Types)+1](ret,0,Clicks[1],dir,self)
		ret:AddDamage(SpaceDamage(p1,self.SelfDamage,(dir+2)%4))
		if (#(PhaseClicks[2] or {})%self.Types)+1 == 4 then
			d2 = GetDirection(PhaseClicks[3][1]-p1)
			damage = SpaceDamage(PhaseClicks[3][1],self.Damage,d2)
			damage.sAnimation = self.QuickExploart
			ret:AddArtillery(damage, "effects/shotup_ignite_fireball.png", NO_DELAY)
		end

		if (#(PhaseClicks[4] or {})%self.Types)+1 == 4 then
			d2 = GetDirection(PhaseClicks[5][1]-p1)
			damage = SpaceDamage(PhaseClicks[5][1],self.Damage,d2)
			damage.sAnimation = self.QuickExploart
			ret:AddArtillery(damage, "effects/shotup_ignite_fireball.png", NO_DELAY)
		end
		if (#(PhaseClicks[6] or {})%self.Types)+1 == 4 then
			d2 = GetDirection(p2-p1)
			damage = SpaceDamage(p2,self.Damage,d2)
			damage.sAnimation = self.QuickExploart
			ret:AddArtillery(damage, "effects/shotup_ignite_fireball.png", NO_DELAY)
		end
		ret:AddDelay(0.15)
			damage = SpaceDamage(Clicks[1], self.Damage, dir)
			damage.sAnimation = "explopush1_"..dir
			damage.bHidePath = false
			if (#(PhaseClicks[2] or {})%self.Types)+1 == 2 then
				damage.loc = Clicks[1]
				ret:AddArtillery(damage,"effects/shotup_tricrack.png", NO_DELAY)
			end
			if (#(PhaseClicks[4] or {})%self.Types)+1 == 2 then
				damage.loc = Clicks[1]+DIR_VECTORS[(dir+3)%4]
				ret:AddArtillery(damage,"effects/shotup_tricrack.png", NO_DELAY)
			end
			if (#(PhaseClicks[6] or {})%self.Types)+1 == 2 then
				damage.loc = Clicks[1]+DIR_VECTORS[(dir+1)%4]
				ret:AddArtillery(damage,"effects/shotup_tricrack.png", NO_DELAY)
			end
		ret:AddDelay(0.15)
			damage = SpaceDamage(Clicks[1], self.Damage, dir)
			damage.sAnimation = "explopush1_"..dir
			damage.bHidePath = true
			if (#(PhaseClicks[2] or {})%self.Types)+1 == 2 then
				damage.loc = Clicks[1]+DIR_VECTORS[(dir+2)%4]
				ret:AddArtillery(damage,"effects/shotup_tricrack.png", NO_DELAY)
			end
			if (#(PhaseClicks[4] or {})%self.Types)+1 == 2 then
				damage.loc = Clicks[1]+DIR_VECTORS[(dir+3)%4]+DIR_VECTORS[(dir+2)%4]
				ret:AddArtillery(damage,"effects/shotup_tricrack.png", NO_DELAY)
			end
			if (#(PhaseClicks[6] or {})%self.Types)+1 == 2 then
				damage.loc = Clicks[1]+DIR_VECTORS[(dir+1)%4]+DIR_VECTORS[(dir+2)%4]
				ret:AddArtillery(damage,"effects/shotup_tricrack.png", NO_DELAY)
			end

		ret:AddDelay(0.5)

		function test()
		if (#(PhaseClicks[2] or {})%self.Types)+1 == 1 then
			local dirs = {0,2}
			for i = 1,2 do
				local damage = SpaceDamage(Clicks[1]+DIR_VECTORS[(dir+dirs[i])%4],self.Damage,(dir+dirs[i])%4)
				damage.sAnimation = self.ClusterOuterAnim..(dir+dirs[i])%4
				ret:AddDamage(damage)
				local damage2 = SpaceDamage(Clicks[1],0)
				damage2.sAnimation = "ExploRepulse2"
				ret:AddDamage(damage2)
				ret:AddBounce(Clicks[1]+DIR_VECTORS[(dir+dirs[i])%4], self.ClusterBounceAmt)
			end
		end
		if (#(PhaseClicks[4] or {})%self.Types)+1 == 1 then
			local dirs = {0,2,3}
			for i = 1,3 do
				local damage = SpaceDamage(Clicks[1]+DIR_VECTORS[(dir+dirs[i])%4]+DIR_VECTORS[(dir+3)%4],self.Damage,(dir+dirs[i])%4)
				damage.sAnimation = self.ClusterOuterAnim..(dir+dirs[i])%4
				ret:AddDamage(damage)
				local damage2 = SpaceDamage(Clicks[1]+DIR_VECTORS[(dir+3)%4],0)
				damage2.sAnimation = "ExploRepulse2"
				ret:AddDamage(damage2)
				ret:AddBounce(Clicks[1]+DIR_VECTORS[(dir+dirs[i])%4]+DIR_VECTORS[(dir+3)%4], self.ClusterBounceAmt)
			end
		end
		if (#(PhaseClicks[6] or {})%self.Types)+1 == 1 then
			local dirs = {0,2,1}
			for i = 1,3 do
				local damage = SpaceDamage(Clicks[1]+DIR_VECTORS[(dir+dirs[i])%4]+DIR_VECTORS[(dir+1)%4],self.Damage,(dir+dirs[i])%4)
				damage.sAnimation = self.ClusterOuterAnim..(dir+dirs[i])%4
				ret:AddDamage(damage)
				local damage2 = SpaceDamage(Clicks[1]+DIR_VECTORS[(dir+1)%4],0)
				damage2.sAnimation = "ExploRepulse2"
				ret:AddDamage(damage2)
				ret:AddBounce(Clicks[1]+DIR_VECTORS[(dir+dirs[i])%4]+DIR_VECTORS[(dir+1)%4], self.ClusterBounceAmt)
			end
		end

		if (#(PhaseClicks[4] or {})%self.Types)+1 == 3 then
			ret:AddBounce(PhaseClicks[4][1],3)
			if PhaseClicks[5] and Board:IsValid(PhaseClicks[5][1]) then
				local damage = SpaceDamage(PhaseClicks[5][1], self.Damage, dir)
				damage.sAnimation = "ExploArt2"
				ret:AddArtillery(PhaseClicks[4][1], damage, "effects/shot_artimech.png", NO_DELAY)
			end
		end
		if (#(PhaseClicks[2] or {})%self.Types)+1 == 3 then
			ret:AddBounce(PhaseClicks[2][1],3)
			if PhaseClicks[3] and Board:IsValid(PhaseClicks[3][1]) then
				local damage = SpaceDamage(PhaseClicks[3][1], self.Damage, dir)
				damage.sAnimation = "ExploArt2"
				ret:AddArtillery(PhaseClicks[2][1], damage, "effects/shot_artimech.png", NO_DELAY)
			end
		end
		if (#(PhaseClicks[6] or {})%self.Types)+1 == 3 then
			ret:AddBounce(PhaseClicks[6][1],3)
			if Board:IsValid(p2) then
				local damage = SpaceDamage(p2, self.Damage, dir)
				damage.sAnimation = "ExploArt2"
				ret:AddArtillery(PhaseClicks[6][1], damage, "effects/shot_artimech.png", NO_DELAY)
			end
		end
		end
		test()
		ret:AddDelay(.3)
		if KillA then
				local damage = SpaceDamage(PhaseClicks[2][1],0)
				if Board:IsTerrain(damage.loc,TERRAIN_WATER) or Board:IsTerrain(damage.loc,TERRAIN_LAVA) or Board:IsTerrain(damage.loc,TERRAIN_HOLE) or Board:IsCracked(damage.loc) or (Board:IsTerrain(damage.loc,TERRAIN_ICE) and Board:IsCracked(damage.loc)) then
					ret:AddBounce(damage.loc,1)
					damage.sPawn = "Copter_Bloom_Bot"
					ret:AddDamage(damage)
				else
					ret:AddAnimation(damage.loc,"Nico_Artillery_Bloome", ANIM_DELAY)
					damage.sPawn = "Nico_artillerybloom"
					ret:AddDamage(damage)
				end
				if Board:IsTerrain(damage.loc,TERRAIN_LAVA) then--this checks that the tile the copter spawns is a lava tile
					local minifire = SpaceDamage(damage.loc)
					minifire.iFire = 1
					ret:AddDamage(minifire)
				end
				if Board:IsAcid(damage.loc) and Board:IsTerrain(damage.loc,TERRAIN_WATER) then --this does the same but for acid water
					local miniacid = SpaceDamage(damage.loc)
					miniacid.iAcid = 1
					ret:AddDamage(miniacid)
				end
		end
		if KillB then
				local damage = SpaceDamage(PhaseClicks[4][1],0)
				damage.sSound = "/weapons/arachnoid_ko"
				if Board:IsTerrain(damage.loc,TERRAIN_WATER) or Board:IsTerrain(damage.loc,TERRAIN_LAVA) or Board:IsTerrain(damage.loc,TERRAIN_HOLE) or Board:IsCracked(damage.loc) or (Board:IsTerrain(damage.loc,TERRAIN_ICE) and Board:IsCracked(damage.loc)) then
					ret:AddBounce(damage.loc,1)
					damage.sPawn = "Copter_Bloom_Bot"
					ret:AddDamage(damage)
				else
					ret:AddAnimation(damage.loc,"Nico_Artillery_Bloome", ANIM_DELAY)
					damage.sPawn = "Nico_artillerybloom"
					ret:AddDamage(damage)
				end
				if Board:IsTerrain(damage.loc,TERRAIN_LAVA) then--this checks that the tile the copter spawns is a lava tile
					local minifire = SpaceDamage(damage.loc)
					minifire.iFire = 1
					ret:AddDamage(minifire)
				end
				if Board:IsAcid(damage.loc) and Board:IsTerrain(damage.loc,TERRAIN_WATER) then --this does the same but for acid water
					local miniacid = SpaceDamage(damage.loc)
					miniacid.iAcid = 1
					ret:AddDamage(miniacid)
				end
		end
		if KillC then
				local damage = SpaceDamage(PhaseClicks[6][1],0)
				if Board:IsTerrain(damage.loc,TERRAIN_WATER) or Board:IsTerrain(damage.loc,TERRAIN_LAVA) or Board:IsTerrain(damage.loc,TERRAIN_HOLE) or Board:IsCracked(damage.loc) or (Board:IsTerrain(damage.loc,TERRAIN_ICE) and Board:IsCracked(damage.loc)) then
					ret:AddBounce(damage.loc,1)
					damage.sPawn = "Copter_Bloom_Bot"
					ret:AddDamage(damage)
				else
					ret:AddAnimation(damage.loc,"Nico_Artillery_Bloome", ANIM_DELAY)
					damage.sPawn = "Nico_artillerybloom"
					ret:AddDamage(damage)
				end
				if Board:IsTerrain(damage.loc,TERRAIN_LAVA) then--this checks that the tile the copter spawns is a lava tile
					local minifire = SpaceDamage(damage.loc)
					minifire.iFire = 1
					ret:AddDamage(minifire)
				end
				if Board:IsAcid(damage.loc) and Board:IsTerrain(damage.loc,TERRAIN_WATER) then --this does the same but for acid water
					local miniacid = SpaceDamage(damage.loc)
					miniacid.iAcid = 1
					ret:AddDamage(miniacid)
				end
		end
	end
}
PhaseChangesB = {
	nil,
	function(ret, p1, p2, self)
		return 2
	end,
	nil,
	function(ret, p1, p2, self)
		return 4
	end,
	nil,
	function(ret, p1, p2, self)
		return 6
	end,
	nil
}


ConfirmationFuncsB = {
	function(p1,self)
	end,
	function(p1,self)
		if (((#(PhaseClicks[2] or {})%self.Types)+1) > 2) and not (((#(PhaseClicks[2] or {})%self.Types)+1) == 5) then
			Phase = 3
			if ((#(PhaseClicks[2] or {})%self.Types)+1) == 3 and (not Board:IsValid(Clicks[1] + DIR_VECTORS[GetDirection(Clicks[1]-p1)])) then
				Phase = 4
			end
		else
			Phase = 4
		end
	end,
	function(p1,self)
	end,
	function(p1,self)
		if (((#(PhaseClicks[4] or {})%self.Types)+1) > 2) and not (((#(PhaseClicks[4] or {})%self.Types)+1) == 5) then
			Phase = 5
			if ((#(PhaseClicks[4] or {})%self.Types)+1) == 3 and (not Board:IsValid(Clicks[1] + DIR_VECTORS[GetDirection(Clicks[1]-p1)])) then
				Phase = 6
			end
		else
			Phase = 6
		end
	end,
	function(p1,self)
	end,
	function(p1,self)
		if (((#(PhaseClicks[6] or {})%self.Types)+1) > 2) and not (((#(PhaseClicks[6] or {})%self.Types)+1) == 5) then
			Phase = 7
			if ((#(PhaseClicks[6] or {})%self.Types)+1) == 3 and (not Board:IsValid(Clicks[1] + DIR_VECTORS[GetDirection(Clicks[1]-p1)])) then
				Phase = 7
				return "true"
			end
		else
			Phase = 7
			return "true"
		end
	end,
	function(p1,self)
	end,
}













Nico_artilleryboom = NClickSkill:new{
	Name = "Bang Rockets Mark I",
	Class = "TechnoVek",
	Icon = "weapons/support_missiles.png",
	Description = "Launch Cluster, Triptych, Quickfire, or Bounce rockets at 3 tiles.",
	BounceAmount = 2,
	Damage = 1,
	SelfDamage = 0,
	PowerCost = 0,
	BuildingDamage = true,
	Upgrades = 2,
	UpgradeList = { "+1 Damage Each",  "+1 Damage"  },
	UpgradeCost = {1,3},
	Phases = 7,
	QuickExploart = "ExploArt1",
	ClusterOuterAnim = "explopush1_",
	ClusterBounceAmt = 2,
	TargetAreas = TargetAreasB,
	SkillEffects = SkillEffectsB,
	Confirmation = true,
	ConfirmationFuncs = ConfirmationFuncsB,
	PhaseChanges = PhaseChangesB,
	LaunchSound = "/enemy/snowart_1/attack",
	ImpactSound = "/impact/generic/explosion",
	KOSound = "/weapons/arachnoid_ko",
	Types = 4,
	CustomTipImage = "Nico_artilleryboom_Tip",
	TipImage = {
		Unit = Point(3,3),
		Target = Point(3,2),
		Enemy1 = Point(1,1),
		Enemy2 = Point(3,1),
		Mountain1 = Point(1,0),
		Mountain2 = Point(3,0),
		Second_Click = Point(1,1),
		Second_Origin = Point(3,3),
		Second_Target = Point(3,1),
        	CustomPawn="Nico_artilleryboom_mech",
		CustomEnemy="Scorpion1",
	},
}
Nico_artilleryboom_A = Nico_artilleryboom:new{
	SelfDamage = 1,
	UpgradeDescription = "Deals 1 additional damage to all targets and damages self.\nAdds a fifth rocket type which creates a Bloom-Artillery on kill.",
	Damage = 2,
	CustomTipImage = "Nico_artilleryboom_Tip_A",
	ClusterBounceAmt = 3,
	ClusterOuterAnim = "explopush2_",
	QuickExploart = "ExploArt2",
	Types = 5,
}
Nico_artilleryboom_B = Nico_artilleryboom:new{
	Damage = 2,
	ClusterBounceAmt = 3,
	CustomTipImage = "Nico_artilleryboom_Tip_B",
	UpgradeDescription = "Deals 1 additional damage to all targets.",
	ClusterOuterAnim = "explopush2_",
	QuickExploart = "ExploArt2"
}
Nico_artilleryboom_AB = Nico_artilleryboom_A:new{
	CustomTipImage = "Nico_artilleryboom_Tip_AB",
	Damage = 3,
}

Nico_artilleryboom_mech_Tip = Nico_artilleryboom_mech:new{
	Health = 2
}


Nico_artilleryboom_Tip = Grenade_Base:new{
	Damage = 1,
	QuickExploart = "ExploArt1",
	ClusterOuterAnim = "explopush1_",
	ClusterBounceAmt = 2,
	TipImage = {
		Unit = Point(2,3),
		Target = Point(0,1),
		Second_Origin = Point(2,3),
		Second_Target = Point(0,0),
		Enemy1 = Point(1,1),
		Enemy2 = Point(2,1),
		Enemy3 = Point(3,1),
        	CustomPawn="Nico_artilleryboom_mech",
		CustomEnemy="Scorpion1",
	},
}

Nico_artilleryboom_Tip_A = Nico_artilleryboom_Tip:new{
	SelfDamage = 1,
	Damage = 2,
	ClusterBounceAmt = 3,
	ClusterOuterAnim = "explopush2_",
	QuickExploart = "ExploArt2",
	Types = 5,
	TipImage = {
		Unit = Point(2,3),
		Target = Point(0,2),
		Enemy1 = Point(1,1),
		Second_Origin = Point(2,3),
		Second_Target = Point(0,0),
		Enemy2 = Point(2,1),
		Enemy3 = Point(3,1),
        	CustomPawn="Nico_artilleryboom_mech_Tip",
		CustomEnemy="Digger1",
	},
}
Nico_artilleryboom_Tip_B = Nico_artilleryboom_Tip:new{
	Damage = 2,
	ClusterBounceAmt = 3,
	ClusterOuterAnim = "explopush2_",
	QuickExploart = "ExploArt2"
}
Nico_artilleryboom_Tip_AB = Nico_artilleryboom_Tip_A:new{
	Damage = 3,
	TipImage = {
		Unit = Point(2,3),
		Target = Point(0,2),
		Enemy1 = Point(1,1),
		Second_Origin = Point(2,3),
		Second_Target = Point(0,0),
		Enemy2 = Point(2,1),
		Enemy3 = Point(3,1),
        	CustomPawn="Nico_artilleryboom_mech_Tip",
		CustomEnemy="Scorpion1",
	},
}


function Nico_artilleryboom_Tip:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	ret:AddDamage(SpaceDamage(p1,self.SelfDamage,2))
	if p2 == Point(0,0) then
		local damage = SpaceDamage(Point(2,1),0)
		damage.sAnimation = "ExploRepulse2",
		ret:AddArtillery(damage, "effects/shotup_dstrike_missile.png", NO_DELAY)
		local damage = SpaceDamage(Point(2,0),self.Damage,0)
	damage.bHidePath = true
		damage.sAnimation = self.ClusterOuterAnim..0
		ret:AddArtillery(damage, "", NO_DELAY)
		local damage = SpaceDamage(Point(2,2),self.Damage,2)
	damage.bHidePath = true
		damage.sAnimation = self.ClusterOuterAnim..2
		ret:AddArtillery(damage, "", NO_DELAY)
	local damage = SpaceDamage(Point(1,0), self.Damage, 0)
	damage.sAnimation = "explopush1_"..0
	damage.bHidePath = true
	ret:AddArtillery(damage,"effects/shotup_tricrack.png", NO_DELAY)

	local damage = SpaceDamage(Point(3,1), self.Damage, 2)
	damage.sAnimation = "ExploArt2"
	ret:AddArtillery(damage, "effects/shot_artimech.png",NO_DELAY)  


	ret:AddDelay(0.15)
	
	local damage = SpaceDamage(Point(1,1), self.Damage, 0)
	damage.sAnimation = "explopush1_"..0
	damage.bHidePath = false
	ret:AddArtillery(damage,"effects/shotup_tricrack.png", NO_DELAY)
	ret:AddDelay(0.15)
	
	local damage = SpaceDamage(Point(1,2), self.Damage, 0)
	damage.sAnimation = "explopush1_"..0
	damage.bHidePath = true
	ret:AddArtillery(damage,"effects/shotup_tricrack.png", NO_DELAY)

	ret:AddDelay(0.5)
	local damage = SpaceDamage(Point(3,0), self.Damage, 0)
	damage.sAnimation = "ExploArt2"
	ret:AddArtillery(Point(3,1), damage, "effects/shot_artimech.png", NO_DELAY)
	ret:AddBounce(Point(1,0), 2)
	ret:AddBounce(Point(1,1), 2)
	ret:AddBounce(Point(1,2), 2)
	ret:AddBounce(Point(1,0), self.ClusterBounceAmt)
	ret:AddBounce(Point(1,2), self.ClusterBounceAmt)
elseif p2 == Point(0,1) then
		local damage = SpaceDamage(Point(1,1),0)
		damage.sAnimation = "ExploRepulse2",
		ret:AddArtillery(damage, "effects/shotup_dstrike_missile.png", NO_DELAY)
		local damage = SpaceDamage(Point(1,0),self.Damage,0)
	damage.bHidePath = true
		damage.sAnimation = self.ClusterOuterAnim..0
		ret:AddArtillery(damage, "", NO_DELAY)
		local damage = SpaceDamage(Point(0,1),self.Damage,3)
	damage.bHidePath = true
		damage.sAnimation = self.ClusterOuterAnim..3
		ret:AddArtillery(damage, "", NO_DELAY)
		local damage = SpaceDamage(Point(1,2),self.Damage,2)
	damage.bHidePath = true
		damage.sAnimation = self.ClusterOuterAnim..2
		ret:AddArtillery(damage, "", NO_DELAY)
	local damage = SpaceDamage(Point(2,1),self.Damage,0)
	damage.sAnimation = self.QuickExploart
	ret:AddArtillery(damage, "effects/shotup_ignite_fireball.png", NO_DELAY)

	damage = SpaceDamage(Point(0,3),self.Damage,3)
	damage.sAnimation = self.QuickExploart
	ret:AddArtillery(damage, "effects/shotup_ignite_fireball.png", NO_DELAY)

	local damage = SpaceDamage(Point(3,1),self.Damage,0)
	damage.sAnimation = self.QuickExploart
	ret:AddArtillery(damage, "effects/shotup_ignite_fireball.png", NO_DELAY)

	damage = SpaceDamage(Point(0,2),self.Damage,3)
	damage.sAnimation = self.QuickExploart
	ret:AddArtillery(damage, "effects/shotup_ignite_fireball.png", NO_DELAY)
	ret:AddDelay(.8)
	ret:AddBounce(Point(1,0), self.ClusterBounceAmt)
	ret:AddBounce(Point(0,1), self.ClusterBounceAmt)
	ret:AddBounce(Point(1,2), self.ClusterBounceAmt)
else
	local damage = SpaceDamage(Point(2,1),self.Damage,0)
	damage.sAnimation = self.QuickExploart
	ret:AddArtillery(damage, "effects/shotup_ignite_fireball.png", NO_DELAY)

	damage = SpaceDamage(Point(0,3),self.Damage,3)
	damage.sAnimation = self.QuickExploart
	ret:AddArtillery(damage, "effects/shotup_ignite_fireball.png", NO_DELAY)

	local damage = SpaceDamage(Point(3,1),self.Damage,0)
	damage.sAnimation = self.QuickExploart
	ret:AddArtillery(damage, "effects/shotup_ignite_fireball.png", NO_DELAY)

	damage = SpaceDamage(Point(0,2),self.Damage,3)
	damage.sAnimation = self.QuickExploart
	ret:AddArtillery(damage, "effects/shotup_ignite_fireball.png", NO_DELAY)

	damage = SpaceDamage(Point(1,1),self.Damage)
	damage.bKO_Effect = Board:IsDeadly(damage, Pawn)
	ret:AddArtillery(damage,"effects/shot_artimech.png",NO_DELAY)
	ret:AddDelay(1.1)
	damage = SpaceDamage(Point(1,1),0)
	ret:AddAnimation(Point(1,1),"Nico_Artillery_Bloome", ANIM_DELAY)
	damage.sPawn = "Nico_artillerybloom"
	ret:AddDamage(damage)
end
	ret:AddMove(Board:GetPath(Point(2,4), Point(2,3), PATH_GROUND), FULL_DELAY)
return ret
end