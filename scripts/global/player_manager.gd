extends Node


@export var current_king : DataManager.UnitFamily
@export var health : int
@export var gold : int
@export var tokens : int
@export var food : int
@export var crystals : int
@export var souls : int
@export var can_swap_time : float
@export var is_can_swap : bool
@export var heroes_choose_count : int = 2
@export var stats_choose_count : int = 2
@export var skill_choose_count : int = 2

@export var wave_rewards : Array[Array]
@export var empty_perc_scene : PackedScene
@export var empty_upgrade_scene : PackedScene
@export var slot_scene : PackedScene
@export var passive_skill_scene : PackedScene
@export var active_skill_scene : PackedScene
@export var unit_factory_scene : PackedScene

@export var base_units_reses : Array[Resource]
@export var base_upgrades_reses : Array[Resource]
@export var base_percs_reses : Array[Resource]
@export var base_units_deck : Array[PackedScene]
@export var base_upgrades_deck : Array[PackedScene]
@export var base_percs_deck : Array[PackedScene]

@export var units_T1_pool : Array[Resource]
@export var units_T2_pool : Array[Resource]
@export var units_T3_pool : Array[Resource]
@export var units_T4_pool : Array[Resource]

@export var upgrades_T1_pool : Array[Resource]
@export var upgrades_T2_pool : Array[Resource]
@export var upgrades_T3_pool : Array[Resource]
@export var upgrades_T4_pool : Array[Resource]

@export var percs_T4_pool : Array[Resource]
@export var percs_T1_pool : Array[Resource]
@export var percs_T2_pool : Array[Resource]
@export var percs_T3_pool : Array[Resource]

@export var hero_family : DataManager.UnitFamily
@export var hero_scene : PackedScene
@export var hero_resources : Array[HeroStatRes]
@export var hero_factory_scene : PackedScene

var bonus_dict : Dictionary

var current_progress : PlayerProgress
var current_health : int
var current_gold : int
var current_tokens : int
var current_food : int
var current_crystals : int
var current_souls : int
var enemy_units : Array[Unit]
var player_units : Array[Unit]
var dead_enemy_units : Array[Unit]
var dead_player_units : Array[Unit]
var heroes : Array[Hero]
var current_wave_count : int
var next_create_units_count : int
var hero_factory : HeroFactory
var unit_factory : UnitFactory
var current_units_coeff : int = 1
var current_bonus_slot_name : String
var is_dead : bool
var current_runs_count : int
var buildings : Array[Building]


func _ready() -> void:
	SignalManager.on_choose_item.connect(add_item_to_deck)
	SignalManager.on_get_res.connect(get_res)
	initialize()


func initialize():
	clear_base_decks()
	unit_factory = unit_factory_scene.instantiate()
	is_dead = false
	heroes.clear()
	buildings.clear()
	enemy_units.clear()
	player_units.clear()
	current_progress = ProgressManager.get_base_progress_by_family(current_king)
	current_progress.meta_stats = DataManager.meta_stats_dict
	current_health = health
	current_gold = gold
	current_tokens = tokens
	current_food = food
	current_crystals = crystals
	current_souls = souls
	generate_base_decks()
	generate_bonus_dict()



func clear_after_result():
	clear_base_decks()
	is_dead = false
	heroes.clear()
	buildings.clear()
	enemy_units.clear()
	player_units.clear()
	current_wave_count = 0
	current_health = health
	current_gold = gold
	current_tokens = tokens
	current_food = food
	current_crystals = crystals
	generate_base_decks()
	generate_bonus_dict()


func initialize_with_data():
	current_progress = ProgressManager.get_current_progress_by_family(current_king)
	clear_after_result()


func get_random_upgrades(tier : DataManager.EntityTier, amount : int):
	var upgrade_reses : Array[Resource]
	match tier:
		DataManager.EntityTier.T1:
			upgrade_reses = current_progress.upgrades_T1_pool
		DataManager.EntityTier.T2:
			upgrade_reses = current_progress.upgrades_T2_pool
		DataManager.EntityTier.T3:
			upgrade_reses = current_progress.upgrades_T3_pool
		DataManager.EntityTier.T4:
			upgrade_reses = current_progress.upgrades_T4_pool
	
	return get_unique_entities(upgrade_reses, amount)


func get_random_units(tier : DataManager.EntityTier, amount : int):
	var unit_reses : Array[Resource]
	match tier:
		DataManager.EntityTier.T1:
			unit_reses = current_progress.units_T1_pool
		DataManager.EntityTier.T2:
			unit_reses = current_progress.units_T2_pool
		DataManager.EntityTier.T3:
			unit_reses = current_progress.units_T3_pool
		DataManager.EntityTier.T4:
			unit_reses = current_progress.units_T4_pool
	
	return get_unique_entities(unit_reses, amount)


func get_random_percs(tier : DataManager.EntityTier, amount : int):
	var perc_reses : Array[Resource]
	match tier:
		DataManager.EntityTier.T1:
			perc_reses = current_progress.percs_T1_pool
		DataManager.EntityTier.T2:
			perc_reses = current_progress.percs_T2_pool
		DataManager.EntityTier.T3:
			perc_reses = current_progress.percs_T3_pool
		DataManager.EntityTier.T4:
			perc_reses = current_progress.percs_T4_pool
	
	return get_unique_entities(perc_reses, amount)


func get_unique_entities(entities : Array[Resource], amount : int):
	#var unique_array : Array[PackedScene]
	#entities.shuffle()
	#var count : int
	#for entity in entities:
		#if count >= amount:
			#break
		#unique_array.append(entity)
		#count += 1
#
	#return unique_array
	var unique_array : Array[PackedScene]
	entities.shuffle()
	var count : int
	for entity in entities:
		if count >= amount:
			break
		unique_array.append(create_slot_scene(entity))
		count += 1

	return unique_array


func add_item_to_deck(slot_scene : PackedScene, slot_type : DataManager.SlotType):
	match slot_type:
		DataManager.SlotType.UPGRADE:
			add_upgrade_slot_to_deck(slot_scene)
		DataManager.SlotType.PERC:
			add_perc_slot_to_deck(slot_scene)
		DataManager.SlotType.UNIT: 
			add_unit_slot_to_deck(slot_scene)


func add_unit_slot_to_deck(slot_scene : PackedScene):
	var slot : Slot
	var T0_count : int
	var T0_index : int
	for i in range(base_units_deck.size()):
		slot = base_units_deck[i].instantiate()
		if slot.slot_res.entity_tier == DataManager.EntityTier.T0:
			T0_count += 1
			T0_index = i
			#base_units_deck.erase(item)
			#break
	if T0_count > 3:
		base_units_deck.erase(base_units_deck[T0_index])
	#var slot_temp : Slot = slot_scene.instantiate()
	#if T0_count > 2 and slot_temp.slot_res.entity_tier == 1:
		#base_units_deck.append(slot_scene)
	base_units_deck.append(slot_scene)


func add_upgrade_slot_to_deck(slot_scene : PackedScene):
	var slot : Slot
	for item in base_upgrades_deck:
		slot = item.instantiate()
		if slot.get_meta('slot_name') == 'Зеро':
			base_upgrades_deck.erase(item)
			break
	base_upgrades_deck.append(slot_scene)


func add_perc_slot_to_deck(slot_scene : PackedScene):
	var slot : Slot
	for item in base_percs_deck:
		slot = item.instantiate()
		if slot.get_meta('slot_name') == 'Зеро':
			base_percs_deck.erase(item)
			break
	base_percs_deck.append(slot_scene)


func get_deck_by_slot_type(slot_type : DataManager.SlotType):
	var slots : Array[PackedScene]
	match slot_type:
		DataManager.SlotType.UPGRADE:
			slots = base_upgrades_deck.duplicate()
		DataManager.SlotType.PERC:
			slots = base_percs_deck.duplicate()
		DataManager.SlotType.UNIT:
			slots = base_units_deck.duplicate()
	slots.shuffle()
	return slots


func get_res(res_type : DataManager.ResType, res_amount : int):
	match res_type:
		DataManager.ResType.GOLD:
			current_gold += res_amount
		DataManager.ResType.SPIN_TOKEN:
			current_tokens += res_amount
		DataManager.ResType.CRYSTAL:
			current_crystals += res_amount
		DataManager.ResType.FOOD:
			current_food += res_amount
	SignalManager.on_res_change.emit(res_type)


func get_gold():
	return current_gold


func get_food():
	return current_food


func get_tokens():
	return current_tokens


func get_crystals():
	return current_crystals


func check_res(amount : int, res_type : DataManager.ResType):
	match res_type:
		DataManager.ResType.GOLD:
			return current_gold - amount >= 0
		DataManager.ResType.SPIN_TOKEN:
			return current_tokens - amount >= 0
		DataManager.ResType.CRYSTAL:
			return current_crystals - amount >= 0
		DataManager.ResType.FOOD:
			return current_food - amount >= 0
		DataManager.ResType.SOULS:
			return current_souls - amount >= 0


func add_unit_to_player_units(unit : Unit):
	player_units.append(unit)


func remove_unit_from_player_units(unit : Unit):
	player_units.erase(unit)
	pass


func add_unit_to_enemy_units(unit : Unit):
	enemy_units.append(unit)


func remove_unit_from_enemy_units(unit : Unit):
	enemy_units.erase(unit)
	
	
func get_enemies():
	return enemy_units


func get_player_units():
	return player_units


func is_enemies_alive():
	return enemy_units.size() > 0


func is_player_units_alive():
	return player_units.size() > 0


func set_player_units_in_fight():
	for unit in player_units:
		if unit and is_instance_valid(unit) and unit.unit_state != DataManager.UnitState.DIED and unit.unit_state != DataManager.UnitState.DEAD:
			unit.is_in_fight = true


func set_player_units_not_in_fight():
	for unit in player_units:
		if unit and is_instance_valid(unit) and unit.unit_state != DataManager.UnitState.DIED and unit.unit_state != DataManager.UnitState.DEAD:
			unit.is_in_fight = false


func check_enemies(unit_owner : DataManager.UnitOwner):
	return is_enemies_alive() if unit_owner == DataManager.UnitOwner.PLAYER else is_player_units_alive()


func apply_heroes_skills(unit : Unit):
	for hero in heroes:
		hero.apply_passives(unit)


func get_current_wave_count():
	return current_wave_count


func increment_current_wave_count():
	current_wave_count += 1


func set_wave_rewards(new_wave_rewards : Array[Array]):
	wave_rewards = new_wave_rewards


func get_wave_rewards():
	return wave_rewards


func get_damage(damage : float):
	if is_dead:
		return
	current_health = clamp(current_health - damage, 0, health)
	if current_health <= 0:
		Player.is_dead = true
		GameManager.loose()
	SignalManager.on_player_get_hit.emit()
	# тряска


func get_current_health():
	return current_health


func get_health():
	return health


func set_units_count_for_next_create(units_count : int):
	next_create_units_count = units_count


func get_units_count_for_next_create():
	return next_create_units_count


func set_unit_factory(new_unit_factory : UnitFactory):
	unit_factory = new_unit_factory


func get_unit_factory():
	return unit_factory


func get_heal(amount : int):
	current_health = clamp(current_health + amount, 0, health)
	SignalManager.on_player_get_health.emit()


func remove_slot_by_type(slot : Slot, slot_type : DataManager.SlotType):
	match slot_type:
		DataManager.SlotType.UPGRADE:
			remove_slot(base_upgrades_deck, slot)
		DataManager.SlotType.PERC:
			remove_slot(base_percs_deck, slot)
		DataManager.SlotType.UNIT:
			remove_slot(base_units_deck, slot)


func remove_slot(deck : Array[PackedScene], slot : Slot):
	var slots : Array[Slot]
	for item in deck:
		var item_instance : Slot = item.instantiate()
		if item_instance.slot_res.slot_name == slot.slot_name:
			if deck.size() == 4:
				deck.erase(item)
				deck.append(empty_perc_scene if slot.slot_type == DataManager.SlotType.PERC else empty_upgrade_scene)
				break
			else:
				deck.erase(item)
				break


func get_can_swap_time():
	return can_swap_time


func set_is_can_swap(new_is_can_swap : bool):
	is_can_swap = new_is_can_swap


func get_is_can_swap():
	return is_can_swap


func create_slot_scene(res : SlotRes):
	var slot : Slot = slot_scene.instantiate()
	slot.slot_res = res
	slot.set_meta('slot_name', res.slot_name)
	var smth : PackedScene = PackedScene.new()
	smth.pack(slot)
	#smth.set_meta('slot_name', res.slot_name)
	return smth


func generate_base_decks():
	for res in current_progress.base_upgrades_reses:
		base_upgrades_deck.append(create_slot_scene(res))
	for res in current_progress.base_units_reses:
		base_units_deck.append(create_slot_scene(res))
	for res in current_progress.base_percs_reses:
		base_percs_deck.append(create_slot_scene(res))


func clear_base_decks():
	base_upgrades_deck.clear()
	base_units_deck.clear()
	base_percs_deck.clear()


func generate_bonus_dict():
	var pool : Array[Resource] = current_progress.units_T1_pool + current_progress.units_T2_pool + current_progress.units_T3_pool + current_progress.units_T4_pool
	for res in pool:
		bonus_dict[res.slot_name] = 0


func get_random_week_bonus():
	var slot_name = bonus_dict.keys().pick_random()
	var count : int = 1
	current_bonus_slot_name = slot_name
	bonus_dict[slot_name] += count
	return [slot_name, count]


func get_bonus_dict():
	return bonus_dict


func update_bonus(slot_name : String, count : int):
	bonus_dict[slot_name] += count


func remove_bonus():
	if current_bonus_slot_name:
		bonus_dict[current_bonus_slot_name] -= 1


func get_current_bonus(slot_name : Resource):
	if not bonus_dict.has(slot_name):
		return 0
	return bonus_dict[slot_name]


func get_random_heroes(heroes_count : int, heroes_level : int):
	var heroes : Array[Hero]
	current_progress.hero_reses.shuffle()
	current_progress.hero_classes.shuffle()
	var counter : int
	var inner_counter : int
	var reses_size : int = current_progress.hero_classes.size()
	while counter < heroes_count:
		var hero_class : DataManager.HeroClass = current_progress.hero_classes[inner_counter]
		var hero : Hero = get_hero_by_class(hero_class, heroes_level)
		heroes.append(hero)
		counter += 1
		inner_counter += 1
		if inner_counter >= reses_size:
			inner_counter = 0
	return heroes


func get_random_hero(hero_level : int):
	var hero_class : DataManager.HeroClass = current_progress.hero_classes.pick_random()
	var hero : Hero = create_hero(hero_class, hero_level)

	return hero


func get_hero_by_class(hero_class : DataManager.HeroClass, hero_level : int):
	return create_hero(hero_class, hero_level)


func get_passive_res_by_class_and_level(hero : Hero, hero_class : DataManager.HeroClass, hero_level : int):
	var skill_grade : DataManager.SkillGrade
	if hero_level >= 9:
		skill_grade = DataManager.SkillGrade.EPIC
	elif hero_level >= 6:
		skill_grade = DataManager.SkillGrade.RARE
	elif hero_level >= 3:
		skill_grade = DataManager.SkillGrade.UNCOMMON
	else:
		skill_grade = DataManager.SkillGrade.BASE
		
	var skill_reses : Array = current_progress.base_pskills_dict[hero_class][skill_grade].duplicate()
	skill_reses.shuffle()
	return skill_reses[0]


func get_random_passive_reses_by_count(hero : Hero, hero_class : DataManager.HeroClass, hero_level : int, res_count : int):
	var reses : Array
	var res = get_passive_res_by_class_and_level(hero, hero_class, hero_level)
	reses.append(res)
	res_count -= 1
	while res_count > 0:
		res = get_passive_res_by_class_and_level(hero, hero_class, hero_level)
		if not reses.has(res):
			reses.append(res)
			res_count -= 1
	return reses


func get_random_active_reses_by_count(hero : Hero, hero_class : DataManager.HeroClass, hero_level : int, res_count : int):
	var reses : Array
	var res = get_active_res_by_class_and_level(hero, hero_class, hero_level)
	reses.append(res)
	res_count -= 1
	while res_count > 0:
		res = get_active_res_by_class_and_level(hero, hero_class, hero_level)
		if not reses.has(res):
			reses.append(res)
			res_count -= 1
	return reses



func get_active_res_by_class_and_level(hero : Hero, hero_class : DataManager.HeroClass, hero_level : int):
	var skill_grade : DataManager.SkillGrade
	if hero_level >= 10:
		skill_grade = DataManager.SkillGrade.EPIC
	elif hero_level >= 7:
		skill_grade = DataManager.SkillGrade.RARE
	elif hero_level >= 4:
		skill_grade = DataManager.SkillGrade.UNCOMMON
	else:
		skill_grade = DataManager.SkillGrade.BASE
		
	var skill_reses : Array = current_progress.base_askills_dict[hero_class][skill_grade].duplicate()
	skill_reses.shuffle()
	return skill_reses[0]


func create_hero(hero_class : DataManager.HeroClass, hero_level : int):
	var hero_stat_res : HeroStatRes = get_hero_res_by_class(hero_class)
	# устанавливаем дефолтные значения для уровня 1
	var hero : Hero = hero_scene.instantiate()
	hero.set_hero_level(hero_level)
	hero.set_stats(hero_stat_res.power, hero_stat_res.quickness, hero_stat_res.mastery, hero_stat_res.grace)
	hero.set_portrait(hero_stat_res.portraits_pool.pick_random())
	hero.set_hero_family(hero_stat_res.hero_family)
	hero.set_hero_class(hero_stat_res.hero_class)
	hero.set_hero_gender(hero_stat_res.hero_gender)
	# открыть когда появятся скиллы
	hero.add_passive_reses(get_passive_res_by_class_and_level(hero, hero.hero_class, 1))
	hero.add_active_reses(get_active_res_by_class_and_level(hero, hero.hero_class, 1))
	hero.set_hero_name(hero_stat_res.hero_names_pool.pick_random())
	
	# левел апаемся
	for i in range(hero_level + 1):
		if i <= 1:
			continue
		# мы дошли до уровня 2
		var up_type : DataManager.HeroUpType = DataManager.default_hero_up_order[i - 2]
		match up_type:
			DataManager.HeroUpType.STAT:
				var random = randf()
				if random < 0.25:
					hero.power += 1
				elif random < 0.5:
					hero.quickness += 1
				elif random < 0.75:
					hero.mastery += 1
				elif random < 1:
					hero.grace += 1
			DataManager.HeroUpType.PASSIVE:
				if i < 5:
					hero.add_passive_reses(get_passive_res_by_class_and_level(hero, hero.hero_class, hero.hero_level))
				elif i < 8:
					hero.add_passive_reses(get_passive_res_by_class_and_level(hero, hero.hero_class, hero.hero_level))
			DataManager.HeroUpType.ACTIVE:
				if i < 5:
					hero.add_active_reses(get_active_res_by_class_and_level(hero, hero.hero_class, hero.hero_level))
				elif i < 8:
					hero.add_active_reses(get_active_res_by_class_and_level(hero, hero.hero_class, hero.hero_level))
	
	return hero


func get_hero_res_by_class(hero_class : DataManager.HeroClass):
	for res in current_progress.hero_reses:
		if res.hero_class == hero_class:
			return res
	return current_progress.hero_reses[0]


func create_active_skill(skill_res : Resource):
	var skill : ActiveSkill = active_skill_scene.instantiate()
	skill.skill_res = skill_res
	return skill


func create_passive_skill(skill_res : Resource):
	var skill : PassiveSkill = passive_skill_scene.instantiate()
	skill.skill_res = skill_res
	return skill


func get_heroes_choose_count():
	return heroes_choose_count


func get_stats_choose_count():
	return stats_choose_count


func get_skill_choose_count():
	return skill_choose_count


func add_hero(new_hero : Hero):
	if not heroes.has(new_hero):
		heroes.append(new_hero)


func get_hero_for_level_up():
	heroes.sort_custom(func(hero_a : Hero, hero_b : Hero): return hero_a.hero_level <= hero_b.hero_level)
	if heroes.size() > 0:
		return heroes[0]


func get_level_by_diff(difficulty_count : int):
	return current_progress.level_scenes[difficulty_count]


func add_level_as_done(level_difficulty : int):
	if not current_progress.levels_done.has(level_difficulty):
		current_progress.levels_done.append(level_difficulty)


func check_is_level_done(level_difficulty : int):
	return current_progress.levels_done.has(level_difficulty)


func get_castle_name():
	return DataManager.castle_name_table[current_king]


func get_level_scenes():
	return current_progress.level_scenes


func add_rewards_to_progress(rewards : Array[Resource]):
	for reward in rewards:
		var res : SlotRes = reward
		if res.slot_type == DataManager.SlotType.UPGRADE:
			match res.entity_tier:
				DataManager.EntityTier.T1:
					if not current_progress.upgrades_T1_pool.has(res):
						current_progress.upgrades_T1_pool.append(res)
				DataManager.EntityTier.T2:
					if not current_progress.upgrades_T2_pool.has(res):
						current_progress.upgrades_T2_pool.append(res)
				DataManager.EntityTier.T3:
					if not current_progress.upgrades_T3_pool.has(res):
						current_progress.upgrades_T3_pool.append(res)
				DataManager.EntityTier.T4:
					if not current_progress.upgrades_T4_pool.has(res):
						current_progress.upgrades_T4_pool.append(res)


func get_buildings_count(building_name : String):
	var count : int
	for building in buildings:
		if building.building_name == building_name:
			count += 1
	
	return count


func change_meta_stat(meta_type : DataManager.MetaType, item_up_value : float):
	current_progress.meta_stats[meta_type] = current_progress.meta_stats[meta_type] + item_up_value


func get_meta_stats():
	return current_progress.meta_stats
