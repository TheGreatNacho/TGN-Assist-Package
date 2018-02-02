--Taken from http://forums.ulyssesmod.net/index.php?topic=8265.0
function FGod( ply, dmginfo )
		if(ply:GetNWInt("FGod") == 1) then
				dmginfo:ScaleDamage( 0 )
		end
end
hook.Add("EntityTakeDamage", "FGod", FGod)

hook.Add("PhysgunDrop", "ply_physgunfreeze", function(pl, ent)
	hook.Remove( "PhysgunDrop", "ulxPlayerDrop" )
	
	ent._physgunned = false
	
	if( ent:IsPlayer() ) then         		   
		ent:SetMoveType(pl:KeyDown(IN_ATTACK2) and MOVETYPE_NOCLIP or MOVETYPE_WALK)
		
		if(pl:KeyDown(IN_ATTACK2)) then
			ent:Freeze(true)
			ent:SetNWInt("FGod", 1)
			ent:DisallowSpawning( not should_unfreeze )
			ulx.setNoDie( ent, not should_unfreeze )
			table.insert( affected_plys, ent )
		else
			ent:Freeze(false)
			ent:SetNWInt("FGod", 0)
			ent:DisallowSpawning( false )
			ulx.setNoDie( ent, should_unfreeze )
			//table.insert( affected_plys, ent )
		end
		   
		if SERVER then
			
			if !ent:Alive() then
				ent:Spawn()
				self:PlayerSpawn(ent)
				ent:SetPos(pl:GetEyeTrace().HitPos)
			end
		end
		
		return --self.BaseClass:PhysgunDrop( pl , ent )   
	end
end)

hook.Add( "PhysgunPickup", "ply_physgunned", function(pl, ent)
	ent._physgunned = true
end)

function playerDies( pl, weapon, killer )
	if(pl._physgunned) then
		return false
	else
		return true
	end
end
hook.Add( "CanPlayerSuicide", "playerNoDeath", playerDies ) 