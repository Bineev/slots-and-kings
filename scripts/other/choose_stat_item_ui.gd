extends VBoxContainer

class_name ChooseStatItemUI


var stat : String

@onready var label_item_name: Label = %label_item_name
@onready var label_item_desc: Label = %label_item_desc
@onready var choose_button: Button = %choose_button


func initialize():
	await get_tree().process_frame
	SoundManager.play_ui(self, DataManager.sound_dict[DataManager.SoundType.SHOW_REWARDS])
	var current_locale : String = TranslationServer.get_locale()
	var current_hero_stats_table : Dictionary
	var current_hero_stats_desc_table : Dictionary
	match current_locale:
		'en_US':
			current_hero_stats_table = DataManager.hero_stats_to_en
			current_hero_stats_desc_table = DataManager.hero_stats_desc_dict_en
		'ru_RU':
			current_hero_stats_table = DataManager.hero_stats_to_rus
			current_hero_stats_desc_table = DataManager.hero_stats_desc_dict
	label_item_name.text = current_hero_stats_table[stat]
	label_item_desc.text = current_hero_stats_desc_table[stat]


func set_stat(new_stat : String):
	stat = new_stat


func _on_choose_button_pressed() -> void:
	SoundManager.play_ui(self, DataManager.sound_dict[DataManager.SoundType.GET_REWARDS])
	choose_button.disabled = true
	SignalManager.on_choose_stat_done.emit(stat, 1)
	SignalManager.on_choose_reward_item.emit()
