extends Building

class_name BuildingGenerator


@export var entity_tier : DataManager.EntityTier
@export var entity_pool : Array[PackedScene]
@export var slots_amount : int
@export var generation_interval : float
@export var choose_UI_scene : PackedScene

var deck : Deck
var choose_UI : ChooseUI


func initialize():
	super.initialize()
	entity_tier = building_res.entity_tier
	generation_interval = building_res.produce_interval
	slots_amount = building_res.produce_amount
	generate_timer.wait_time = generation_interval
	var tween = get_tree().create_tween()
	tween.tween_callback(show_choose_UI).set_delay(0.5)


func show_choose_UI():
	choose_UI = choose_UI_scene.instantiate()
	var upgrades : Array[PackedScene] = Player.get_random_upgrades(entity_tier, building_res.slots_amount)
	choose_UI.set_choose_scenes(upgrades)
	choose_UI.set_building_owner(self)
	SignalManager.on_show_choose_UI.emit(self, choose_UI)


func _on_generate_timer_timeout() -> void:
	show_choose_UI()


func start_produce():
	generate_timer.start()
