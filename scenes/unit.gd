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

var is_should_change_state : bool 

@onready var attack_range_collision: CollisionShape2D = %attack_range_collision
@onready var unit_anim_player: AnimationPlayer = %unit_anim_player
@onready var scout_range_collision: CollisionShape2D = %scout_range_collision
@onready var unit_sprite: Sprite2D = %unit_sprite


func _process(delta: float) -> void:
	if is_should_change_state:
		apply_state()


func initialize(slot : Slot, owner : DataManager.UnitOwner):
	await get_tree().process_frame
	unit_owner = owner
	unit_state = DataManager.UnitState.IDLE
	unit_name = slot.slot_name
	unit_desc = slot.slot_description
	unit_types = slot.unit_types
	unit_cost = slot.unit_cost
	var ar_shape = CircleShape2D.new()
	ar_shape.radius = stats.attack_range
	attack_range_collision.shape  = ar_shape
	var sr_shape = RectangleShape2D.new()
	sr_shape.size = Vector2(stats.scout_range, 50)
	attack_range_collision.shape  = sr_shape
	unit_anim_player.get_animation("attack").loop_mode = Animation.LOOP_LINEAR
	change_state(DataManager.UnitState.ATTACK)


func set_active():
	is_active = true
	change_state(DataManager.UnitState.IDLE)
	unit_anim_player.get_animation("attack").loop_mode = Animation.LOOP_NONE


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
