local rank = {}
function addLimit(rn, limit)
	rank[rn] = limit
end

addLimit("user", 60)
addLimit("regular", 80)
addLimit("donator", 150)
addLimit("trusted", 200)

function PropLimiter(ply,mdl)
	if (rank[ply:GetUserGroup()]) then
		print(ply:GetCount("props"))
		if (ply:GetCount("props") >= rank[ply:GetUserGroup()]) then
			ply:SendLua("chat.AddText(Color(0,64,128),'[High Command] ', Color(220,220,220), 'You have reached the prop limit.'  )")
			ply:SendLua("surface.PlaySound('buttons/blip1.wav')")
			return false
		end
	end
	return true
end
hook.Add( "PlayerSpawnProp", "BGNPropLimiter", PropLimiter )