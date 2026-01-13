extends Node


@export var empire_unit_reses : Array[Resource]
@export var hell_unit_reses : Array[Resource]
@export var forest_unit_reses : Array[Resource]

@export var spawn_scene : PackedScene
@export var wave_scene : PackedScene

var current_enemy_families : Array[DataManager.UnitFamily]


func _ready() -> void:
	current_enemy_families = [DataManager.UnitFamily.CASTLE]


func create_wave_by_wave_count(wave_count : int, diff_count : int):
	# исходя из уровня волны и уровня сложности, генерируем волну
	pass
