extends Building

class_name BuildingGenerator


@export var entity_pool : Array[PackedScene]
@export var generation_interval : float
@export var choose_UI_scene : PackedScene

var deck : Deck
var choose_UI : ChooseUI

@onready var generate_timer: Timer = %generate_timer


func _ready() -> void:
	SignalManager.on_entity_choosed.connect(add_choosed_entity)


func initialize():
	await self.ready
	#deck = new_deck
	generate_timer.wait_time = generation_interval
	show_choose_UI()


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
