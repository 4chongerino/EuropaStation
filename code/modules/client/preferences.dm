//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

var/list/preferences_datums = list()


datum/preferences
	//doohickeys for savefiles
	var/path
	var/default_slot = 1				//Holder so it doesn't default to slot 1, rather the last one used
	var/savefile_version = 0

	//non-preference stuff
	var/warns = 0
	var/muted = 0
	var/last_ip
	var/last_id

	//game-preferences
	var/lastchangelog = ""				//Saved changlog filesize to detect if there was a change
	var/ooccolor = "#010000"			//Whatever this is set to acts as 'reset' color and is thus unusable as an actual custom color
	var/list/be_special_role = list()		//Special role selection
	var/toggles = TOGGLES_DEFAULT
	var/UI_style_color = "#aaaaaa"
	var/UI_style_alpha = 255
	var/tgui_fancy = 1
	var/tgui_lock = 1

	//character preferences
	var/real_name						//our character's name
	var/be_random_name = 0				//whether we are a random name every round
	var/gender = MALE					//gender of character (well duh)
	var/age = 30						//age of character
	var/spawnpoint = "Arrivals" //where this character will spawn (0-2).
	var/b_type = "A+"					//blood type (not-chooseable)
	var/underwear						//underwear type
	var/backbag = 2						//backpack type
	var/h_style = "Bald"				//Hair type
	var/f_style = "Shaved"				//Face hair type

	var/col_hair = 0					//Hair color
	var/col_facial = 0					//Face hair color
	var/col_skin = 0					//Skin color
	var/col_eyes = 0					//Eye color

	var/species = "Human"               //Species datum to use.
	var/species_preview                 //Used for the species selection window.
	var/list/alternate_languages = list() //Secondary language(s)
	var/list/language_prefixes = list() //Kanguage prefix keys
	var/radio_voice
	var/list/gear						//Custom/fluff item loadout.

		//Some faction information.
	var/home_system = "Unset"           //System of birth.
	var/citizenship = "None"            //Current home system.
	var/faction = "None"                //Antag faction/general associated faction.
	var/religion = "None"               //Religious association.

		//Mob preview
	var/icon/preview_icon = null

	//Jobs, uses bitflags
	var/list/job_preferences = list()

	//Keeps track of preferrence for not getting any wanted jobs
	var/alternate_option = 0

	var/list/aspects = list() // List of aspect names that the mob has selected.

	// maps each organ to either null(intact), "cyborg" or "amputated"
	// will probably not be able to do this for head and torso ;)
	var/list/organ_data = list()
	var/list/rlimb_data = list()
	var/list/player_alt_titles = new()		// the default name of a job like "Medical Doctor"

	var/list/flavor_texts = list()
	var/list/flavour_texts_robot = list()

	var/med_record = ""
	var/sec_record = ""
	var/gen_record = ""
	var/exploit_record = ""
	var/disabilities = 0

	var/nanotrasen_relation = "Neutral"

	var/uplinklocation = "Locker"

	// OOC Metadata:
	var/metadata = ""

	var/client/client = null
	var/client_ckey = null

	var/savefile/loaded_preferences
	var/savefile/loaded_character
	var/datum/category_collection/player_setup_collection/player_setup

	var/dress_mob = 1

/datum/preferences/New(client/C)
	player_setup = new(src)
	gender = pick(MALE, FEMALE)
	real_name = random_name(gender,species)
	b_type = RANDOM_BLOOD_TYPE

	gear = list()

	if(istype(C))
		client = C
		client_ckey = C.ckey
		if(!IsGuestKey(C.key))
			load_path(C.ckey)
			load_preferences()
			load_and_update_character()

/datum/preferences/proc/load_and_update_character(var/slot)
	load_character(slot)
	if(update_setup(loaded_preferences, loaded_character))
		save_preferences()
		save_character()

/datum/preferences/proc/ShowChoices(mob/user)
	if(!user || !user.client)	return
	var/dat = "<html><body><center>"

	if(path)
		dat += "Slot - "
		dat += "<a href='?src=\ref[src];load=1'>Load slot</a> - "
		dat += "<a href='?src=\ref[src];save=1'>Save slot</a> - "
		dat += "<a href='?src=\ref[src];reload=1'>Reload slot</a>"

	else
		dat += "Please create an account to save your preferences."

	dat += "<br>"
	dat += player_setup.header()
	dat += "<br><HR></center>"
	dat += player_setup.content(user)

	dat += "</html></body>"
	user << browse(dat, "window=preferences;size=625x736")


/datum/preferences/proc/process_link(mob/user, list/href_list)
	if(!user)	return

	if(!istype(user, /mob/new_player))	return

	if(href_list["preference"] == "open_whitelist_forum")
		if(config.forumurl)
			user << link(config.forumurl)
		else
			user << "<span class='danger'>The forum URL is not set in the server configuration.</span>"
			return
	ShowChoices(usr)
	return 1

/datum/preferences/Topic(href, list/href_list)
	if(..())
		return 1

	if(href_list["save"])
		save_preferences()
		save_character()
	else if(href_list["reload"])
		load_preferences()
		load_character()
		sanitize_preferences()
	else if(href_list["load"])
		if(!IsGuestKey(usr.key))
			open_load_dialog(usr)
			return 1
	else if(href_list["changeslot"])
		load_character(text2num(href_list["changeslot"]))
		sanitize_preferences()
		close_load_dialog(usr)
	else
		return 0

	ShowChoices(usr)
	return 1

/datum/preferences/proc/copy_to(var/mob/living/human/character, var/icon_updates = 1)
	// Sanitizing rather than saving as someone might still be editing when copy_to occurs.
	player_setup.sanitize_setup()
	character.set_species(species)

	if(be_random_name)
		real_name = random_name(gender,species)

	if(config.humans_need_surnames)
		var/firstspace = findtext(real_name, " ")
		var/name_length = length(real_name)
		if(!firstspace)	//we need a surname
			real_name += " [pick(last_names)]"
		else if(firstspace == name_length)
			real_name += "[pick(last_names)]"

	character.real_name = real_name
	character.name = character.real_name

	character.flavor_texts["general"] = flavor_texts["general"]
	character.flavor_texts["head"] = flavor_texts["head"]
	character.flavor_texts["face"] = flavor_texts["face"]
	character.flavor_texts["eyes"] = flavor_texts["eyes"]
	character.flavor_texts["torso"] = flavor_texts["torso"]
	character.flavor_texts["arms"] = flavor_texts["arms"]
	character.flavor_texts["hands"] = flavor_texts["hands"]
	character.flavor_texts["legs"] = flavor_texts["legs"]
	character.flavor_texts["feet"] = flavor_texts["feet"]

	character.med_record = med_record
	character.sec_record = sec_record
	character.gen_record = gen_record
	character.exploit_record = exploit_record

	character.gender = gender
	character.age = age
	character.b_type = b_type

	character.h_style =    h_style
	character.f_style =    f_style
	character.col_eyes =   col_eyes
	character.col_hair =   col_hair
	character.col_facial = col_facial
	character.col_skin =   col_skin

	character.h_style = h_style
	character.f_style = f_style

	character.home_system = home_system
	character.citizenship = citizenship
	character.personal_faction = faction
	character.religion = religion

	// Replace any missing limbs.
	for(var/name in BP_ALL_LIMBS)
		var/obj/item/organ/external/O = character.organs_by_name[name]
		if(!O && organ_data[name] != "amputated")
			var/list/organ_data = character.species.has_limbs[name]
			if(!islist(organ_data)) continue
			var/limb_path = organ_data["path"]
			O = new limb_path(character)

	// Destroy/cyborgize organs and limbs.
	for(var/name in BP_BY_DEPTH)
		var/status = organ_data[name]
		var/obj/item/organ/external/O = character.organs_by_name[name]
		if(!O)
			continue
		O.status = 0
		O.model = null
		if(status == "amputated")
			character.organs_by_name[O.organ_tag] = null
			character.organs -= O
			if(O.children) // This might need to become recursive.
				for(var/obj/item/organ/external/child in O.children)
					character.organs_by_name[child.organ_tag] = null
					character.organs -= child
		else if(status == "cyborg")
			if(rlimb_data[name])
				O.robotize(rlimb_data[name])
			else
				O.robotize()
	for(var/name in list(O_HEART,O_EYES,O_BRAIN))
		var/status = organ_data[name]
		if(!status)
			continue
		var/obj/item/organ/internal/I = character.internal_organs_by_name[name]
		if(I)
			if(status == "assisted")
				I.mechassist()
			else if(status == "mechanical")
				I.robotize()

	character.underwear = underwear
	if(backbag > 4 || backbag < 1)
		backbag = 1 //Same as above
	character.backbag = backbag
	character.radio_voice = radio_voice

	if(icon_updates)
		character.force_update_limbs()
		character.update_body(0)
		character.update_hair(0)
		character.update_icons()


/datum/preferences/proc/open_load_dialog(mob/user)
	var/dat = "<body>"
	dat += "<tt><center>"

	var/savefile/S = new /savefile(path)
	if(S)
		dat += "<b>Select a character slot to load</b><hr>"
		var/name
		for(var/i=1, i<= config.character_slots, i++)
			S.cd = "/character[i]"
			S["real_name"] >> name
			if(!name)	name = "Character[i]"
			if(i==default_slot)
				name = "<b>[name]</b>"
			dat += "<a href='?src=\ref[src];changeslot=[i]'>[name]</a><br>"

	dat += "<hr>"
	dat += "</center></tt>"
	user << browse(dat, "window=saves;size=300x390")

/datum/preferences/proc/close_load_dialog(mob/user)
	user << browse(null, "window=saves")
