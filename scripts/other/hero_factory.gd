extends Node2D

class_name HeroFactory


@export var hero_family : DataManager.UnitFamily
@export var hero_scene : PackedScene
@export var hero_resources : Array[HeroStatRes]


func get_random_heroes():
	pass


func get_random_hero(hero_level : int):
	var hero_stat_res : HeroStatRes = hero_resources.pick_random()
	var hero : Hero = create_hero(hero_stat_res.hero_type, hero_level)

	return hero


func get_hero_by_type(hero_type : DataManager.HeroType, hero_level : int):
	return create_hero(hero_type, hero_level)


func create_hero(hero_type : DataManager.HeroType, hero_level : int):
	var hero_stat_res : HeroStatRes = get_hero_res_by_type(hero_type)
	# устанавливаем дефолтные значения для уровня 1
	var hero : Hero = hero_scene.instantiate()
	hero.set_hero_level(hero_level)
	hero.set_stats(hero_stat_res.power, hero_stat_res.quickness, hero_stat_res.mastery, hero_stat_res.grace)
	hero.set_portrait(hero_stat_res.portraits_pool.pick_random())
	hero.set_hero_family(hero_stat_res.hero_family)
	hero.set_hero_class(hero_stat_res.hero_class)
	hero.set_hero_gender(hero_stat_res.hero_gender)
	# открыть когда появятся скиллы
	#hero.add_passive_scenes(hero_stat_res.first_passive_skill_pool.pick_random())
	#hero.add_active_scenes(hero_stat_res.first_passive_skill_pool.pick_random())
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
					hero.add_passive_scenes(hero_stat_res.second_passive_skill_pool.pick_random())
				elif i < 8:
					hero.add_passive_scenes(hero_stat_res.third_passive_skill_pool.pick_random())
			DataManager.HeroUpType.ACTIVE:
				if i < 5:
					hero.add_active_scenes(hero_stat_res.second_active_skill_pool.pick_random())
				elif i < 8:
					hero.add_active_scenes(hero_stat_res.third_active_skill_pool.pick_random())
	
	return hero


func get_hero_res_by_type(hero_type : DataManager.HeroType):
	return hero_resources[hero_type]
