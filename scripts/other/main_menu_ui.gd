extends PanelContainer

class_name MainMenuUI


@onready var confirmed_container: VBoxContainer = %confirmed_container
@onready var yes_button: Button = %yes_button
@onready var no_button: Button = %no_button
@onready var play_button: Button = %play_button
@onready var continue_button: Button = %continue_button


func _ready() -> void:
	GameManager.set_main_menu(self)
	initialize()

func initialize():
	await get_tree().process_frame
	if ProgressManager.is_progress_exists():
		continue_button.show()
	else:
		continue_button.hide()


func _on_play_button_pressed() -> void:
	await get_tree().process_frame
	if ProgressManager.is_progress_exists():
		show_confirmed()
	else:
		_on_yes_button_pressed()


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


func _on_yes_button_pressed() -> void:
	SoundManager.play_ui(self, DataManager.sound_dict[DataManager.SoundType.UI])
	#Player.clear_after_result()
	Player.initialize()
	GameManager.show_lobby()


func _on_no_button_pressed() -> void:
	SoundManager.play_ui(self, DataManager.sound_dict[DataManager.SoundType.UI])
	confirmed_container.hide()
	play_button.show()


func show_confirmed():
	play_button.hide()
	confirmed_container.show()
