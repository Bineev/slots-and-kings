extends Node


@export var current_king : DataManager.UnitFamily
@export var health : int
@export var gold : int
@export var tokens : int
@export var food : int
@export var crystals : int
@export var can_swap_time : float
@export var is_can_swap : bool

@export var wave_rewards : Array[DataManager.RewardType]
@export var empty_perc_scene : PackedScene
@export var empty_upgrade_scene : PackedScene
@export var slot_scene : PackedScene

@export var base_units_reses : Array[Resource]
@export var base_upgrades_reses : Array[Resource]
@export var base_percs_reses : Array[Resource]
@export var base_units_deck : Array[PackedScene]
@export var base_upgrades_deck : Array[PackedScene]
@export var base_percs_deck : Array[PackedScene]

@export var units_T1_pool : Array[Resource]
@export var units_T2_pool : Array[Resource]
@export var units_T3_pool : Array[Resource]
@export var units_T4_pool : Array[Resource]

@export var upgrades_T1_pool : Array[Resource]
@export var upgrades_T2_pool : Array[Resource]
@export var upgrades_T3_pool : Array[Resource]
@export var upgrades_T4_pool : Array[Resource]

@export var percs_T4_pool : Array[Resource]
@export var percs_T1_pool : Array[Resource]
@export var percs_T2_pool : Array[Resource]
@export var percs_T3_pool : Array[Resource]

@export var hero_factory_scene : PackedScene

var current_health : int
var current_gold : int
var current_tokens : int
var current_food : int
var current_crystals : int
var enemy_units : Array[Unit]
var player_units : Array[Unit]
var dead_enemy_units : Array[Unit]
var dead_player_units : Array[Unit]
var heroes : Array[Hero]
var current_wave_count : int
var next_create_units_count : int
var hero_factory : HeroFactory
var unit_factory : UnitFactory

func _ready() -> void:
	SignalManager.on_choose_item.connect(add_item_to_deck)
	SignalManager.on_get_res.connect(get_res)
	initialize()


func initialize():
	current_health = health
	current_gold = gold
	current_tokens = tokens
	current_food = food
	current_crystals = crystals
	hero_factory = hero_factory_scene.instantiate()
	generate_base_decks()


func get_random_upgrades(tier : DataManager.EntityTier, amount : int):
	var upgrade_reses : Array[Resource]
	match tier:
		DataManager.EntityTier.T1:
			upgrade_reses = upgrades_T1_pool
		DataManager.EntityTier.T2:
			upgrade_reses = upgrades_T2_pool
		DataManager.EntityTier.T3:
			upgrade_reses = upgrades_T3_pool
		DataManager.EntityTier.T4:
			upgrade_reses = upgrades_T4_pool
	
	return get_unique_entities(upgrade_reses, amount)


func get_random_units(tier : DataManager.EntityTier, amount : int):
	var unit_reses : Array[Resource]
	match tier:
		DataManager.EntityTier.T1:
			unit_reses = units_T1_pool
		DataManager.EntityTier.T2:
			unit_reses = units_T2_pool
		DataManager.EntityTier.T3:
			unit_reses = units_T3_pool
		DataManager.EntityTier.T4:
			unit_reses = units_T4_pool
	
	return get_unique_entities(unit_reses, amount)


func get_random_percs(tier : DataManager.EntityTier, amount : int):
	pass


func get_random_heroes(tier : DataManager.EntityTier, amount : int):
	pass


func get_unique_entities(entities : Array[Resource], amount : int):
	#var unique_array : Array[PackedScene]
	#entities.shuffle()
	#var count : int
	#for entity in entities:
		#if count >= amount:
			#break
		#unique_array.append(entity)
		#count += 1
#
	#return unique_array
	var unique_array : Array[PackedScene]
	entities.shuffle()
	var count : int
	for entity in entities:
		if count >= amount:
			break
		unique_array.append(create_slot_scene(entity))
		count += 1

	return unique_array


func add_item_to_deck(slot_scene : PackedScene, slot_type : DataManager.SlotType):
	match slot_type:
		DataManager.SlotType.UPGRADE:
			add_upgrade_slot_to_deck(slot_scene)
		DataManager.SlotType.PERC:
			base_percs_deck.append(slot_scene)
		DataManager.SlotType.UNIT: 
			add_unit_slot_to_deck(slot_scene)


func add_unit_slot_to_deck(slot_scene : PackedScene):
	var slot : Slot
	for item in base_units_deck:
		slot = item.instantiate()
		if slot.slot_res.unit_tier == DataManager.UnitTier.T0:
			base_units_deck.erase(item)
			break
	base_units_deck.append(slot_scene)


func add_upgrade_slot_to_deck(slot_scene : PackedScene):
	var slot : Slot
	for item in base_upgrades_deck:
		slot = item.instantiate()
		if slot.get_meta('slot_name') == 'empty':
			base_upgrades_deck.erase(item)
			break
	base_upgrades_deck.append(slot_scene)


func get_deck_by_slot_type(slot_type : DataManager.SlotType):
	var slots : Array[PackedScene]
	match slot_type:
		DataManager.SlotType.UPGRADE:
			slots = base_upgrades_deck.duplicate()
		DataManager.SlotType.PERC:
			slots = base_percs_deck.duplicate()
		DataManager.SlotType.UNIT:
			slots = base_units_deck.duplicate()
	slots.shuffle()
	return slots


func get_res(res_type : DataManager.ResType, res_amount : int):
	match res_type:
		DataManager.ResType.GOLD:
			current_gold += res_amount
		DataManager.ResType.SPIN_TOKEN:
			current_tokens += res_amount
		DataManager.ResType.CRYSTAL:
			current_crystals += res_amount
		DataManager.ResType.FOOD:
			current_food += res_amount
	SignalManager.on_res_change.emit(res_type)


func get_gold():
	return current_gold


func get_food():
	return current_food


func get_tokens():
	return current_tokens


func get_crystals():
	return current_crystals


func check_res(amount : int, res_type : DataManager.ResType):
	match res_type:
		DataManager.ResType.GOLD:
			return current_gold - amount >= 0
		DataManager.ResType.SPIN_TOKEN:
			return current_tokens - amount >= 0
		DataManager.ResType.CRYSTAL:
			return current_crystals - amount >= 0
		DataManager.ResType.FOOD:
			return current_food - amount >= 0


func add_unit_to_player_units(unit : Unit):
	player_units.append(unit)


func remove_unit_from_player_units(unit : Unit):
	player_units.erase(unit)
	pass


func add_unit_to_enemy_units(unit : Unit):
	enemy_units.append(unit)


func remove_unit_from_enemy_units(unit : Unit):
	enemy_units.erase(unit)
	
	
func get_enemies():
	return enemy_units


func get_player_units():
	return player_units


func is_enemies_alive():
	return enemy_units.size() > 0


func is_player_units_alive():
	return player_units.size() > 0


func set_player_units_in_fight():
	for unit in player_units:
		if unit and is_instance_valid(unit) and unit.unit_state != DataManager.UnitState.DIED and unit.unit_state != DataManager.UnitState.DEAD:
			unit.is_in_fight = true


func set_player_units_not_in_fight():
	for unit in player_units:
		if unit and is_instance_valid(unit) and unit.unit_state != DataManager.UnitState.DIED and unit.unit_state != DataManager.UnitState.DEAD:
			unit.is_in_fight = false

func check_enemies(unit_owner : DataManager.UnitOwner):
	return is_enemies_alive() if unit_owner == DataManager.UnitOwner.PLAYER else is_player_units_alive()


func apply_heroes_skills(unit : Unit):
	for hero in heroes:
		hero.apply_passives(unit)


func get_current_wave_count():
	return current_wave_count


func increment_current_wave_count():
	current_wave_count += 1


func set_wave_rewards(new_wave_rewards : Array[DataManager.RewardType]):
	wave_rewards = new_wave_rewards


func get_wave_rewards():
	return wave_rewards


func get_damage(damage : float):
	current_health = clamp(current_health - damage, 0, health)
	if current_health <= 0:
		print("DIE")
	SignalManager.on_player_get_hit.emit()
	# тряска


func get_current_health():
	return current_health


func get_health():
	return health


func set_units_count_for_next_create(units_count : int):
	next_create_units_count = units_count


func get_units_count_for_next_create():
	return next_create_units_count


func get_random_hero(hero_level : int):
	var hero : Hero = hero_factory.get_random_hero(hero_level)
	heroes.append(hero)
	SignalManager.on_add_hero_to_field.emit(hero)


func set_unit_factory(new_unit_factory : UnitFactory):
	unit_factory = new_unit_factory


func get_unit_factory():
	return unit_factory


func get_heal(amount : int):
	current_health = clamp(current_health + amount, 0, health)
	SignalManager.on_player_get_health.emit()


func remove_slot_by_type(slot : Slot, slot_type : DataManager.SlotType):
	match slot_type:
		DataManager.SlotType.UPGRADE:
			remove_slot(base_upgrades_deck, slot)
		DataManager.SlotType.PERC:
			remove_slot(base_percs_deck, slot)
		DataManager.SlotType.UNIT:
			remove_slot(base_units_deck, slot)


func remove_slot(deck : Array[PackedScene], slot : Slot):
	var slots : Array[Slot]
	for item in deck:
		var item_instance : Slot = item.instantiate()
		if item_instance.slot_res.slot_name == slot.slot_name:
			if deck.size() == 4:
				deck.erase(item)
				deck.append(empty_perc_scene if slot.slot_type == DataManager.SlotType.PERC else empty_upgrade_scene)
				break
			else:
				deck.erase(item)
				break


func get_can_swap_time():
	return can_swap_time


func set_is_can_swap(new_is_can_swap : bool):
	is_can_swap = new_is_can_swap


func get_is_can_swap():
	return is_can_swap


func create_slot_scene(res : SlotRes):
	var slot : Slot = slot_scene.instantiate()
	slot.slot_res = res
	slot.set_meta('slot_name', res.slot_name)
	var smth : PackedScene = PackedScene.new()
	smth.pack(slot)
	#smth.set_meta('slot_name', res.slot_name)
	return smth


func generate_base_decks():
	for res in base_upgrades_reses:
		base_upgrades_deck.append(create_slot_scene(res))
	for res in base_units_reses:
		base_units_deck.append(create_slot_scene(res))
	for res in base_percs_reses:
		base_percs_deck.append(create_slot_scene(res))
