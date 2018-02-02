function playershouldtakedamage( victim )
    if victim:Team() == TEAM_STAFFONDUTY then
        return false -- do not damage the player
    end
end
hook.Add( "PlayerShouldTakeDamage", "staffgod", playershouldtakedamage)