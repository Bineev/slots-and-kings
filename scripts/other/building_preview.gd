extends VBoxContainer

class_name BuildingPreview


@export var building_scene : PackedScene
@export var building_res : BuildingRes
@export var building_name : String
@export var building_desc : String
@export var building_cost : int

var is_should_check_input : bool = true

@onready var label_building_name: Label = %label_building_name
@onready var building_texture: TextureRect = %building_texture
@onready var label_building_desc: Label = %label_building_desc
@onready var buy_button: Button = %buy_button


func _ready() -> void:
	initialize()


func initialize():
	await self.ready
	building_name = building_res.building_name
	building_desc = building_res.building_desc
	building_cost = building_res.building_cost
	#building_scene = building_res.building_scene
	label_building_name.text = building_name
	label_building_desc.text = building_desc
	building_texture.texture = building_res.building_sprite
	buy_button.text = str(building_cost)


func choose_building():
	SignalManager.on_choose_building.emit(building_scene)


func _on_buy_button_pressed() -> void:
	choose_building()
