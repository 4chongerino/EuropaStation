#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

/obj/item/circuitboard/recharge_station
	name = T_BOARD("robot recharging station")
	build_path = /obj/machinery/recharge_station
	board_type = "machine"

	req_components = list(
							/obj/item/stack/cable_coil = 5,
							/obj/item/stock_parts/capacitor = 2,
							/obj/item/stock_parts/manipulator = 2,
							/obj/item/cell = 1)