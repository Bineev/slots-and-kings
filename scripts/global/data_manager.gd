extends Node


var viewport_size = Vector2(960, 540)

enum SlotType {
	UPGRADE, UNIT, PERC, ULT
}

enum CarouselType {
	TOP, MID, BOT
}

enum UnitState {
	IDLE, WALK, ATTACK, HITTED, DIED, DEAD, WALK_TO_CASTLE
}

enum UnitFamily {
	CASTLE, HELL, FOREST
}

enum UnitTier {
	T0,
	T1_1, T1_2, T1_3, T1_4,
	T2_1, T2_2, T2_3, T2_4,
	T3_1, T3_2, T3_3, T3_4,
	T4_1, T4_2, T4_3, T4_4,
	T5_1, T5_2, T5_3, T5_4,
	T6_1, T6_2, T6_3, T6_4,
	T7_1, T7_2, T7_3, T7_4,
}

enum EntityTier {
	T0, T1, T2, T3, T4, T5, T6, T7
}

enum UnitOwner {
	PLAYER, ENEMY
}

enum ResType {
	GOLD, FOOD, SPIN_TOKEN, CRYSTAL
}

enum UnitType {
	MELEE, RANGE, PHYS, MAGE, SUPPORT, TANK, ASSASSIN, AOE
}

enum DifficultyType {
	TUTORIAL, LVL1, LVL2, LVL3, LVL4, LVL5, LVL6, LVL7, LVL8, LVL9, LVL10
}

enum TargetSetting {
	CLOSEST, MAX_HP, LOW_HP, CLOSEST_Y
}

enum HeroClass {
	ENGINEER, PRIEST, MAGE, SCOUT, COMMANDER
}

enum RewardType {
	EMPTY, UNIT, UPGRADE, PERC, HERO, REMOVER, MARKET, BLACK_MARKET
}

enum RelateType {
	EQUAL, GREATER, LESSER
}

enum HeroType {
	TYPE1, TYPE2, TYPE3
}

enum HeroGender {
	MALE, FEMALE
}

enum HeroUpType {
	STAT, PASSIVE, ACTIVE
}

enum ActionType {
	DAMAGE, HEAL
}

enum AttackType {
	SINGLE, AOE
}

enum PassiveSkillType {
	RES_BY_WAVE, HEALTH_BY_WAVE, RES_BY_TIME, HEALTH_BY_TIME, UNIT_NAME, UNIT_TYPE
}


enum SkillGrade {
	BASE, RARE, EPIC
}


var default_hero_up_order : Array[HeroUpType] = [HeroUpType.STAT, HeroUpType.PASSIVE, HeroUpType.STAT, HeroUpType.ACTIVE, HeroUpType.STAT, HeroUpType.PASSIVE, HeroUpType.STAT, HeroUpType.ACTIVE, HeroUpType.STAT, HeroUpType.STAT, HeroUpType.STAT, HeroUpType.STAT, HeroUpType.STAT, HeroUpType.STAT, HeroUpType.STAT, HeroUpType.STAT, HeroUpType.STAT, HeroUpType.STAT, HeroUpType.STAT, HeroUpType.STAT, HeroUpType.STAT, HeroUpType.STAT, HeroUpType.STAT]


var unit_types_table : Dictionary = {
	UnitType.MELEE : 'мили',
	UnitType.RANGE : 'ренж',
	UnitType.PHYS : 'физ',
	UnitType.MAGE : 'маг',
	UnitType.SUPPORT : 'саппорт',
	UnitType.TANK : 'танк',
	UnitType.ASSASSIN : 'убийца',
	UnitType.AOE : 'АОЕ',
}

var default_choose_amount : int = 2

var slot_size : Vector2 = Vector2(16, 16)

var started_indexes : Vector2 = Vector2(1, 0)

var min_spin_time : float = 1.5

var max_spin_time : float = 3

var default_spin_speed : float = 0.1

var max_armor : float = 70

var gold_drop_default : int = 10

var tokens_drop_chance : float = 0.2

var food_drop_chance : float = 0.1

var crystals_drop_chance : float = 0.03

var T2_transition : int = 4

var T3_transition : int = 8

var T4_transition : int = 12

var default_gold_reward : int = 300

var default_crystal_reward : int = 1

var default_food_reward : int = 3

#var action_speed_coeff : float = 1.5
var action_speed_coeff : float = 1.5

var move_speed_coeff : float = 1.3

var min_damage_mult : float = 0.3

var empty_slot_name : String = 'Зеро'

var movement_offset_min : float = -0.3

var movement_offset_max : float = 0.3

var upper_fight_limit : float = 160

var bottom_fight_limit : float = 280

var male_names = [
	'Aaron', 'Abraham', 'Adalhelm', 'Agbert', 'Aldrich',
	'Bernard', 'Baldo', 'Bran', 'Benedict', 'Bert',
	'Clement', 'Calvo', 'Charles', 'Crispin', ' Dadmar',
	'Daniel', 'Duncan', 'Darwin', 'Erik', 'Ernest',
	'Engelrich', 'Fabian', 'Francis', 'Frank', 'Frotbald',
	'Gerbert', 'Gustav', 'Grimwin', 'Godric', 'Harold',
	 'Helmwin', 'Hardulf', 'Hildewalde', 'Ingram', 'Ishmael',
	'Jacob', 'Job', 'Joshua', 'Knut', 'Lance', ' Luke', 'Laurence',
	'Macbeth', 'Mark', 'Maga', 'Muhammad', 'Nadalbert', 'Nathan',
	'Noah', 'Ortolf', 'Orm', 'Olaf', 'Octavian', 'Pascal',
	'Patrick', 'Paul', 'Peter', 'Quentin', 'Raphael', 'Reynold',
	'Remy', 'Rufus', 'Reinrich', 'Sigmund', 'Simon', 'Santiago',
	'Tanculf', 'Thorsten', 'Theobald', 'Tiberius', 'Urith',
	'Victor', 'Virgil', 'Volkrich', 'Walrich', 'Geoffrey', 
	'William', 'Warnhard', 
]

# переработать статы исходя из их логики и представления
var default_stats : Dictionary = {
	'physical_attack' : 0,
	'physical_attack_mult' : 1,
	'magical_attack' : 0,
	'magical_attack_mult' : 1,
	'true_damage' : 0,
	'true_damage_mult' : 1,
	'health' : 0,
	'health_mult' : 1,
	'armor' : 0,
	'armor_mult' : 1,
	'magic_defence' : 0,
	'magic_defence_mult' : 1,
	'evade' : 0,
	'evade_mult' : 1,
	'attack_speed' : 0,
	'attack_speed_mult' : 1,
	'hit_chance' : 100,
	'hit_chance_mult' : 1,
	'crit_chance' : 0,
	'crit_chance_mult' : 1,
	'crit_attack' : 50,
	'crit_attack_mult' : 1,
	'life_steal' : 0,
	'life_steal_mult' : 1,
	'health_regen' : 0,
	'health_regen_mult' : 1,
	'health_regen_interval' : INF,
	'health_regen_interval_mult' : 1,
	'shield' : 0,
	'shield_mult' : 1,
	'move_speed' : 0,
	'move_speed_mult' : 1,
	'attack_range' : 0,
	'attack_range_mult' : 1,
	'scout_range' : 0,
	'scout_range_mult' : 1,
	'damage_mult_vs_all' : 1,
	'damage_mult_vs_castle' : 1,
	'damage_mult_vs_hell' : 1,
	'damage_mult_vs_forest' : 1,
	'inc_damage_mult_vs_all' : 1,
	'inc_damage_mult_vs_castle' : 1,
	'inc_damage_mult_vs_hell' : 1,
	'inc_damage_mult_vs_forest' : 1,
	'projectile_speed' : 0,
	'projectile_speed_mult' : 1,
	'projectile_attack_range' : 0,
	'projectile_attack_range_mult' : 1,
}

var max_entity_tier : int = 4

var default_stats_to_rus : Dictionary = {
	'health' : 'здоровье',
	'health_mult' : 'здоровье x ',
	'armor' : 'броня',
	'armor_mult' : 'броня x',
	'magic_defence' : 'маг защита',
	'magic_defence_mult' : 'маг защита x',
	'physical_attack' : 'физ атака',
	'physical_attack_mult' : 'физ атака x',
	'magical_attack' : 'маг атака',
	'magical_attack_mult' : 'маг атака x',
	'hit_chance' : 'точность',
	'hit_chance_mult' : 'точность x',
	'crit_chance' : 'шанс крита',
	'crit_chance_mult' : 'шанс крита x',
	'crit_attack' : 'величина крита',
	'crit_attack_mult' : 'величина крита x',
	'evade' : 'уворот',
	'evade_mult' : 'уворот x',
	'shield' : 'щит',
	'shield_mult' : 'щит x',
	'attack_speed' : 'ск. атаки',
	'attack_speed_mult' : 'ск. атаки x',
	'move_speed' : 'ск. движения',
	'move_speed_mult' : 'ск. движения x',
	'attack_range' : 'дальность атаки',
	'attack_range_mult' : 'дальность атаки x',
	'life_steal' : 'лайфстил',
	'life_steal_mult' : 'лайфстил x',
	'health_regen' : 'регенерация',
	'health_regen_mult' : 'регенерация x',
	'health_regen_interval' : "реген интервал",
	'health_regen_interval_mult' : 'реген интервал x',
	'true_damage' : 'чистая атака',
	'true_damage_mult' : 'чистая атака x',
	'scout_range' : 'дальность обнаружения',
	'scout_range_mult' : 'дальность обнаружения x',
	'damage_mult_vs_all' : 'весь урон x',
	'damage_mult_vs_castle' : 'урон против Империи x',
	'damage_mult_vs_hell' : 'урон против Бездны x',
	'damage_mult_vs_forest' : 'урон против Чащи x',
	'inc_damage_mult_vs_all' : 'снижение всего урона',
	'inc_damage_mult_vs_castle' : 'снижение урона от Империи x',
	'inc_damage_mult_vs_hell' : 'снижение урона от Бездны x',
	'inc_damage_mult_vs_forest' : 'снижение урона от Чащи x',
	'projectile_speed' : 'скорость снаряда',
	'projectile_speed_mult' : 'скорость снаряда x',
	'projectile_attack_range' : 'радиус аое снаряда',
	'projectile_attack_range_mult' : 'радиус аое снаряда x',
}


var hero_stats_to_rus : Dictionary = {
	'power' : 'мощь',
	'quiqness' : 'проворство',
	'mastery' : 'мастерство',
	'grace' : 'благородство'
}

var hero_classes_table : Dictionary = {
	HeroClass.ENGINEER : 'инженер',
	HeroClass.PRIEST : 'священник',
	HeroClass.MAGE : 'волшебник',
	HeroClass.SCOUT : 'следопыт',
	HeroClass.COMMANDER : 'полководец'
}

var unit_type_to_damage_type_table : Dictionary = {
	UnitType.PHYS : 'физический',
	UnitType.MAGE : 'магический',
	UnitType.ASSASSIN : 'чистый'
}
