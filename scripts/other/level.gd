extends Node2D

class_name Level


var is_need_def_of_loop : bool

@onready var player_units: Node2D = %player_units
@onready var spawners: Node2D = %spawners
@onready var ui: CanvasLayer = %UI
@onready var buildings: Node2D = %buildings


func _ready() -> void:
	SignalManager.on_create_player_unit.connect(add_player_unit)
	SignalManager.on_pop_up_UI.connect(add_UI)
	SignalManager.on_build_building.connect(build_building)


func add_player_unit(unit : Unit, slots : Array[Slot], owner : DataManager.UnitOwner):
	player_units.add_child(unit)
	unit.initialize(slots[0], owner)
	unit.global_position = get_free_random_spawner().global_position


func get_free_random_spawner():
	var active_spawner : Spawner
	for spawner in spawners.get_children():
		if not spawner.is_filled:
			active_spawner = spawner
			spawner.is_filled = true
			break
	if not active_spawner:
		active_spawner = spawners.get_children().pick_random()
		
	return active_spawner


func free_spawners():
	for spawner in spawners.get_children():
		spawner.is_filled = false


func add_UI(pop_up_UI : Control):
	ui.add_child(pop_up_UI)
	pop_up_UI.initialize()


func build_building(building_scene : PackedScene, prebuilding : Building):
	var new_building = building_scene.instantiate()
	buildings.add_child(new_building)
	new_building.global_position = prebuilding.global_position
	new_building.initialize()
	buildings.remove_child(prebuilding)
	prebuilding.queue_free()
