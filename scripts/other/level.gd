extends Node2D

@onready var player_units: Node2D = %player_units
@onready var top_spawner: Marker2D = %top_spawner
@onready var mid_spawner: Marker2D = %mid_spawner
@onready var bot_spawner: Marker2D = %bot_spawner


func _ready() -> void:
	SignalManager.on_create_player_unit.connect(add_player_unit)


func add_player_unit(unit : Unit, slots : Array[Slot], owner : DataManager.UnitOwner):
	player_units.add_child(unit)
	unit.initialize(slots[0], owner)
	unit.global_position = mid_spawner.global_position
