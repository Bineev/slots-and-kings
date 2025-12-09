extends Area2D

class_name FightPoint


@export var is_filled : bool


func _on_body_entered(body: Node2D) -> void:
	var unit : Unit = body
	unit.change_state(DataManager.UnitState.ATTACK)
	unit.attack_castle()
	get_tree().create_timer(unit.current_attack_speed / 2).timeout.connect(unit.get_damage.bind(unit.actual_health, null))
	is_filled = false
