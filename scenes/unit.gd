extends CharacterBody2D

class_name Unit

@export var unit_family : DataManager.UnitFamily
@export var unit_tier : DataManager.UnitTier
@export var unit_types : Array[DataManager.UnitType]
@export var unit_cost : int
# stats and multiplicators
var stats : Dictionary = {
	'health' : 0,
	'health_mult' : 1,
	'armor' : 0,
	'armor_mult' : 1,
	'physical_attack' : 0,
	'physical_attack_mult' : 1,
	'magical_attack' : 0,
	'magical_attack_mult' : 1,
	'hit_chance' : 1,
	'hit_chance_mult' : 1,
	'crit_chance' : 0,
	'crit_chance_mult' : 1,
	'evade' : 0,
	'evade_mult' : 1,
	'shield' : 0,
	'shield_mult' : 1,
	'attack_speed' : 0,
	'attack_speed_mult' : 1,
	'move_speed' : 0,
	'move_speed_mult' : 1,
	'attack_range' : 0,
	'attack_range_mult' : 1,
	'life_steal' : 0,
	'life_steal_mult' : 1,
	'health_regen' : 0,
	'health_regen_mult' : 1,
	'health_regen_interval' : INF,
	'health_regen_interval_mult' : 1,
	'true_damage' : 0,
	'true_damage_mult' : 0,
	'scout_range' : 0,
	'scout_range_mult' : 1,
	'damage_mult_vs_all' : 1,
	'damage_mult_vs_castle' : 1,
	'damage_mult_vs_hell' : 1,
	'damage_mult_vs_forest' : 1,
	'inc_damage_magic_mult' : 1,
	'inc_damage_physical_mult' : 1,
	'inc_damage_mult_vs_all' : 1,
	'inc_damage_mult_vs_castle' : 1,
	'inc_damage_mult_vs_hell' : 1,
	'inc_damage_mult_vs_forest' : 1
}

@export var unit_state : DataManager.UnitState
@export var unit_owner : DataManager.UnitOwner
@export var unit_name : String
@export var unit_desc : String
@export var is_active : bool
@export var get_target_setting : DataManager.TargetSetting

var is_should_change_state : bool 
var is_can_attack : bool = true
var current_target : Unit
var enemies_in_range : Array[Unit]
var is_in_fight : bool
var current_health : int

@onready var attack_range_collision: CollisionShape2D = %attack_range_collision
@onready var unit_anim_player: AnimationPlayer = %unit_anim_player
@onready var scout_range_collision: CollisionShape2D = %scout_range_collision
@onready var unit_sprite: Sprite2D = %unit_sprite
@onready var unit_collision: CollisionShape2D = %unit_collision
@onready var timer_aspd: Timer = %timer_aspd
@onready var attack_range: Area2D = %attack_range


func _ready() -> void:
	SignalManager.on_wave_done.connect(toggle_is_in_fight)


func _process(delta: float) -> void:
	if is_should_change_state:
		apply_state()

	if not is_active:
		return

	match unit_state:
		DataManager.UnitState.WALK:
			if current_target and current_target.get_state() != DataManager.UnitState.DIED and current_target.get_state() != DataManager.UnitState.DEAD:
				var direction : Vector2 = (current_target.global_position - global_position).normalized()
				velocity = stats.move_speed * direction
				move_and_slide()
				if enemies_in_range.has(current_target):
					change_state(DataManager.UnitState.IDLE)
			else:
				current_target = get_enemy_on_field()
		DataManager.UnitState.IDLE:
			if is_in_fight and is_can_attack and Player.check_enemies(unit_owner):
				fight()
		DataManager.UnitState.DIED:
			print('died')
			# remove from


func initialize(slot : Slot, owner : DataManager.UnitOwner):
	await get_tree().process_frame
	unit_owner = owner
	unit_state = DataManager.UnitState.IDLE
	unit_name = slot.slot_name
	unit_desc = slot.slot_description
	unit_types = slot.unit_types
	unit_cost = slot.unit_cost
	unit_family = slot.slot_res.unit_family
	unit_tier = slot.slot_unit_tier
	unit_sprite.texture = slot.slot_res.unit_sprite
	var ar_shape = CircleShape2D.new()
	ar_shape.radius = stats.attack_range
	attack_range_collision.shape  = ar_shape
	#var sr_shape = RectangleShape2D.new()
	#sr_shape.size = Vector2(stats.scout_range, 50)
	#scout_range_collision.shape  = sr_shape
	unit_anim_player.get_animation("attack").loop_mode = Animation.LOOP_LINEAR
	change_state(DataManager.UnitState.ATTACK)
	if unit_owner == DataManager.UnitOwner.ENEMY:
		unit_sprite.flip_h = true
	set_collisions_by_owner()


func get_state() -> DataManager.UnitState:
	return unit_state


func set_active():
	await get_tree().process_frame
	is_active = true
	change_state(DataManager.UnitState.IDLE)
	unit_anim_player.get_animation("attack").loop_mode = Animation.LOOP_NONE


func set_collisions_by_owner():
	if unit_owner == DataManager.UnitOwner.PLAYER:
		set_collision_layer_value(2, true)
		attack_range.set_collision_mask_value(3, true)
	else:
		set_collision_layer_value(3, true)
		attack_range.set_collision_mask_value(2, true)
	


func parse_stats():
	var unique_stats : Dictionary
	for stat in DataManager.default_stats.keys():
		if stats[stat] == DataManager.default_stats[stat]:
			continue
		unique_stats[stat] = stats[stat]
	
	return unique_stats


func change_state(new_state : DataManager.UnitState):
	is_should_change_state = true
	unit_state = new_state


func apply_state():
	match unit_state:
		DataManager.UnitState.IDLE:
			unit_anim_player.play('idle')
		DataManager.UnitState.WALK:
			unit_anim_player.play('walk')
		DataManager.UnitState.ATTACK:
			unit_anim_player.play('attack')
		DataManager.UnitState.DIED:
			unit_anim_player.play('died')
		DataManager.UnitState.DEAD:
			unit_anim_player.play('dead')

	is_should_change_state = false
	# можно привязать логику к аним треку (дроп ресурса, стата, исчезновение, мб звук)


func _on_attack_range_body_entered(body: Node2D) -> void:
	var unit : Unit = body
	if unit.unit_owner == unit_owner:
		return
	if not enemies_in_range.has(unit) and unit.get_state() != DataManager.UnitState.DIED and unit.get_state() != DataManager.UnitState.DEAD:
		enemies_in_range.append(unit)


func _on_attack_range_body_exited(body: Node2D) -> void:
	var unit : Unit = body
	if unit.unit_owner == unit_owner:
		return
	enemies_in_range.erase(unit)


func fight():
	# если есть живой таргет в ренже атаки
	if current_target and current_target.get_state() != DataManager.UnitState.DIED and current_target.get_state() != DataManager.UnitState.DEAD:
		attack()
		return
	else:
		current_target = get_target_by_setting()

	# если нет живого таргета в ренже, ищем какой-то таргет на поле
	if current_target and current_target.get_state() != DataManager.UnitState.DIED and current_target.get_state() != DataManager.UnitState.DEAD:
		attack()
		return
	else:
		current_target = get_enemy_on_field()
	# если есть живой таргет на поле, то идем к нему, пока не дойдем в ренж атаки
	if current_target and current_target.get_state() != DataManager.UnitState.DIED and current_target.get_state() != DataManager.UnitState.DEAD:
		change_state(DataManager.UnitState.WALK)
	# если живого таргета нет, встаем в idle
	else:
		change_state(DataManager.UnitState.IDLE)


func stop_fight():
	is_in_fight = false


func attack():
	change_state(DataManager.UnitState.ATTACK)
	is_can_attack = false
	timer_aspd.wait_time = stats.attack_speed
	timer_aspd.start()
	current_target.get_damage(1, self)


func get_target_by_setting():
	var targets : Array[Unit]
	# понадобится проверка на освобожден
	for unit in enemies_in_range:
		if unit.get_state() != DataManager.UnitState.DIED and unit.get_state() != DataManager.UnitState.DEAD:
			targets.append(unit)
	if targets.size() == 0:
		return null
		
	match get_target_setting:
		DataManager.TargetSetting.CLOSEST:
			targets.sort_custom(custom_sort_closest)
		DataManager.TargetSetting.MAX_HP:
			targets.sort_custom(custom_sort_max_hp)
		DataManager.TargetSetting.LOW_HP:
			targets.sort_custom(custom_sort_low_hp)
	
	return targets[0]


func custom_sort_closest(a : Unit, b : Unit):
	return true


func custom_sort_max_hp(a : Unit, b : Unit):
	return true


func custom_sort_low_hp(a : Unit, b : Unit):
	return true


func get_enemy_on_field():
	var targets : Array[Unit] = Player.get_enemies() if unit_owner == DataManager.UnitOwner.PLAYER else Player.get_player_units()
	if targets.size() == 0:
		return null
	# потом можно через match и target_setting
	targets.sort_custom(custom_sort_closest)
	return targets[0]


func get_damage(damage, damage_owner):
	if current_health - damage <= 0:
		current_health = 0
		change_state(DataManager.UnitState.DIED)


func toggle_is_in_fight():
	is_in_fight = false


func _on_timer_aspd_timeout() -> void:
	change_state(DataManager.UnitState.IDLE)
	is_can_attack = true
