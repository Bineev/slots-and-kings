extends Resource

class_name SkillRes


@export var skill_tier : DataManager.EntityTier
@export var skill_name : String
@export var skill_desc : String
@export var skill_preview : Texture2D
@export var skill_anim : Texture2D
@export var skill_target_type : DataManager.UnitOwner
@export var skill_damage_type : DataManager.UnitType
@export var skill_buff_stats : Array[Dictionary]
@export var skill_slot_scenes : Array[PackedScene]
@export var is_void_zone : bool
@export var is_trap : bool
# {stat_name : current_stat, stat_change_type : 0 (+) or 1 (*), stat_change_amount : float}

@export var skill_delay : float

@export var skill_cooldown : float
@export var skill_flat_damage : int
@export var skill_tick_damage : int
@export var skill_tick_interval : int
@export var skill_duration : float
@export var skill_flat_heal : int
@export var skill_tick_heal : int
@export var skill_range : float
