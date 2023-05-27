local weaponBoundKeys = {
"next_weapon", "previous_weapon"
}

function toggleWeaponBoundControls( player, state )
	if isElement( player ) then
		if type( state ) == "boolean" then
			for _, val in ipairs( weaponBoundKeys ) do
			toggleControl( player, val, state )
			end
		else
			for _, val in ipairs( weaponBoundKeys ) do
				if isControlEnabled( player, val ) then
				toggleControl( player, val, false )
				else
				toggleControl( player, val, true )
				end
			end
		end
	end
end

addEventHandler( "onPlayerJoin", getRootElement(), function()
toggleWeaponBoundControls( source, false )
end)

addEventHandler( "onPlayerLogin", getRootElement(), function()
toggleWeaponBoundControls( source, false )
end)

addEventHandler( "onResourceStart", root, function()
	for _, pl in ipairs( getElementsByType( "player" ) ) do
	toggleWeaponBoundControls( pl, false )
	end
end)

function setPlayerCustomCurrentWeapon( player, weaponID )
	if isElement( player ) then
	setElementData( player, "Current Weapon", weaponID )
	end
end

function createPlayerWeapon( player )
local weaponID = getElementData( player, "Current Weapon" )
	if weaponID and weaponID ~= nil and weaponID ~= false and type( weaponID ) == "number" and weaponID >= 1 then
	local data = getWeaponDataFromTable( weaponID )
	giveWeapon( player, weaponAnimationGroup[ data[ 8 ] ] )
	setPedStat( player, getWeaponSkillFromID( weaponAnimationGroup[ data[ 8 ] ] ), data[ 9 ] )
	local usedSlot = getSlotFromWeapon( weaponAnimationGroup[ data[ 8 ] ] )
	setPedWeaponSlot( player, usedSlot )
	end
end

addEventHandler( "onElementDataChange", getRootElement(), function( key, o_val, n_val )
	if getElementType( source ) == "player" then
		if key == "Current Weapon" then
			if type( n_val ) == "number" and n_val >= 1 then
			local data = getWeaponDataFromTable( n_val )
			createPlayerWeapon( source )
			end
		end
	end
end)

addCommandHandler( "gwp", function( pl, _, id )
	if isElement( pl ) and not isPedDead( pl ) then
	local id = tonumber( id )
		if weaponDataTable[ id ] then
		setPlayerCustomCurrentWeapon( pl, id )
		else
		outputChatBox( "There's no weapon with current ID!", pl, 255, 100, 100, true )
		end
	end
end)