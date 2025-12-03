extends Node2D

class_name Level


@export var unit_preview_scene : PackedScene

var is_need_def_of_loop : bool
var free_spawners : Array[Spawner]
var unit_preview_UI : UnitPreviewUI
var current_unit : Unit

@onready var player_units: Node2D = %player_units
@onready var spawners: Node2D = %spawners
@onready var ui: CanvasLayer = %UI
@onready var buildings: Node2D = %buildings


func _ready() -> void:
	SignalManager.on_create_player_unit.connect(add_unit_preview)
	SignalManager.on_pop_up_UI.connect(add_UI)
	SignalManager.on_build_building.connect(build_building)
	SignalManager.on_show_choose_UI.connect(add_choose_UI)
	SignalManager.on_add_unit_on_field.connect(add_player_unit)
	SignalManager.on_show_info_res_popup.connect(show_info_res_popup_UI)
	SignalManager.on_open_building_menu.connect(add_building_menu_UI)
	#SignalManager.on_ready_choose_ui.connect(align_popup)
	for spawner in spawners.get_children():
		free_spawners.append(spawner)


func add_player_unit():
	Player.get_res(DataManager.ResType.FOOD, -current_unit.unit_cost)
	current_unit.reparent(player_units)
	current_unit.global_position = get_free_random_spawner().global_position
	current_unit.set_active()


func add_unit_preview(unit : Unit, slots : Array[Slot], owner : DataManager.UnitOwner):
	unit_preview_UI = unit_preview_scene.instantiate()
	ui.add_child(unit_preview_UI)
	unit_preview_UI.set_unit(unit)
	unit_preview_UI.add_unit()
	unit.initialize(slots[0], owner)
	unit_preview_UI.initialize()
	unit_preview_UI.global_position = Vector2(93, 241)
	current_unit = unit
	# может быть баг
	await get_tree().process_frame
	if Player.check_res(current_unit.unit_cost, DataManager.ResType.FOOD):
		SignalManager.on_enough_food.emit()
	else:
		SignalManager.on_not_enough_food.emit()


func get_free_random_spawner():
	var spawner = free_spawners.pick_random()
	spawner.is_filled = true
	free_spawners.erase(spawner)

	return spawner


func add_UI(pop_up_UI : Control):
	ui.add_child(pop_up_UI)
	pop_up_UI.initialize()


func add_building_menu_UI(building : Building, menu_UI : Control):
	ui.add_child(menu_UI)
	menu_UI.initialize()
	menu_UI.global_position = building.global_position
	get_tree().create_timer(0.01).timeout.connect(align_popup.bind(menu_UI))


func add_choose_UI(building : Building, chooseUI : ChooseUI):
	ui.add_child(chooseUI)
	chooseUI.initialize()
	chooseUI.global_position = building.global_position
	get_tree().create_timer(0.01).timeout.connect(align_popup.bind(chooseUI))


func build_building(building_scene : PackedScene, prebuilding : Building):
	var new_building = building_scene.instantiate()
	buildings.add_child(new_building)
	new_building.global_position = prebuilding.global_position
	new_building.initialize()
	buildings.remove_child(prebuilding)
	prebuilding.queue_free()


func align_popup(popup : Control):
	var window = DataManager.viewport_size
	popup.global_position.x = popup.global_position.x - popup.size.x / 2 
	popup.global_position.y = popup.global_position.y - popup.size.y / 2 
	var popup_corrected_x : float = popup.global_position.x
	var popup_corrected_y : float = popup.global_position.y
	if popup_corrected_y < 0:
		popup.global_position.y = 0
	if popup_corrected_y + popup.size.y > window.y:
		popup.global_position.y = window.y - popup.size.y
	if popup_corrected_x < 0:
		popup.global_position.x = 0
	if popup_corrected_x + popup.size.x > window.x:
		popup.global_position.x = window.x - popup.size.x


func get_current_unit():
	return current_unit


func show_info_res_popup_UI(building : Building, info_res_popup_UI : InfoResPopupUI):
	ui.add_child(info_res_popup_UI)
	info_res_popup_UI.global_position = building.global_position - Vector2(16, 16)
	info_res_popup_UI.initialize()
	var tween = get_tree().create_tween()
	tween.set_parallel()
	tween.tween_property(info_res_popup_UI, 'global_position', building.global_position - Vector2(16, 76), 1).set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(info_res_popup_UI, 'modulate', Color8(1, 1, 1, 0.3), 1).set_trans(Tween.TRANS_SPRING)
	tween.tween_property(info_res_popup_UI, 'scale', Vector2(0.5, 0.5), 1).set_trans(Tween.TRANS_SPRING)
	tween.tween_callback(info_res_popup_UI.close_popup).set_delay(1)
