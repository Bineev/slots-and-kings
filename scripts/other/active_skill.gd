extends Skill

class_name ActiveSkill


@export var skill_res : SkillRes

@export var skill_cooldown : float
@export var skill_delay : float
@export var skill_flat_damage : int
@export var skill_tick_damage : int
@export var skill_tick_interval : int
@export var skill_duration : float
@export var skill_buff_amount : float
@export var skill_buff_stats : Array[String]
@export var skill_flat_heal : int
@export var skill_tick_heal : int
@export var skill_range : float


@onready var timer_skill_delay: Timer = %timer_skill_delay
@onready var skill_zone: SkillZone = %SkillZone
@onready var skill_anim: Sprite2D = %skill_anim
@onready var skill_anim_player: AnimationPlayer = %skill_anim_player


func initialize():
	await get_tree().process_frame
	skill_buff_stats = skill_res.skill_buff_stats
	skill_preview = skill_res.skill_preview
	skill_name = skill_res.skill_name
	skill_desc = skill_res.skill_desc
	skill_delay = skill_res.skill_delay
	# инициализируем статы
	# пересчитываем исходя из стат героя
	recalculate_stats()
	texture = skill_res.skill_preview
	skill_zone.set_skill(self)
	skill_zone.initialize()


func recalculate_stats():
	skill_cooldown = skill_res.skill_cooldown - skill_res.skill_cooldown / 20 * skill_owner.quickness
	skill_flat_damage = skill_res.skill_flat_damage + skill_res.skill_flat_damage / 4 * skill_owner.power 
	skill_tick_damage = skill_res.skill_tick_damage + skill_res.skill_tick_damage / 4 * skill_owner.power 
	skill_tick_interval = skill_res.skill_tick_interval - skill_res.skill_tick_interval / 10 * skill_owner.quickness
	skill_duration = skill_res.skill_duration + skill_res.skill_duration / 10 * skill_owner.grace
	skill_buff_amount = skill_res.skill_buff_amount + skill_res.skill_buff_amount / 15 * skill_owner.grace
	skill_flat_heal = skill_res.skill_flat_heal + skill_res.skill_flat_heal / 4 * skill_owner.grace
	skill_tick_heal = skill_res.skill_tick_heal + skill_res.skill_tick_heal / 4 * skill_owner.grace
	skill_range = skill_res.skill_range + skill_res.skill_range / 8 * skill_owner.mastery


func set_skill_cooldown(new_skill_cooldown : float):
	skill_cooldown = new_skill_cooldown


func set_skill_delay(new_skill_delay : float):
	skill_delay = new_skill_delay


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			skill_zone.previous_position = global_position
			skill_zone.set_active()
			skill_zone.show()
			# Calculate the offset from the object's origin to the mouse position
			#skill_zone.offset = get_global_mouse_position() - global_position
		else:
			start_skill()
			# вернуть зону в неактивное состояние
			# запустить КД скилла
			# Optional: Add logic here to "drop" the object or apply momentum


func start_skill():
	timer_skill_delay.wait_time = skill_delay
	timer_skill_delay.start()
	skill_anim_player.play('skill')
	skill_zone.hide()
	skill_zone.set_is_stopped(true)


func _on_timer_skill_delay_timeout() -> void:
	skill_zone.stop_working()
	activate()
