extends Building

class_name BuildingGenerator


@export var entity_tier : DataManager.EntityTier
@export var entity_pool : Array[PackedScene]
@export var slots_amount : int
@export var generation_interval : float
@export var choose_UI_scene : PackedScene

var deck : Deck
var choose_UI : Control

@onready var generate_timer: Timer = %generate_timer


func _ready() -> void:
	SignalManager.on_entity_choosed.connect(add_choosed_entity)
	initialize()

func initialize():
	super.initialize()
	#deck = new_deck
	entity_tier = building_res.entity_tier
	slots_amount = building_res.slots_amount
	generation_interval = building_res.produce_interval
	slots_amount = building_res.produce_amount
	generate_timer.wait_time = generation_interval
	Player.get_random_upgrades(entity_tier, slots_amount)
	#show_choose_UI()


func show_choose_UI():
	choose_UI = choose_UI_scene.instantiate()
	choose_UI.initialize(self, [entity_pool.pick_random(), entity_pool.pick_random(), entity_pool.pick_random()])
	SignalManager.on_show_choose_UI.emit(choose_UI)


func add_choosed_entity(owner : Building, slot_scene : PackedScene):
	if owner == self:
		var slot : Slot = slot_scene.instantiate()
		deck.append(slot)
		generate_timer.start()
	# может быть баг, если во время спина 


func _on_generate_timer_timeout() -> void:
	show_choose_UI()
