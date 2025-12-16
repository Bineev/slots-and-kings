extends ActiveSkill

class_name ActiveSkillSummon


var entity : Object

func activate():
	create_entity()
	timer_deactivate.wait_time = skill_duration
	timer_deactivate.start()


func deactivate():
	pass


func create_entity():
	pass


func _on_timer_deactivate_timeout() -> void:
	skill_zone.stop_working()
	deactivate()
	clear_targets()


func _on_timer_skill_delay_timeout() -> void:
	#if skill_duration == 0:
		#skill_zone.stop_working()
	activate()
