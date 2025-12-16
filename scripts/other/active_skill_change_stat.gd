extends ActiveSkill

class_name ActiveSkillChangeStat


func get_targets():
	return targets


func activate():
	if targets.size() == 0:
		return
	timer_deactivate.wait_time = skill_duration
	timer_deactivate.start()
	for target in targets:
		apply_change_stat(target)
		if skill_target_type == DataManager.UnitOwner.PLAYER:
			target.show_buff()
		else:
			target.show_debuff()
		target.hide_tooltip()
		target.parse_stats()
		target.create_tooltip()


func deactivate():
	for target in targets:
		if target and is_instance_valid(target):
			back_stat_to_default(target)
			target.hide_status()
			target.hide_tooltip()
			target.parse_stats()
			target.create_tooltip()
	clear_targets()


func apply_change_stat(unit : Unit):
	for dict in skill_buff_stats:
		if dict.stat_change_type == 0:
			unit.set('current_%s' % dict.stat_name, unit.get('current_%s' % dict.stat_name) + dict.stat_change_amount)
			print(unit.get('current_%s' % dict.stat_name))
		elif dict.stat_change_type == 1:
			unit.set('current_%s' % dict.stat_name, unit.get('current_%s' % dict.stat_name) * dict.stat_change_amount)


func back_stat_to_default(unit : Unit):
	for dict in skill_buff_stats:
		if dict.stat_change_type == 0:
			unit.set('current_%s' % dict.stat_name, unit.get('current_%s' % dict.stat_name) - dict.stat_change_amount)
		elif dict.stat_change_type == 1:
			unit.set('current_%s' % dict.stat_name, unit.get('current_%s' % dict.stat_name) / dict.stat_change_amount)


func _on_timer_deactivate_timeout() -> void:
	deactivate()
