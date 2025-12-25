extends Area2D

class_name FightPoint


@export var is_filled : bool


func _on_body_entered(body: Node2D) -> void:
	var unit : Unit = body
	if unit.fight_point == self:
		unit.change_state(DataManager.UnitState.ATTACK)
		unit.timer_regen.stop()
		get_tree().create_timer(unit.current_attack_speed / DataManager.action_speed_coeff / 4).timeout.connect(unit.attack_castle)
		get_tree().create_timer(unit.current_attack_speed / DataManager.action_speed_coeff / 1.5).timeout.connect(unit.get_damage.bind(unit.actual_health, null))
		is_filled = false
