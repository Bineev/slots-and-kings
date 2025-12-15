extends Skill

class_name ActiveSkill


@export var skill_res : SkillRes
@export var skill_damage_type : DataManager.UnitType

@export var skill_cooldown : float
@export var skill_delay : float
@export var skill_flat_damage : int
@export var skill_tick_damage : int
@export var skill_tick_interval : int
@export var skill_duration : float
@export var skill_buff_stats : Array[Dictionary]
@export var skill_flat_heal : int
@export var skill_tick_heal : int
@export var skill_range : float

var is_on_cd : bool

@onready var timer_skill_delay: Timer = %timer_skill_delay
@onready var skill_zone: SkillZone = %SkillZone
@onready var skill_anim: Sprite2D = %skill_anim
@onready var skill_anim_player: AnimationPlayer = %skill_anim_player
@onready var timer_cd: Timer = %timer_cd
@onready var label_cd: Label = %label_cd
@onready var rect_cd_overlay: ColorRect = %rect_cd_overlay


func initialize():
	await get_tree().process_frame
	skill_buff_stats = skill_res.skill_buff_stats
	skill_preview = skill_res.skill_preview
	skill_name = skill_res.skill_name
	skill_desc = skill_res.skill_desc
	skill_delay = skill_res.skill_delay
	skill_damage_type = skill_res.skill_damage_type
	skill_target_type = skill_res.skill_target_type

	# инициализируем статы
	# пересчитываем исходя из стат героя
	recalculate_stats()
	texture = skill_res.skill_preview
	skill_anim.texture = skill_res.skill_anim
	timer_cd.wait_time = skill_cooldown
	skill_zone.set_skill(self)
	skill_zone.initialize()
	create_tooltip()


func _process(delta: float) -> void:
	update_label_cd()


func recalculate_stats():
	skill_cooldown = skill_res.skill_cooldown - skill_res.skill_cooldown / 20 * skill_owner.quickness
	skill_flat_damage = skill_res.skill_flat_damage + skill_res.skill_flat_damage / 4 * skill_owner.power 
	skill_tick_damage = skill_res.skill_tick_damage + skill_res.skill_tick_damage / 4 * skill_owner.power 
	skill_tick_interval = skill_res.skill_tick_interval - skill_res.skill_tick_interval / 10 * skill_owner.quickness
	skill_duration = skill_res.skill_duration + skill_res.skill_duration / 10 * skill_owner.grace
	#skill_res.skill_buff_amount + skill_res.skill_buff_amount / 15 * skill_owner.grace
	for dict in skill_buff_stats:
		if dict.stat_change_type == 0:
			dict.stat_change_amount = dict.stat_change_amount + dict.stat_change_amount / 10 * skill_owner.grace
		elif dict.stat_change_type == 1:
			if skill_damage_type == DataManager.UnitOwner.PLAYER:
				dict.stat_change_amount = dict.stat_change_amount + dict.stat_change_amount / 15 * skill_owner.grace
			else:
				dict.stat_change_amount = dict.stat_change_amount - dict.stat_change_amount / 15 * skill_owner.grace
	skill_flat_heal = skill_res.skill_flat_heal + skill_res.skill_flat_heal / 4 * skill_owner.grace
	skill_tick_heal = skill_res.skill_tick_heal + skill_res.skill_tick_heal / 4 * skill_owner.grace
	skill_range = skill_res.skill_range + skill_res.skill_range / 8 * skill_owner.mastery


func set_skill_cooldown(new_skill_cooldown : float):
	skill_cooldown = new_skill_cooldown


func set_skill_delay(new_skill_delay : float):
	skill_delay = new_skill_delay


func _on_gui_input(event: InputEvent) -> void:
	if is_on_cd:
		return
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
	skill_anim.global_position = skill_zone.global_position
	set_anim_scale_by_range()
	if skill_anim_player.get_animation('skill'):
		skill_anim_player.play('skill')
	skill_zone.hide()
	skill_zone.set_is_stopped(true)
	timer_cd.start()
	is_on_cd = true
	label_cd.show()
	rect_cd_overlay.show()


func _on_timer_skill_delay_timeout() -> void:
	skill_zone.stop_working()
	activate()


func _on_timer_cd_timeout() -> void:
	# возможно нужно переместить скилл аним
	is_on_cd = false
	label_cd.hide()
	rect_cd_overlay.hide()


func update_label_cd():
	label_cd.text = str(int(timer_cd.time_left))


func clear_targets():
	targets.clear()


func create_tooltip():
	await get_tree().process_frame
	tooltip = tooltip_scene.instantiate()
	tooltip.set_tooltip_owner(self)
	tooltip.set_entity_name(skill_name)
	tooltip.set_entity_desc(skill_desc)
	var skill_stats : String
	# генерируем инфу
	if skill_cooldown > 0:
		skill_stats += 'откат: %d\n' % skill_cooldown
	if skill_flat_damage > 0 or skill_tick_damage > 0:
		skill_stats += 'тип урона: %s\n' % DataManager.unit_type_to_damage_type_table[skill_damage_type]
	if skill_flat_damage > 0:
		skill_stats += 'урон: %d\n' % skill_flat_damage
	if skill_flat_heal > 0:
		skill_stats += 'лечение: %d\n' % skill_flat_heal
	if skill_tick_damage > 0:
		skill_stats += 'урон за тик: %d\n' % skill_tick_damage
	if skill_tick_heal > 0:
		skill_stats += 'лечение за тик: %d\n' % skill_tick_heal
	if skill_tick_interval > 0:
		skill_stats += 'интервал между эффектами: %.1f\n' % skill_tick_interval
	#if skill_buff_amount > 0:
		#skill_stats += 'величина бафа: %.1f%\n' % ((skill_buff_amount - 1) * 100)
	if skill_duration > 0:
		skill_stats += 'длительность: %.1f\n' % skill_duration
	for dict in skill_buff_stats:
		var stat_info : String = DataManager.default_stats_to_rus[dict.stat_name] + ': '
		if dict.stat_change_type == 0:
			if skill_target_type == DataManager.UnitOwner.PLAYER:
				stat_info += '+%s' % str(int(dict.stat_change_amount))
			if skill_target_type == DataManager.UnitOwner.ENEMY:
				stat_info += '-%s' % str(int(dict.stat_change_amount))
		elif dict.stat_change_type == 1:
			if skill_target_type == DataManager.UnitOwner.PLAYER:
				stat_info += '+%s%' % str(int(dict.stat_change_amount * 100))
			if skill_target_type == DataManager.UnitOwner.ENEMY:
				stat_info += '-%s%' % str(int(dict.stat_change_amount * 100))
		skill_stats += stat_info + '\n'

	tooltip.set_stats(skill_stats)
	## create subtooltips
	#for slot_res in slot_resources:
		#var subtooltip : SubTooltip = subtooltip_scene.instantiate()
		#subtooltip.set_entity_name(slot_res.slot_name)
		#subtooltip.set_entity_desc(slot_res.slot_description)
		#subtooltip.set_preview_texture(slot_res.slot_sprite)
		#tooltip.add_subtooltip(subtooltip)
	tooltip.visible = false


func set_anim_scale_by_range():
	if not skill_anim_player.get_animation("skill") or not skill_anim.texture:
		return
	var current_scale : float = skill_range / skill_res.skill_anim.get_height() * 1.5
	skill_anim.scale = Vector2(current_scale, current_scale)


func apply_damage(current_target : Unit):
	# таргета нет, то выходим
	if not current_target or not is_instance_valid(current_target) or current_target.get_state() == DataManager.UnitState.DIED or current_target.get_state() == DataManager.UnitState.DEAD:
		return
	
	var attack : float = skill_flat_damage if skill_flat_damage > 0 else skill_tick_damage
	
	# проверка на хит (мдля маг урона не работает эвейд)
	var hit_chance : float = (100 - current_target.current_evade) / 100 if skill_damage_type != DataManager.UnitType.MAGE else 1
	var hit_check : float = randf()
	var is_hit : bool = hit_check <= hit_chance
	if not is_hit:
		# показать popup "промах"
		current_target.show_miss()
		return
	
	# проверка на крит
	var crit_chance : float = skill_owner.mastery * 8 / 100
	var crit_check : float = randf()
	var is_crit : bool = crit_check <= crit_chance
	if is_crit:
		# поменять цвет попапа и размер
		attack += attack * (skill_owner.mastery * 10 / 100)

	if not current_target or not is_instance_valid(current_target):
		return
	# проверка на броню
	var armor = current_target.current_armor if current_target.current_armor < DataManager.max_armor else DataManager.max_armor
	var magic_defence = current_target.current_magic_defence if current_target.current_magic_defence < DataManager.max_armor else DataManager.max_armor
	if skill_damage_type == DataManager.UnitType.MAGE:
		attack *= ((100 - magic_defence) / 100)
	elif skill_damage_type == DataManager.UnitType.PHYS:
		attack *= ((100 - armor) / 100)

	if not current_target or not is_instance_valid(current_target):
		return

	# применить урон к цели
	current_target.get_damage(round(attack), self, is_crit)
	print('%s наносит %f урона %s' % [skill_owner.hero_name, attack, current_target.unit_name])
