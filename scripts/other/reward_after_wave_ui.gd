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


@export var wave_count : int



func initialize():
	await get_tree().process_frame
	set_entity_tier_by_wave_count()
	set_resorces_count_by_wave_count()
	generate_reward_header()
	generate_reward_info()
	generate_reward_container()
	SoundManager.play_ui(self, DataManager.sound_dict[DataManager.SoundType.NICE])


func show_popup_UI():
	if reward_type == DataManager.RewardType.REMOVER:
		show_slot_remover()
		return
	if reward_type != DataManager.RewardType.MARKET and reward_type != DataManager.RewardType.BLACK_MARKET:
		show_choose_UI()
		return
	else:
		pass


func show_choose_UI():
	#SoundManager.play_ui(self, DataManager.sound_dict[DataManager.SoundType.SHOW_REWARDS])
	choose_UI = choose_UI_scene.instantiate()
	var choose_scenes : Array[PackedScene]
	match reward_type:
		DataManager.RewardType.UNIT:
			choose_scenes = Player.get_random_units(entity_tier, DataManager.default_choose_amount)
		DataManager.RewardType.UPGRADE:
			choose_scenes = Player.get_random_upgrades(entity_tier, DataManager.default_choose_amount)
		DataManager.RewardType.PERC:
			choose_scenes = Player.get_random_percs(entity_tier, DataManager.default_choose_amount)
		DataManager.RewardType.HERO:
			var choose_hero_UI : ChooseHeroUI = choose_hero_UI_scene.instantiate()
			var heroes_count = Player.get_heroes_choose_count()
			choose_hero_UI.set_heroes_count(heroes_count)
			choose_hero_UI.set_heroes_level(wave_count)
			# поменять если нужно повышать уровень с прогрессом волн
			choose_hero_UI.set_heroes(Player.get_random_heroes(heroes_count, 1))
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
	label_reward_info.text = 'Здесь будет статистика'


func generate_reward_header():
	label_reward_header.text = 'Волна %d пройдена!' % wave_count


func generate_reward_container():
	for res in resources_dict.keys():
		if resources_dict[res] == 0:
			continue
		var reward_item_res : RewardItemRes = res_reward_item_scene.instantiate()
		reward_item_res.set_res_count(resources_dict[res])
		reward_item_res.set_res_type(int(res))
		rewards_container.add_child(reward_item_res)
		reward_item_res.initialize()
	var reward_item_action = action_reward_item_scene.instantiate()
	if reward_type == DataManager.RewardType.EMPTY:
		return
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
	if wave_count >=DataManager.T4_transition:
		resources_dict[DataManager.ResType.GOLD] = DataManager.default_gold_reward * 2.5
		resources_dict[DataManager.ResType.CRYSTAL] = DataManager.default_crystal_reward * 4
		resources_dict[DataManager.ResType.FOOD] = DataManager.default_food_reward * 4
		resources_dict[DataManager.ResType.SPIN_TOKEN] = DataManager.default_spin_reward * 2
		return
	elif wave_count >= DataManager.T3_transition:
		resources_dict[DataManager.ResType.GOLD] = DataManager.default_gold_reward * 2
		resources_dict[DataManager.ResType.CRYSTAL] = DataManager.default_crystal_reward * 3
		resources_dict[DataManager.ResType.FOOD] = DataManager.default_food_reward * 3
		resources_dict[DataManager.ResType.SPIN_TOKEN] = DataManager.default_spin_reward * 1.5
		return
	elif wave_count >= DataManager.T2_transition:
		resources_dict[DataManager.ResType.GOLD] = DataManager.default_gold_reward * 1.5
		resources_dict[DataManager.ResType.CRYSTAL] = DataManager.default_crystal_reward * 2
		resources_dict[DataManager.ResType.FOOD] = DataManager.default_food_reward * 2
		resources_dict[DataManager.ResType.SPIN_TOKEN] = DataManager.default_spin_reward * 1.25
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
	var slot_scenes : Array[PackedScene]
	var units : Array[PackedScene] = Player.get_deck_by_slot_type(DataManager.SlotType.UNIT)
	if units.size() > 4:
		slot_scenes.append_array(units)
	slot_scenes.append_array(Player.get_deck_by_slot_type(DataManager.SlotType.UPGRADE))
	slot_scenes.append_array(Player.get_deck_by_slot_type(DataManager.SlotType.PERC))
	remover_slot_UI.set_slot_scenes(slot_scenes)
	remover_slot_UI.set_is_should_start_wave(true)
	SignalManager.on_show_choose_UI_after_wave.emit(remover_slot_UI)
