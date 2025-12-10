extends Node2D

class_name Level


@export var unit_preview_scene : PackedScene
@export var waves_scenes : Array[PackedScene]
@export var first_wave_timer : float
@export var wave_rewards : Array[DataManager.RewardType]
@export var wave_reward_UI_scene : PackedScene

var is_need_def_of_loop : bool
var free_spawners : Array[Spawner]
var free_enemy_spawners : Array[Spawner]
var unit_preview_UI : UnitPreviewUI
var current_unit : Unit
var is_wave_in_progress : bool
var next_wave : Wave
var wave_reward_UI : RewardAfterWaveUI
var free_fight_points : Array[FightPoint]
var current_tooltip : Control

@onready var player_units: Node2D = %player_units
@onready var spawners: Node2D = %spawners
@onready var enemy_spawners: Node2D = %enemy_spawners
@onready var ui: CanvasLayer = %UI
@onready var buildings: Node2D = %buildings
@onready var enemy_units: Node2D = %enemy_units
@onready var timer_to_next_wave: Timer = %timer_to_next_wave
@onready var waves: Node2D = %waves
@onready var spawns: Node2D = %spawns
@onready var timer_between_check_enemies: Timer = %timer_between_check_enemies
@onready var castle_fight_points: Node2D = %castle_fight_points
@onready var hp_bar: ProgressBar = %hp_bar
@onready var label_hp_bar: Label = %label_hp_bar
@onready var slot_machine: SlotMachine = %SlotMachine
@onready var next_wave_ui: NextWaveUI = %NextWaveUI
@onready var panel_in_fight: PanelContainer = %panel_in_fight


func _ready() -> void:
	SignalManager.on_create_unit.connect(add_unit_preview)
	SignalManager.on_pop_up_UI.connect(add_UI)
	SignalManager.on_build_building.connect(build_building)
	SignalManager.on_show_choose_UI.connect(add_choose_UI)
	SignalManager.on_add_unit_on_field.connect(add_player_unit)
	SignalManager.on_show_info_res_popup.connect(show_info_res_popup_UI)
	SignalManager.on_open_building_menu.connect(add_building_menu_UI)
	SignalManager.on_create_enemy_unit.connect(add_enemy_unit)
	SignalManager.on_start_spawn.connect(clear_enemy_spawns)
	SignalManager.on_end_wave.connect(start_check_is_enemies_remaining)
	SignalManager.on_show_choose_UI_after_wave.connect(add_choose_UI_in_center)
	SignalManager.on_new_wave_start.connect(start_next_wave_countdown)
	SignalManager.on_wave_done.connect(show_reward)
	SignalManager.on_wave_done.connect(clear_fight_points)
	SignalManager.on_player_get_hit.connect(update_hp_bar)
	SignalManager.on_drop_res_popup.connect(show_res_popup_after_unit_dead)
	SignalManager.on_show_damage.connect(show_damage_ui)
	SignalManager.on_show_tooltip.connect(add_tooltip)
	SignalManager.on_hide_tooltip.connect(remove_tooltip)
	#SignalManager.on_ready_choose_ui.connect(align_popup)
	for spawner in spawners.get_children():
		free_spawners.append(spawner)
	for spawner in enemy_spawners.get_children():
		free_enemy_spawners.append(spawner)
	for point in castle_fight_points.get_children():
		free_fight_points.append(point)
	Player.set_wave_rewards(wave_rewards)
	start_waves()


func start_waves():
	await self.ready
	initialize_hp_bar()
	next_wave_ui.set_timer(timer_to_next_wave)
	start_next_wave_countdown()
	# установить false когда последний спавн и врагов на карте не осталось


func add_player_unit():
	for i in range(Player.get_units_count_for_next_create()):
		if Player.check_res(current_unit.unit_cost, DataManager.ResType.FOOD):
			Player.get_res(DataManager.ResType.FOOD, -current_unit.unit_cost)
			create_unit_from_scratch()
	current_unit = null


func add_enemy_unit(unit : Unit, slots : Array[Slot], owner : DataManager.UnitOwner):
	enemy_units.add_child(unit)
	unit.initialize(slots[0], owner)
	unit.global_position = get_free_random_enemy_spawner().global_position
	unit.set_active()
	Player.add_unit_to_enemy_units(unit)
	unit.is_in_fight = true
	unit.fight_point = get_free_random_fight_point()


func add_unit_preview(unit : Unit, slots : Array[Slot], owner : DataManager.UnitOwner):
	unit_preview_UI = unit_preview_scene.instantiate()
	ui.add_child(unit_preview_UI)
	unit_preview_UI.set_unit(unit)
	unit_preview_UI.add_unit()
	unit.initialize(slots[0], owner)
	unit_preview_UI.initialize()
	unit_preview_UI.global_position = Vector2(57, 262)
	current_unit = unit
	# может быть баг
	await get_tree().process_frame
	if Player.check_res(current_unit.unit_cost, DataManager.ResType.FOOD):
		SignalManager.on_enough_food.emit()
	else:
		SignalManager.on_not_enough_food.emit()


func create_unit_from_scratch():
	var factory = slot_machine.get_factory()
	var unit : Unit = factory.get_unit(current_unit.slots)
	player_units.add_child(unit)
	unit.initialize(current_unit.slots[0], DataManager.UnitOwner.PLAYER)
	unit.fight_point = get_free_random_spawner()
	unit.global_position = unit.fight_point.global_position
	unit.set_active()
	Player.add_unit_to_player_units(unit)
	if Player.check_enemies(DataManager.UnitOwner.PLAYER):
		unit.is_in_fight = true


func get_free_random_spawner():
	if free_spawners.size() == 0:
		clear_player_spawns()
	var spawner = free_spawners.pick_random()
	spawner.is_filled = true
	free_spawners.erase(spawner)

	return spawner


func get_free_random_enemy_spawner():
	var spawner = free_enemy_spawners.pick_random()
	spawner.is_filled = true
	free_enemy_spawners.erase(spawner)
	
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


func add_choose_UI_in_center(chooseUI : ChooseUI):
	ui.add_child(chooseUI)
	chooseUI.initialize()
	get_tree().create_timer(0.01).timeout.connect(align_item_in_center.bind(chooseUI))


func align_item_in_center(item : Control):
	item.global_position.x = DataManager.viewport_size.x / 2 - item.size.x / 2
	item.global_position.y = DataManager.viewport_size.y / 2 - item.size.y / 2


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

func show_res_popup_after_unit_dead(unit : Unit, info_res_popup_UI : InfoResPopupUI , x_offset : float):
	ui.add_child(info_res_popup_UI)
	info_res_popup_UI.global_position = unit.global_position + Vector2(-16 + x_offset, -16)
	info_res_popup_UI.initialize()
	var tween = get_tree().create_tween()
	tween.set_parallel()
	tween.tween_property(info_res_popup_UI, 'global_position', unit.global_position + Vector2(16 + x_offset, -76), 1).set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(info_res_popup_UI, 'modulate', Color8(1, 1, 1, 0.3), 1).set_trans(Tween.TRANS_SPRING)
	tween.tween_property(info_res_popup_UI, 'scale', Vector2(0.5, 0.5), 1).set_trans(Tween.TRANS_SPRING)
	tween.tween_callback(info_res_popup_UI.close_popup).set_delay(1)


func clear_enemy_spawns():
	free_enemy_spawners.clear()
	for spawner in enemy_spawners.get_children():
		spawner.is_filled = false
		free_enemy_spawners.append(spawner)


func clear_player_spawns():
	free_spawners.clear()
	for spawner in spawners.get_children():
		spawner.is_filled = false
		free_spawners.append(spawner)


func _on_timer_to_next_wave_timeout() -> void:
	create_wave()
	
	
func create_wave():
	panel_in_fight.visible = true
	next_wave_ui.next_wave_anim_player.stop()
	next_wave_ui.visible = false
	next_wave.start_wave()
	Player.increment_current_wave_count()
	is_wave_in_progress = true
	Player.set_player_units_in_fight()


func start_next_wave_countdown():
	var next_wave_scene : PackedScene = waves_scenes.pop_front()
	if not next_wave_scene:
		timer_to_next_wave.stop()
		return
	next_wave = next_wave_scene.instantiate()
	waves.add_child(next_wave)
	timer_to_next_wave.wait_time = next_wave.time_to_next_wave
	timer_to_next_wave.start()
	next_wave_ui.is_should_update_label = true
	next_wave_ui.visible = true


func start_check_is_enemies_remaining():
	timer_between_check_enemies.start()


func _on_timer_between_check_enemies_timeout() -> void:
	if not Player.is_enemies_alive():
		timer_between_check_enemies.stop()
		is_wave_in_progress = false
		SignalManager.on_wave_done.emit()


func show_reward():
	panel_in_fight.visible = false
	var wave_count : int = Player.get_current_wave_count()
	wave_reward_UI = wave_reward_UI_scene.instantiate()
	wave_reward_UI.set_wave_count(wave_count)
	wave_reward_UI.set_reward_type(Player.get_wave_rewards().pop_front())
	ui.add_child(wave_reward_UI)
	wave_reward_UI.initialize()
	get_tree().create_timer(0.01).timeout.connect(align_item_in_center.bind(wave_reward_UI))


func get_free_random_fight_point():
	if free_fight_points.size() == 0:
		clear_player_spawns()
	var point = free_fight_points.pick_random()
	point.is_filled = true
	free_fight_points.erase(point)

	return point


func clear_fight_points():
	free_fight_points.clear()
	for point in castle_fight_points.get_children():
		point.is_filled = false
		free_fight_points.append(point)


func initialize_hp_bar():
	hp_bar.max_value = Player.get_current_health()
	hp_bar.value = Player.get_current_health()
	label_hp_bar.text = '%d / %d' % [Player.get_current_health(), Player.get_health()]


func update_hp_bar():
	hp_bar.value = Player.get_current_health()
	label_hp_bar.text = '%d / %d' % [Player.get_current_health(), Player.get_health()]


func show_damage_ui(unit : Unit, info_damage_popup_ui : InfoDamagePopupUI):
	ui.add_child(info_damage_popup_ui)
	info_damage_popup_ui.global_position = unit.global_position + Vector2(0, -24)
	info_damage_popup_ui.initialize()
	await get_tree().process_frame
	var tween = get_tree().create_tween()
	tween.set_parallel()
	tween.tween_property(info_damage_popup_ui, 'global_position', unit.global_position + Vector2(0, -76), 1).set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(info_damage_popup_ui, 'modulate', Color8(1, 1, 1, 0.3), 1).set_trans(Tween.TRANS_SPRING)
	tween.tween_property(info_damage_popup_ui, 'scale', Vector2(0.5, 0.5), 1).set_trans(Tween.TRANS_SPRING)
	tween.tween_callback(info_damage_popup_ui.close_popup).set_delay(1)


func add_tooltip(object : Object, tooltip : Tooltip):
	if current_tooltip and current_tooltip.tooltip_owner:
		current_tooltip.tooltip_owner.hide_tooltip()
	ui.add_child(tooltip)
	tooltip.global_position = object.global_position
	if not tooltip.is_initialized:
		tooltip.initialize()
		tooltip.is_initialized = true
	# здесь может быть баг
	current_tooltip = tooltip
	await get_tree().process_frame
	tooltip.global_position.y -= (tooltip.size.y + 20)


func remove_tooltip(tooltip : Tooltip):
	if tooltip and ui.get_children().has(tooltip):
		ui.remove_child(tooltip)
		current_tooltip = null
