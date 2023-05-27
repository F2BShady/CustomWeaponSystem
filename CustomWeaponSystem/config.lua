weaponTable = {

[ 1 ] = { 331, false },
[ 2 ] = { 333, false },
[ 3 ] = { 334, false },
[ 4 ] = { 335, false },
[ 5 ] = { 336, false },
[ 6 ] = { 337, false },
[ 7 ] = { 338, false },
[ 8 ] = { 339, false },
[ 9 ] = { 341, false },
[ 22 ] = { 346, 69 },
[ 23 ] = { 347, 70 },
[ 24 ] = { 348, 71 },
[ 25 ] = { 349, 72 },
[ 26 ] = { 350, 73 },
[ 27 ] = { 351, 74 },
[ 28 ] = { 352, 75 },
[ 29 ] = { 353, 76 },
[ 32 ] = { 372, 75 },
[ 30 ] = { 355, 77 },
[ 31 ] = { 356, 78 },
[ 33 ] = { 357, 79 },
[ 34 ] = { 358, 79 },
[ 35 ] = { 359, false },
[ 36 ] = { 360, false },
[ 37 ] = { 361, false },
[ 38 ] = { 362, false },
[ 16 ] = { 342, false },
[ 17 ] = { 343, false },
[ 18 ] = { 344, false },
[ 39 ] = { 363, false },
[ 41 ] = { 365, false },
[ 42 ] = { 366, false },
[ 43 ] = { 367, false },
[ 10 ] = { 321, false },
[ 11 ] = { 322, false },
[ 12 ] = { 323, false },
[ 14 ] = { 325, false },
[ 15 ] = { 326, false },
[ 44 ] = { 368, false },
[ 45 ] = { 369, false },
[ 46 ] = { 371, false },

}

weaponDataTable = {

[ 1 ] = { 
bin = "ak47",
objectID = 1853,
clipAmmo = 30,
maxAmmo = 300,
reloadTime = 3,
takingTime = 1.5,
fireType = "auto",
animationGroup = "rifle",
skillRate = 999
},

[ 2 ] = { 
bin = "deagle",
objectID = 1854,
clipAmmo = 100,
maxAmmo = 640,
reloadTime = 4,
takingTime = 5,
fireType = "auto",
animationGroup = "rifle",
skillRate = 999
},

[ 3 ] = { 
bin = "sawnoff",
objectID = 1855,
clipAmmo = 2,
maxAmmo = 32,
reloadTime = 3,
takingTime = 0.75,
fireType = "single",
animationGroup = "combat",
skillRate = 999
},

}

weaponAnimationGroup = {

[ "rifle" ] = 31,
[ "pistol" ] = 24,
[ "combat" ] = 27,

}

function getWeaponDataFromTable( ID )
local ID = tonumber( ID )
	if ID then
		if weaponDataTable[ ID ] then
		local weaponData = weaponDataTable[ ID ]
		local objectID = weaponData.objectID
		local bin = weaponData.bin
		local clipAmmo = weaponData.clipAmmo
		local maxAmmo = weaponData.maxAmmo
		local reloadTime = weaponData.reloadTime
		local takingTime = weaponData.takingTime
		local fireType = weaponData.fireType
		local animationGroup = weaponData.animationGroup
		local skillRate = weaponData.skillRate
		return { bin, objectID, clipAmmo, maxAmmo, reloadTime, takingTime, fireType, animationGroup, skillRate }
		else
		return { "ak47", 355, 30, 300, 3, 1.5, "auto", "rifle", 1000 }
		end
	end
end

function getWeaponModelFromID( weaponID )
	if weaponTable[ weaponID ] then
	return weaponTable[ weaponID ][ 1 ]
	end
end

function getCustomWeaponIDFromModel( objectID )
	for i, val in ipairs( weaponDataTable ) do
		if weaponDataTable[ i ].objectID == objectID then
		return i
		end
	end
end

function getWeaponSkillFromID( weaponID )
	if weaponTable[ weaponID ] then
	return weaponTable[ weaponID ][ 2 ]
	end
end