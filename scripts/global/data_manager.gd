extends Node


var viewport_size = Vector2(960, 540)

enum SlotType {
	UPGRADE, UNIT, PERC, ULT
}

enum CarouselType {
	TOP, MID, BOT
}

enum UnitState {
	IDLE, WALK, ATTACK, HITTED, DIED, DEAD
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
	T1, T2, T3, T4, T5, T6, T7
}

enum UnitOwner {
	PLAYER, ENEMY
}

enum ResType {
	GOLD, FOOD, SPIN_TOKEN, CRYSTAL
}

enum UnitType {
	MELEE, RANGE, PHYS, MAGE, SUPPORT, TANK
}

var slot_size : Vector2 = Vector2(16, 16)

var started_indexes : Vector2 = Vector2(1, 0)

var min_spin_time : float = 1.5

var max_spin_time : float = 3

var default_spin_speed : float = 0.1

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
