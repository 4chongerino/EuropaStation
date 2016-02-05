/*
 * Hand-tele
 */
/obj/item/weapon/hand_tele
	name = "hand tele"
	desc = "A portable item using blue-space technology."
	icon = 'icons/obj/device.dmi'
	icon_state = "hand_tele"
	item_state = "electronic"
	throwforce = 5
	w_class = 2.0
	throw_speed = 3
	throw_range = 5
	matter = list(DEFAULT_WALL_MATERIAL = 10000)

/obj/item/weapon/hand_tele/attack_self(mob/user as mob)
	var/turf/current_location = get_turf(user)//What turf is the user on?
	if(!current_location||current_location.z==2||current_location.z>=7)//If turf was not found or they're on z level 2 or >7 which does not currently exist.
		user << "<span class='notice'>\The [src] is malfunctioning.</span>"
		return
	var/list/L = list(  )
	for(var/obj/machinery/teleport/hub/R in machines)
		var/obj/machinery/computer/teleporter/com = locate(/obj/machinery/computer/teleporter, locate(R.x - 2, R.y, R.z))
		if (istype(com, /obj/machinery/computer/teleporter) && com.locked && !com.one_time_use)
			if(R.icon_state == "tele1")
				L["[com.id] (Active)"] = com.locked
			else
				L["[com.id] (Inactive)"] = com.locked
	var/list/turfs = list(	)
	for(var/turf/T in orange(10))
		if(T.x>world.maxx-8 || T.x<8)	continue	//putting them at the edge is dumb
		if(T.y>world.maxy-8 || T.y<8)	continue
		turfs += T
	if(turfs.len)
		L["None (Dangerous)"] = pick(turfs)
	var/t1 = input(user, "Please select a teleporter to lock in on.", "Hand Teleporter") in L
	if ((user.get_active_hand() != src || user.stat || user.restrained()))
		return
	var/count = 0	//num of portals from this teleport in world
	for(var/obj/effect/portal/PO in world)
		if(PO.creator == src)	count++
	if(count >= 3)
		user.show_message("<span class='notice'>\The [src] is recharging!</span>")
		return
	var/T = L[t1]
	for(var/mob/O in hearers(user, null))
		O.show_message("<span class='notice'>Locked In.</span>", 2)
	var/obj/effect/portal/P = new /obj/effect/portal( get_turf(src) )
	P.target = T
	P.creator = src
	src.add_fingerprint(user)
	return
