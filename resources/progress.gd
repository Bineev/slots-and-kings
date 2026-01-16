extends Resource

class_name PlayerProgress


@export var family : DataManager.UnitFamily
@export var difficulty : DataManager.DifficultyType
@export var hero_classes : Array[DataManager.HeroClass]
@export var levels_done : Array[int]
@export var meta_stats : Dictionary[DataManager.MetaType, float]

@export var base_units_reses : Array[Resource]
@export var base_upgrades_reses : Array[Resource]
@export var base_percs_reses : Array[Resource]
# словарь вида UnitClass : Array[SkillRes]
@export var base_pskills_dict : Dictionary[DataManager.HeroClass, Array]
@export var base_askills_dict : Dictionary[DataManager.HeroClass, Array]

@export var special_units_reses : Array[Resource]
@export var special_upgrades_reses : Array[Resource]
@export var special_percs_reses : Array[Resource]
@export var special_pskills_dict : Dictionary
@export var special_askills_dict : Dictionary

@export var units_T0_pool : Array[Resource]
@export var units_T1_pool : Array[Resource]
@export var units_T2_pool : Array[Resource]
@export var units_T3_pool : Array[Resource]
@export var units_T4_pool : Array[Resource]

@export var upgrades_T1_pool : Array[Resource]
@export var upgrades_T2_pool : Array[Resource]
@export var upgrades_T3_pool : Array[Resource]
@export var upgrades_T4_pool : Array[Resource]

@export var percs_T4_pool : Array[Resource]
@export var percs_T1_pool : Array[Resource]
@export var percs_T2_pool : Array[Resource]
@export var percs_T3_pool : Array[Resource]

@export var hero_reses : Array[Resource]

@export var level_scenes : Array[PackedScene]

@export var save_path : String
