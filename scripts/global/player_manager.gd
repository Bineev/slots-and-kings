extends Node

@export var current_king : DataManager.UnitFamily
@export var health : int
@export var gold : int
@export var tokens : int
@export var food : int
@export var crystals : int

@export var base_units_deck : Array[PackedScene]
@export var base_upgrades_deck : Array[PackedScene]
@export var base_percs_deck : Array[PackedScene]

@export var units_T1_pool : Array[PackedScene]
@export var units_T2_pool : Array[PackedScene]
@export var units_T3_pool : Array[PackedScene]
@export var units_T4_pool : Array[PackedScene]

@export var upgrades_T1_pool : Array[PackedScene]
@export var upgrades_T2_pool : Array[PackedScene]
@export var upgrades_T3_pool : Array[PackedScene]
@export var upgrades_T4_pool : Array[PackedScene]

@export var percs_T4_pool : Array[PackedScene]
@export var percs_T1_pool : Array[PackedScene]
@export var percs_T2_pool : Array[PackedScene]
@export var percs_T3_pool : Array[PackedScene]

var current_health : int
var current_gold : int
var current_tokens : int
var current_food : int
var current_crystals : int

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


func get_random_upgrades(tier : DataManager.EntityTier, amount : int):
	var upgrade_scenes : Array[PackedScene]
	match tier:
		DataManager.EntityTier.T1:
			upgrade_scenes = upgrades_T1_pool
		DataManager.EntityTier.T2:
			upgrade_scenes = upgrades_T2_pool
		DataManager.EntityTier.T3:
			upgrade_scenes = upgrades_T3_pool
		DataManager.EntityTier.T4:
			upgrade_scenes = upgrades_T4_pool
	
	return get_unique_entities(upgrade_scenes, amount)


func get_random_units(tier : DataManager.EntityTier, amount : int):
	var unit_scenes : Array[PackedScene]
	match tier:
		DataManager.EntityTier.T1:
			unit_scenes = units_T1_pool
		DataManager.EntityTier.T2:
			unit_scenes = units_T2_pool
		DataManager.EntityTier.T3:
			unit_scenes = units_T3_pool
		DataManager.EntityTier.T4:
			unit_scenes = units_T4_pool
	
	return get_unique_entities(unit_scenes, amount)


func get_unique_entities(entities : Array[PackedScene], amount : int):
	var unique_array : Array[PackedScene]
	entities.shuffle()
	var count : int
	for entity in entities:
		if count >= amount:
			break
		unique_array.append(entity)
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
	var counter : int
	for item in base_units_deck:
		slot = item.instantiate()
		if slot.slot_res.unit_tier == DataManager.UnitTier.T0:
			base_units_deck.erase(item)
			counter += 1
			if counter == 2:
				break
	for i in range(counter):
		base_units_deck.append(slot_scene)

	# пока костылем добавляются два юнита (заменяются кресты)


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
