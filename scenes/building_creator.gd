extends Building

class_name BuildingCreator


@export var entity_pool : Array[PackedScene]
@export var generation_interval : float
@export var choose_UI_scene : PackedScene
@export var choose_count : int

var deck : Deck
var choose_UI : ChooseUI

@onready var generate_timer: Timer = %generate_timer


func _ready() -> void:
	SignalManager.on_entity_choosed.connect(add_choosed_entity)


func initialize(new_deck : Deck):
	await self.ready
	deck = new_deck
	generate_timer.wait_time = generation_interval
	show_choose_UI()


func show_choose_UI():
	choose_UI = choose_UI_scene.instantiate()
	var copy_entity_pool : Array[PackedScene] = entity_pool.duplicate(true)
	choose_UI.initialize(self, UtilsManager.get_random_items(copy_entity_pool, choose_count))
	SignalManager.on_show_choose_UI.emit(choose_UI)


func add_choosed_entity(owner : Building, slot_scene : PackedScene):
	if owner == self:
		var slot : Slot = slot_scene.instantiate()
		deck.append(slot)
	# может быть баг, если во время спина 


func _on_generate_timer_timeout() -> void:
	show_choose_UI()
