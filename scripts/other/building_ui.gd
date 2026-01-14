extends PanelContainer

class_name BuildingUI


@export var building_preview_scenes : Array[PackedScene]

@onready var buildings_container: GridContainer = %buildings_container
@onready var label_gold: Label = %label_gold

var building_previews : Array[BuildingPreview]
var is_should_check_input : bool = true
var prebuilding : Building

func _ready() -> void:
	initialize()
	SignalManager.on_choose_building.connect(choose_building)


func _input(event):
	if not is_should_check_input:
		return
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
			get_tree().paused = false
			visible = false
			is_should_check_input = false
			var tween = get_tree().create_tween()
			tween.tween_callback(destroy).set_delay(0.5)


func initialize():
	await self.ready
	for building_scene in building_preview_scenes:
		var building = building_scene.instantiate()
		buildings_container.add_child(building)
		building.initialize()
	update_gold()
	get_tree().paused = true
	SoundManager.play_ui(self, DataManager.sound_dict[DataManager.SoundType.UI])


func destroy():
	queue_free()


func choose_building(building_scene : PackedScene):
	get_tree().paused = false
	SignalManager.on_build_building.emit(building_scene, prebuilding)
	visible = false
	var tween = get_tree().create_tween()
	tween.tween_callback(destroy).set_delay(0.5)


func update_gold():
	label_gold.text = str(Player.get_gold())
