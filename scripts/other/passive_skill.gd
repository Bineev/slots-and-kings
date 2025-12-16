extends Skill

class_name PassiveSkill


@export var skill_res : PassiveSkillRes
@export var skill_passive_type : DataManager.PassiveSkillType
@export var skill_damage_type : DataManager.UnitType
@export var skill_buff_stats : Array
@export var skill_resources : Array
@export var skill_resources_amounts : Array
@export var skill_health_amount : int
@export var skill_wave_count : int
@export var get_something_time : int

@onready var timer_get_res: Timer = %timer_get_res
@onready var timer_get_health: Timer = %timer_get_health


func initialize():
	await get_tree().process_frame
	skill_tier = skill_res.skill_tier
	skill_buff_stats = skill_res.skill_buff_stats
	skill_preview = skill_res.skill_preview
	skill_name = skill_res.skill_name
	skill_desc = skill_res.skill_desc
	skill_damage_type = skill_res.skill_damage_type
	skill_target_type = skill_res.skill_target_type
	skill_resources = skill_res.skill_resources
	skill_resources_amounts = skill_res.skill_resources_amounts
	skill_health_amount = skill_res.skill_health_amount
	skill_wave_count = skill_res.skill_wave_count
	skill_passive_type = skill_res.skill_passive_type
	get_something_time = skill_res.get_something_time
	# пересчитываем исходя из стат героя
	recalculate_stats()
	texture = skill_res.skill_preview
	create_tooltip()
	parse_skill()


func recalculate_stats():
	pass


func create_tooltip():
	await get_tree().process_frame
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
		DataManager.PassiveSkillType.UNIT_STAT:
			pass
		DataManager.PassiveSkillType.UNIT_TYPE:
			pass


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
	pass


func _on_timer_get_health_timeout() -> void:
	pass # Replace with function body.
