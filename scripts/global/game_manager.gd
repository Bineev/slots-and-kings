extends Node2D

@export var main_menu_scene : PackedScene = preload('res://scenes/main_menu_ui.tscn')
@export var options_scene : PackedScene = preload("res://scenes/options.tscn")
@export var lobby_scene : PackedScene = preload("res://scenes/lobby_ui.tscn")

var main_menu_UI : MainMenuUI
var options_UI : OptionsMenu
var current_level : Level
var lobby : LobbyUI


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS


func clear_scene():
	if current_level and current_level.get_parent():
		get_tree().root.remove_child(current_level)
	if main_menu_UI and main_menu_UI.get_parent():
		get_tree().root.remove_child(main_menu_UI)
	if lobby and lobby.get_parent():
		get_tree().root.remove_child(lobby)
	if options_UI and options_UI.get_parent():
		get_tree().root.remove_child(options_UI)



func show_menu():
	#clear_scene()
	if lobby:
		lobby.queue_free()
	if main_menu_UI:
		main_menu_UI.queue_free()
	main_menu_UI = main_menu_scene.instantiate()
	get_tree().root.add_child(main_menu_UI)


func _input(event: InputEvent) -> void:
	if event.is_action_released("options"):
		if options_UI and options_UI.is_opened:
			GameManager.hide_options()
		else:
			GameManager.show_options()


func show_options():
	options_UI = options_scene.instantiate()
	get_tree().paused = true
	#BUG
	if main_menu_UI and is_instance_valid(main_menu_UI):
		main_menu_UI.add_child(options_UI)
	elif lobby and is_instance_valid(lobby):
		lobby.add_child(options_UI)
	elif current_level and is_instance_valid(current_level):
		current_level.add_child(options_UI)
	options_UI.initialize()


func hide_options():
	if options_UI:
		options_UI.queue_free()
		options_UI = null
		get_tree().paused = false


func start_level():
	#clear_scene()
	if lobby:
		lobby.queue_free()
	get_tree().root.add_child(current_level)
	main_menu_UI = null



func end_level():
	get_rewards()
	main_menu_UI = main_menu_scene.instantiate()
	main_menu_UI.set_data()
	get_tree().root.add_child(main_menu_UI)


func exit():
	get_tree().quit()


func get_rewards():
	pass


func show_lobby():
	get_tree().paused = false
	if main_menu_UI:
		main_menu_UI.queue_free()
	if lobby:
		lobby.queue_free()
	if Player.current_runs_count > 0:
		Player.clear_after_result()
	hide_options()
	#clear_scene()
	lobby = lobby_scene.instantiate()
	lobby.set_data(Player.get_level_scenes())
	get_tree().root.add_child(lobby)
	lobby.initialize()


func set_current_level(level : Level):
	current_level = level


func set_main_menu(new_main_menu_UI):
	main_menu_UI = new_main_menu_UI


func correct_options():
	if main_menu_UI or lobby:
		options_UI.hide_to_lobby_button()


func win():
	Player.current_runs_count += 1
	Player.current_progress.current_runs_count = Player.current_runs_count
	Player.current_progress.current_souls_count = Player.current_souls
	Player.add_rewards_to_progress(current_level.rewards)
	Player.add_level_as_done(current_level.difficulty_count)
	#current_level.show_win_label()
	current_level.is_result = true
	ProgressManager.save_progress_by_family(Player.current_king)


func loose():
	Player.current_runs_count += 1
	Player.current_progress.current_runs_count = Player.current_runs_count
	Player.current_progress.current_souls_count = Player.current_souls
	#current_level.show_loose_label()
	current_level.is_result = true
	ProgressManager.save_progress_by_family(Player.current_king)


func stop_all():
	get_tree().paused = true


func remove_current_level():
	if current_level:
		current_level.queue_free()
		current_level = null


func show_end_level():
	pass
