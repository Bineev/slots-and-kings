extends TextureRect

class_name Skill


@export var skill_name : String
@export var skill_desc : String
@export var skill_tooltip : Tooltip
@export var skill_preview : Texture2D
@export var skill_target_type : DataManager.UnitOwner

var skill_owner : Hero
var targets : Array[Unit]

@onready var skill_sprite: Sprite2D = %skill_sprite


func initialize():
	pass


func set_skill_name(new_skill_name : String):
	skill_name = new_skill_name


func set_skill_desc(new_skill_desc : String):
	skill_desc = new_skill_desc


func set_skill_tooltip(new_skill_preview : Texture2D):
	skill_preview = new_skill_preview


func set_skill_target_type(new_skill_target_type : DataManager.UnitOwner):
	skill_target_type = new_skill_target_type


func set_skill_owner(new_hero : Hero):
	skill_owner = new_hero


func create_tooltip():
	pass


func get_targets():
	pass


func add_target(unit : Unit):
	targets.append(unit)


func remove_target(unit : Unit):
	targets.erase(unit)


func activate():
	pass
