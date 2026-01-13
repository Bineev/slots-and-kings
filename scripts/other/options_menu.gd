extends PanelContainer

class_name OptionsMenu


@onready var to_lobby_button: Button = %to_lobby_button


func initialize():
	await get_tree().process_frame
	GameManager.correct_options()


func _on_close_button_pressed() -> void:
	GameManager.hide_options()


func _on_to_lobby_button_pressed() -> void:
	GameManager.show_lobby()


func show_to_lobby_button():
	if to_lobby_button:
		to_lobby_button.visible = true


func hide_to_lobby_button():
	if to_lobby_button:
		to_lobby_button.visible = false
