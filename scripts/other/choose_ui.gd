extends PanelContainer

class_name ChooseUI

@export var choose_item_type : DataManager.SlotType
@export var choose_item_scene : PackedScene

var building_owner : Building
var choose_scenes : Array[PackedScene]
var choose_items : Array[Slot]
var is_should_start_wave : bool

@onready var choose_container: HBoxContainer = %choose_container
@onready var label_header: Label = %label_header


func _ready() -> void:
	SignalManager.on_choice_done.connect(close_choose_UI)


func set_choose_scenes(new_choose_scenes : Array[PackedScene]):
	choose_scenes = new_choose_scenes


func set_building_owner(building : Building):
	building_owner = building


func set_is_should_start_wave(new_is_should_start_wave : bool):
	is_should_start_wave = new_is_should_start_wave


func initialize():
	await get_tree().process_frame
	# здесь баг при установке казарм 2 уровня
	var slot_type : DataManager.SlotType
	for scene in choose_scenes:
		var new_choose_slot : Slot = scene.instantiate()
		var slot_res = new_choose_slot.slot_res # (bug)
		slot_type = slot_res.slot_type
		var choose_item : ChooseItem = choose_item_scene.instantiate()
		choose_container.add_child(choose_item)
		choose_item.set_slot_scene(scene)
		choose_item.set_slot_res(slot_res)
		choose_item.set_choose_UI(self)
		choose_item.building_owner = building_owner
		choose_item.initialize()
	if slot_type == DataManager.SlotType.UPGRADE:
		label_header.text = 'Выберите улучшение для слот-машины'
	elif slot_type == DataManager.SlotType.UNIT:
		label_header.text = 'Выберите юнита для слот-машины'
	elif slot_type == DataManager.SlotType.PERC:
		label_header.text = 'Выберите перк для слот-машины'
	SignalManager.on_ready_choose_ui.emit(self)
	SoundManager.play_ui(self, DataManager.sound_dict[DataManager.SoundType.SHOW_REWARDS])
	get_tree().paused = true


func close_choose_UI(item : ChooseItem):
	if building_owner:
		building_owner.start_produce()
	#if is_should_start_wave:
		#SignalManager.on_new_wave_start.emit()
		
