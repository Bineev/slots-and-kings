extends PanelContainer

class_name MessageUI


@export var text1 : String
@export var counselor_texture : Texture2D
@export var messages_pack : MessagesPackUI

@onready var label_content: RichTextLabel = %label_content
@onready var counselor_rect: TextureRect = %counselor_rect
@onready var prevmessage_btn: Button = %prevmessage_btn
@onready var nextmessage_btn: Button = %nextmessage_btn
@onready var close_btn: Button = %close_btn


func initialize():
	await get_tree().process_frame
	label_content.text = text1
	counselor_rect.texture = counselor_texture
	var messages_index : int = messages_pack.get_messages_index()
	if messages_index == 0:
		prevmessage_btn.hide()
	if messages_index >= messages_pack.messages_scenes.size() - 1:
		nextmessage_btn.hide()
		close_btn.show()


func _on_prevmessage_btn_pressed() -> void:
	prevmessage_btn.disabled = true
	messages_pack.show_prev_message()


func _on_nextmessage_btn_pressed() -> void:
	nextmessage_btn.disabled = true
	messages_pack.show_next_message()


func _on_close_btn_pressed() -> void:
	close_btn.disabled = true
	messages_pack.hide_messages()
