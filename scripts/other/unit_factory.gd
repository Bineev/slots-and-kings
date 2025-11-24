extends Node2D

@export var unit_family : DataManager.UnitFamily

@export var T0 : PackedScene
@export var T1_1 : PackedScene
@export var T1_2 : PackedScene
@export var T1_3 : PackedScene
@export var T1_4 : PackedScene
@export var T2_1 : PackedScene
@export var T2_2 : PackedScene
@export var T2_3 : PackedScene
@export var T2_4 : PackedScene
@export var T3_1 : PackedScene
@export var T3_2 : PackedScene
@export var T3_3 : PackedScene
@export var T3_4 : PackedScene
@export var T4_1 : PackedScene
@export var T4_2 : PackedScene
@export var T4_3 : PackedScene
@export var T4_4 : PackedScene
@export var T5_1 : PackedScene
@export var T5_2 : PackedScene
@export var T5_3 : PackedScene
@export var T5_4 : PackedScene
@export var T6_1 : PackedScene
@export var T6_2 : PackedScene
@export var T6_3 : PackedScene
@export var T6_4 : PackedScene
@export var T7_1 : PackedScene
@export var T7_2 : PackedScene
@export var T7_3 : PackedScene
@export var T7_4 : PackedScene


func choose_player_unit(slots : Array[Slot]):
	print(slots[0].slot_unit_tier)
	match slots[0].slot_unit_tier:
		DataManager.UnitTier.T0:
			create_player_unit(T0, slots)
		DataManager.UnitTier.T1_1:
			create_player_unit(T1_1, slots)
		DataManager.UnitTier.T1_2:
			create_player_unit(T1_2, slots)
		DataManager.UnitTier.T1_3:
			create_player_unit(T1_3, slots)
		DataManager.UnitTier.T1_4:
			create_player_unit(T1_4, slots)
		DataManager.UnitTier.T2_1:
			create_player_unit(T2_1, slots)
		DataManager.UnitTier.T2_2:
			create_player_unit(T2_2, slots)
		DataManager.UnitTier.T2_3:
			create_player_unit(T2_3, slots)
		DataManager.UnitTier.T2_4:
			create_player_unit(T2_4, slots)
		DataManager.UnitTier.T3_1:
			create_player_unit(T3_1, slots)
		DataManager.UnitTier.T3_2:
			create_player_unit(T3_2, slots)
		DataManager.UnitTier.T3_3:
			create_player_unit(T3_3, slots)
		DataManager.UnitTier.T3_4:
			create_player_unit(T3_4, slots)
		DataManager.UnitTier.T4_1:
			create_player_unit(T4_1, slots)
		DataManager.UnitTier.T4_2:
			create_player_unit(T4_2, slots)
		DataManager.UnitTier.T4_3:
			create_player_unit(T4_3, slots)
		DataManager.UnitTier.T4_4:
			create_player_unit(T4_4, slots)
		DataManager.UnitTier.T5_1:
			create_player_unit(T5_1, slots)
		DataManager.UnitTier.T5_2:
			create_player_unit(T5_2, slots)
		DataManager.UnitTier.T5_3:
			create_player_unit(T5_3, slots)
		DataManager.UnitTier.T5_4:
			create_player_unit(T5_4, slots)
		DataManager.UnitTier.T6_1:
			create_player_unit(T6_1, slots)
		DataManager.UnitTier.T6_2:
			create_player_unit(T6_2, slots)
		DataManager.UnitTier.T6_3:
			create_player_unit(T6_3, slots)
		DataManager.UnitTier.T6_4:
			create_player_unit(T6_4, slots)
		DataManager.UnitTier.T7_1:
			create_player_unit(T7_1, slots)
		DataManager.UnitTier.T7_2:
			create_player_unit(T7_2, slots)
		DataManager.UnitTier.T7_3:
			create_player_unit(T7_3, slots)
		DataManager.UnitTier.T7_4:
			create_player_unit(T7_4, slots)


func create_player_unit(unit, slots):
	var new_unit = unit.instantiate()
	apply_slots(new_unit, slots)
	SignalManager.on_create_player_unit.emit(new_unit, slots, DataManager.UnitOwner.PLAYER)


func apply_slots(new_unit, slots):
	for slot in slots:
		if slot.slot_type == DataManager.SlotType.ULT:
			# some logic
			continue
		new_unit.health += slot.slot_res.health
		new_unit.health_mult += slot.slot_res.health_mult - 1
		new_unit.armor += slot.slot_res.armor
		new_unit.armor_mult += slot.slot_res.armor_mult - 1
		new_unit.physical_attack += slot.slot_res.physical_attack
		new_unit.physical_attack_mult += slot.slot_res.physical_attack_mult - 1
		new_unit.magical_attack += slot.slot_res.magical_attack
		new_unit.magical_attack_mult += slot.slot_res.magical_attack_mult - 1
		new_unit.hit_chance += slot.slot_res.hit_chance
		new_unit.hit_chance_mult += slot.slot_res.hit_chance_mult - 1
		new_unit.crit_chance += slot.slot_res.crit_chance
		new_unit.crit_chance_mult += slot.slot_res.crit_chance_mult - 1
		new_unit.evade += slot.slot_res.evade
		new_unit.evade_mult += slot.slot_res.evade_mult - 1
		new_unit.shield += slot.slot_res.shield
		new_unit.shield_mult += slot.slot_res.shield_mult - 1
		new_unit.attack_speed += slot.slot_res.attack_speed
		new_unit.attack_speed_mult += slot.slot_res.attack_speed_mult - 1
		new_unit.move_speed += slot.slot_res.move_speed
		new_unit.move_speed_mult += slot.slot_res.move_speed_mult - 1
		new_unit.attack_range += slot.slot_res.attack_range
		new_unit.attack_range_mult += slot.slot_res.attack_range_mult - 1
		new_unit.life_steal += slot.slot_res.life_steal
		new_unit.life_steal_mult += slot.slot_res.life_steal_mult - 1
		new_unit.health_regen += slot.slot_res.health_regen
		new_unit.health_regen_mult += slot.slot_res.health_regen_mult - 1
		new_unit.health_regen_interval += slot.slot_res.health_regen_interval
		new_unit.health_regen_interval_mult += slot.slot_res.health_regen_interval_mult - 1
		new_unit.true_damage += slot.slot_res.true_damage
		new_unit.true_damage_mult += slot.slot_res.true_damage_mult - 1
		new_unit.damage_mult_vs_all += slot.slot_res.damage_mult_vs_all - 1
		new_unit.damage_mult_vs_castle += slot.slot_res.damage_mult_vs_castle - 1
		new_unit.damage_mult_vs_hell += slot.slot_res.damage_mult_vs_hell - 1
		new_unit.damage_mult_vs_forest += slot.slot_res.damage_mult_vs_forest - 1
		new_unit.inc_damage_magic_mult += slot.slot_res.inc_damage_magic_mult - 1
		new_unit.inc_damage_physical_mult += slot.slot_res.inc_damage_physical_mult - 1
		new_unit.inc_damage_mult_vs_all += slot.slot_res.inc_damage_mult_vs_all - 1
		new_unit.inc_damage_mult_vs_castle += slot.slot_res.inc_damage_mult_vs_castle - 1
		new_unit.inc_damage_mult_vs_hell += slot.slot_res.inc_damage_mult_vs_hell - 1
		new_unit.inc_damage_mult_vs_forest += slot.slot_res.inc_damage_mult_vs_forest - 1
