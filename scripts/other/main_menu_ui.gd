extends PanelContainer

class_name MainMenuUI


func _ready() -> void:
	GameManager.set_main_menu(self)


func _on_play_button_pressed() -> void:
	SoundManager.play_ui(self, DataManager.sound_dict[DataManager.SoundType.UI])
	Player.clear_after_result()
	Player.initialize()
	GameManager.show_lobby()


func _on_continue_button_pressed() -> void:
	SoundManager.play_ui(self, DataManager.sound_dict[DataManager.SoundType.UI])
	Player.initialize_with_data()
	GameManager.show_lobby()


func _on_options_button_pressed() -> void:
	SoundManager.play_ui(self, DataManager.sound_dict[DataManager.SoundType.UI])
	GameManager.show_options()


func _on_exit_button_pressed() -> void:
	SoundManager.play_ui(self, DataManager.sound_dict[DataManager.SoundType.UI])
	GameManager.exit()
