extends Area2D

class_name Building

@export var building_res : BuildingRes
@export var building_name : String
@export var building_desc : String
@export var building_cost : int
@export var pop_up_ui_scene : PackedScene

var pop_up_ui : Control

@onready var building_sprite: AnimatedSprite2D = %building_sprite


func _ready() -> void:
	initialize()

func initialize():
	await self.ready
	building_name = building_res.building_name
	building_desc = building_res.building_desc
	building_cost = building_res.building_cost
	building_sprite.sprite_frames = SpriteFrames.new()
	building_sprite.sprite_frames.add_frame('default', building_res.building_sprite)


func show_ui():
	pass


func close_ui():
	pass


func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT: # Check for left click
			show_ui()
