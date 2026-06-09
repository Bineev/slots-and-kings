extends Node


var viewport_size = Vector2(960, 540)


enum SlotType {
	UPGRADE, UNIT, PERC, ULT
}

enum UtilType {
	RES, HEALTH, CREATE_UNIT, CREATE_SKILL, CREATE_THING
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

enum UnitPosition {
	DEFAULT, MIDDLECENTER, MIDDLEBOT, MIDDLETOP, ENEMYSIDEMIDDLE, ENEMYSIDEBOT, ENEMYSIDETOP
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
	GOLD, SPIN_TOKEN, FOOD, CRYSTAL, SOULS
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
	ENGINEER, PRIEST, MAGE, SCOUT, COMMANDER, DOMINATOR, LORD, TORTURER
}

enum RewardType {
	EMPTY, UNIT, UPGRADE, PERC, HERO, LEVEL_UP, REMOVER, MARKET, BLACK_MARKET
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
	BASE, UNCOMMON, RARE, EPIC
}

enum SoundType {
	RANGE, MAGE, MELEE, HIT_SELF, HIT_ENEMY, WALK, DIED_SELF, DIED_ENEMNY, UI, START_WAVE, END_WAVE, SLOTS_START, SLOTS_END, CREATE_UNIT, SHOW_REWARDS, GET_REWARDS, SWAP, CASTLE_HIT, SLOTS_SPIN, MAKE_CHOISE, NICE, HERO
}

enum MetaType {
	GOLD_INC, TOKEN_INC, FOOD_INC, CRYSTAL_INC, GOLD_START, TOKEN_START, FOOD_START, CRYSTAL_START, BASE_HP, BASE_DAMAGE, T1_CREATE_COEFF, T2_CREATE_COEFF, T3_CREATE_COEFF, T4_CREATE_COEFF, SWAP_TIME
}


enum LevelStats {
	UNITS_LOST, UNITS_DESTROYED, PHYS_DAMAGE_COUNT, MAGE_DAMAGE_COUNT, PURE_DAMAGE_COUNT, FORTRESS_HEALTH_LOST, FORTRESS_HEALTH_RESTORED, GOLD_LOST, TOKEN_LOST, FOOD_LOST, CRYSTALLS_LOST, HEROES_DAMAGE_DEALT
}


var default_hero_up_order : Array[HeroUpType] = [HeroUpType.STAT, HeroUpType.PASSIVE, HeroUpType.STAT, HeroUpType.ACTIVE, HeroUpType.STAT, HeroUpType.PASSIVE, HeroUpType.STAT, HeroUpType.ACTIVE, HeroUpType.STAT, HeroUpType.STAT, HeroUpType.STAT, HeroUpType.STAT, HeroUpType.STAT, HeroUpType.STAT, HeroUpType.STAT, HeroUpType.STAT, HeroUpType.STAT, HeroUpType.STAT, HeroUpType.STAT, HeroUpType.STAT, HeroUpType.STAT, HeroUpType.STAT, HeroUpType.STAT]


var default_reward_progression : Array = [
	[RewardType.HERO],
	[RewardType.LEVEL_UP, RewardType.UPGRADE],
	[RewardType.LEVEL_UP, RewardType.UNIT],
	[RewardType.LEVEL_UP, RewardType.PERC],
	[RewardType.LEVEL_UP, RewardType.REMOVER],
	[RewardType.LEVEL_UP, RewardType.UPGRADE],
	[RewardType.HERO, RewardType.LEVEL_UP],
	[RewardType.LEVEL_UP, RewardType.LEVEL_UP],
	[RewardType.LEVEL_UP, RewardType.UPGRADE, RewardType.REMOVER],
	[RewardType.LEVEL_UP, RewardType.UNIT],
	[RewardType.LEVEL_UP, RewardType.PERC],
	[RewardType.LEVEL_UP, RewardType.REMOVER],
	[RewardType.LEVEL_UP, RewardType.UPGRADE],
	[RewardType.HERO, RewardType.LEVEL_UP],
	[RewardType.LEVEL_UP, RewardType.LEVEL_UP, RewardType.LEVEL_UP],
	[RewardType.LEVEL_UP, RewardType.UPGRADE, RewardType.REMOVER],
	[RewardType.LEVEL_UP, RewardType.UNIT],
	[RewardType.LEVEL_UP, RewardType.PERC],
	[RewardType.LEVEL_UP, RewardType.REMOVER],
	[RewardType.LEVEL_UP, RewardType.UPGRADE],
	[RewardType.HERO, RewardType.LEVEL_UP],
	[RewardType.LEVEL_UP, RewardType.LEVEL_UP, RewardType.LEVEL_UP],
	[RewardType.LEVEL_UP, RewardType.UPGRADE, RewardType.REMOVER],
	[RewardType.LEVEL_UP, RewardType.UNIT],
	[RewardType.LEVEL_UP, RewardType.PERC],
	[RewardType.LEVEL_UP, RewardType.REMOVER],
	[RewardType.LEVEL_UP, RewardType.UPGRADE],
	[RewardType.LEVEL_UP, RewardType.LEVEL_UP],
	[RewardType.LEVEL_UP, RewardType.REMOVER],
	[RewardType.LEVEL_UP, RewardType.LEVEL_UP],
	[RewardType.LEVEL_UP, RewardType.LEVEL_UP, RewardType.REMOVER],
	[RewardType.LEVEL_UP, RewardType.UPGRADE],
	[RewardType.LEVEL_UP, RewardType.LEVEL_UP],
	[RewardType.LEVEL_UP, RewardType.REMOVER],
	[RewardType.LEVEL_UP, RewardType.LEVEL_UP],
	[RewardType.LEVEL_UP, RewardType.LEVEL_UP],
	[RewardType.LEVEL_UP, RewardType.PERC, RewardType.REMOVER],
	[RewardType.LEVEL_UP, RewardType.LEVEL_UP],
	[RewardType.LEVEL_UP, RewardType.REMOVER],
	[RewardType.LEVEL_UP, RewardType.LEVEL_UP],
	[RewardType.LEVEL_UP, RewardType.LEVEL_UP],
	[RewardType.LEVEL_UP, RewardType.UPGRADE, RewardType.REMOVER],
	[RewardType.LEVEL_UP, RewardType.LEVEL_UP],
	[RewardType.LEVEL_UP, RewardType.REMOVER],
	[RewardType.LEVEL_UP, RewardType.LEVEL_UP],
	[RewardType.LEVEL_UP, RewardType.LEVEL_UP],
]



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

var unit_types_table_en : Dictionary = {
	UnitType.MELEE : 'MELEE',
	UnitType.RANGE : 'RANGE',
	UnitType.PHYS : 'PHYS',
	UnitType.MAGE : 'MAGE',
	UnitType.SUPPORT : 'SUPPORT',
	UnitType.TANK : 'TANK',
	UnitType.ASSASSIN : 'ASSASSIN',
	UnitType.AOE : 'АОЕ',
}



var default_choose_amount : int = 2

var slot_size : Vector2 = Vector2(16, 16)

var started_indexes : Vector2 = Vector2(1, 0)

var min_spin_time : float = 1.5

var max_spin_time : float = 2.5

var default_spin_speed : float = 0.1

var max_armor : float = 70

var default_evade : float = 50

var gold_drop_default : int = 13

var tokens_drop_chance : float = 0.25

var food_drop_chance : float = 0.2

var crystals_drop_chance : float = 0.03

var T2_transition : int = 7

var T3_transition : int = 13

var T4_transition : int = 20

var default_gold_reward : int = 400

var default_crystal_reward : int = 1

var default_food_reward : int = 6

var default_spin_reward : int = 5

#var action_speed_coeff : float = 1.5
var action_speed_coeff : float = 1.55

var move_speed_coeff : float = 1.2

var min_damage_mult : float = 0.3

var empty_slot_name : String = 'Зеро'

var empty_slot_name_en : String = 'Zero'

var movement_offset_min : float = -0.3

var movement_offset_max : float = 0.3

var upper_fight_limit : float = 160

var bottom_fight_limit : float = 280

var default_damage_to_base : int = 25

var diff_coeff_damage_to_base : float = 0.5

var meta_price_coeff : float = 1.5

var default_souls_inc : int = 10

var max_sounds : int = 40

var sound_delay : int = 50

var default_market_commission : float = 0.1

var market_res_chain : Array[ResType] = [ResType.GOLD, ResType.SPIN_TOKEN, ResType.FOOD, ResType.CRYSTAL]

var default_market_coeffs_dict : Dictionary[ResType, int] = {
	ResType.GOLD : 1,
	ResType.SPIN_TOKEN : 50,
	ResType.FOOD : 100,
	ResType.CRYSTAL : 400
}

	#ResType.GOLD : [1, 50, 100, 300],
	#ResType.SPIN_TOKEN : [0.02, 2, 6],
	#ResType.FOOD : [0.01, 0.5, 1, 3],
	#ResType.CRYSTAL : [0.003, 0.17]

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

	
var data_skill_table_ru : Dictionary = {
	'cd': 'откат',
	'damage' : 'урон',
	'type' : 'тип',
	'heal' : 'лечение',
	'interval' : 'интервал',
	'duration' : 'длительность'
} 
	
var data_skill_table_en : Dictionary = {
	'cd': 'cd',
	'damage' : 'damage',
	'type' : 'type',
	'heal' : 'heal',
	'interval' : 'interval',
	'duration' : 'duration'
} 

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

var max_entity_tier : int = 5

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
	'life_steal' : 'вампиризм',
	'life_steal_mult' : 'вампиризм x',
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

var default_stats_to_en : Dictionary = {
	'health' : 'health',
	'health_mult' : 'health x',
	'armor' : 'armor',
	'armor_mult' : 'armor x',
	'magic_defence' : 'magic defence',
	'magic_defence_mult' : 'magic defence x',
	'physical_attack' : 'phys attack',
	'physical_attack_mult' : 'phys attack x',
	'magical_attack' : 'magic attack',
	'magical_attack_mult' : 'magic attack x',
	'hit_chance' : 'accuracy',
	'hit_chance_mult' : 'accuracy x',
	'crit_chance' : 'critical chance',
	'crit_chance_mult' : 'critical chance x',
	'crit_attack' : 'critical attack',
	'crit_attack_mult' : 'critical attack x',
	'evade' : 'dodge',
	'evade_mult' : 'dodge x',
	'shield' : 'shield',
	'shield_mult' : 'shield x',
	'attack_speed' : 'attack speed',
	'attack_speed_mult' : 'attack speed x',
	'move_speed' : 'movespeed',
	'move_speed_mult' : 'movespeed x',
	'attack_range' : 'range',
	'attack_range_mult' : 'range x',
	'life_steal' : 'lifesteal',
	'life_steal_mult' : 'lifesteal x',
	'health_regen' : 'regen',
	'health_regen_mult' : 'regen x',
	'health_regen_interval' : "regen interval",
	'health_regen_interval_mult' : 'regen interval x',
	'true_damage' : 'pure attack',
	'true_damage_mult' : 'pure attack x',
	'scout_range' : 'detection range',
	'scout_range_mult' : 'detection range x',
	'damage_mult_vs_all' : 'all damage x',
	'damage_mult_vs_castle' : 'damage vs Empire x',
	'damage_mult_vs_hell' : 'damage vs Abyss x',
	'damage_mult_vs_forest' : 'damage vs Bush x',
	'inc_damage_mult_vs_all' : 'damage reduce x',
	'inc_damage_mult_vs_castle' : 'damage reduce vs Empire x',
	'inc_damage_mult_vs_hell' : 'damage reduce vs Abyss x',
	'inc_damage_mult_vs_forest' : 'damage reduce vs Bush x',
	'projectile_speed' : 'projectile speed',
	'projectile_speed_mult' : 'projectile speed x',
	'projectile_attack_range' : 'AOE radius',
	'projectile_attack_range_mult' : 'AOE radius x',
}


var unit_name_ru_to_en : Dictionary = {
	'Крестьянин' : 'Villein',
	'Баллиста' : 'Ballista',
	'Орудийная башня' : 'Cannon tower',
	'Головорез' : 'Cutthroat',
	'Охотник на демонов' : 'Demonhunter',
	'Ополченец' : 'Fyrd',
	'Инквизитор' : 'Inquisitor',
	'Рыцарь' : 'Knight',
	'Жрец солнца' : 'Sun priest',
	'Колдун' : 'Warlock',
	'Лучник' : 'Yeomen',
	'Проклятый' : 'Accursed',
	'Кровосос' : 'Bloodsucker',
	'Чокоатль' : 'Chocoatl',
	'Культист' : 'Cultist',
	'Бес' : 'Fiend',
	'Имп' : 'Imp',
	'Мантикора' : 'Manticore',
	'Субстанция' : 'Substance',
	'Суккуб' : 'Succubus',
}


var hero_stats_to_rus : Dictionary = {
	'power' : 'могущество',
	'quickness' : 'проворство',
	'mastery' : 'мастерство',
	'grace' : 'благородство'
}

var hero_stats_to_en : Dictionary = {
	'power' : 'power',
	'quickness' : 'quickness',
	'mastery' : 'mastery',
	'grace' : 'grace'
}

var sound_dict : Dictionary[SoundType, Resource] = {
	SoundType.RANGE : preload("res://sounds/sword.wav"),
	 SoundType.MAGE : preload("res://sounds/magic.wav"),
	 SoundType.MELEE : preload("res://sounds/melee.wav"),
	 SoundType.HIT_SELF : preload("res://sounds/getting_hit.wav"),
	 SoundType.HIT_ENEMY : preload("res://sounds/getting_hit.wav"),
	 SoundType.WALK : preload("res://sounds/steps.wav"),
	 SoundType.DIED_SELF : preload("res://sounds/died_or_hit.wav"),
	 SoundType.DIED_ENEMNY : preload("res://sounds/melee2.wav"),
	 SoundType.UI : preload("res://sounds/smth.wav"),
	 SoundType.START_WAVE : preload("res://sounds/start_wave2.wav"),
	 SoundType.END_WAVE : preload("res://sounds/slots_end4.wav"),
	 SoundType.SLOTS_START : preload("res://sounds/slots_swap.mp3"),
	 SoundType.SLOTS_END : preload("res://sounds/slots_end9.mp3"),
	 SoundType.CREATE_UNIT : preload("res://sounds/slots_end7.mp3"),
	 SoundType.SHOW_REWARDS : preload("res://sounds/rewards.wav"),
	 SoundType.GET_REWARDS : preload("res://sounds/slots_end4.wav"),
	 SoundType.SWAP : preload("res://sounds/for_slots1.wav"),
	 SoundType.CASTLE_HIT : preload("res://sounds/slots_end.mp3"),
	 SoundType.SLOTS_SPIN : preload("res://sounds/slots_swap.mp3"),
	 SoundType.MAKE_CHOISE : preload("res://sounds/slots_end9.mp3"),
	 SoundType.NICE : preload("res://sounds/slots_end3.wav"),
	 SoundType.HERO : preload("res://sounds/died.wav")
}


var meta_stats_dict : Dictionary[MetaType, float] = {
	MetaType.GOLD_INC : 1,
	MetaType.TOKEN_INC : 1,
	MetaType.FOOD_INC : 1,
	MetaType.CRYSTAL_INC : 1,
	MetaType.GOLD_START : 1,
	MetaType.TOKEN_START : 1,
	MetaType.FOOD_START : 1,
	MetaType.CRYSTAL_START : 1,
	MetaType.BASE_HP : 1,
	MetaType.BASE_DAMAGE : 1,
	MetaType.T1_CREATE_COEFF : 1,
	MetaType.T2_CREATE_COEFF : 1,
	MetaType.T3_CREATE_COEFF : 1,
	MetaType.T4_CREATE_COEFF : 1,
	MetaType.SWAP_TIME : 1,
}


var hero_stats_desc_dict : Dictionary = {
	'power' : 'мощь атакующих умений +\n',
	'quickness' : 'скорость восстановления умений +\n',
	'mastery' : 'размер области +\n',
	'grace' : 'длительность умений +\nсила лечения +\nсила бафов/дебафов +\n'
}

var hero_stats_desc_dict_en : Dictionary = {
	'power' : 'power of attacking skills +\n',
	'quickness' : 'skill cooldown rate +\n',
	'mastery' : 'skill area size +\n',
	'grace' : 'skill duration +\nhealing power +\npower of buffs/debuffs +\n'
}


var hero_classes_table : Dictionary = {
	HeroClass.ENGINEER : 'инженер',
	HeroClass.PRIEST : 'священник',
	HeroClass.MAGE : 'волшебник',
	HeroClass.SCOUT : 'следопыт',
	HeroClass.COMMANDER : 'полководец'
}

var hero_classes_table_en : Dictionary = {
	HeroClass.ENGINEER : 'Engineer',
	HeroClass.PRIEST : 'Priest',
	HeroClass.MAGE : 'Sorcecer',
	HeroClass.SCOUT : 'Scout',
	HeroClass.COMMANDER : 'Commander'
}


var castle_name_table : Dictionary = {
	UnitFamily.CASTLE : 'Империя',
	UnitFamily.HELL : 'Бездна',
	UnitFamily.FOREST : 'Чаща'
}


var castle_name_table_en : Dictionary = {
	UnitFamily.CASTLE : 'Empire',
	UnitFamily.HELL : 'Abyss',
	UnitFamily.FOREST : 'Bush'
}


var unit_type_to_damage_type_table : Dictionary = {
	UnitType.PHYS : 'физический',
	UnitType.MAGE : 'магический',
	UnitType.ASSASSIN : 'чистый'
}


var unit_type_to_damage_type_table_en : Dictionary = {
	UnitType.PHYS : 'phys',
	UnitType.MAGE : 'mage',
	UnitType.ASSASSIN : 'pure'
}


var hero_names_table_en : Dictionary = {
	HeroClass.ENGINEER : ['Henry', 'Norman', 'Eddrick', 'Osmond', 'Turbert', 'Godwin'],
	HeroClass.PRIEST : ['Priest'],
	HeroClass.MAGE : ['Augusta', 'Abra', 'Beatrice', 'Olivia', 'Sigrid'],
	HeroClass.SCOUT : ['Scout'],
	HeroClass.COMMANDER : ['Benedict', 'Ulrich', 'Arthur', 'Bernard', 'Guillaume'],
	HeroClass.DOMINATOR : ['Nisrok', 'Ufir', 'Habaril', 'Xaphan', 'Verdelet'],
	HeroClass.TORTURER : ['Morgana', 'Lilith', 'Empusa', 'Naama', 'Obizut'],
	HeroClass.LORD : ['Flevreti', 'Sargatanas', 'Lucifuge', 'Acheron', 'Andras']
}


var hero_names_table_ru : Dictionary = {
	HeroClass.ENGINEER : ['Генрих', 'Норман', 'Эддрик', 'Осмонд', 'Турберт', 'Годвин'],
	HeroClass.PRIEST : ['Priest'],
	HeroClass.MAGE : ['Августа', 'Абра', 'Беатрис', 'Оливия', 'Сигрид'],
	HeroClass.SCOUT : ['Scout'],
	HeroClass.COMMANDER : ['Бенедикт', 'Ульрих', 'Артур', 'Бернард', 'Гийом'],
	HeroClass.DOMINATOR : ['Нисрок', 'Уфир', 'Хабарил', 'Ксафан', 'Верделет'],
	HeroClass.TORTURER : ['Моргана', 'Лилит', 'Эмпуса', 'Наама', 'Обизут'],
	HeroClass.LORD : ['Флеврети', 'Саргатанас', 'Люцифуг', 'Ахерон', 'Андрас']
}


var reward_action_table_ru : Dictionary = {
	DataManager.RewardType.UNIT : 'Выбор юнита',
	DataManager.RewardType.UPGRADE : 'Выбор улучшения',
	DataManager.RewardType.PERC : 'Выбор перка',
	DataManager.RewardType.HERO : 'Выбор героя',
	DataManager.RewardType.REMOVER : 'Удалить слот',
	DataManager.RewardType.BLACK_MARKET : 'Черный рынок',
	DataManager.RewardType.MARKET : 'Торговец',
	DataManager.RewardType.LEVEL_UP : 'Левел-ап героя'
}


var reward_action_table_en : Dictionary = {
	DataManager.RewardType.UNIT : 'Choosing unit',
	DataManager.RewardType.UPGRADE : 'Choosing upgrade',
	DataManager.RewardType.PERC : 'Choosing perc',
	DataManager.RewardType.HERO : 'Chooisng hero',
	DataManager.RewardType.REMOVER : 'Remove slot',
	DataManager.RewardType.BLACK_MARKET : 'Black market',
	DataManager.RewardType.MARKET : 'Market',
	DataManager.RewardType.LEVEL_UP : 'Level-up hero'
}


var choose_name_table_ru : Dictionary = {
	SlotType.UPGRADE : 'Выберите улучшение для слот-машины',
	SlotType.UNIT : 'Выберите юнита для слот-машины',
	SlotType.PERC : 'Выберите перк для слот-машины'
}


var choose_name_table_en : Dictionary = {
	SlotType.UPGRADE : 'Choose upgrade slot for the roulette',
	SlotType.UNIT : 'Choose unit slot for the roulette',
	SlotType.PERC : 'Choose perc slot for the roulette'
}
