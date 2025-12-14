extends ActiveSkill

class_name ActiveSkillChangeStat


@onready var timer_deactivate: Timer = %timer_deactivate


func get_targets():
	return targets


func activate():
	timer_deactivate.wait_time = skill_duration
	timer_deactivate.start()
	for target in targets:
		apply_change_stat(target)
		if skill_target_type == DataManager.UnitOwner.PLAYER:
			target.show_buff()
		else:
			target.show_debuff()


func deactivate():
	for target in targets:
		back_stat_to_default(target)


func apply_change_stat(unit : Unit):
	unit.get('current_') % 


func back_stat_to_default(unit : Unit):
	pass
