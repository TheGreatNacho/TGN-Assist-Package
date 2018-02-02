CATEGORY_NAME = "Extra Commands"
// Content
function ulx.content(ply) 
	ply:SendLua([[gui.OpenURL("http://steamcommunity.com/sharedfiles/filedetails/?id=839288741")]])
end
local content = ulx.command( CATEGORY_NAME, "ulx content", ulx.content, "!content" ) 
content:defaultAccess( ULib.ACCESS_ALL ) 
content:help( "Download the servers content to stop seeing errors." )

// Forum
function ulx.forum(ply) 
	ply:SendLua([[gui.OpenURL("http://www.high-command.com/")]])
end
local forum = ulx.command( CATEGORY_NAME, "ulx forum", ulx.forum, "!forum" ) 
forum:defaultAccess( ULib.ACCESS_ALL ) 
forum:help( "Open the community forum." )

// Refund
function ulx.refund(ply, targply, amount)
	targply:addMoney(amount)
	ulx.fancyLogAdmin( ply, "#A refunded #T by amount #i", targply, amount )
end
local refund = ulx.command( CATEGORY_NAME, "ulx refund", ulx.refund, "!refund")
refund:defaultAccess(ULib.ACCESS_SUPERADMIN)
refund:addParam{ type=ULib.cmds.PlayerArg}
refund:addParam{ type=ULib.cmds.NumArg, min=0, max=1000000, default=0, hint="Amount"}
refund:help( "Refund money to players." )

// Lockdown
function ulx.lockdown(ply, reverse)
	
	if (not reverse) then
		DarkRP.printMessageAll(HUD_PRINTTALK, DarkRP.getPhrase("lockdown_started"))
		SetGlobalBool("DarkRP_LockDown", true)
		DarkRP.notifyAll(0, 3, DarkRP.getPhrase("lockdown_started"))
		ulx.fancyLogAdmin( ply, "#A started a lockdown" )
	else
		DarkRP.printMessageAll(HUD_PRINTTALK, DarkRP.getPhrase("lockdown_ended"))
		DarkRP.notifyAll(0, 3, DarkRP.getPhrase("lockdown_ended"))
		SetGlobalBool("DarkRP_LockDown", false)

		lastLockdown = CurTime()
		
		ulx.fancyLogAdmin( ply, "#A ended a lockdown" )
	end
end
local lockdown = ulx.command( CATEGORY_NAME, "ulx lockdown", ulx.lockdown, "!lockdown")
lockdown:defaultAccess(ULib.ACCESS_ADMIN)
lockdown:addParam{ type=ULib.cmds.BoolArg, invisible=true }
lockdown:help( "Start a lockdown." )
lockdown:setOpposite( "ulx unlockdown", {_, true}, "!unlockdown" )

// Force Arrest
function ulx.arrest(ply, targ, time, reverse)
	print(reverse)
	if (!reverse) then
		local timeBool = true
		if (time==120) then
			timeBool = false
		end
		targ:arrest(time, ply)
		if (timeBool) then 
			ulx.fancyLogAdmin( ply, "#A arrested #T for #i seconds", targ, time )
		else
			ulx.fancyLogAdmin( ply, "#A arrested #T", targ )
		end
	else 
		targ:unArrest(ply)
		ulx.fancyLogAdmin( ply, "#A unarrested #T", targ )
	end
end
local arrest = ulx.command( CATEGORY_NAME, "ulx arrest", ulx.arrest, "!arrest")
arrest:defaultAccess(ULib.ACCESS_ADMIN)
arrest:addParam{ type=ULib.cmds.PlayerArg}
arrest:addParam{ type=ULib.cmds.NumArg, min=0, max=600, default=120, ULib.cmds.optional, hint="Time" }
arrest:addParam{ type=ULib.cmds.BoolArg, invisible=true }
arrest:help( "Arrest a player." )
arrest:setOpposite( "ulx unarrest", {_,_,_,true}, "!unarrest" )

// Empty Pocket
function ulx.emptypocket(ply, targ)
	for k, v in pairs(targ:getPocketItems()) do
        targ:dropPocketItem(k)
    end
	
	ulx.fancyLogAdmin( ply, "#A forced #T to empty their pocket", targ )
end
local emptypocket = ulx.command( CATEGORY_NAME, "ulx emptypocket", ulx.emptypocket, "!emptypocket" )
emptypocket:defaultAccess(ULib.ACCESS_ADMIN)
emptypocket:addParam{ type=ULib.cmds.PlayerArg }
emptypocket:help("Forces a player to empty their pocket.")

// Team Ban
function ulx.jobban(ply, targ, time)
	local job = targ:Team()
	local jobString = team.GetName(job)
	if (job==TEAM_CITIZEN) then
		ULib.tsayError( ply, targ:Nick() .. " can not be job banned from Citizen.", true )
		return
	end
	targ:changeTeam(TEAM_CITIZEN, true)
	targ:teamBan(job, time)
	ulx.fancyLogAdmin( ply, "#A job banned #T from #s for #i seconds", targ, jobString, time )
end
local jobban = ulx.command( CATEGORY_NAME, "ulx jobban", ulx.jobban, "!jobban" )
jobban:defaultAccess(ULib.ACCESS_ADMIN)
jobban:addParam{ type=ULib.cmds.PlayerArg }
jobban:addParam{ type=ULib.cmds.NumArg, min=0, default=300, ULib.cmds.optional, hint="Time" }

// Damage Ban
local damageBanned = {}
function ulx.damageban(ply, targ, time, reverse)
	if not reverse then
		targ.dbanpos = table.insert(damageBanned, targ)
		timer.Simple(time, function()
			table.remove(damageBanned, targ.dbanpos)
		end)
		ulx.fancyLogAdmin( ply, "#A banned #T from dealing damage for #i seconds", targ, time )
	else
		if (targ.dbanpos) then
			ulx.fancyLogAdmin( ply, "#A has allowed #T to deal damage", targ )
			table.remove(damageBanned, targ.dbanpos)
			targ.dbanpos = nil
		end
	end
end
local damageban = ulx.command( CATEGORY_NAME, "ulx damageban", ulx.damageban, "!damageban" )
damageban:defaultAccess(ULib.ACCESS_ADMIN)
damageban:addParam{ type=ULib.cmds.PlayerArg }
damageban:addParam{ type=ULib.cmds.NumArg, min=0, default=300, ULib.cmds.optional, hint="Time" }
damageban:addParam{ type=ULib.cmds.BoolArg, invisible=true }
damageban:setOpposite( "ulx undamageban", {_,_,_,true}, "!undamageban" )
hook.Add("PlayerShouldTakeDamage", "ExtraCommandsDamageBan", function(ply, attacker)
	return !table.HasValue(damageBanned, attacker)
end)
