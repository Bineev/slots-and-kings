extends ActiveSkill

class_name ActiveSkillSummon


var entity : Object

@onready var timer_deactivate: Timer = %timer_deactivate




func activate():
	create_entity()
	timer_deactivate.wait_time = skill_duration
	timer_deactivate.start()


func deactivate():
	pass


func create_entity():
	pass


func _on_timer_deactivate_timeout() -> void:
	deactivate()
