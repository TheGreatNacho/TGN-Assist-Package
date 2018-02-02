/*------------------------------------------
InvisPhysguns - Exilium
------------------------------------------*/

timer.Create( "PhysgunTimer", 1, 0, function()
    for id, ply in pairs( player.GetAll() ) do
		teamColor = team.GetColor(ply:Team())
		tcVec = Vector(teamColor.r, teamColor.g, teamColor.b)
        if !(ply:CheckGroup("donator")) then
			ply:SetWeaponColor( Vector( 1, 1, 1 ) )
			ply:SetPlayerColor( Vector( 1, 1, 1 ) )
		end
    end
end)
