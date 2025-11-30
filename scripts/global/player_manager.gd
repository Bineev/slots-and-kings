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


func _ready() -> void:
	SignalManager.on_choose_item.connect(add_item_to_deck)


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
	
	print(get_unique_entities(upgrade_scenes, amount))


func get_unique_entities(entities : Array[PackedScene], amount : int):
	var unique_array : Array
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
			base_upgrades_deck.append(slot_scene)
		DataManager.SlotType.PERC:
			base_percs_deck.append(slot_scene)
		DataManager.SlotType.UNIT:
			base_units_deck.append(slot_scene)


func get_deck_by_slot_type(slot_type : DataManager.SlotType):
	match slot_type:
		DataManager.SlotType.UPGRADE:
			return base_upgrades_deck.duplicate()
		DataManager.SlotType.PERC:
			return base_percs_deck.duplicate()
		DataManager.SlotType.UNIT:
			return base_units_deck.duplicate()
