extends Resource

class_name PassiveSkillRes


@export var skill_passive_type : DataManager.PassiveSkillType
@export var skill_tier : DataManager.EntityTier
@export var skill_name : String
@export var skill_desc : String
@export var skill_preview : Texture2D
@export var skill_target_type : DataManager.UnitOwner
@export var skill_damage_type : DataManager.UnitType
@export var skill_buff_stats : Array[Dictionary]
@export var skill_resources : Array[DataManager.ResType]
@export var skill_resources_amounts : Array[int]
@export var skill_health_amount : int
@export var skill_wave_count : int
@export var get_something_time : int
# {stat_name : current_stat, stat_change_type : 0 (+) or 1 (*), stat_change_amount : float}
