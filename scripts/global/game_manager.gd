extends Node

@export var main_menu_scene : PackedScene
@export var options_scene : PackedScene

var main_menu_UI : MainMenuUI
var options_UI : OptionsUI
var current_level : Level


func start_game():
	main_menu_UI = main_menu_scene.instantiate()
	main_menu_UI.set_data()
	add_child(main_menu_UI)


func show_options():
	if not options_UI:
		options_UI = options_scene.instantiate()
	get_tree().paused = true
	add_child(options_UI)


func hide_options():
	remove_child(options_UI)
	get_tree().paused = false


func start_level(difficulty_count : int):
	current_level = Player.get_level_by_diff(difficulty_count)
	add_child(current_level)
	if main_menu_UI:
		remove_child(main_menu_UI)


func end_level():
	get_rewards()
	main_menu_UI = main_menu_scene.instantiate()
	main_menu_UI.set_data()
	add_child(main_menu_UI)


func exit():
	queue_free()


func get_rewards():
	pass
