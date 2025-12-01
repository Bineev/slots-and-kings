extends PanelContainer

class_name ChooseUI


@export var choose_item_scene : PackedScene

var building_owner : Building
var choose_scenes : Array[PackedScene]
var choose_items : Array[Slot]

@onready var choose_container: HBoxContainer = %choose_container


func _ready() -> void:
	SignalManager.on_choice_done.connect(close_choose_UI)


func set_choose_scenes(new_choose_scenes : Array[PackedScene]):
	choose_scenes = new_choose_scenes


func set_building_owner(building : Building):
	building_owner = building


func initialize():
	await get_tree().process_frame
	for scene in choose_scenes:
		var new_choose_slot : Slot = scene.instantiate()
		var slot_res = new_choose_slot.slot_res # (bug)
		var choose_item : ChooseItem = choose_item_scene.instantiate()
		choose_container.add_child(choose_item)
		choose_item.set_slot_scene(scene)
		choose_item.set_slot_res(slot_res)
		choose_item.set_choose_UI(self)
		choose_item.initialize()


func close_choose_UI(item : ChooseItem):
	building_owner.start_produce()
