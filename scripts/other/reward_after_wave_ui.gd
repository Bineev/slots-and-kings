extends RewardUI

class_name RewardAfterWaveUI


@export var res_reward_item_scene : PackedScene
@export var action_reward_item_scene : PackedScene
@export var choose_hero_UI_scene : PackedScene
@export var choose_UI_scene : PackedScene
@export var choose_UI : ChooseUI
@export var remover_slot_UI_scene : PackedScene
@export var remover_slot_UI : RemoverUI
@export var level_up_UI_scene : PackedScene
@export var current_reward_type : DataManager.RewardType


@export var wave_count : int


func _ready() -> void:
	SignalManager.on_choose_reward_item.connect(show_next_choose_UI)


func initialize():
	await get_tree().process_frame
	set_entity_tier_by_wave_count()
	set_resorces_count_by_wave_count()
	generate_reward_header()
	generate_reward_info()
	generate_reward_container()
	SignalManager.on_change_reward_state.emit(true)
	SoundManager.play_ui(self, DataManager.sound_dict[DataManager.SoundType.NICE])


func show_popup_UI():
	if current_reward_type == DataManager.RewardType.REMOVER:
		show_slot_remover()
		return
	if current_reward_type != DataManager.RewardType.MARKET and current_reward_type != DataManager.RewardType.BLACK_MARKET:
		show_choose_UI()
		return


func show_choose_UI():
	#SoundManager.play_ui(self, DataManager.sound_dict[DataManager.SoundType.SHOW_REWARDS])
	choose_UI = choose_UI_scene.instantiate()
	var choose_scenes : Array[PackedScene]
	match current_reward_type:
		DataManager.RewardType.UNIT:
			choose_scenes = Player.get_random_units(entity_tier, Player.units_choose_count)
		DataManager.RewardType.UPGRADE:
			choose_scenes = Player.get_random_upgrades(entity_tier, Player.upgrades_choose_count)
		DataManager.RewardType.PERC:
			choose_scenes = Player.get_random_percs(entity_tier, Player.upgrades_choose_count)
		DataManager.RewardType.HERO:
			var choose_hero_UI : ChooseHeroUI = choose_hero_UI_scene.instantiate()
			var heroes_count = Player.get_heroes_choose_count()
			choose_hero_UI.set_heroes_count(heroes_count)
			choose_hero_UI.set_heroes_level(wave_count)
			# поменять если нужно повышать уровень с прогрессом волн
			var hero_level : int = 1
			if Player.heroes.size() > 0:
				hero_level = Player.heroes[0].hero_level - 1
			choose_hero_UI.set_heroes(Player.get_random_heroes(heroes_count, hero_level))
			#choose_hero_UI.initialize()
			SignalManager.on_show_choose_UI_after_wave.emit(choose_hero_UI)
			return
		DataManager.RewardType.LEVEL_UP:
			var level_up : LevelUpUI = level_up_UI_scene.instantiate()
			var hero : Hero = Player.get_hero_for_level_up()
			hero.level_up()
			hero.previous_position = hero.global_position
			level_up.set_hero(hero)
			SignalManager.on_show_choose_UI_after_wave.emit(level_up)
			return
	choose_UI.set_choose_scenes(choose_scenes)
	choose_UI.set_is_should_start_wave(true)
	SignalManager.on_show_choose_UI_after_wave.emit(choose_UI)


func close_popup_UI():
	pass


func generate_reward_info():
	var current_locale : String = TranslationServer.get_locale()
	var reward_prefix : String
	match current_locale:
		'en_US':
			reward_prefix = 'Units lost: %d\nEnemies destroyed: %d'
		'ru_RU':
			reward_prefix = 'Потеряно бойцов: %d\nУничтожено врагов: %d'
	label_reward_info.text = reward_prefix % [Player.get_player_die_count(), Player.get_enemy_die_count()]


func generate_reward_header():
	var current_locale : String = TranslationServer.get_locale()
	var reward_prefix : String
	match current_locale:
		'en_US':
			reward_prefix = 'Wave %d done!'
		'ru_RU':
			reward_prefix = 'Волна %d пройдена!'
	label_reward_header.text = reward_prefix % wave_count


func generate_reward_container():
	for res in resources_dict.keys():
		if resources_dict[res] == 0:
			continue
		var reward_item_res : RewardItemRes = res_reward_item_scene.instantiate()
		reward_item_res.set_res_count(resources_dict[res])
		reward_item_res.set_res_type(int(res))
		rewards_container.add_child(reward_item_res)
		reward_item_res.initialize()
	for reward_type in reward_types:
		var reward_item_action = action_reward_item_scene.instantiate()
		if reward_type == DataManager.RewardType.EMPTY:
			continue
		reward_item_action.set_reward_type(reward_type)
		rewards_container.add_child(reward_item_action)
		reward_item_action.initialize()


func set_entity_tier_by_wave_count():
	if wave_count >= DataManager.T4_transition:
		entity_tier = DataManager.EntityTier.T4
		return
	if wave_count >= DataManager.T3_transition:
		entity_tier = DataManager.EntityTier.T3
		return
	if wave_count >= DataManager.T2_transition:
		entity_tier = DataManager.EntityTier.T2
		return
	entity_tier = DataManager.EntityTier.T1


func set_resorces_count_by_wave_count():
	resources_dict[DataManager.ResType.SOULS] = DataManager.default_souls_inc
	if wave_count >=DataManager.T4_transition:
		resources_dict[DataManager.ResType.GOLD] = DataManager.default_gold_reward * 2.5 
		resources_dict[DataManager.ResType.CRYSTAL] = DataManager.default_crystal_reward * 3 
		resources_dict[DataManager.ResType.FOOD] = DataManager.default_food_reward * 3
		resources_dict[DataManager.ResType.SPIN_TOKEN] = DataManager.default_spin_reward * 1.4 
		return
	elif wave_count >= DataManager.T3_transition:
		resources_dict[DataManager.ResType.GOLD] = DataManager.default_gold_reward * 2
		resources_dict[DataManager.ResType.CRYSTAL] = DataManager.default_crystal_reward * 3
		resources_dict[DataManager.ResType.FOOD] = DataManager.default_food_reward * 2.5
		resources_dict[DataManager.ResType.SPIN_TOKEN] = DataManager.default_spin_reward * 1.3
		return
	elif wave_count >= DataManager.T2_transition:
		resources_dict[DataManager.ResType.GOLD] = DataManager.default_gold_reward * 1.5
		resources_dict[DataManager.ResType.CRYSTAL] = DataManager.default_crystal_reward * 2
		resources_dict[DataManager.ResType.FOOD] = DataManager.default_food_reward * 2
		resources_dict[DataManager.ResType.SPIN_TOKEN] = DataManager.default_spin_reward * 1.2
		return
	else:
		resources_dict[DataManager.ResType.GOLD] = DataManager.default_gold_reward
		resources_dict[DataManager.ResType.CRYSTAL] = DataManager.default_crystal_reward
		resources_dict[DataManager.ResType.FOOD] = DataManager.default_food_reward
		resources_dict[DataManager.ResType.SPIN_TOKEN] = DataManager.default_spin_reward


func set_wave_count(new_wave_count : int):
	wave_count = new_wave_count


func show_slot_remover():
	remover_slot_UI = remover_slot_UI_scene.instantiate()
	if wave_count >= 16:
		remover_slot_UI.max_remove_count = 4
	elif wave_count >= 11:
		remover_slot_UI.max_remove_count = 3
	elif wave_count >= 7:
		remover_slot_UI.max_remove_count = 2
	var slot_scenes : Array[PackedScene]
	var units : Array[PackedScene] = Player.get_deck_by_slot_type(DataManager.SlotType.UNIT)
	if units.size() >= 4 + remover_slot_UI.max_remove_count:
		slot_scenes.append_array(units)
	slot_scenes.append_array(Player.get_deck_by_slot_type(DataManager.SlotType.UPGRADE))
	slot_scenes.append_array(Player.get_deck_by_slot_type(DataManager.SlotType.PERC))
	remover_slot_UI.set_slot_scenes(slot_scenes)
	remover_slot_UI.set_is_should_start_wave(true)
	SignalManager.on_show_choose_UI_after_wave.emit(remover_slot_UI)


func show_next_choose_UI():
	if reward_types.size() == 0:
		get_tree().create_timer(1).timeout.connect(queue_free)
		SignalManager.on_change_reward_state.emit(false)
		SignalManager.on_new_wave_start.emit()
		return
	current_reward_type = reward_types.pop_front()
	show_popup_UI()
	
