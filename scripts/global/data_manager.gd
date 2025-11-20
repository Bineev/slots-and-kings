extends Node

enum SlotType {
	UPGRADE, UNIT, PERC, ULT
}

enum CarouselType {
	TOP, MID, BOT
}

var slot_size : Vector2 = Vector2(16, 16)

var started_indexes : Vector2 = Vector2(1, 0)

var min_spin_time : float = 2

var max_spin_time : float = 3

var default_spin_speed : float = 0.1
