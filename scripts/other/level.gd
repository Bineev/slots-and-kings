extends Node2D

class_name Level


@export var unit_preview_scene : PackedScene
@export var tutorial_scenes : Array[PackedScene]
@export var waves_scenes : Array[PackedScene]
@export var first_wave_timer : float
@export var wave_rewards : Array
@export var wave_reward_UI_scene : PackedScene
@export var bonus_ui_scene : PackedScene
@export var difficulty_count : int
@export var level_name : String
@export var level_desc : String
@export var rewards : Array[Resource]
@export var waves_count : int = 10
@export var end_level_scene : PackedScene

var is_need_def_of_loop : bool
var free_spawners : Array[Spawner]
var free_enemy_spawners : Array[Spawner]
var unit_preview_UI : UnitPreviewUI
var end_level : EndLevelUI
var current_unit : Unit
var is_wave_in_progress : bool
var next_wave : Wave
var wave_reward_UI : RewardAfterWaveUI
var free_fight_points : Array[FightPoint]
var current_tooltip : Control
var heroes_slots_points : Array[Spawner]
var current_bonus_name : String
var current_bonus_count : int
var is_result : bool
var tutorial_item : TutorialItemUI
var is_tutorial_1_done : bool
var is_tutorial_2_done : bool
var is_tutorial_3_done : bool
var is_tutorial_4_done : bool
var is_tutorial_5_done : bool
var is_tutorial_6_done : bool
var is_tutorial_7_done : bool
var is_tutorial_8_done : bool
var is_farm_ready : bool
var is_factory_ready : bool

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
@onready var heroes: Node2D = %heroes
@onready var heroes_slots: Node2D = %heroes_slots
@onready var projectiles: Node2D = %projectiles
@onready var label_result: Label = %label_result
@onready var shaders_layer: ShadersLayer = %shaders_layer
@onready var shader_layer: CanvasLayer = %ShaderLayer
@onready var messages_pack_ui: MessagesPackUI = %MessagesPackUI
@onready var check_barracks_timer: Timer = %check_barracks_timer
@onready var check_second_buildings_timer: Timer = %check_second_buildings_timer
@onready var check_crystall_timer: Timer = %check_crystall_timer
@onready var check_hero_timer: Timer = %check_hero_timer


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
	SignalManager.on_wave_done.connect(pause_timers)
	SignalManager.on_wave_done.connect(cancel_attack)
	SignalManager.on_player_get_hit.connect(update_hp_bar)
	SignalManager.on_drop_res_popup.connect(show_res_popup_after_unit_dead)
	SignalManager.on_show_damage.connect(show_damage_ui)
	SignalManager.on_show_tooltip.connect(add_tooltip)
	SignalManager.on_hide_tooltip.connect(remove_tooltip)
	SignalManager.on_add_hero_to_field.connect(add_hero_to_field)
	SignalManager.on_add_unit_from_skill.connect(add_unit_from_skill)
	SignalManager.on_player_get_health.connect(update_hp_bar)
	SignalManager.on_create_projectile.connect(create_projectile)
	SignalManager.on_ready_choose_ui.connect(align_popup)
	SignalManager.on_clear_tooltips.connect(clear_tooltips)
	SignalManager.on_hero_choose_done.connect(add_hero_to_field)
	SignalManager.on_hero_return.connect(return_hero_to_field)
	SignalManager.on_change_reward_state.connect(set_buildings_reward_state)
	SignalManager.on_show_next_tutorial.connect(show_tutorial_item)
	SignalManager.on_align_item.connect(align_popup2)
	SignalManager.on_check_barracks_start.connect(check_barracks)
	for spawner in spawners.get_children():
		free_spawners.append(spawner)
	for spawner in enemy_spawners.get_children():
		free_enemy_spawners.append(spawner)
	for point in castle_fight_points.get_children():
		free_fight_points.append(point)
	for spawner in heroes_slots.get_children():
		heroes_slots_points.append(spawner)
	wave_rewards = DataManager.default_reward_progression.duplicate(true)
	Player.set_wave_rewards(wave_rewards)
	Player.level = self
	Player.diff_count = difficulty_count
	Player.add_random_slots_on_start()
	waves_count = difficulty_count * 2 + 6
	if difficulty_count == 0:
		messages_pack_ui.show()
		Player.is_message_tutorial = true
		waves_count = 7
		Player.current_food = 12
		Player.current_tokens = 12
	else:
		messages_pack_ui.hide()
	waves_scenes = SpawnManager.get_waves_by_diff_and_count(difficulty_count, waves_count)
	Player.generate_bonus_dict()
	start_waves()
	#TODO здесь должна играть мирная музыка
	#SoundManager.play_music(3)
	if not Player.is_should_shader_work:
		disable_shader()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("spin"):
		if not slot_machine.spin_button.disabled:
			slot_machine.press_spin_button()
	if event.is_action_pressed("create"):
		if not slot_machine.create_button.disabled:
			slot_machine.press_create_button()
	#if event.is_action_pressed("options"):
		#GameManager.show_options()
	if event.is_action_pressed("swap_down"):
		slot_machine.swap_down()
	if event.is_action_pressed("swap_up"):
		slot_machine.swap_up()


func start_waves():
	await self.ready
	update_shake(Player.is_should_shake)
	initialize_hp_bar()
	next_wave_ui.set_timer(timer_to_next_wave)
	next_wave_ui.set_remaining_waves(get_waves_remaining())
	start_next_wave_countdown()
	if Player.is_tutorial:
		get_tree().create_timer(1).timeout.connect(show_tutorial_item)
	# установить false когда последний спавн и врагов на карте не осталось


func add_player_unit():
	if not current_unit:
		return
	activate_util_slots()
	for i in range(Player.creates_unit_count):
		if Player.check_res(current_unit.unit_cost, DataManager.ResType.FOOD):
			Player.get_res(DataManager.ResType.FOOD, -current_unit.unit_cost)
			create_unit_from_scratch()
	SoundManager.play_ui(self, DataManager.sound_dict[DataManager.SoundType.CREATE_UNIT])
	# здесь сидит баг
	await get_tree().process_frame
	current_unit.get_parent().remove_child(current_unit)
	current_unit = null
	if Player.is_message_tutorial and not Player.is_first_create:
		Player.is_first_create = true
		SignalManager.on_message_pack_next.emit()


func activate_util_slots():
	for slot in Player.util_slots:
		if slot.slot_type != DataManager.SlotType.ULT:
			return
		if slot.slot_name == DataManager.empty_slot_name or slot.slot_name == DataManager.empty_slot_name_en:
			return
		var slot_util_res : SlotResUtil = slot.slot_res
		var rand_pos : float = randf()
		match slot_util_res.slot_util_type:
			DataManager.UtilType.RES:
				if rand_pos <= slot_util_res.positive_procentage:
					var rand_neg : float = randf()
					if rand_neg > slot_util_res.negative_procentage:
						print('res proc')
						for i in range(slot_util_res.res_types.size()):
							Player.get_res(slot_util_res.res_types[i], slot_util_res.res_counts[i])
			DataManager.UtilType.HEALTH:
				if rand_pos <= slot_util_res.positive_procentage:
					var rand_neg : float = randf()
					if rand_neg > slot_util_res.negative_procentage:
						print('heal proc')
						Player.get_heal(slot_util_res.health_count)
			DataManager.UtilType.CREATE_UNIT:
				var create_chance : float
				match slot_util_res.entity_tier:
					DataManager.EntityTier.T0:
						create_chance = slot_util_res.positive_procentage
					DataManager.EntityTier.T1:
						create_chance = slot_util_res.positive_procentage
					DataManager.EntityTier.T2:
						create_chance = slot_util_res.positive_procentage - slot_util_res.positive_procentage / float(3)
					DataManager.EntityTier.T3:
						create_chance = slot_util_res.positive_procentage - slot_util_res.positive_procentage / float(3) * 2
					DataManager.EntityTier.T4:
						create_chance = (slot_util_res.positive_procentage - slot_util_res.positive_procentage / float(3) * 2) / float(2)
				if rand_pos <= create_chance:
					var unit : Unit = create_unit_from_scratch()
					print('unit proc')
					var rand_neg : float = randf()
					if rand_neg > slot_util_res.negative_procentage:
						unit.unit_owner == DataManager.UnitOwner.ENEMY
					match slot_util_res.unit_position:
						DataManager.UnitPosition.MIDDLECENTER:
							pass
						DataManager.UnitPosition.MIDDLEBOT:
							pass
						DataManager.UnitPosition.MIDDLETOP:
							pass
						DataManager.UnitPosition.ENEMYSIDEMIDDLE:
							pass
						DataManager.UnitPosition.ENEMYSIDEBOT:
							pass
						DataManager.UnitPosition.ENEMYSIDETOP:
							pass
			DataManager.UtilType.CREATE_SKILL:
				pass
			DataManager.UtilType.CREATE_THING:
				pass


func update_units_count():
	var units_count_default : int = Player.get_units_count_for_next_create() 
	var bonus_dict = Player.get_bonus_dict()
	var bonus_count = 0
	if bonus_dict.keys().has(current_unit.slots[0].slot_name):
		bonus_count = bonus_dict[current_unit.slots[0].slot_name]
	Player.creates_unit_count = units_count_default * Player.current_units_coeff + bonus_count


func add_enemy_unit(unit : Unit, slots : Array[Slot], owner : DataManager.UnitOwner):
	enemy_units.add_child(unit)
	unit.initialize(slots[0], owner)
	unit.global_position = get_free_random_enemy_spawner().global_position
	unit.set_active()
	Player.add_unit_to_enemy_units(unit)
	unit.is_in_fight = true
	unit.fight_point = get_free_random_fight_point()
	SignalManager.on_unit_created.emit(unit)


func add_unit_preview(unit : Unit, slots : Array[Slot], owner : DataManager.UnitOwner):
	current_unit = unit
	update_units_count()
	if unit_preview_UI:
		unit_preview_UI.queue_free()
	unit_preview_UI = unit_preview_scene.instantiate()
	ui.add_child(unit_preview_UI)
	unit_preview_UI.set_unit(unit)
	unit_preview_UI.add_unit()
	unit.initialize(slots[0], owner)
	unit_preview_UI.initialize()
	unit_preview_UI.global_position = Vector2(50, 310)
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
	SignalManager.on_unit_created.emit(unit)
	return unit


func add_unit_from_skill(unit : Unit, spawn_position : Vector2):
	player_units.add_child(unit)
	unit.initialize(unit.slots[0], DataManager.UnitOwner.PLAYER)
	unit.fight_point = get_free_random_spawner()
	unit.global_position = spawn_position
	unit.set_active()
	Player.add_unit_to_player_units(unit)
	if Player.check_enemies(DataManager.UnitOwner.PLAYER):
		unit.is_in_fight = true
	SignalManager.on_unit_created.emit(unit)


func get_free_random_spawner():
	if free_spawners.size() == 0:
		clear_player_spawns()
	var spawner = free_spawners.pick_random()
	spawner.is_filled = true
	free_spawners.erase(spawner)

	return spawner


func get_free_random_enemy_spawner():
	var spawner = free_enemy_spawners.pick_random()
	if not spawner:
		clear_enemy_spawns()
		spawner = free_enemy_spawners.pick_random()
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
	#get_tree().create_timer(1).timeout.connect(align_popup.bind(menu_UI))


func add_choose_UI(building : Building, chooseUI : ChooseUI):
	ui.add_child(chooseUI)
	chooseUI.initialize()
	chooseUI.global_position = building.global_position
	#get_tree().create_timer(0.01).timeout.connect(align_popup.bind(chooseUI))


func add_choose_UI_in_center(chooseUI : Control):
	ui.add_child(chooseUI)
	chooseUI.initialize()
	get_tree().create_timer(0.01).timeout.connect(align_item_in_center.bind(chooseUI))


func align_item_in_center(item : Control):
	item.global_position.x = DataManager.viewport_size.x / 2 - item.size.x / 2
	item.global_position.y = DataManager.viewport_size.y / 2 - item.size.y / 2
	if item is BonusUI:
		item.global_position.y = item.global_position.y - 200


func build_building(building_scene : PackedScene, prebuilding : Building):
	var new_building = building_scene.instantiate()
	buildings.add_child(new_building)
	new_building.global_position = prebuilding.global_position
	Player.buildings.append(new_building)
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


func align_popup2(popup : Control):
	var window = DataManager.viewport_size
	#popup.global_position.x = popup.global_position.x - popup.size.x / 2 
	#popup.global_position.y = popup.global_position.y - popup.size.y / 2 
	await get_tree().process_frame
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
	SoundManager.play_ui(self, DataManager.sound_dict[DataManager.SoundType.START_WAVE])
	panel_in_fight.visible = true
	next_wave_ui.next_wave_anim_player.stop()
	next_wave_ui.visible = false
	next_wave.start_wave()
	Player.increment_current_wave_count()
	is_wave_in_progress = true
	Player.set_player_units_in_fight()


func show_end_level():
	end_level = end_level_scene.instantiate()
	ui.add_child(end_level)
	end_level.initialize()


func start_next_wave_countdown():
	unpause_timers()
	if Player.get_current_wave_count() > 1 and waves_scenes.size() > 0:
		get_tree().create_timer(0.5).timeout.connect(show_bonus_UI)
	var next_wave_scene : PackedScene = waves_scenes.pop_front()
	Player.clear_statistics()
	if not next_wave_scene:
		timer_to_next_wave.stop()
		show_end_level()
		return
	next_wave = next_wave_scene.instantiate()
	waves.add_child(next_wave)
	timer_to_next_wave.wait_time = next_wave.time_to_next_wave
	timer_to_next_wave.start()
	next_wave_ui.is_should_update_label = true
	next_wave_ui.set_remaining_waves(get_waves_remaining())
	next_wave_ui.visible = true
	if Player.is_tutorial and is_tutorial_7_done and not is_tutorial_8_done and Player.get_current_wave_count() == 4:
		is_tutorial_8_done = true
		show_tutorial_item()


func start_check_is_enemies_remaining():
	timer_between_check_enemies.start()


func _on_timer_between_check_enemies_timeout() -> void:
	if not Player.is_enemies_alive():
		timer_between_check_enemies.stop()
		is_wave_in_progress = false
		SignalManager.on_wave_done.emit()


func show_reward():
	Player.get_res(DataManager.ResType.SOULS, DataManager.default_souls_inc)
	if is_result:
		return
	if waves_scenes.size() == 0:
		SignalManager.on_new_wave_start.emit()
		return
	panel_in_fight.visible = false
	var wave_count : int = Player.get_current_wave_count()
	wave_reward_UI = wave_reward_UI_scene.instantiate()
	wave_reward_UI.set_wave_count(wave_count)
	var reward_types = Player.get_wave_rewards().pop_front()
	if reward_types.size() == 0:
		return
	wave_reward_UI.set_reward_types(reward_types)
	ui.add_child(wave_reward_UI)
	wave_reward_UI.initialize()
	get_tree().create_timer(0.01).timeout.connect(align_item_in_center.bind(wave_reward_UI))


func get_free_random_fight_point():
	if free_fight_points.size() == 0:
		#clear_player_spawns()
		clear_fight_points()
	var point = free_fight_points.pick_random()
	if not point:
		clear_fight_points()
		point = free_fight_points.pick_random()
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
	if info_damage_popup_ui.action_type == DataManager.ActionType.DAMAGE:
		info_damage_popup_ui.global_position = unit.global_position + Vector2(0, -40)
	if info_damage_popup_ui.action_type == DataManager.ActionType.HEAL:
		info_damage_popup_ui.global_position = unit.global_position + Vector2(-24, -40)
	info_damage_popup_ui.initialize()
	await get_tree().process_frame
	var tween = get_tree().create_tween()
	tween.set_parallel()
	tween.tween_property(info_damage_popup_ui, 'global_position', unit.global_position + Vector2(0, -76), 1).set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(info_damage_popup_ui, 'modulate', Color8(1, 1, 1, 0.3), 1).set_trans(Tween.TRANS_SPRING)
	tween.tween_property(info_damage_popup_ui, 'scale', Vector2(0.5, 0.5), 1).set_trans(Tween.TRANS_SPRING)
	tween.tween_callback(info_damage_popup_ui.close_popup).set_delay(1)


func add_tooltip(object : Object, tooltip : Tooltip):
	if current_tooltip and is_instance_valid(current_tooltip):
		current_tooltip.queue_free()
	current_tooltip = tooltip
	ui.add_child(tooltip)
	tooltip.initialize()
	await get_tree().process_frame
	if tooltip and is_instance_valid(tooltip) and object and is_instance_valid(object):
		tooltip.global_position = object.global_position - Vector2(0, (tooltip.size.y + 30))
	#if not tooltip.is_initialized:
		#tooltip.initialize()
		#tooltip.is_initialized = true
	# здесь может быть баг
	#await get_tree().process_frame
	#tooltip.global_position.y -= (tooltip.size.y / 2 + 30)


func remove_tooltip(tooltip : Tooltip):
	if tooltip and ui.get_children().has(tooltip):
		ui.remove_child(tooltip)
		current_tooltip = null


func add_hero_to_field(hero : Hero):
	Player.add_hero(hero)
	var hero_slot : Spawner = heroes_slots_points.pop_front()
	hero_slot.is_filled = true
	if hero.get_parent():
		for skill in hero.actives:
			print(skill.skill_anim_player.get_animation('skill').loop_mode)
		hero.reparent(heroes)
		for skill in hero.actives:
			print(skill.skill_anim_player.get_animation('skill').loop_mode)
			skill.reinit()
		for skill in hero.passives:
			skill.is_active = true
			skill.parse_skill()
	else:
		heroes.add_child(hero)
		hero.initialize()
	hero.global_position = hero_slot.global_position
	hero.is_active = true
	get_tree().create_timer(0.5).timeout.connect(hero.set_skills_is_active)
	if Player.is_tutorial and not is_tutorial_7_done:
		is_tutorial_7_done = true
		get_tree().create_timer(10).timeout.connect(show_tutorial_item)


func return_hero_to_field(hero : Hero):
	if hero.get_parent():
		hero.reparent(heroes)
		for skill in hero.actives:
			print(skill.skill_anim_player.get_animation('skill').loop_mode)
			skill.reinit()
	hero.global_position = hero.previous_position


func _on_is_in_fight_timer_timeout() -> void:
	if Player.check_enemies(DataManager.UnitOwner.PLAYER):
		Player.set_player_units_in_fight()
	else:
		Player.set_player_units_not_in_fight()


func pause_timers():
	var timers : Array[Timer]
	recursive_find(self, Timer, timers)
	for timer in timers:
		#print(timer.name)
		if timer.name == 'timer_tick' or timer.name == 'timer_skill_delay' or timer.name == 'timer_deactivate':
			continue
		timer.paused = true


func unpause_timers():
	var timers : Array[Timer]
	recursive_find(self, Timer, timers)
	for timer in timers:
		if timer.paused:
			timer.paused = false


func recursive_find(node, target_type, result_array):
	for child in node.get_children():
		if is_instance_of(child, target_type):
			result_array.append(child)
		recursive_find(child, target_type, result_array) # Рекурсивный вызов


func sort_player_units():
	var units : Array[Unit] = Player.get_player_units()
	if units.size() == 0:
		return
	units.sort_custom(sort_units)
	var base_ordering : int = 43
	for unit in units:
		base_ordering += 1
		if unit and is_instance_valid(unit) and unit.unit_state != DataManager.UnitState.DIED and unit.unit_state != DataManager.UnitState.DEAD:
			unit.z_index = base_ordering


func sort_enemy_units():
	var units : Array[Unit] = Player.get_enemies()
	if units.size() == 0:
		return
	# баг (текстура не успевает показаться)
	units.sort_custom(sort_units) 
	var base_ordering : int = 3
	for unit in units:
		base_ordering += 1
		if unit and is_instance_valid(unit) and unit.unit_state != DataManager.UnitState.DIED and unit.unit_state != DataManager.UnitState.DEAD:
			unit.z_index = base_ordering


func sort_units(a : Unit, b : Unit):
	if a.slot_unit_res and b.slot_unit_res:
		return a.global_position.y + a.slot_unit_res.unit_sprite.get_height() / 5 / 2 < b.global_position.y + b.slot_unit_res.unit_sprite.get_height() / 5 / 2
	return false

func _on_timer_sort_units_timeout() -> void:
	sort_player_units()
	sort_enemy_units()


func create_projectile(projectile : Projectile, new_pos : Vector2):
	projectiles.add_child(projectile)
	projectile.initialize()
	projectile.global_position = new_pos


func cancel_attack():
	var units : Array[Unit] = Player.get_player_units()
	for unit in units:
		unit.change_state(DataManager.UnitState.IDLE)
		unit.is_can_attack = true
		unit.is_in_fight = false


func show_bonus_UI():
	if is_result:
		return
	var bonus_ui : BonusUI = bonus_ui_scene.instantiate()
	Player.remove_bonus()
	var bonus_data = Player.get_random_week_bonus()
	current_bonus_name = bonus_data[0]
	current_bonus_count = bonus_data[1]
	bonus_ui.set_bonus_count(current_bonus_count)
	bonus_ui.set_bonus_name(current_bonus_name)
	ui.add_child(bonus_ui)
	bonus_ui.initialize()
	bonus_ui.global_position = get_viewport_rect().get_center()
	var tween : Tween = get_tree().create_tween()
	tween.set_parallel()
	tween.tween_property(bonus_ui, 'global_position', bonus_ui.global_position + Vector2(0, -500), 10)
	tween.tween_callback(bonus_ui.queue_free).set_delay(11)


func clear_tooltips():
	if current_tooltip and is_instance_valid(current_tooltip):
		current_tooltip.queue_free()
	#for item in ui.get_children():
		#print(item.get_class())
		#if item and is_instance_valid(item) and item is Tooltip:
			#item.hide()
			#item.queue_free()


func get_waves_remaining():
	return waves_scenes.size() + 1


func show_win_label():
	#var current_locale : String = TranslationServer.get_locale()
	#var result_text : String
	#match current_locale:
		#'en_US':
			#result_text = 'CONGRATULATIONS!'
		#'ru_RU':
			#result_text = 'ПОБЕДА!'
	#label_result.text = result_text
	#result_panel.global_position = get_viewport_rect().get_center()
	var tween : Tween = get_tree().create_tween()
	tween.set_parallel()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	#tween.tween_property(result_panel, 'modulate', Color(1, 1, 1, 1), 1.5)
	tween.tween_callback(GameManager.stop_all).set_delay(0.5)
	tween.tween_callback(GameManager.show_lobby).set_delay(0.5)
	tween.tween_callback(queue_free).set_delay(1)

func show_loose_label():
	#var current_locale : String = TranslationServer.get_locale()
	#var result_text : String
	#match current_locale:
		#'en_US':
			#result_text = 'DEFEAT!'
		#'ru_RU':
			#result_text = 'ПОРАЖЕНИЕ!'
	#label_result.text = result_text
	#result_panel.global_position = get_viewport_rect().get_center()
	var tween : Tween = get_tree().create_tween()
	tween.set_parallel()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	#tween.tween_property(result_panel, 'modulate', Color(1, 1, 1, 1), 1.5)
	tween.tween_callback(GameManager.stop_all).set_delay(0.5)
	tween.tween_callback(GameManager.show_lobby).set_delay(0.5)
	tween.tween_callback(queue_free).set_delay(1)


func hide_bonus_ui():
	show_bonus_UI()


func set_buildings_reward_state(is_in_reward_state : bool):
	for building in buildings.get_children():
		building.is_in_reward_state = is_in_reward_state


func show_tutorial_item():
	if tutorial_scenes.size() == 0:
		return
	if tutorial_item:
		ui.remove_child(tutorial_item)
	tutorial_item = tutorial_scenes.pop_front().instantiate()
	ui.add_child(tutorial_item)
	tutorial_item.global_position = get_viewport_rect().get_center()
	tutorial_item.initialize()


func update_shake(is_should_shake : bool):
	if is_should_shake and not SignalManager.on_player_get_hit.is_connected(shaders_layer.shake):
		SignalManager.on_player_get_hit.connect(shaders_layer.shake)
	elif not is_should_shake and SignalManager.on_player_get_hit.is_connected(shaders_layer.shake):
		SignalManager.on_player_get_hit.disconnect(shaders_layer.shake)


func disable_shader():
	shader_layer.hide()


func start_pieceful_music():
	SoundManager.change_to_peaceful_phase()


func start_martial_music():
	SoundManager.change_to_martial_phase()


func check_barracks():
	check_barracks_timer.start()


func _on_check_barracks_timer_timeout() -> void:
	# TODO Здесь проверка костылем для локалей
	for building in buildings.get_children():
		if tr(building.building_name).contains('1'):
			Player.is_first_build = true
			check_barracks_timer.stop()
			check_second_buildings_timer.start()
			SignalManager.on_message_pack_next.emit()


func _on_check_second_buildings_timer_timeout() -> void:
	# TODO Здесь проверка костылем для локалей
	for building in buildings.get_children():
		if not is_farm_ready:
			if tr(building.building_name).contains('Farm') or tr(building.building_name).contains('Ферма'):
				is_farm_ready = true
		if not is_factory_ready:
			if tr(building.building_name).contains('Factory') or tr(building.building_name).contains('Фабрика'):
				is_factory_ready = true
	if is_farm_ready and is_factory_ready:
		check_second_buildings_timer.stop()
		Player.is_second_build = true
		slot_machine.show_swaps()
		SignalManager.on_message_pack_next.emit()


func start_check_crystall_timer():
	check_crystall_timer.start()


func _on_check_crystall_timer_timeout() -> void:
	if Player.check_res(3, DataManager.ResType.CRYSTAL):
		check_crystall_timer.stop()
		Player.is_crystall_inc = true
		SignalManager.on_message_pack_next.emit()


func check_hero():
	check_hero_timer.start()


func _on_check_hero_timeout() -> void:
	if Player.heroes.size() > 0:
		check_hero_timer.stop()
		Player.is_hero_come = true
		SignalManager.on_message_pack_next.emit()
