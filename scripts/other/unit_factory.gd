extends Node2D

class_name UnitFactory


@export var unit_family : DataManager.UnitFamily
@export var unit_owner : DataManager.UnitOwner
@export var unit_scene : PackedScene


func set_unit_owner(new_unit_owner : DataManager.UnitOwner):
	unit_owner = new_unit_owner


func choose_unit(slots : Array[Slot]):
	create_unit(slots)



func get_unit(slots : Array[Slot]):
	return create_and_get_unit(slots)



func create_unit(slots):
	#var new_unit = unit.instantiate()
	var new_unit = unit_scene.instantiate()
	apply_slots(new_unit, slots)
	if unit_owner == DataManager.UnitOwner.PLAYER:
		SignalManager.on_create_unit.emit(new_unit, slots, unit_owner)
	else:
		SignalManager.on_create_enemy_unit.emit(new_unit, slots, unit_owner)


func create_and_get_unit(slots):
	#var new_unit = unit.instantiate()
	var new_unit = unit_scene.instantiate()
	apply_slots(new_unit, slots)
	return new_unit


func apply_slots(new_unit : Unit, slots):
	for slot in slots:
		new_unit.add_slot(slot)
		if slot.slot_type != DataManager.SlotType.UNIT:
			if slot.has_meta('slot_name') and slot.get_meta('slot_name') == 'empty':
				pass
			else:
				new_unit.add_slot_res(slot.slot_res)
		if slot.slot_type == DataManager.SlotType.ULT:
			# some logic
			continue
		new_unit.stats.health += slot.slot_res.health
		new_unit.stats.health_mult += slot.slot_res.health_mult - 1
		new_unit.stats.armor += slot.slot_res.armor
		new_unit.stats.armor_mult += slot.slot_res.armor_mult - 1
		new_unit.stats.magic_defence += slot.slot_res.magic_defence
		new_unit.stats.magic_defence_mult += slot.slot_res.magic_defence_mult - 1
		new_unit.stats.physical_attack += slot.slot_res.physical_attack
		new_unit.stats.physical_attack_mult += slot.slot_res.physical_attack_mult - 1
		new_unit.stats.magical_attack += slot.slot_res.magical_attack
		new_unit.stats.magical_attack_mult += slot.slot_res.magical_attack_mult - 1
		new_unit.stats.hit_chance += slot.slot_res.hit_chance
		new_unit.stats.hit_chance_mult += slot.slot_res.hit_chance_mult - 1
		new_unit.stats.crit_chance += slot.slot_res.crit_chance
		new_unit.stats.crit_chance_mult += slot.slot_res.crit_chance_mult - 1
		new_unit.stats.crit_attack += slot.slot_res.crit_attack
		new_unit.stats.crit_attack_mult += slot.slot_res.crit_attack_mult - 1
		new_unit.stats.evade += slot.slot_res.evade
		new_unit.stats.evade_mult += slot.slot_res.evade_mult - 1
		new_unit.stats.shield += slot.slot_res.shield
		new_unit.stats.shield_mult += slot.slot_res.shield_mult - 1
		new_unit.stats.attack_speed += slot.slot_res.attack_speed
		new_unit.stats.attack_speed_mult += slot.slot_res.attack_speed_mult - 1
		new_unit.stats.move_speed += slot.slot_res.move_speed
		new_unit.stats.move_speed_mult += slot.slot_res.move_speed_mult - 1
		new_unit.stats.attack_range += slot.slot_res.attack_range
		new_unit.stats.attack_range_mult += slot.slot_res.attack_range_mult - 1
		new_unit.stats.life_steal += slot.slot_res.life_steal
		new_unit.stats.life_steal_mult += slot.slot_res.life_steal_mult - 1
		new_unit.stats.health_regen += slot.slot_res.health_regen
		new_unit.stats.health_regen_mult += slot.slot_res.health_regen_mult - 1
		new_unit.stats.health_regen_interval = min(slot.slot_res.health_regen_interval, new_unit.stats.health_regen_interval)
		new_unit.stats.health_regen_interval_mult += slot.slot_res.health_regen_interval_mult - 1
		new_unit.stats.true_damage += slot.slot_res.true_damage
		new_unit.stats.true_damage_mult += slot.slot_res.true_damage_mult - 1
		new_unit.stats.scout_range += slot.slot_res.scout_range
		new_unit.stats.scout_range_mult += slot.slot_res.scout_range_mult - 1
		new_unit.stats.damage_mult_vs_all += slot.slot_res.damage_mult_vs_all - 1
		new_unit.stats.damage_mult_vs_castle += slot.slot_res.damage_mult_vs_castle - 1
		new_unit.stats.damage_mult_vs_hell += slot.slot_res.damage_mult_vs_hell - 1
		new_unit.stats.damage_mult_vs_forest += slot.slot_res.damage_mult_vs_forest - 1
		new_unit.stats.inc_damage_mult_vs_all += slot.slot_res.inc_damage_mult_vs_all - 1
		new_unit.stats.inc_damage_mult_vs_castle += slot.slot_res.inc_damage_mult_vs_castle - 1
		new_unit.stats.inc_damage_mult_vs_hell += slot.slot_res.inc_damage_mult_vs_hell - 1
		new_unit.stats.inc_damage_mult_vs_forest += slot.slot_res.inc_damage_mult_vs_forest - 1
