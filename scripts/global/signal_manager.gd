extends Node

signal spin_columns
signal on_create_unit(unit : Unit, slots : Array[Slot], owner : DataManager.UnitOwner)
signal on_spin_end
signal on_get_res(res_type : DataManager.ResType, res_amount : int)
signal on_entity_choosed(owner : Building, slot : Slot)
signal on_show_choose_UI(building : Building, choose_UI : ChooseUI)
signal on_pop_up_UI(pop_up_UI : Control)
signal on_build_building(building_scene : PackedScene, prebuilding : Building)
signal on_choose_building(building_scene : PackedScene)
signal on_choose_item(slot_scene : PackedScene, slot_type : DataManager.SlotType)
signal on_choice_done(chooseItem : ChooseItem)
signal on_ready_choose_ui(chooseUI : Control)
signal on_add_unit_on_field
signal on_res_change(res_type : DataManager.ResType)
signal on_not_enough_food
signal on_enough_food
signal on_show_info_res_popup(building : Building, info_res_popup_UI : InfoResPopupUI)
signal on_open_building_menu(building : Building, menu_UI : Control)
signal on_create_enemy_unit(unit : Unit, slots : Array[Slot], owner : DataManager.UnitOwner)
signal on_end_wave
signal on_start_spawn
signal on_wave_done
signal on_unit_die(unit : Unit)
signal on_show_choose_UI_after_wave(chooseUI : ChooseUI)
signal on_new_wave_start
signal on_player_get_hit
signal on_drop_res_popup(unit : Unit, info_res_popup_UI : InfoResPopupUI , x_offsetx_offset : float)
signal on_show_damage(unit : Unit, info_damage_popup_ui : InfoDamagePopupUI)
signal on_show_tooltip(owner : Object, tooltip : Tooltip)
signal on_hide_tooltip(tooltip : Tooltip)
signal on_hide_unit_tooltip(tooltip : Tooltip)
signal on_add_hero_to_field(hero : Hero)
signal on_add_unit_from_skill(unit : Unit, spawn_position : Vector2)
signal on_player_get_health
signal on_unit_created(unit : Unit)
signal on_create_projectile(projectile : Projectile, pos : Vector2)
