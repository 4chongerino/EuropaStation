/obj/structure/reagent_dispensers
	name = "Dispenser"
	desc = "..."
	icon = 'icons/obj/objects.dmi'
	icon_state = "watertank"
	density = 1
	anchored = 0

	var/amount_per_transfer_from_this = 10
	var/possible_transfer_amounts = list(10,25,50,100)

	attackby(obj/item/W as obj, mob/user as mob)
		return

	New()
		var/datum/reagents/R = new/datum/reagents(1000)
		reagents = R
		R.my_atom = src
		if (!possible_transfer_amounts)
			src.verbs -= /obj/structure/reagent_dispensers/verb/set_APTFT
		..()

	examine(mob/user)
		if(!..(user, 2))
			return
		user << "\blue It contains:"
		if(reagents && reagents.reagent_list.len)
			for(var/datum/reagent/R in reagents.reagent_list)
				user << "\blue [R.volume] units of [R.name]"
		else
			user << "\blue Nothing."

	verb/set_APTFT() //set amount_per_transfer_from_this
		set name = "Set transfer amount"
		set category = "Object"
		set src in view(1)
		var/N = input("Amount per transfer from this:","[src]") as null|anything in possible_transfer_amounts
		if (N)
			amount_per_transfer_from_this = N

	ex_act(severity)
		switch(severity)
			if(1.0)
				qdel(src)
				return
			if(2.0)
				if (prob(50))
					new /obj/effect/effect/water(src.loc)
					qdel(src)
					return
			if(3.0)
				if (prob(5))
					new /obj/effect/effect/water(src.loc)
					qdel(src)
					return
			else
		return
