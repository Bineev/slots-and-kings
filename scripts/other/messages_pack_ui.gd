extends Control

class_name MessagesPackUI


@export var messages_scenes : Array[PackedScene]
@export var messages_index : int = -1
@export var current_message : MessageUI

@onready var showtuts_btn: Button = %showtuts_btn


func _ready() -> void:
	SignalManager.on_message_pack_next.connect(show_next_message)
	initialize()


func initialize():
	await get_tree().process_frame
	show_next_message()


func show_next_message():
	if current_message:
		remove_child(current_message)
	messages_index += 1
	if messages_index >= messages_scenes.size():
		return
	current_message = messages_scenes[messages_index].instantiate()
	current_message.messages_pack = self
	add_child(current_message)
	current_message.initialize()


func show_prev_message():
	if messages_index < 1:
		return
	if current_message:
		remove_child(current_message)
	messages_index -= 1
	current_message = messages_scenes[messages_index].instantiate()
	current_message.messages_pack = self
	add_child(current_message)
	current_message.initialize()


func show_current_message():
	if messages_index > messages_scenes.size() - 1:
		return
	current_message = messages_scenes[messages_index].instantiate()
	current_message.messages_pack = self
	add_child(current_message)
	current_message.initialize()


func get_messages_index():
	return messages_index


func _on_showtuts_btn_pressed() -> void:
	show_current_message()
	showtuts_btn.hide()


func hide_messages():
	if current_message:
		remove_child(current_message)
		current_message = null
	showtuts_btn.show()
