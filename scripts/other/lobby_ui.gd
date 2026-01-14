extends PanelContainer

class_name LobbyUI


@export var level_item_scene : PackedScene
@export var stylebox_tooltip : StyleBox = preload("res://styles/panel_gold.tres")
@export var font_tooltip : Font = preload("res://fonts/DigitalPixelV124-Regular.otf")

var level_scenes : Array[PackedScene]
var levels : Array[Level]

@onready var label_castle_name: Label = %label_castle_name
@onready var levels_container: HBoxContainer = %levels_container
@onready var label_level_name: Label = %label_level_name
@onready var label_level_desc: Label = %label_level_desc
@onready var rewards_container: HBoxContainer = %rewards_container
@onready var start_button: Button = %start_button


func initialize():
	await get_tree().process_frame
	label_castle_name.text = Player.get_castle_name()
	for scene in level_scenes:
		# создать левел итем, при нажатии на который будет меняться представление
		var level : Level = scene.instantiate()
		var level_item : LevelItem = level_item_scene.instantiate()
		level_item.set_data(level, self)
		levels_container.add_child(level_item)
		level_item.initialize()


func set_data(new_level_scenes : Array[PackedScene]):
	level_scenes = new_level_scenes


func change_level_data(level_name : String, level_desc : String):
	label_level_name.text = level_name
	label_level_desc.text = level_desc


func _on_start_button_pressed() -> void:
	SoundManager.play_ui(self, DataManager.sound_dict[DataManager.SoundType.END_WAVE])
	GameManager.start_level()


func _on_back_to_menu_button_pressed() -> void:
	SoundManager.play_ui(self, DataManager.sound_dict[DataManager.SoundType.UI])
	GameManager.show_menu()


func add_rewards(slot_scenes : Array[PackedScene]):
	for reward in rewards_container.get_children():
		rewards_container.remove_child(reward)
	for scene in slot_scenes:
		var slot : Slot = scene.instantiate()
		#slot.initialize()
		var texture_rect : TextureRect = TextureRect.new()
		texture_rect.texture = slot.slot_res.slot_sprite
		texture_rect.tooltip_text = slot.slot_res.slot_name
		var theme = Theme.new()
		theme.set_stylebox('panel', 'TooltipPanel', stylebox_tooltip)
		theme.set_font('font', 'TooltipLabel', font_tooltip)
		theme.set_font_size('font_size', 'TooltipLabel', 8)
		theme.set_color('font_color', 'TooltipLabel', Color8(52, 28, 39, 255))
		texture_rect.theme = theme
		rewards_container.add_child(texture_rect)


func show_start_button():
	start_button.visible = true
