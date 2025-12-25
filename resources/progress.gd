extends Resource

class_name PlayerProgress


@export var family : DataManager.UnitFamily
@export var difficulty : DataManager.DifficultyType

@export var base_units_reses : Array[Resource]
@export var base_upgrades_reses : Array[Resource]
@export var base_percs_reses : Array[Resource]
@export var special_units_reses : Array[Resource]
@export var special_upgrades_reses : Array[Resource]
@export var special_percs_reses : Array[Resource]

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
