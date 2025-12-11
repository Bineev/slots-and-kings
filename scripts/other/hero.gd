extends PanelContainer

class_name Hero


@export var hero_family : DataManager.UnitFamily
@export var hero_class : DataManager.UnitClass
@export var current_level : int = 1
@export var passives_scenes : Array[PackedScene]
@export var actives_scenes : Array[PackedScene]

var passives : Array[Skill]
var actives : Array[Skill]

@onready var hero_collision: CollisionShape2D = %hero_collision
@onready var hero_sprite: Sprite2D = %hero_sprite


func apply_passives(unit : Unit):
	for passive in passives:
		passive.apply(unit)
