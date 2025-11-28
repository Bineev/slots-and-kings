extends CenterContainer

class_name BuildingUI


@export var building_preview_scenes : Array[PackedScene]

@onready var buildings_container: GridContainer = %buildings_container

var building_previews : Array[BuildingPreview]


func _ready() -> void:
	initialize()


func initialize():
	await self.ready
	for building_scene in building_preview_scenes:
		var building = building_scene.instantiate()
		buildings_container.add_child(building)
		building.initialize()
