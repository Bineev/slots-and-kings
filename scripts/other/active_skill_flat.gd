extends ActiveSkill

class_name ActiveSkillFlat


func get_targets():
	return targets


func activate():
	for target in targets:
		target.get_damage(skill_flat_damage, self.skill_owner)
	clear_targets()
