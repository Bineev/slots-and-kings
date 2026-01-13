extends Node2D

@export var main_menu_scene : PackedScene = preload('res://scenes/main_menu_ui.tscn')
@export var options_scene : PackedScene = preload("res://scenes/options_ui.tscn")
@export var lobby_scene : PackedScene = preload("res://scenes/lobby_ui.tscn")

var main_menu_UI : MainMenuUI
var options_UI : Control
var current_level : Level
var lobby : LobbyUI


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
	clear_scene()
	if not main_menu_UI:
		main_menu_UI = main_menu_scene.instantiate()
	get_tree().root.add_child(main_menu_UI)


func show_options():
	if not options_UI:
		options_UI = options_scene.instantiate()
	get_tree().paused = true
	get_tree().root.add_child(options_UI)


func hide_options():
	get_tree().root.remove_child(options_UI)
	get_tree().paused = false


func start_level():
	clear_scene()
	get_tree().root.add_child(current_level)



func end_level():
	get_rewards()
	main_menu_UI = main_menu_scene.instantiate()
	main_menu_UI.set_data()
	get_tree().root.add_child(main_menu_UI)


func exit():
	queue_free()


func get_rewards():
	pass


func show_lobby():
	clear_scene()
	lobby = lobby_scene.instantiate()
	lobby.set_data(Player.get_level_scenes())
	get_tree().root.add_child(lobby)
	lobby.initialize()


func set_current_level(level : Level):
	current_level = level
