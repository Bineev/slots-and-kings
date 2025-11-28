extends CenterContainer

class_name BuildingUI


@export var building_preview_scenes : Array[PackedScene]

@onready var buildings_container: GridContainer = %buildings_container

var building_previews : Array[BuildingPreview]
var is_should_check_input : bool = true

func _ready() -> void:
	initialize()


func _input(event):
	if not is_should_check_input:
		return
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
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


func destroy():
	queue_free()
