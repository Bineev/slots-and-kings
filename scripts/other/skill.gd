extends TextureRect

class_name Skill

@export var skill_tier : DataManager.EntityTier
@export var tooltip_scene : PackedScene
@export var skill_name : String
@export var skill_desc : String
@export var skill_tooltip : Tooltip
@export var skill_preview : Texture2D
@export var skill_target_type : DataManager.UnitOwner

var skill_owner : Hero
var targets : Array[Unit]
var tooltip : Tooltip
var is_tooltip_shown : bool

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


func show_tooltip():
		SignalManager.on_show_tooltip.emit(self, tooltip)
		tooltip.visible = true
		get_tree().create_timer(10).timeout.connect(hide_tooltip)


func hide_tooltip():
	if is_tooltip_shown:
		SignalManager.on_hide_tooltip.emit(tooltip)
		tooltip.visible = false
		is_tooltip_shown = false


func hide_unit_tooltip(new_tooltip : Tooltip):
	if new_tooltip == tooltip:
		hide_tooltip()


func _on_mouse_entered() -> void:
	if not is_tooltip_shown:
		is_tooltip_shown = true
		show_tooltip()


func _on_mouse_exited() -> void:
	hide_tooltip()
