extends ActiveSkill

class_name ActiveSkillFlat


func get_targets():
	return targets


func activate():
	for target in targets:
		apply_damage(target)
	clear_targets()
