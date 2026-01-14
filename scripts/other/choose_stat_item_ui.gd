extends VBoxContainer

class_name ChooseStatItemUI


var stat : String

@onready var label_item_name: Label = %label_item_name
@onready var label_item_desc: Label = %label_item_desc
@onready var choose_button: Button = %choose_button


func initialize():
	await get_tree().process_frame
	SoundManager.play_ui(self, DataManager.sound_dict[DataManager.SoundType.SHOW_REWARDS])
	label_item_name.text = DataManager.hero_stats_to_rus[stat]
	label_item_desc.text = DataManager.hero_stats_desc_dict[stat]


func set_stat(new_stat : String):
	stat = new_stat


func _on_choose_button_pressed() -> void:
	SoundManager.play_ui(self, DataManager.sound_dict[DataManager.SoundType.GET_REWARDS])
	choose_button.disabled = true
	SignalManager.on_choose_stat_done.emit(stat, 1)
