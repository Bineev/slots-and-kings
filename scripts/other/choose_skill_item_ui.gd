extends VBoxContainer

class_name ChooseSkillItemUI


var skill : Skill

@onready var choose_button: Button = %choose_button
@onready var skill_container: Container = %skill_container


func set_skill(new_skill : Skill):
	skill = new_skill


func initialize():
	await get_tree().process_frame
	skill_container.add_child(skill)
	if skill is PassiveSkill:
		skill.is_active = false
	skill.initialize()
	skill.scale = Vector2(2, 2)
	SoundManager.play_ui(self, DataManager.sound_dict[DataManager.SoundType.SHOW_REWARDS])


func _on_choose_button_pressed() -> void:
	SoundManager.play_ui(self, DataManager.sound_dict[DataManager.SoundType.GET_REWARDS])
	SignalManager.on_choose_skill_done.emit(skill)
	if skill is PassiveSkill:
		skill.parse_skill()
