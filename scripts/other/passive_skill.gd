extends Skill

class_name PassiveSkill


@export var skill_res : PassiveSkillRes
@export var skill_passive_type : DataManager.PassiveSkillType
@export var skill_damage_type : DataManager.UnitType
@export var skill_unit_name : String
@export var skill_buff_stats : Array
@export var skill_resources : Array
@export var skill_resources_amounts : Array
@export var skill_health_amount : int
@export var skill_wave_count : int
@export var get_something_time : int

var is_active : bool = true

@onready var timer_get_res: Timer = %timer_get_res
@onready var timer_get_health: Timer = %timer_get_health


func initialize():
	await get_tree().process_frame
	skill_tier = skill_res.skill_tier
	skill_buff_stats = skill_res.skill_buff_stats
	skill_preview = skill_res.skill_preview
	skill_name = tr(skill_res.skill_name)
	skill_desc = tr(skill_res.skill_desc)
	skill_damage_type = skill_res.skill_damage_type
	skill_target_type = skill_res.skill_target_type
	skill_resources = skill_res.skill_resources
	skill_resources_amounts = skill_res.skill_resources_amounts
	skill_health_amount = skill_res.skill_health_amount
	skill_wave_count = skill_res.skill_wave_count
	skill_passive_type = skill_res.skill_passive_type
	get_something_time = skill_res.get_something_time
	skill_unit_name = skill_res.skill_unit_name
	# пересчитываем исходя из стат героя
	recalculate_stats()
	texture = skill_res.skill_preview
	#create_tooltip()
	#if is_active:
		#parse_skill()


func recalculate_stats():
	pass


func create_tooltip():
	#await get_tree().process_frame
	tooltip = tooltip_scene.instantiate()
	tooltip.set_tooltip_owner(self)
	tooltip.set_entity_name(skill_name)
	tooltip.set_entity_desc(skill_desc)
	tooltip.set_entity_tier(skill_tier)


func parse_skill():
	match skill_passive_type:
		DataManager.PassiveSkillType.RES_BY_WAVE:
			SignalManager.on_wave_done.connect(add_res_by_wave)
		DataManager.PassiveSkillType.HEALTH_BY_WAVE:
			SignalManager.on_wave_done.connect(add_health_by_wave)
		DataManager.PassiveSkillType.RES_BY_TIME:
			timer_get_res.wait_time = get_something_time
			timer_get_res.start()
		DataManager.PassiveSkillType.HEALTH_BY_TIME:
			timer_get_health.wait_time = get_something_time
			timer_get_health.start()
		DataManager.PassiveSkillType.UNIT_NAME:
			apply_stats()
			SignalManager.on_unit_created.connect(apply_stat)
		DataManager.PassiveSkillType.UNIT_TYPE:
			apply_stats()
			SignalManager.on_unit_created.connect(apply_stat)


func add_res_by_wave():
	var current_wave = Player.get_current_wave_count()
	if current_wave % skill_wave_count == 0:
		for i in range(skill_resources.size()):
			Player.get_res(skill_resources[i], skill_resources_amounts[i])


func add_health_by_wave():
	var current_wave = Player.get_current_wave_count()
	if current_wave % skill_wave_count == 0:
		Player.get_heal(skill_health_amount)


func add_res():
	for i in range(skill_resources.size()):
		Player.get_res(skill_resources[i], skill_resources_amounts[i])


func add_health():
	Player.get_heal(skill_health_amount)


func _on_timer_get_res_timeout() -> void:
	add_res()

func _on_timer_get_health_timeout() -> void:
	add_health()


func apply_stats():
	var units : Array[Unit] = Player.get_player_units() if skill_target_type == DataManager.UnitOwner.PLAYER else Player.get_enemies()
	#if skill_passive_type == DataManager.PassiveSkillType.UNIT_TYPE:
		#units = units.filter(func(new_unit : Unit): return new_unit.unit_types.has(skill_damage_type))
	#if skill_passive_type == DataManager.PassiveSkillType.UNIT_NAME:
		#units = units.filter(func(new_unit : Unit): return new_unit.unit_name == skill_unit_name)
	#print(units)
	for unit in units:
		if unit and is_instance_valid(unit):
			apply_stat(unit)


func apply_stat(current_unit : Unit):
	await get_tree().process_frame
	if current_unit.unit_owner != skill_target_type:
		return
	if skill_passive_type == DataManager.PassiveSkillType.UNIT_TYPE and not current_unit.unit_types.has(skill_damage_type):
		return
	# вот здесь нужна проверить имя, но учитывая локализацию
	var current_locale : String = TranslationServer.get_locale()
	var current_skill_unit_name : String = skill_unit_name
	# TODO имя к кому применяется не работает из-за локали
	# BUG поменять первую букву
	if skill_unit_name != '':
		match current_locale:
			'en_US':
				current_skill_unit_name = DataManager.unit_name_ru_to_en[capitalize_first(skill_unit_name)]
	
	if skill_passive_type == DataManager.PassiveSkillType.UNIT_NAME and not current_unit.unit_name.to_lower() == current_skill_unit_name.to_lower():
		return
	for dict in skill_buff_stats:
		if dict.stat_change_type == 0:
			if dict.stat_name == 'health_regen_interval':
				if current_unit.get('current_%s' % dict.stat_name) > dict.stat_change_amount:
					current_unit.set('current_%s' % dict.stat_name, dict.stat_change_amount)
				#else:
					#current_unit.set('current_%s' % dict.stat_name, current_unit.get('current_%s' % dict.stat_name) + dict.stat_change_amount)
				current_unit.update_health_regen_interval()
			else:
				current_unit.set('current_%s' % dict.stat_name, current_unit.get('current_%s' % dict.stat_name) + dict.stat_change_amount)
		elif dict.stat_change_type == 1:
			current_unit.set('current_%s' % dict.stat_name, current_unit.get('current_%s' % dict.stat_name) * dict.stat_change_amount)
	#current_unit.hide_tooltip()
	#current_unit.parse_stats()
	#current_unit.create_tooltip()


func capitalize_first(s: String) -> String:
	if s.is_empty():
		return s
	return s.left(1).to_upper() + s.substr(1)
