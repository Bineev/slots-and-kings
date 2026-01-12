extends PanelContainer

class_name MainMenuUI



func _on_play_button_pressed() -> void:
	GameManager.show_lobby()


func _on_continue_button_pressed() -> void:
	pass # Replace with function body.


func _on_options_button_pressed() -> void:
	GameManager.show_options()


func _on_exit_button_pressed() -> void:
	GameManager.exit()
