extends Skill

class_name ActiveSkill


@export var skill_res : SkillRes
@export var skill_damage_type : DataManager.UnitType

@export var is_void_zone : bool
@export var is_trap : bool
@export var skill_cooldown : float
@export var skill_delay : float
@export var skill_flat_damage : int
@export var skill_tick_damage : int
@export var skill_tick_interval : int
@export var skill_duration : float
@export var skill_buff_stats : Array
@export var skill_flat_heal : int
@export var skill_tick_heal : int
@export var skill_range : float

var is_on_cd : bool
var was_trap : bool
var unit_stat_changes_dict : Dictionary[Unit, Dictionary]

@onready var timer_skill_delay: Timer = %timer_skill_delay
@onready var skill_zone: SkillZone = %SkillZone
@onready var skill_anim: Sprite2D = %skill_anim
@onready var skill_anim_player: AnimationPlayer = %skill_anim_player
@onready var timer_cd: Timer = %timer_cd
@onready var label_cd: Label = %label_cd
@onready var rect_cd_overlay: ColorRect = %rect_cd_overlay
@onready var timer_deactivate: Timer = %timer_deactivate
@onready var timer_tick: Timer = %timer_tick

@export var unit_slots_scenes : Array[Array]

var slots : Array[Slot]
var units : Array[Unit]
var is_active : bool = false


func create_entity():
	var factory : UnitFactory = Player.get_unit_factory()
	var current_offset : Vector2
	for unit_pack in unit_slots_scenes:
		for slot_res in unit_pack:
			var slot : Slot = Player.create_slot_scene(slot_res).instantiate()
			add_child(slot)
			slot.hide()
			slot.initialize()
			slots.append(slot)
		await get_tree().process_frame
		var unit : Unit = factory.get_unit(slots)
		units.append(unit)
		var unit_position : Vector2
		if unit_slots_scenes.size() == 1:
			unit_position =  skill_zone.global_position
		else:
			unit_position = skill_zone.global_position + current_offset
			current_offset = Vector2(randf_range(-skill_range / 2, skill_range / 2), randf_range(-skill_range / 2, skill_range / 2))
		SignalManager.on_add_unit_from_skill.emit(unit, unit_position)
		slots.clear()
		#get_tree().create_timer(1).timeout.connect(remove_slots)


func remove_slots():
	for slot in slots:
		if slot and is_instance_valid(slot):
			slot.queue_free()


func initialize():
	await get_tree().process_frame
	skill_tier = skill_res.skill_tier
	skill_buff_stats = skill_res.skill_buff_stats
	skill_preview = skill_res.skill_preview
	skill_name = skill_res.skill_name
	skill_desc = skill_res.skill_desc
	skill_delay = skill_res.skill_delay
	is_void_zone = skill_res.is_void_zone
	is_trap = skill_res.is_trap
	skill_damage_type = skill_res.skill_damage_type
	skill_target_type = skill_res.skill_target_type
	unit_slots_scenes = skill_res.skill_slot_scenes
	# инициализируем статы
	# пересчитываем исходя из стат героя
	recalculate_stats()
	skill_anim_player.get_animation('skill').loop_mode = Animation.LOOP_NONE
	texture = skill_res.skill_preview
	skill_anim.texture = skill_res.skill_anim
	timer_cd.wait_time = skill_cooldown
	skill_zone.set_skill(self)
	skill_zone.initialize()
	#create_tooltip()
	if is_void_zone or is_trap:
		skill_anim.z_index
	if is_void_zone:
		if skill_anim_player.get_animation('skill'):
			skill_anim_player.get_animation('skill').loop_mode = Animation.LOOP_LINEAR
	if is_trap:
		skill_delay = skill_cooldown - skill_duration - 1
	#skill_anim_player.speed_scale = DataManager.action_speed_coeff


func reinit():
	skill_anim_player.get_animation('skill').loop_mode = Animation.LOOP_NONE
	if is_void_zone:
		if skill_anim_player.get_animation('skill'):
			skill_anim_player.get_animation('skill').loop_mode = Animation.LOOP_LINEAR


func _process(delta: float) -> void:
	update_label_cd()


func after_level_up_stat():
	pass


func recalculate_stats():
	skill_cooldown = skill_res.skill_cooldown - skill_res.skill_cooldown / 20 * skill_owner.quickness
	skill_flat_damage = skill_res.skill_flat_damage + skill_res.skill_flat_damage / 6 * skill_owner.power 
	skill_tick_damage = skill_res.skill_tick_damage + skill_res.skill_tick_damage / 6 * skill_owner.power 
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
	skill_flat_heal = skill_res.skill_flat_heal + skill_res.skill_flat_heal / 6 * skill_owner.grace
	skill_tick_heal = skill_res.skill_tick_heal + skill_res.skill_tick_heal / 6 * skill_owner.grace
	skill_range = skill_res.skill_range + skill_res.skill_range / 8 * skill_owner.mastery


func set_skill_cooldown(new_skill_cooldown : float):
	skill_cooldown = new_skill_cooldown


func set_skill_delay(new_skill_delay : float):
	skill_delay = new_skill_delay


func _on_gui_input(event: InputEvent) -> void:
	if is_on_cd or not is_active:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			skill_zone.start_working()
			# Calculate the offset from the object's origin to the mouse position
			#skill_zone.offset = get_global_mouse_position() - global_position
		else:
			start_skill()
			# вернуть зону в неактивное состояние
			# запустить КД скилла
			# Optional: Add logic here to "drop" the object or apply momentum


func activate():
	if not is_void_zone and unit_slots_scenes.size() == 0 and targets.size() == 0:
		skill_zone.stop_working()
		return
	SoundManager.play_ui(self, DataManager.sound_dict[DataManager.SoundType.MAGE])
	if is_void_zone:
		skill_anim.modulate = Color(1, 1, 1, 0.8)
	else:
		skill_anim.modulate = Color(1, 1, 1, 1)
	# проверяем, продолжительный ли это скилл
	if skill_duration > 0:
		timer_deactivate.wait_time = skill_duration
	else:
		timer_deactivate.wait_time = 0.01
	timer_deactivate.start()
	# проверяем, нужно ли нанести урон сразу
	if skill_flat_damage > 0:
		for target in targets:
			apply_damage(target)
	# проверяем, есть ли изменение стат (мгновенное)
	if skill_buff_stats.size() > 0 and not is_void_zone:
		# так как это не войд зона, то скилл зон надо отключить (чтобы не добавлялись юниты)
		skill_zone.stop_working()
		for target in targets:
			apply_stats(target)
	elif skill_buff_stats.size() > 0 and is_void_zone:
		for target in targets:
			apply_stats(target)
	# проверяем, есть ли прямое лечение
	if skill_flat_heal > 0:
		for target in targets:
			target.get_health(skill_flat_heal)
	# проверяем, есть ли тик
	if skill_tick_interval > 0:
		for target in targets:
			apply_tick(target)
		timer_tick.wait_time = skill_tick_interval
		timer_tick.start()
	# если это создание юнита, то создаем
	if unit_slots_scenes.size() > 0:
		create_entity()


func apply_tick(target : Unit):
	if not target or not is_instance_valid(target) or target.unit_state == DataManager.UnitState.DIED or target.unit_state == DataManager.UnitState.DEAD:
		return
	if skill_tick_damage > 0:
		apply_damage(target)
	if skill_tick_heal > 0:
		target.get_health(skill_tick_heal)
	


func start_skill():
	if not is_trap:
		skill_anim.hframes = 6
	timer_skill_delay.wait_time = skill_delay
	timer_skill_delay.start()
	skill_anim.global_position = skill_zone.global_position
	set_anim_scale_by_range()
	if skill_anim_player.get_animation('skill'):
		if is_trap and skill_anim_player.get_animation('trap'):
			skill_anim.modulate = Color(1, 1, 1, 0.5)
			skill_anim_player.play('trap')
		else:
			skill_anim_player.play('skill')
	skill_zone.hide()
	skill_zone.set_is_stopped(true)
	timer_cd.start()
	is_on_cd = true
	label_cd.show()
	rect_cd_overlay.show()
	if is_trap and targets.size() > 0:
		if skill_anim_player.get_animation('skill'):
			skill_anim.modulate = Color(1, 1, 1, 0.8)
			skill_anim_player.play('skill')
		timer_skill_delay.stop()
		timer_skill_delay.wait_time = 0.5
		timer_skill_delay.start()
		is_trap = false
		was_trap = true


func _on_timer_skill_delay_timeout() -> void:
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
	#await get_tree().process_frame
	tooltip = tooltip_scene.instantiate()
	tooltip.set_tooltip_owner(self)
	tooltip.set_entity_name(skill_name)
	tooltip.set_entity_desc(skill_desc)
	tooltip.set_entity_tier(skill_tier)
	var skill_stats : String
	# генерируем инфу
	if skill_cooldown > 0:
		skill_stats += 'откат: %d с\n' % skill_cooldown
	if skill_flat_damage > 0:
		skill_stats += 'урон: %d\n' % skill_flat_damage
	if skill_tick_damage > 0:
		skill_stats += 'урон: %d\n' % skill_tick_damage
	if skill_flat_damage > 0 or skill_tick_damage > 0:
		skill_stats += 'тип: %s\n' % DataManager.unit_type_to_damage_type_table[skill_damage_type]
	if skill_flat_heal > 0:
		skill_stats += 'лечение: %d\n' % skill_flat_heal
	if skill_tick_heal > 0:
		skill_stats += 'лечение: %d\n' % skill_tick_heal
	if skill_tick_interval > 0:
		skill_stats += 'интервал: %.1f\n' % skill_tick_interval
	#if skill_buff_amount > 0:
		#skill_stats += 'величина бафа: %.1f%\n' % ((skill_buff_amount - 1) * 100)
	if skill_duration > 0:
		skill_stats += 'длительность: %.1f с\n' % skill_duration
	for dict in skill_buff_stats:
		var stat_info : String = DataManager.default_stats_to_rus[dict.stat_name] + ': '
		if dict.stat_change_type == 0:
			if skill_target_type == DataManager.UnitOwner.PLAYER:
				stat_info += '+%s' % str(int(dict.stat_change_amount))
			if skill_target_type == DataManager.UnitOwner.ENEMY:
				stat_info += '%s' % str(int(dict.stat_change_amount))
		elif dict.stat_change_type == 1:
			if skill_target_type == DataManager.UnitOwner.PLAYER:
				stat_info += '+%s%%' % str(int(dict.stat_change_amount * 100))
			if skill_target_type == DataManager.UnitOwner.ENEMY:
				stat_info += '-%s%%' % str(int(100 - dict.stat_change_amount * 100))
		skill_stats += stat_info + '\n'

	tooltip.set_stats(skill_stats)
	## create subtooltips
	#for slot_res in slot_resources:
		#var subtooltip : SubTooltip = subtooltip_scene.instantiate()
		#subtooltip.set_entity_name(slot_res.slot_name)
		#subtooltip.set_entity_desc(slot_res.slot_description)
		#subtooltip.set_preview_texture(slot_res.slot_sprite)
		#tooltip.add_subtooltip(subtooltip)
	#tooltip.visible = false


func set_anim_scale_by_range():
	if not skill_anim_player.get_animation("skill") or not skill_anim.texture:
		return
	var current_scale : float = skill_range * 2 / skill_res.skill_anim.get_height()
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


func deactivate():
	if skill_anim_player.get_animation('skill'):
		#skill_anim_player.stop()
		skill_anim_player.play("RESET")
	#skill_anim.hide()
	skill_zone.stop_working()
	# если создавался юнит, но удалить
	for unit in units:
		if unit and is_instance_valid(unit):
			unit.get_damage(1000000, skill_owner)
	units.clear()
	# если не войд зона и менялись статы, то вернуть как было
	# если это была единоразовая акция, то возвращаем статы из старых таргетов
	# если это была войд зона, то на момент отключения таргеты будут верные (если не будет делэев)
	if skill_buff_stats.size() > 0:
		for target in targets:
			if target and is_instance_valid(target):
				back_stats(target)
	# остановить тик таймер
	timer_tick.stop()
	clear_targets()
	unit_stat_changes_dict.clear()
	if was_trap:
		is_trap = true


func _on_timer_deactivate_timeout() -> void:
	deactivate()


func apply_change_stat(current_unit : Unit):
	for dict in skill_buff_stats:
		var current_stat_amount = current_unit.get('current_%s' % dict.stat_name)
		if dict.stat_change_type == 0:
			var change_amount = current_stat_amount + dict.stat_change_amount
			# защита от отрицательных значений
			if change_amount < 0:
				change_amount = -current_stat_amount
			current_unit.set('current_%s' % dict.stat_name, current_unit.get('current_%s' % dict.stat_name) + change_amount)
			if not unit_stat_changes_dict.get(current_unit):
				unit_stat_changes_dict.set(current_unit, {dict.stat_name : change_amount})
			else:
				unit_stat_changes_dict[current_unit].set(dict.stat_name, change_amount)
		elif dict.stat_change_type == 1:
			current_unit.set('current_%s' % dict.stat_name, current_unit.get('current_%s' % dict.stat_name) * dict.stat_change_amount)
			if dict.stat_change_amount != 0:
				if not unit_stat_changes_dict.get(current_unit):
					unit_stat_changes_dict.set(current_unit, {dict.stat_name : dict.stat_change_amount})
				else:
					unit_stat_changes_dict[current_unit].set(dict.stat_name, dict.stat_change_amount)
			else:
				if not unit_stat_changes_dict.get(current_unit):
					unit_stat_changes_dict.set(current_unit, {dict.stat_name : current_stat_amount})
				else:
					unit_stat_changes_dict[current_unit].set(dict.stat_name, current_stat_amount)


func back_stat_to_default(current_unit : Unit):
	for dict in skill_buff_stats:
		if not unit_stat_changes_dict.has(current_unit) or not unit_stat_changes_dict[current_unit].has(dict.stat_name):
			continue
		if dict.stat_change_type == 0:
			current_unit.set('current_%s' % dict.stat_name, current_unit.get('current_%s' % dict.stat_name) - unit_stat_changes_dict[current_unit][dict.stat_name])
		elif dict.stat_change_type == 1:
			if dict.stat_change_amount == 0:
				current_unit.set('current_%s' % dict.stat_name, current_unit.get('current_%s' % dict.stat_name) + unit_stat_changes_dict[current_unit][dict.stat_name])
			else:
				current_unit.set('current_%s' % dict.stat_name, current_unit.get('current_%s' % dict.stat_name) / unit_stat_changes_dict[current_unit][dict.stat_name])
		unit_stat_changes_dict[current_unit].erase(dict.stat_name)


func _on_timer_tick_timeout() -> void:
	for target in targets:
		apply_tick(target)


func apply_stats(target : Unit):
	apply_change_stat(target)
	if skill_target_type == DataManager.UnitOwner.PLAYER:
		target.show_buff()
	else:
		target.show_debuff()
	#target.hide_tooltip()
	#target.parse_stats()
	#target.create_tooltip()


func back_stats(target : Unit):
	if target and is_instance_valid(target):
		back_stat_to_default(target)
		target.hide_status()
		#target.hide_status()
		#target.hide_tooltip()
		#target.parse_stats()
		#target.create_tooltip()


func _on_skill_anim_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == 'skill':
		skill_anim_player.play("RESET")


func set_is_active(new_is_active : bool):
	is_active = new_is_active


func _on_skill_anim_player_animation_started(anim_name: StringName) -> void:
	print(anim_name)
	print(skill_anim_player.get_animation(anim_name).loop_mode)
