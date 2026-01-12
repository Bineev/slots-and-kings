extends Building

class_name BuildingCreator
@export var entity_tier : DataManager.EntityTier
@export var entity_pool : Array[PackedScene]
@export var slots_amount : int
@export var generation_interval : float
@export var choose_UI_scene : PackedScene
@export var current_unit_slot_name : String
@export var upgrade_tier_cost : int
@export var current_tier : int = 1

var deck : Deck
var choose_UI : ChooseUI


func initialize():
	super.initialize()
	building_progress_bar.visible = false
	entity_tier = building_res.entity_tier
	slots_amount = building_res.produce_amount
	generation_interval = building_res.produce_interval
	generate_timer.wait_time = generation_interval
	upgrade_tier_cost = building_res.entity_tier * 3
	var tween = get_tree().create_tween()
	tween.tween_callback(show_choose_UI).set_delay(0.5)


func show_choose_UI():
	choose_UI = choose_UI_scene.instantiate()
	var units : Array[PackedScene] = Player.get_random_units(entity_tier, building_res.slots_amount)
	choose_UI.set_choose_scenes(units)
	choose_UI.set_building_owner(self)
	SignalManager.on_show_choose_UI.emit(self, choose_UI)


func _on_generate_timer_timeout() -> void:
	show_choose_UI()


func start_produce():
	generate_timer.start()


func show_ui():
	pop_up_ui = pop_up_ui_scene.instantiate()
	pop_up_ui.set_data(self, upgrade_tier_cost, current_tier)
	SignalManager.on_open_building_menu.emit(self, pop_up_ui)
