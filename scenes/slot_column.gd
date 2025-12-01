extends Node2D

class_name SlotColumn


@export var slot_type : DataManager.SlotType
@export var deck_scene : PackedScene
@export var spin_curve : Curve

var deck : Array[PackedScene]
var is_first_spin : bool = true

@onready var slot_carousel_top: SlotCarousel = %SlotCarouselTop
@onready var slot_carousel_mid: SlotCarousel = %SlotCarouselMid
@onready var slot_carousel_bot: SlotCarousel = %SlotCarouselBot


func _ready() -> void:
	SignalManager.spin_columns.connect(spin_carousels)


func initialize_deck():
	clear_deck()
	deck = Player.get_deck_by_slot_type(slot_type)
	deck.shuffle()


func clear_deck():
	deck.clear()


func initialize_carousels():
	slot_carousel_top.spin_curve = spin_curve
	slot_carousel_mid.spin_curve = spin_curve
	slot_carousel_bot.spin_curve = spin_curve
	slot_carousel_top.initialize(deck)
	slot_carousel_mid.initialize(deck)
	slot_carousel_bot.initialize(deck)


func pre_spin():
	initialize_deck()
	initialize_carousels()
	is_first_spin = false


func spin_carousels():
	if not is_first_spin:
		initialize_deck()
		initialize_carousels()
	var new_spin_time : float = get_random_spin_time()
	slot_carousel_top.spin_time = new_spin_time
	slot_carousel_mid.spin_time = new_spin_time
	slot_carousel_bot.spin_time = new_spin_time
	slot_carousel_top.spin()
	slot_carousel_mid.spin()
	slot_carousel_bot.spin()


func stop_carousels():
	slot_carousel_top.stop_spin()
	slot_carousel_mid.stop_spin()
	slot_carousel_bot.stop_spin()


func get_random_spin_time():
	return randf_range(DataManager.min_spin_time, DataManager.max_spin_time)


func get_active_slots():
	var new_slots : Array[Slot]
	var mid_slot : Slot = slot_carousel_mid.get_active_slot()
	var top_slot : Slot = slot_carousel_top.get_active_slot()
	var bot_slot : Slot = slot_carousel_bot.get_active_slot()
	new_slots.append(mid_slot)
	if mid_slot.slot_name == top_slot.slot_name:
		new_slots.append(top_slot)
	if mid_slot.slot_name == bot_slot.slot_name:
		new_slots.append(bot_slot)
	return new_slots


func check_spin_end():
	return slot_carousel_top.is_spin_end and slot_carousel_mid.is_spin_end and slot_carousel_bot.is_spin_end


func set_carousels_spin_start():
	slot_carousel_top.spin_start()
	slot_carousel_mid.spin_start()
	slot_carousel_bot.spin_start()
