/atom/movable/proc/make_dead_drop(var/mob/living/human/player)
	return

/atom/movable/proc/is_valid_dead_drop()
	return 1

/datum/antagonist/proc/equip(var/mob/living/human/player)

	if(!istype(player))
		return 0

	// This could use work.
	if(flags & ANTAG_CLEAR_EQUIPMENT)
		for(var/obj/item/thing in player.contents)
			player.drop_from_inventory(thing)
			if(thing.loc != player)
				qdel(thing)

	if(has_dead_drop && uplink_locations.len)
		var/use_drop
		if(player.client && player.client.prefs)
			use_drop = player.client.prefs.uplinklocation
		else
			use_drop = pick(uplink_locations)

		var/list/possible_targets = list()
		switch(use_drop)
			if("Locker")
				for(var/obj/structure/closet/C in all_structures)
					possible_targets |= C
			else
				player << "<span class='warning'>A dead drop could not be supplied for this mission; good luck.</span>"
				return 1

		if(possible_targets.len)
			var/atom/movable/drop_target = pick(possible_targets)
			possible_targets -= drop_target
			while(!drop_target.is_valid_dead_drop())
				possible_targets -= drop_target
				if(!possible_targets.len)
					drop_target = null
					break
				drop_target = pick(possible_targets)
			if(drop_target)
				player << "<span class='notice'><b>Your dead drop is located inside \a [drop_target] in [get_area(drop_target)]; good luck.</b></span>"
				drop_target.make_dead_drop(player)
				return 1

			player << "<span class='warning'>A dead drop could not be supplied for this mission; good luck.</span>"

	return 1

/datum/antagonist/proc/unequip(var/mob/living/human/player)
	if(!istype(player))
		return 0
	return 1