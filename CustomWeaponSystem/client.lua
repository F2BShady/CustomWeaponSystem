local screenW, screenH = guiGetScreenSize( )
local sW, sH = ( screenW / 1920 ), ( screenH / 1080 )

local weaponBoundKeys = {
[ "fire" ] = {},
[ "next_weapon" ] = {},
[ "previous_weapon" ] = {},
}

function writeBoundMovementKeys()
local kFire = getBoundKeys( "fire" )
local kWeapon_N = getBoundKeys( "next_weapon" )
local kWeapon_P = getBoundKeys( "previous_weapon" )
	for key, _ in pairs( kFire ) do
	table.insert( weaponBoundKeys[ "fire" ], key )
    end
    for key, _ in pairs( kWeapon_N ) do
	table.insert( weaponBoundKeys[ "next_weapon" ], key )
    end
	for key, _ in pairs( kWeapon_P ) do
	table.insert( weaponBoundKeys[ "previous_weapon" ], key )
    end
end

function toggleWeaponSounds( bool )
	if type( bool ) == "boolean" then
	setWorldSoundEnabled( 5, bool )
	end
end

addEventHandler( "onClientResourceStart", resourceRoot, function()
writeBoundMovementKeys()
toggleWeaponSounds( false )
	for i, val in ipairs( weaponDataTable ) do
	local alphaID = getWeaponModelFromID( weaponAnimationGroup[ weaponDataTable[ i ].animationGroup ] )
	local alpha = engineLoadDFF( "assets/alpha.dff", alphaID )
	local txd = engineLoadTXD( "bin/"..weaponDataTable[ i ].bin.."/texture.txd", weaponDataTable[ i ].objectID )
	local dff = engineLoadDFF( "bin/"..weaponDataTable[ i ].bin.."/model.dff", weaponDataTable[ i ].objectID )
	engineImportTXD( txd, weaponDataTable[ i ].objectID )
	engineReplaceModel( dff, weaponDataTable[ i ].objectID )
	engineReplaceModel( alpha, alphaID )
	end
end)

addEventHandler( "onClientResourceStop", resourceRoot, function()
toggleWeaponSounds( true )
end)

customWeapon = {}
addEventHandler( "onClientRender", root, function()
	for _, pl in ipairs( getElementsByType( "player" ) ) do
		if isElement( pl ) and not isPedDead( pl ) then
			if getElementData( pl, "Current Weapon" ) ~= false and getElementData( pl, "Current Weapon" ) ~= nil then
			local weaponID = getElementData( pl, "Current Weapon" )
				if isElement( customWeapon[ pl ] ) then
				exports.pattach:attach( customWeapon[ pl ], pl, 24, 0, 0, 0, 0, 0, 0)
				end
			end
		end
	end
end)

function createPlayerWeaponClientside( player, weaponID )
	if isElement( player ) and getElementType( player ) == "player" and not isPedDead( player ) then
		if weaponID == false then
		local currentID = getElementData( player, "Current Weapon" )
			if weaponDataTable[ currentID ] then
			local data = getWeaponDataFromTable( currentID )
				if not isElement( customWeapon[ player ] ) then
				customWeapon[ player ] = createObject( data[ 2 ], getElementPosition( player ) )
				else
				setElementPosition( customWeapon[ player ], getElementPosition( player ) )
				setElementModel( customWeapon[ player ], data[ 2 ] )
				end
			end
		else
		local data = getWeaponDataFromTable( weaponID )
			if not isElement( customWeapon[ player ] ) then
			customWeapon[ player ] = createObject( data[ 2 ], getElementPosition( player ) )
			else
			setElementPosition( customWeapon[ player ], getElementPosition( player ) )
			setElementModel( customWeapon[ player ], data[ 2 ] )
			end
		end
	end
end

function destroyPlayerWeaponClientside( player )
	if isElement( customWeapon[ player ] ) then
	destroyElement( customWeapon[ player ] )
	customWeapon[ player ] = nil
	table.remove( customWeapon, customWeapon[ player ] )
	return true
	else
	return false
	end
end
addEvent( "destroyPlayerWeaponClientside", true )
addEventHandler( "destroyPlayerWeaponClientside", getRootElement(), destroyPlayerWeaponClientside )

addEventHandler( "onClientElementDataChange", getRootElement(), function( key, o_val, n_val )
	if key == "Current Weapon" and isElement( source ) and getElementType( source ) == "player" then
	local value = tonumber( n_val )
		if type( value ) == "number" and value >= 1 then
			if weaponDataTable[ value ] then
			createPlayerWeaponClientside( source, value )
			end
		end
	end
end)

customBullet = {}
addEventHandler( "onClientPlayerWeaponFire", getRootElement(), function( _, tAmmo, cAmmo, hX, hY, hZ, hElement, sX, sY, sZ )
	if isElement( customWeapon[ source ] ) then
	local modelID = getElementModel( customWeapon[ source ] )
	local weaponID = getCustomWeaponIDFromModel( modelID )
	local data = getWeaponDataFromTable( weaponID )
	local shot = playSound3D("bin/"..data[ 1 ].."/shot.wav", sX, sY, sZ)
	setSoundMaxDistance( shot, 90 )
	setSoundVolume( shot, 0.25 )
	setElementInterior( shot, getElementInterior( source ) )
	setElementDimension( shot, getElementDimension( source ) )
	attachElements( shot, source )
	--
	local muzzleX, muzzleY, muzzleZ = getPedWeaponMuzzlePosition( source )
	local muzzle_eX, muzzle_eY, muzzle_eZ = getPedTargetEnd( source )
	--
	local weaponRange = 100
	local distanceX, distanceY, distanceZ = muzzle_eX - muzzleX, muzzle_eY - muzzleY, muzzle_eZ - muzzleZ
	local weaponDefaultDistance = math.sqrt( (distanceX * distanceX) + (distanceY * distanceY) + (distanceZ * distanceZ) )
	local multiplier = weaponRange / weaponDefaultDistance
	local newX, newY, newZ = muzzleX + distanceX * multiplier, muzzleY + distanceY * multiplier, muzzleZ + distanceZ * multiplier
	--		
	local l_sX, l_sY, l_sZ = muzzleX, muzzleY, muzzleZ
	local l_eX, l_eY, l_eZ = newX, newY, newZ
	table.insert( customBullet, { source, l_sX, l_sY, l_sZ, l_eX, l_eY, l_eZ } )
	--
	end
end)

function drawShotline()
	for i, v in ipairs( customBullet ) do
	dxDrawLine3D( v[ 2 ], v[ 3 ], v[ 4 ], v[ 5 ], v[ 6 ], v[ 7 ], tocolor( 255, 0, 0, 100 ), 2 )
	local hit, x, y, z, elementHit = processLineOfSight( v[ 2 ], v[ 3 ], v[ 4 ], v[ 5 ], v[ 6 ], v[ 7 ] )
		if hit then
			if isElement( v[ 1 ] ) then
				if v[ 1 ] ~= localPlayer then
				outputChatBox( "Owner: ["..getElementData( v[ 1 ], "ID" ).."] "..getPlayerName( v[ 1 ] ).."" )
				table.remove( customBullet, i )
				end
			else
			table.remove( customBullet, i )
			end
		end
	end
end
addEventHandler( "onClientRender", root, drawShotline )

addEventHandler( "onClientElementStreamIn", getRootElement(), function()
	if source.type ~= "player" then
	return
	end
createPlayerWeaponClientside( source, false )
end)

addEventHandler( "onClientElementStreamOut", getRootElement(), function()
	if source.type ~= "player" then
	return
	end
destroyPlayerWeaponClientside( source )
end)

addEventHandler( "onClientElementDestroy", getRootElement(), function()
	if source.type ~= "player" then
	return
	end
destroyPlayerWeaponClientside( source )
end)

addEventHandler( "onClientPlayerQuit", getRootElement(), function()
destroyPlayerWeaponClientside( source )
end)

addEventHandler( "onClientResourceStart", resourceRoot, function()
	for _, pl in ipairs( getElementsByType( "player" ) ) do
	createPlayerWeaponClientside( pl, false )
	end
end)