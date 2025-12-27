extends Resource

class_name SlotRes

@export var slot_name : String
@export var slot_description : String
@export var slot_sprite : Texture2D
@export var slot_type : DataManager.SlotType
@export var entity_tier : DataManager.EntityTier

# stats and multiplicators
@export var physical_attack : float = 0
@export var physical_attack_mult : float = 1
@export var magical_attack : float = 0
@export var magical_attack_mult : float = 1
@export var true_damage : float = 0
@export var true_damage_mult : float = 1
@export var health : float = 0
@export var health_mult : float = 1
@export var armor : float = 0
@export var armor_mult : float = 1
@export var magic_defence : float = 0
@export var magic_defence_mult : float = 1
@export var attack_speed : float = 0
@export var attack_speed_mult : float = 1
@export var life_steal : float = 0
@export var life_steal_mult : float = 1
@export var health_regen : float = 0
@export var health_regen_mult : float = 1
@export var health_regen_interval : float = INF
@export var health_regen_interval_mult : float = 1
@export var hit_chance : float = 0
@export var hit_chance_mult : float = 1
@export var crit_chance : float = 0
@export var crit_chance_mult : float = 1
@export var crit_attack : float = 0
@export var crit_attack_mult : float = 1
@export var evade : float = 0
@export var evade_mult : float = 1
@export var shield : float = 0
@export var shield_mult : float = 1

@export var move_speed : float = 0
@export var move_speed_mult : float = 1
@export var attack_range : float = 0
@export var attack_range_mult : float = 1

@export var scout_range : float = 0
@export var scout_range_mult : float = 1
@export var damage_mult_vs_all : float = 1
@export var damage_mult_vs_castle : float = 1
@export var damage_mult_vs_hell : float = 1
@export var damage_mult_vs_forest : float = 1
@export var inc_damage_mult_vs_all : float = 1
@export var inc_damage_mult_vs_castle : float = 1
@export var inc_damage_mult_vs_hell : float = 1
@export var inc_damage_mult_vs_forest : float = 1
@export var projectile_speed : float = 0
@export var projectile_speed_mult : float = 1
@export var projectile_attack_range : float = 0
@export var projectile_attack_range_mult : float = 1
