extends Area2D

class_name Building

@export var building_res : BuildingRes
@export var building_name : String
@export var building_desc : String
@export var building_cost : int
@export var pop_up_ui_scene : PackedScene

var pop_up_ui : Control

@onready var building_sprite: AnimatedSprite2D = %building_sprite
@onready var building_progress_bar: ProgressBar = %building_progress_bar
@onready var generate_timer: Timer = %generate_timer


func initialize():
	await get_tree().process_frame
	building_name = building_res.building_name
	building_desc = building_res.building_desc
	building_cost = building_res.building_cost
	building_sprite.sprite_frames = SpriteFrames.new()
	building_sprite.sprite_frames.add_frame('default', building_res.building_sprite)
	building_progress_bar.max_value = building_res.produce_interval


func _process(delta: float) -> void:
	update_progress_bar()


func update_progress_bar():
	building_progress_bar.value = building_res.produce_interval - generate_timer.time_left


func show_ui():
	pass


func close_ui():
	pass


func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT: # Check for left click
			show_ui()
