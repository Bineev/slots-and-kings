extends PanelContainer

class_name ChooseHeroUI


@export var heroes : Array[Hero]
@export var choose_item_hero_scene : PackedScene
@export var heroes_level : int
@export var heroes_count : int

@onready var heroes_container: HBoxContainer = %heroes_container


func _ready() -> void:
	SignalManager.on_hero_choose_done.connect(after_choice_done)


func initialize():
	await get_tree().process_frame
	
	for hero in heroes:
		hero.is_active = false
		var choose_item_hero : ChooseItemHero = choose_item_hero_scene.instantiate()
		choose_item_hero.set_hero(hero)
		heroes_container.add_child(choose_item_hero)
		choose_item_hero.initialize()
	SoundManager.play_ui(self, DataManager.sound_dict[DataManager.SoundType.GET_REWARDS])


func after_choice_done(new_hero : Hero):
	visible = false
	#SignalManager.on_new_wave_start.emit()
	var tween : Tween = get_tree().create_tween()
	tween.tween_callback(queue_free).set_delay(1)


func set_heroes(new_heroes : Array[Hero]):
	heroes = new_heroes


func set_heroes_level(new_heroes_level : int):
	heroes_level = new_heroes_level


func set_heroes_count(new_heroes_count : int):
	heroes_count = new_heroes_count
