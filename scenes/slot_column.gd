extends Node2D

class_name SlotColumn


@export var slot_type : DataManager.SlotType
@export var deck_scene : PackedScene
@export var spin_curve : Curve

var deck : Deck

@onready var slot_carousel_top: SlotCarousel = %SlotCarouselTop
@onready var slot_carousel_mid: SlotCarousel = %SlotCarouselMid
@onready var slot_carousel_bot: SlotCarousel = %SlotCarouselBot


func _ready() -> void:
	initialize_deck()
	SignalManager.spin_columns.connect(spin_carousels)


func initialize_deck():
	deck = deck_scene.instantiate()
	deck.initialize_slots()
	initialize_carousels()

func initialize_carousels():
	slot_carousel_top.spin_curve = spin_curve
	slot_carousel_mid.spin_curve = spin_curve
	slot_carousel_bot.spin_curve = spin_curve
	slot_carousel_top.initialize(deck.get_copy_slots())
	slot_carousel_mid.initialize(deck.get_copy_slots())
	slot_carousel_bot.initialize(deck.get_copy_slots())


func spin_carousels():
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
