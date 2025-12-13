extends Area2D


class_name SkillZone


var skill : ActiveSkill
var is_active : bool
var previous_position : Vector2

@onready var skill_zone_collision: CollisionShape2D = %skill_zone_collision
@onready var skill_zone_sprite: Sprite2D = %skill_zone_sprite


func _process(delta: float) -> void:
	if is_active:
		global_position = get_global_mouse_position()


func initialize():
	await get_tree().process_frame
	create_zone_view()
	create_collision()


func set_skill(new_skill : ActiveSkill):
	skill = new_skill


func set_collisions():
	if skill.skill_target_type == DataManager.UnitOwner.ENEMY:
		set_collision_mask_value(3, true)
	elif skill.skill_target_type == DataManager.UnitOwner.PLAYER:
		set_collision_mask_value(2, true)


func create_zone_view():
	var zone_view = GradientTexture2D.new()
	zone_view.fill = GradientTexture2D.FILL_RADIAL
	zone_view.fill_from = Vector2(0.5, 0.5)
	zone_view.width = skill.skill_range * 2
	zone_view.height = skill.skill_range * 2
	#zone_view.gradient.colors = PackedColorArray([Color(207, 87, 60, 100), Color(207, 87, 60, 100)])
	skill_zone_sprite.texture = zone_view


func create_collision():
	var shape = CircleShape2D.new()
	shape.radius = skill.skill_range
	skill_zone_collision.shape = shape


func _on_body_entered(body: Node2D) -> void:
	if is_active:
		var unit : Unit = body
		skill.add_target(unit)


func _on_body_exited(body: Node2D) -> void:
	if is_active:
		var unit : Unit = body
		skill.remove_target(unit)


func set_active():
	is_active = true


func set_inactive():
	is_active = false


func start_working():
	previous_position = global_position
	set_active()
	show()


func stop_working():
	set_inactive()
	global_position = previous_position
