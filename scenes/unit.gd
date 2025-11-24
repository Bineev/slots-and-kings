extends CharacterBody2D

class_name Unit

@export var unit_family : DataManager.UnitFamily
@export var unit_tier : DataManager.UnitTier
# stats and multiplicators
@export var health : float = 0
@export var health_mult : float = 1
@export var armor : float = 0
@export var armor_mult : float = 1
@export var physical_attack : float = 0
@export var physical_attack_mult : float = 1
@export var magical_attack : float = 0
@export var magical_attack_mult : float = 1
@export var hit_chance : float = 1
@export var hit_chance_mult : float = 1
@export var crit_chance : float = 0
@export var crit_chance_mult : float = 1
@export var evade : float = 0
@export var evade_mult : float = 1
@export var shield : float = 0
@export var shield_mult : float = 1
@export var attack_speed : float = 0
@export var attack_speed_mult : float = 1
@export var move_speed : float = 0
@export var move_speed_mult : float = 1
@export var attack_range : float = 0
@export var attack_range_mult : float = 1
@export var life_steal : float = 0
@export var life_steal_mult : float = 1
@export var health_regen : float = 0
@export var health_regen_mult : float = 1
@export var health_regen_interval : float = INF
@export var health_regen_interval_mult : float = 1
@export var true_damage : float = 0
@export var true_damage_mult : float = 0
@export var scout_range : float = 0
@export var scout_range_mult : float = 1
@export var damage_mult_vs_all : float = 1
@export var damage_mult_vs_castle : float = 1
@export var damage_mult_vs_hell : float = 1
@export var damage_mult_vs_forest : float = 1
@export var inc_damage_magic_mult : float = 1
@export var inc_damage_physical_mult : float = 1
@export var inc_damage_mult_vs_all : float = 1
@export var inc_damage_mult_vs_castle : float = 1
@export var inc_damage_mult_vs_hell : float = 1
@export var inc_damage_mult_vs_forest : float = 1

var unit_state : DataManager.UnitState
var unit_owner : DataManager.UnitOwner
var unit_name : String
var unit_desc : String

@onready var attack_range_collision: CollisionShape2D = %attack_range_collision
@onready var scout_range_collision: CollisionShape2D = %scout_range_collision


func initialize(slot : Slot, owner : DataManager.UnitOwner):
	await self.ready
	unit_owner = owner
	unit_state = DataManager.UnitState.IDLE
	unit_name = slot.slot_name
	unit_desc = slot.slot_description
	var ar_shape = CircleShape2D.new()
	ar_shape.radius = attack_range
	attack_range_collision.shape  = ar_shape
	var sr_shape = RectangleShape2D.new()
	sr_shape.size = Vector2(scout_range, 50)
	attack_range_collision.shape  = sr_shape
