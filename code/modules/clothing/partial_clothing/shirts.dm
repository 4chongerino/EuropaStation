/* SHIRTS */
/obj/item/clothing/accessory/shirt
	name = "t-shirt"
	desc = "A plain grey t-shirt. A popular piece of human clothing."
	icon_state = "tshirt-grey"
	slot = "shirt"
	body_parts_covered = UPPER_TORSO
	slot_flags = SLOT_ICLOTHING|SLOT_TIE

/obj/item/clothing/accessory/shirt/longsleeve
	name = "longsleeve shirt"
	desc = "A white shirt with long sleeves. Great for any white collar worker."
	icon_state = "longsleeve-white"
	body_parts_covered = UPPER_TORSO|ARMS

/obj/item/clothing/accessory/shirt/turtleneck
	name = "turtleneck shirt"
	desc = "A thick, black turtleneck shirt. For when the air gets a bit chilly."
	icon_state = "turtleneck-black"
	body_parts_covered = UPPER_TORSO|ARMS

/obj/item/clothing/accessory/shirt/turtleneckwinterred
	name = "winter turtleneck shirt"
	desc = "A thick, red turtleneck shirt with a wintery design. For when the air gets a bit nippy."
	icon_state = "turtleneck-winterred"
	body_parts_covered = UPPER_TORSO|ARMS

/obj/item/clothing/accessory/shirt/chemise
	name = "chemise"
	desc = "A plain grey chemise."
	icon_state = "chemise"

/obj/item/clothing/accessory/shirt/black
	name = "black shirt"
	desc = "A plain black t-shirt."
	icon_state = "shirt"

/obj/item/clothing/accessory/shirt/white
	name = "white shirt"
	desc = "A white shirt."
	icon_state = "shirt_white"

/obj/item/clothing/accessory/shirt/singlet
	name = "white singlet"
	desc = "A white singlet."
	icon_state = "singlet"

/obj/item/clothing/accessory/shirt/singletblack
	name = "black singlet"
	desc = "A black singlet."
	icon_state = "singlet_black"

/* OVERALLS */
/obj/item/clothing/accessory/overalls
	name = "overalls"
	desc = "A plain set of overalls. For the hard working individual."
	icon_state = "overalls"
	slot = "overalls"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS
	slot_flags = SLOT_OCLOTHING|SLOT_TIE

/obj/item/clothing/accessory/overalls/emergency
	name = "emergency overalls"
	desc = "A pair of blue overalls with visible reflectors. Standard wear for emergency responders."
	icon_state = "emergency-overalls"

/obj/item/clothing/accessory/overalls/electrician
	name = "electrician overalls"
	desc = "A pair of insulated leather overalls. Used for wiring and electronic maintenance."
	icon_state = "electrician-overalls"

/* VESTS and APRONS */

/obj/item/clothing/accessory/storage/factoryvest
	name = "factory worker's vest"
	desc = "A rough leather vest used by factory workers. For holding a few small personal items."
	icon = 'icons/obj/clothing/ties.dmi'
	icon_state = "factoryworker-vest"
	slots = 2
	body_parts_covered = UPPER_TORSO
	slot_flags = SLOT_OCLOTHING|SLOT_TIE
	slot = "vest"

/obj/item/clothing/accessory/storage/factoryvest/apron
	name = "factory worker's apron"
	desc = "A long leather apron used by factory workers. Keeps the dust and dirt off and holds a few small items."
	icon_state = "factoryworker-apron"
	slots = 3