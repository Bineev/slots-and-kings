extends Skill

class_name PassiveSkill


@export var skill_res : SkillRes
@export var skill_passive_type : DataManager.PassiveSkillType
@export var skill_damage_type : DataManager.UnitType
@export var skill_buff_stats : Array[Dictionary]


func initialize():
	await get_tree().process_frame
	skill_tier = skill_res.skill_tier
	skill_buff_stats = skill_res.skill_buff_stats
	skill_preview = skill_res.skill_preview
	skill_name = skill_res.skill_name
	skill_desc = skill_res.skill_desc
	skill_damage_type = skill_res.skill_damage_type
	skill_target_type = skill_res.skill_target_type
	# инициализируем статы
	# пересчитываем исходя из стат героя
	recalculate_stats()
	texture = skill_res.skill_preview
	create_tooltip()


func recalculate_stats():
	pass


func create_tooltip():
	pass
