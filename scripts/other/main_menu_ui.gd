extends PanelContainer

class_name MainMenuUI


func _ready() -> void:
	GameManager.set_main_menu(self)


func _on_play_button_pressed() -> void:
	Player.clear_after_result()
	Player.initialize()
	GameManager.show_lobby()


func _on_continue_button_pressed() -> void:
	ProgressManager.load_progress_from_file_by_family(Player.current_king)
	Player.clear_after_result()
	GameManager.show_lobby()


func _on_options_button_pressed() -> void:
	GameManager.show_options()


func _on_exit_button_pressed() -> void:
	GameManager.exit()
