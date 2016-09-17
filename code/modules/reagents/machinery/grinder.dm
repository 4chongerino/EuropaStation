////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
/obj/machinery/reagentgrinder

	name = "food processor"
	icon = 'icons/obj/kitchen/inedible/machines.dmi'
	icon_state = "juicer1"
	layer = 2.9
	density = 0
	anchored = 0
	use_power = 1
	idle_power_usage = 5
	active_power_usage = 100
	var/inuse = 0
	var/obj/item/reagent_containers/beaker = null
	var/limit = 10
	var/list/holdingitems = list()
	var/global/list/grind_products = list(
		/obj/item/reagent_containers/food/snacks/meat/slab = /obj/item/reagent_containers/food/snacks/meat/mince
		)
	var/global/list/sheet_reagents = list(
		/obj/item/stack/material/iron = "iron",
		/obj/item/stack/material/uranium = "uranium",
		/obj/item/stack/material/gold = "gold",
		/obj/item/stack/material/silver = "silver",
		/obj/item/stack/material/mhydrogen = "hydrogen"
		)

/obj/machinery/reagentgrinder/New()
	..()
	beaker = new (src)
	return

/obj/machinery/reagentgrinder/update_icon()
	icon_state = "juicer"+num2text(!isnull(beaker))
	return

/obj/machinery/reagentgrinder/attackby(var/obj/item/O as obj, var/mob/user as mob)

	if (istype(O,/obj/item/reagent_containers/glass) || \
		istype(O,/obj/item/reagent_containers/food/drinks/drinkingglass) || \
		istype(O,/obj/item/reagent_containers/food/drinks/shaker))

		if (beaker)
			return 1
		else
			src.beaker =  O
			user.drop_item()
			O.loc = src
			update_icon()
			src.updateUsrDialog()
			return 0

	if(holdingitems && holdingitems.len >= limit)
		usr << "The machine cannot hold anymore items."
		return 1

	if(!istype(O))
		return

	if(!sheet_reagents[O.type] && (!O.reagents || !O.reagents.total_volume))
		user << "\The [O] is not suitable for blending."
		return 1

	user.remove_from_mob(O)
	O.loc = src
	holdingitems += O
	src.updateUsrDialog()
	return 0

/obj/machinery/reagentgrinder/attack_hand(mob/user as mob)
	interact(user)

/obj/machinery/reagentgrinder/interact(mob/user as mob)
	if(inoperable())
		return
	user.set_machine(src)
	var/is_chamber_empty = 0
	var/is_beaker_ready = 0
	var/processing_chamber = ""
	var/beaker_contents = ""
	var/dat = ""

	if(!inuse)
		for (var/obj/item/O in holdingitems)
			processing_chamber += "\A [O.name]<BR>"

		if (!processing_chamber)
			is_chamber_empty = 1
			processing_chamber = "Nothing."
		if (!beaker)
			beaker_contents = "<B>No beaker attached.</B><br>"
		else
			is_beaker_ready = 1
			beaker_contents = "<B>The beaker contains:</B><br>"
			var/anything = 0
			for(var/datum/reagent/R in beaker.reagents.reagent_list)
				anything = 1
				beaker_contents += "[R.volume] - [R.name]<br>"
			if(!anything)
				beaker_contents += "Nothing<br>"


		dat = {"
	<b>Processing chamber contains:</b><br>
	[processing_chamber]<br>
	[beaker_contents]<hr>
	"}
		if (is_beaker_ready && !is_chamber_empty && !(stat & (NOPOWER|BROKEN)))
			dat += "<A href='?src=\ref[src];action=grind'>Process the reagents</a><BR>"
		if(holdingitems && holdingitems.len > 0)
			dat += "<A href='?src=\ref[src];action=eject'>Eject the reagents</a><BR>"
		if (beaker)
			dat += "<A href='?src=\ref[src];action=detach'>Detach the beaker</a><BR>"
	else
		dat += "Please wait..."
	user << browse("<HEAD><TITLE>All-In-One Grinder</TITLE></HEAD><TT>[dat]</TT>", "window=reagentgrinder")
	onclose(user, "reagentgrinder")
	return


/obj/machinery/reagentgrinder/Topic(href, href_list)
	if(..())
		return 1

	switch(href_list["action"])
		if ("grind")
			grind()
		if("eject")
			eject()
		if ("detach")
			detach()
	src.updateUsrDialog()
	return 1

/obj/machinery/reagentgrinder/proc/detach()

	if (usr.stat != 0)
		return
	if (!beaker)
		return
	beaker.loc = src.loc
	beaker = null
	update_icon()

/obj/machinery/reagentgrinder/proc/eject()

	if (usr.stat != 0)
		return
	if (!holdingitems || holdingitems.len == 0)
		return

	for(var/obj/item/O in holdingitems)
		O.loc = src.loc
		holdingitems -= O
	holdingitems.Cut()

/obj/machinery/reagentgrinder/proc/grind()

	if(stat & (NOPOWER|BROKEN))
		return

	// Sanity check.
	if (!beaker || (beaker && beaker.reagents.total_volume >= beaker.reagents.maximum_volume))
		return

	playsound(src.loc, 'sound/machines/blender.ogg', 50, 1)
	inuse = 1

	// Reset the machine.
	spawn(60)
		inuse = 0
		interact(usr)

	// Process.
	for (var/obj/item/O in holdingitems)

		var/product_made
		for(var/check_type in grind_products)
			if(istype(O, check_type))
				var/product_type = grind_products[check_type]
				var/obj/item/product = new product_type(get_turf(src))
				product.color = O.color

				// Snowflakey as fuck, but so far the machine only uses meat so ehhhh.
				var/obj/item/reagent_containers/food/snacks/meat/meatsource = O
				var/obj/item/reagent_containers/food/snacks/meat/meatoutput = product
				if(istype(meatsource) && istype(meatoutput))
					meatoutput.set_source_mob(meatsource.source_mob)

				holdingitems -= O
				qdel(O)
				product_made = 1
				break

		if(product_made)
			return

		var/remaining_volume = beaker.reagents.maximum_volume - beaker.reagents.total_volume
		if(remaining_volume <= 0)
			break

		if(sheet_reagents[O.type])
			var/obj/item/stack/stack = O
			if(istype(stack))
				var/amount_to_take = max(0,min(stack.amount,round(remaining_volume/REAGENTS_PER_SHEET)))
				if(amount_to_take)
					stack.use(amount_to_take)
					if(deleted(stack))
						holdingitems -= stack
					beaker.reagents.add_reagent(sheet_reagents[stack.type], (amount_to_take*REAGENTS_PER_SHEET))
					continue

		if(O.reagents)
			O.reagents.trans_to(beaker, min(O.reagents.total_volume, remaining_volume))
			if(O.reagents.total_volume == 0)
				holdingitems -= O
				qdel(O)
			if (beaker.reagents.total_volume >= beaker.reagents.maximum_volume)
				break
