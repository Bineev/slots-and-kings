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
