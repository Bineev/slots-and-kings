extends Node2D

@onready var player_units: Node2D = %player_units
@onready var spawners: Node2D = %spawners

var is_need_def_of_loop : bool

func _ready() -> void:
	SignalManager.on_create_player_unit.connect(add_player_unit)


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
