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
	MELEE, RANGE, PHYS, MAGE, SUPPORT, TANK, ASSASSIN
}

enum TargetSetting {
	CLOSEST, MAX_HP, LOW_HP
}

enum HeroClass {
	ENGINEER, PRIEST, MAGE, SCOUT, KNIGHT
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

var default_hero_up_order : Array[HeroUpType] = [HeroUpType.STAT, HeroUpType.PASSIVE, HeroUpType.STAT, HeroUpType.ACTIVE, HeroUpType.STAT, HeroUpType.PASSIVE, HeroUpType.STAT, HeroUpType.ACTIVE, HeroUpType.STAT, HeroUpType.STAT, HeroUpType.STAT, HeroUpType.STAT, HeroUpType.STAT, HeroUpType.STAT, HeroUpType.STAT, HeroUpType.STAT, HeroUpType.STAT, HeroUpType.STAT, HeroUpType.STAT, HeroUpType.STAT, HeroUpType.STAT, HeroUpType.STAT, HeroUpType.STAT]


var unit_types_table : Dictionary = {
	UnitType.MELEE : 'мили',
	UnitType.RANGE : 'ренж',
	UnitType.PHYS : 'физ',
	UnitType.MAGE : 'маг',
	UnitType.SUPPORT : 'саппорт',
	UnitType.TANK : 'танк',
	UnitType.ASSASSIN : 'убийца'
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

var min_damage_mult : float = 0.3

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
	'health' : 0,
	'health_mult' : 1,
	'armor' : 0,
	'armor_mult' : 1,
	'magic_defence' : 0,
	'magic_defence_mult' : 1,
	'physical_attack' : 0,
	'physical_attack_mult' : 1,
	'magical_attack' : 0,
	'magical_attack_mult' : 1,
	'hit_chance' : 100,
	'hit_chance_mult' : 1,
	'crit_chance' : 0,
	'crit_chance_mult' : 1,
	'crit_attack' : 50,
	'crit_attack_mult' : 1,
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
	'true_damage_mult' : 1,
	'scout_range' : 0,
	'scout_range_mult' : 1,
	'damage_mult_vs_all' : 1,
	'damage_mult_vs_castle' : 1,
	'damage_mult_vs_hell' : 1,
	'damage_mult_vs_forest' : 1,
	'inc_damage_mult_vs_all' : 1,
	'inc_damage_mult_vs_castle' : 1,
	'inc_damage_mult_vs_hell' : 1,
	'inc_damage_mult_vs_forest' : 1
}

var max_entity_tier : int = 4

var default_stats_to_rus : Dictionary = {
	'health' : 'здоровье',
	'health_mult' : 1,
	'armor' : 'броня',
	'armor_mult' : 1,
	'magic_defence' : 'маг защита',
	'magic_defence_mult' : 1,
	'physical_attack' : 'физ атака',
	'physical_attack_mult' : 1,
	'magical_attack' : 'маг атака',
	'magical_attack_mult' : 1,
	'hit_chance' : 'точность',
	'hit_chance_mult' : 1,
	'crit_chance' : 'шанс крита',
	'crit_chance_mult' : 1,
	'crit_attack' : 'величина крита',
	'crit_attack_mult' : 1,
	'evade' : 'уворот',
	'evade_mult' : 1,
	'shield' : 'щит',
	'shield_mult' : 1,
	'attack_speed' : 'ск. атаки',
	'attack_speed_mult' : 1,
	'move_speed' : 'ск. движения',
	'move_speed_mult' : 1,
	'attack_range' : 'дальность атаки',
	'attack_range_mult' : 1,
	'life_steal' : 'лайфстил',
	'life_steal_mult' : 1,
	'health_regen' : 'регенерация',
	'health_regen_mult' : 1,
	'health_regen_interval' : "реген интервал",
	'health_regen_interval_mult' : 1,
	'true_damage' : 'чистая атака',
	'true_damage_mult' : 1,
	'scout_range' : 'дальность обнаружения',
	'scout_range_mult' : 1,
	'damage_mult_vs_all' : 'повышение урона',
	'damage_mult_vs_castle' : 'повышение урона против Замка',
	'damage_mult_vs_hell' : 'повышшение урона против Преисподней',
	'damage_mult_vs_forest' : 'повышение урона против Леса',
	'inc_damage_mult_vs_all' : 'снижение урона',
	'inc_damage_mult_vs_castle' : 'снижение урона от Замка',
	'inc_damage_mult_vs_hell' : 'снижение урона от Преисподней',
	'inc_damage_mult_vs_forest' : 'снижение урона от Леса'
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
	HeroClass.KNIGHT : 'полководец'
}

var unit_type_to_damage_type_table : Dictionary = {
	UnitType.PHYS : 'физический',
	UnitType.MAGE : 'магический',
	UnitType.ASSASSIN : 'чистый'
}
