/*
CONTAINS:
T-RAY
DETECTIVE SCANNER
HEALTH ANALYZER
GAS ANALYZER
PLANT ANALYZER
MASS SPECTROMETER
REAGENT SCANNER
FORENSIC SCANNER
K9 SCANNER
*/
/obj/item/device/rx_requester
	name = "\improper RequestX Coupon"
	icon = 'icons/obj/items/disk.dmi'
	icon_state = "botanydisk"
	item_state = "botanydisk"
	w_class = SIZE_TINY
	item_icons = list(
		WEAR_WAIST = 'icons/mob/humans/onmob/clothing/belts/tools.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/equipment/devices_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/equipment/devices_righthand.dmi'
	)
	desc = "Pager to Request Medication from Pharmacy."
	flags_atom = FPRINT|CONDUCT
	flags_equip_slot = SLOT_WAIST
	flags_item = NOBLUDGEON
	throwforce = 3
	throw_speed = SPEED_VERY_FAST
	throw_range = 10

	var/popup_window = TRUE

/obj/item/device/healthanalyzer/Destroy()
	QDEL_NULL(last_health_display)
	return ..()

/obj/item/device/healthanalyzer/attack(mob/living/M, mob/living/user)
	if(!popup_window)
		last_scan = M.health_scan(user, FALSE, TRUE, popup_window, alien)
	else
		if (!last_health_display)
			last_health_display = new(M)
		else
			last_health_display.target_mob = M
		SStgui.close_user_uis(user, src)
		last_scan = last_health_display.ui_data(user, DETAIL_LEVEL_HEALTHANALYSER)
		last_health_display.look_at(user, DETAIL_LEVEL_HEALTHANALYSER, bypass_checks = FALSE, ignore_delay = FALSE, alien = alien)
	to_chat(user, SPAN_NOTICE("[user] has analyzed [M]'s vitals."))
	playsound(src.loc, 'sound/items/healthanalyzer.ogg', 50)
	src.add_fingerprint(user)
	return

/obj/item/device/healthanalyzer/attack_self(mob/user)
	. = ..()
	if(.)
		return
	if(action == "change_color")
		var/new_color = params["color"]
		if(!(color in allowed_coors))
			return FALSE
		color = new_color
		. = TRUE

/obj/item/device/healthanalyzer/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
	ui = new(user, src, "rx_requester")
	ui.open()

/obj/item/device/healthanalyzer/ui_data(mob/user)
	var/list/data = list()
	data["health"] = health
	data["color"] = color

	return data


