extends Area2D

class_name Projectile


@export var projectile_owner : Unit

var unit_projectile_texture : Texture2D
var is_active : bool
var projectile_speed : float
var target : Unit
var is_hit : bool

@onready var sprite_projectile: Sprite2D = %sprite_projectile
@onready var collision_projectile: CollisionShape2D = %collision_projectile


func _process(delta: float) -> void:
	if not is_active:
		return
	if not target or not is_instance_valid(target) or target.unit_state == DataManager.UnitState.DIED or target.unit_state == DataManager.UnitState.DIED:
		queue_free()
		return
	var direction = global_position.direction_to(target.global_position)
	global_position += direction * projectile_speed * DataManager.action_speed_coeff * delta
	if is_hit and (abs(global_position.x - target.global_position.x) < 2):
		projectile_speed = 0


func initialize():
	await get_tree().process_frame
	sprite_projectile.texture = unit_projectile_texture
	create_projectile_collision()
	set_collision_by_owner()
	sprite_projectile.flip_h = global_position.x > target.global_position.x
	is_active = true


func set_projectile_owner(new_projectile_owner : Unit):
	projectile_owner = new_projectile_owner


func set_unit_projectile_texture(new_unit_projectile_texture : Texture2D):
	unit_projectile_texture = new_unit_projectile_texture


func set_projectile_speed(new_projectile_speed : float):
	projectile_speed = new_projectile_speed


func set_target(new_target : Unit):
	target = new_target


func create_projectile_collision():
	var shape = RectangleShape2D.new()
	var extents : Vector2
	extents.x = sprite_projectile.texture.get_width() / 10
	extents.y = sprite_projectile.texture.get_height() / 10
	shape.extents = extents # Set the size/extents
	collision_projectile.shape = shape


func set_collision_by_owner():
	if projectile_owner.unit_owner == DataManager.UnitOwner.PLAYER:
		set_collision_mask_value(3, true)
	else:
		set_collision_mask_value(2, true)


func _on_body_entered(body: Node2D) -> void:
	var unit : Unit = body
	if unit != target:
		return
	if projectile_owner.unit_attack_type == DataManager.AttackType.AOE:
		var targets : Array[Unit]
		if projectile_owner.unit_owner == DataManager.UnitOwner.PLAYER:
			targets = Player.get_enemies()
		else:
			targets = Player.get_player_units()
		targets = targets.filter(get_units_for_aoe)
		for new_target in targets:
			projectile_owner.apply_damage(new_target)
	else:
		projectile_owner.apply_damage(unit)
	is_hit = true
	var tween : Tween = get_tree().create_tween()
	tween.set_parallel()
	tween.tween_property(self, 'is_active', false, 0.2)
	tween.tween_property(self, 'modulate', Color(1, 1, 1, 0), 0.2)
	tween.tween_callback(hide).set_delay(0.5)
	get_tree().create_timer(3).timeout.connect(queue_free)


func get_units_for_aoe(unit : Unit): 
	if not unit or not is_instance_valid(unit) or unit.unit_state == DataManager.UnitState.DIED or unit.unit_state == DataManager.UnitState.DIED:
		return false
	var distance_x = unit.global_position.x - target.global_position.x
	var distance_y = unit.global_position.y - target.global_position.y
	return abs(distance_x) <= projectile_owner.current_projectile_attack_range and abs(distance_y) <= projectile_owner.current_projectile_attack_range
	
