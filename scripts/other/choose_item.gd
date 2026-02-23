extends PanelContainer

class_name ChooseItem

var slot_scene : PackedScene
var slot_res : SlotRes
var slot_type : DataManager.SlotType
var chooseUI : ChooseUI
var building_owner : Building

@onready var label_item_name: Label = %label_item_name
@onready var item_texture: TextureRect = %item_texture
@onready var label_item_desc: Label = %label_item_desc
@onready var choose_button: Button = %choose_button
@onready var label_item_stats: Label = %label_item_stats
@onready var label_open_stats: Label = %label_open_stats


func _ready() -> void:
	SignalManager.on_choice_done.connect(on_choose_done)


func initialize():
	label_item_name.text = tr(slot_res.slot_name)
	var current_locale : String = TranslationServer.get_locale()
	var current_unit_types_table : Dictionary
	if slot_res.slot_type == DataManager.SlotType.UNIT:
		var types : String
		match current_locale:
			'en_US':
				current_unit_types_table = DataManager.unit_types_table_en
			'ru_RU':
				current_unit_types_table = DataManager.unit_types_table
		for item in slot_res.unit_types:
			types += current_unit_types_table[item] + '\n'
		label_item_desc.text = types
	else:
		label_item_desc.text = tr(slot_res.slot_description)
	item_texture.texture = slot_res.slot_sprite
	slot_type = slot_res.slot_type
	if slot_res.slot_type == DataManager.SlotType.UNIT or slot_res.slot_type == DataManager.SlotType.PERC:
		label_item_stats.text = generate_stats()
	else:
		label_item_stats.hide()
		label_open_stats.hide()

#TODO
func generate_stats():
	var unit_stats : String
	var current_locale : String = TranslationServer.get_locale()
	var current_stats_table : Dictionary
	match current_locale:
		'en_US':
			current_stats_table = DataManager.default_stats_to_en
		'ru_RU':
			current_stats_table = DataManager.default_stats_to_rus
	for stat in DataManager.default_stats.keys():
		if stat.contains('scout'):
			continue
		if stat == 'crit_attack' and slot_res.get(stat) == 50:
			continue 
		if DataManager.default_stats[stat] != slot_res.get(stat):
			if stat.contains('hit_chance') and slot_res.get(stat) == 0:
				continue
			if stat.contains('crit_attack') and slot_res.get(stat) == 0:
				continue
			if stat.contains('attack_speed') or stat.contains('mult'):
				unit_stats += ('%s: %.1f\n') % [current_stats_table[stat], slot_res.get(stat)]
			else:
				unit_stats += ('%s: %d\n') % [current_stats_table[stat], slot_res.get(stat)]
	
	return unit_stats


func set_slot_scene(new_slot_scene : PackedScene):
	slot_scene = new_slot_scene


func set_slot_res(new_slot_res : SlotRes):
	slot_res = new_slot_res


func set_choose_UI(new_choose_UI : ChooseUI):
	chooseUI = new_choose_UI


func _on_choose_button_pressed() -> void:
	get_tree().paused = false
	SoundManager.play_ui(self, DataManager.sound_dict[DataManager.SoundType.GET_REWARDS])
	SignalManager.on_choice_done.emit(self)
	SignalManager.on_choose_item.emit(slot_scene, slot_type)
	SignalManager.on_choose_reward_item.emit()
	if slot_res.slot_type == DataManager.SlotType.UNIT and building_owner:
		building_owner.current_unit_slot_name = slot_res.slot_name


func on_choose_done(chooseItem : ChooseItem):
	if chooseItem == self:
		choose_button.disabled = true
		var tween = get_tree().create_tween()
		tween.tween_property(chooseUI, "scale", Vector2.ZERO, 0.3)
		tween.tween_callback(chooseUI.queue_free).set_delay(0.4)


func _on_label_open_stats_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				label_open_stats.hide()
				label_item_stats.show()
				SignalManager.on_align_item.emit(chooseUI)
