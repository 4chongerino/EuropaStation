var/list/clients = list()							//list of all clients
var/list/admins = list()							//list of all clients whom are admins
var/list/directory = list()							//list of all ckeys with associated client

//Since it didn't really belong in any other category, I'm putting this here
//This is for procs to replace all the goddamn 'in world's that are chilling around the code

var/list/player_list = list()				//List of all mobs **with clients attached**. Excludes /mob/new_player
var/list/mob_list = list()					//List of all mobs, including clientless
var/list/human_mob_list = list()				//List of all human mobs and sub-types, including c
var/list/living_mob_list = list()			//List of all alive mobs, including clientless. Excludes /mob/new_player
var/list/dead_mob_list = list()				//List of all dead mobs, including clientless. Excludes /mob/new_player

var/list/cable_list = list()					//Index for all cables, so that powernets don't have to look through the entire world all the time
var/list/landmarks_list = list()				//list of all landmarks created
var/list/surgery_steps = list()				//list of all surgery steps  |BS12
var/list/side_effects = list()				//list of all medical sideeffects types by thier names |BS12
var/list/mechas_list = list()				//list of all mechs. Used by hostile mobs target tracking.

var/list/turfs = list()						//list of all turfs

//Languages/species/whitelist.
var/list/all_species[0]
var/list/all_languages[0]
var/list/language_keys[0]					// Table of say codes for all languages
var/list/whitelisted_species = list("Human") // Species that require a whitelist check.
var/list/playable_species = list("Human")    // A list of ALL playable species, whitelisted, latejoin or otherwise.

var/list/mannequins_

// Uplinks
var/list/obj/item/device/uplink/world_uplinks = list()

//Preferences stuff

//Hairstyles
var/list/hair_styles_list = list()			//stores /datum/sprite_accessory/hair indexed by name
var/list/hair_styles_male_list = list()
var/list/hair_styles_female_list = list()
var/list/facial_hair_styles_list = list()	//stores /datum/sprite_accessory/facial_hair indexed by name
var/list/facial_hair_styles_male_list = list()
var/list/facial_hair_styles_female_list = list()
var/list/skin_styles_female_list = list()		//unused

//Underwear
var/list/underwear_m = list("Default" = "m1")
var/list/underwear_f = list("Default" = "f1")

//Backpacks
var/list/backbaglist = list("Nothing", "Backpack", "Satchel", "Satchel Alt")

// Music.
var/global/list/ambient_tracks = list(
	'sound/music/europa/Chronox_-_03_-_In_Orbit.ogg',
	'sound/music/europa/Chronox_-_04_-_Juno.ogg',
	'sound/music/europa/Macamoto_-_05_-_Torn.ogg',
	'sound/music/europa/Pulse_Emitter_-_04_-_Nebula.ogg',
	'sound/music/europa/Six_Umbrellas_-_05_-_Monument.ogg',
	'sound/music/europa/Six_Umbrellas_-_07_-_The_And_Of_The_World.ogg',
	'sound/music/europa/Martian Cowboy.ogg',
	)

// Runes
var/global/list/rune_list = new()
var/global/list/escape_list = list()
var/global/list/syndicate_access = list(access_maint_tunnels, access_syndicate, access_external_airlocks)

// Strings which corraspond to bodypart covering flags, useful for outputting what something covers.
var/global/list/string_part_flags = list(
	"head" = HEAD,
	"face" = FACE,
	"eyes" = EYES,
	"upper body" = UPPER_TORSO,
	"lower body" = LOWER_TORSO,
	"legs" = LEGS,
	"feet" = FEET,
	"arms" = ARMS,
	"hands" = HANDS
)

// Strings which corraspond to slot flags, useful for outputting what slot something is.
var/global/list/string_slot_flags = list(
	"back" = SLOT_BACK,
	"face" = SLOT_MASK,
	"waist" = SLOT_BELT,
	"ID slot" = SLOT_ID,
	"ears" = SLOT_EARS,
	"eyes" = SLOT_EYES,
	"hands" = SLOT_GLOVES,
	"head" = SLOT_HEAD,
	"feet" = SLOT_FEET,
	"exo slot" = SLOT_OCLOTHING,
	"body" = SLOT_ICLOTHING,
	"uniform" = SLOT_TIE,
	"holster" = SLOT_HOLSTER
)

//////////////////////////
/////Initial Building/////
//////////////////////////

/proc/makeDatumRefLists()

	var/list/paths

	//Hair - Initialise all /datum/sprite_accessory/hair into an list indexed by hair-style name
	paths = typesof(/datum/sprite_accessory/hair) - /datum/sprite_accessory/hair
	for(var/path in paths)
		var/datum/sprite_accessory/hair/H = new path()
		hair_styles_list[H.name] = H
		switch(H.gender)
			if(MALE)	hair_styles_male_list += H.name
			if(FEMALE)	hair_styles_female_list += H.name
			else
				hair_styles_male_list += H.name
				hair_styles_female_list += H.name

	//Facial Hair - Initialise all /datum/sprite_accessory/facial_hair into an list indexed by facialhair-style name
	paths = typesof(/datum/sprite_accessory/facial_hair) - /datum/sprite_accessory/facial_hair
	for(var/path in paths)
		var/datum/sprite_accessory/facial_hair/H = new path()
		facial_hair_styles_list[H.name] = H
		switch(H.gender)
			if(MALE)	facial_hair_styles_male_list += H.name
			if(FEMALE)	facial_hair_styles_female_list += H.name
			else
				facial_hair_styles_male_list += H.name
				facial_hair_styles_female_list += H.name

	//Surgery Steps - Initialize all /datum/surgery_step into a list
	paths = typesof(/datum/surgery_step)-/datum/surgery_step
	for(var/T in paths)
		var/datum/surgery_step/S = new T
		surgery_steps += S
	sort_surgeries()

	//Languages and species.
	paths = typesof(/datum/language)-/datum/language
	for(var/T in paths)
		var/datum/language/L = new T
		all_languages[L.name] = L

	for (var/language_name in all_languages)
		var/datum/language/L = all_languages[language_name]
		if(!(L.flags & NONGLOBAL))
			language_keys[lowertext(L.key)] = L

	for(var/T in typesof(/datum/species)-/datum/species)
		var/datum/species/S = new T
		all_species[S.name] = S
		if(!(S.spawn_flags & IS_RESTRICTED))
			playable_species += S.name
		if(S.spawn_flags & IS_WHITELISTED)
			whitelisted_species += S.name

	return 1

/proc/get_mannequin(var/ckey)
	if(!mannequins_)
		mannequins_ = new()

	. = mannequins_[ckey]
	if(!.)
		. = new/mob/living/human/dummy/mannequin()
		mannequins_[ckey] = .
