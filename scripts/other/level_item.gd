extends PanelContainer

class_name LevelItem


@export var level_difficulty : int
@export var level_name : String
@export var level_desc : String
@export var lobby : LobbyUI
@export var level : Level
@export var rewards : Array[Resource]
@export var stylebox_active : StyleBoxFlat = preload("res://styles/panel_blue.tres")
@export var stylebox_done : StyleBoxFlat = preload("res://styles/panel_green.tres")
@export var stylebox_undone : StyleBoxFlat = preload("res://styles/panel_red.tres")

var is_checked : bool

@onready var label_reward_info: Label = %label_reward_info


func _ready() -> void:
	SignalManager.on_level_click.connect(uncheck)


func initialize():
	await get_tree().process_frame
	label_reward_info.text = str(level_difficulty)
	if Player.check_is_level_done(level_difficulty):
		add_theme_stylebox_override('panel', stylebox_done)
	else:
		add_theme_stylebox_override('panel', stylebox_undone)


func set_data(new_level : Level, new_lobby : LobbyUI):
	level = new_level
	level_difficulty = level.difficulty_count
	level_name = tr(level.level_name)
	level_desc = tr(level.level_desc)
	lobby = new_lobby
	rewards = level.rewards

func _on_gui_input(event: InputEvent) -> void:
	if is_checked:
		return
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			SoundManager.play_ui(self, DataManager.sound_dict[DataManager.SoundType.UI])
			is_checked = true
			lobby.change_level_data(level_name, level_desc)
			generate_rewards()
			GameManager.set_current_level(level)
			add_theme_stylebox_override('panel', stylebox_active)
			lobby.show_start_button()
			SignalManager.on_level_click.emit(self)


func uncheck(level_item : LevelItem):
	if level_item != self:
		is_checked = false
		if Player.check_is_level_done(level_difficulty):
			add_theme_stylebox_override('panel', stylebox_done)
		else:
			add_theme_stylebox_override('panel', stylebox_undone)


func generate_rewards():
	var reward_slot_scenes : Array[PackedScene]
	for reward in rewards:
		var slot_scene : PackedScene = Player.create_slot_scene(reward)
		reward_slot_scenes.append(slot_scene)
	lobby.add_rewards(reward_slot_scenes)
