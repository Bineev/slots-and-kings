extends PanelContainer

class_name LevelUpUI


@export var choose_skill_item_scene : PackedScene
@export var choose_stats_item_scene : PackedScene 

var hero : Hero

@onready var data_container: VBoxContainer = %data_container
@onready var hero_container: CenterContainer = %hero_container
@onready var content_container: HBoxContainer = %content_container


func _ready() -> void:
	SignalManager.on_choose_skill_done.connect(add_skill_to_hero)
	SignalManager.on_choose_stat_done.connect(change_stat)


func initialize():
	await get_tree().process_frame
	hero.reparent(hero_container)
	hero.set_skills_is_inactive()
	hero.update_hero_level()
	if hero.hero_level > 10 or hero.hero_level == 2 or hero.hero_level == 5 or hero.hero_level == 8:
		# показать меню стат ап
		var stats : Array[String] = ['power', 'quickness', 'mastery', 'grace']
		var count : int = Player.get_stats_choose_count()
		stats.shuffle()
		for i in range(count):
			var choose_stats_item : ChooseStatItemUI = choose_stats_item_scene.instantiate()
			choose_stats_item.set_stat(stats.pop_front())
			content_container.add_child(choose_stats_item)
			choose_stats_item.initialize()
	elif hero.hero_level == 3 or hero.hero_level == 6 or hero.hero_level == 9:  
		# взять пассивные скиллы случайные и добавить в контент контейнер
		var count : int = Player.get_skill_choose_count()
		var reses = Player.get_random_passive_reses_by_count(hero, hero.hero_class, hero.hero_level, count)
		for res in reses:
			var skill : Skill = Player.create_passive_skill(res)
			skill.set_skill_owner(hero)
			var choose_skill_item : ChooseSkillItemUI = choose_skill_item_scene.instantiate()
			choose_skill_item.set_skill(skill)
			content_container.add_child(choose_skill_item)
			choose_skill_item.initialize()
	elif hero.hero_level == 4 or hero.hero_level == 7 or hero.hero_level == 10: 
		# взять активные скиллы случайные и добавить в контент контейнер
		var count : int = Player.get_skill_choose_count()
		var reses = Player.get_random_active_reses_by_count(hero, hero.hero_class, hero.hero_level, count)
		for res in reses:
			var skill : Skill = Player.create_active_skill(res)
			skill.set_skill_owner(hero)
			var choose_skill_item : ChooseSkillItemUI = choose_skill_item_scene.instantiate()
			choose_skill_item.set_skill(skill)
			content_container.add_child(choose_skill_item)
			choose_skill_item.initialize()
			get_tree().create_timer(0.5).timeout.connect(skill.set_is_active.bind(false))


func set_hero(new_hero : Hero):
	hero = new_hero


func close_level_up():
	visible = false
	SignalManager.on_hero_return.emit(hero)
	#SignalManager.on_new_wave_start.emit()
	get_tree().create_timer(1).timeout.connect(queue_free)


func add_skill_to_hero(new_skill : Skill):
	if new_skill is PassiveSkill:
		hero.add_passive_skill(new_skill)
		new_skill.reparent(hero.passive_container)
		new_skill.parse_skill()
	elif new_skill is ActiveSkill:
		hero.add_active_skill(new_skill)
		new_skill.reparent(hero.active_container)
	hero.set_skills_is_active()
	close_level_up()


func change_stat(stat : String, amount : int):
	hero.set(stat, hero.get(stat) + amount)
	for skill in hero.actives:
		skill.recalculate_stats()
	hero.set_skills_is_active()
	close_level_up()
