extends Area2D

class_name Slot


@export var highlight_texture : Texture2D = preload('res://img/slots/highlight_texture.png')
@export var unit_back_texture : Texture2D = preload('res://img/slots/slot_back.png')

@export var back_upgrades_dict : Dictionary = {
	DataManager.EntityTier.T0 : preload('res://img/slots/upgrade_back_T1.png'),
	DataManager.EntityTier.T1 : preload('res://img/slots/upgrade_back_T1.png'),
	DataManager.EntityTier.T2 : preload('res://img/slots/upgrade_back_T2.png'),
	DataManager.EntityTier.T3 : preload('res://img/slots/upgrade_back_T3.png'),
	DataManager.EntityTier.T4 : preload('res://img/slots/upgrade_back_T4.png'),
}

@export var back_perc_dict : Dictionary = {
	DataManager.EntityTier.T0 : preload('res://img/slots/perc_back_T1.png'),
	DataManager.EntityTier.T1 : preload('res://img/slots/perc_back_T1.png'),
	DataManager.EntityTier.T2 : preload('res://img/slots/perc_back_T2.png'),
	DataManager.EntityTier.T3 : preload('res://img/slots/perc_back_T3.png'),
	DataManager.EntityTier.T4 : preload('res://img/slots/perc_back_T4.png'),
}

@export var back_ult_dict : Dictionary = {
	DataManager.EntityTier.T0 : preload('res://img/slots/ult_back_T1.png'),
	DataManager.EntityTier.T1 : preload('res://img/slots/ult_back_T1.png'),
	DataManager.EntityTier.T2 : preload('res://img/slots/ult_back_T2.png'),
	DataManager.EntityTier.T3 : preload('res://img/slots/ult_back_T3.png'),
	DataManager.EntityTier.T4 : preload('res://img/slots/ult_back_T4.png'),
}

@export var slot_type : DataManager.SlotType
@export var slot_res : SlotRes
@export var slot_content_scene : PackedScene
@export var entity_tier : DataManager.EntityTier
@export var shader : Shader
@export var tooltip_scene : PackedScene
@export var unit_attack_type : DataManager.AttackType
@export var unit_projectile_texture : Texture2D
@export var before_can_swap_position : Vector2
@export var slot_particle_scene : PackedScene

var slot_name : String
var slot_description : String
var slot_unit_tier : DataManager.UnitTier
var unit_types : Array[DataManager.UnitType]
var unit_cost : int
var tooltip : Tooltip
var is_tooltip_shown : bool
var is_on_remover_UI : bool
var is_in_swap_state : bool
var slot_for_swap : Slot
var previous_z_index : int
var is_can_swap : bool = true
var current_swap_slots : Array[Slot]

@onready var slot_sprite: AnimatedSprite2D = %slot_sprite
@onready var slot_anim_player: AnimationPlayer = %slot_anim_player
@onready var highlight_sprite: Sprite2D = %highlight_sprite
@onready var shader_rect: ColorRect = %shader_rect
@onready var slot_back_sprite: Sprite2D = %slot_back_sprite


func _process(delta: float) -> void:
	if is_in_swap_state:
		#global_position = Vector2(global_position.x, clampf(get_global_mouse_position().y, before_can_swap_position.y - 16, before_can_swap_position.y + 16))
		global_position = Vector2(global_position.x, get_global_mouse_position().y)
		if get_global_mouse_position().x > global_position.x + 8 or get_global_mouse_position().x < global_position.x - 8:
			is_in_swap_state = false
			current_swap_slots.clear()
			global_position = before_can_swap_position
			Player.set_is_can_swap(true)
		#if slot_for_swap:
			#if slot_for_swap.global_position.y + 12 < global_position.y:
				#move_slots()


func initialize():
	await get_tree().process_frame
	slot_name = tr(slot_res.slot_name)
	slot_description = tr(slot_res.slot_description)
	entity_tier = slot_res.entity_tier
	slot_type = slot_res.slot_type
	if slot_type == DataManager.SlotType.UPGRADE:
		slot_back_sprite.texture = back_upgrades_dict[entity_tier]
	if slot_type == DataManager.SlotType.PERC:
		slot_back_sprite.texture = back_perc_dict[entity_tier]
	if slot_type == DataManager.SlotType.ULT:
		slot_back_sprite.texture = back_ult_dict[entity_tier]
	slot_sprite.sprite_frames = SpriteFrames.new()
	slot_sprite.sprite_frames.add_frame("default", slot_res.slot_sprite)
	if slot_type == DataManager.SlotType.UNIT and slot_res is SlotUnitRes:
		slot_unit_tier = slot_res.unit_tier
		unit_types = slot_res.unit_types
		unit_cost = slot_res.unit_cost
		unit_attack_type = slot_res.unit_attack_type
		unit_projectile_texture = slot_res.unit_projectile_texture
	#create_tooltip()


func set_is_on_remover_UI(new_is_on_remover_UI : bool):
	is_on_remover_UI = new_is_on_remover_UI


func highlight_slot():
	#slot_anim_player.play("highlight")
	add_child(slot_particle_scene.instantiate())
	var shader_material = ShaderMaterial.new()
	shader_material.shader = shader
	shader_rect.material = shader_material
	slot_back_sprite.texture = highlight_texture


func stop_highlight():
	#slot_anim_player.stop()
	shader_rect.material = null
	slot_back_sprite.texture = highlight_texture
	if slot_type == DataManager.SlotType.UPGRADE:
		slot_back_sprite.texture = back_upgrades_dict[entity_tier]
	elif slot_type == DataManager.SlotType.PERC:
		slot_back_sprite.texture = back_perc_dict[entity_tier]
	elif slot_type == DataManager.SlotType.ULT:
		slot_back_sprite.texture = back_ult_dict[entity_tier]
	elif slot_type == DataManager.SlotType.UNIT:
		slot_back_sprite.texture = unit_back_texture

func generate_unit_stats():
	var unit_stats : String
	for stat in DataManager.default_stats.keys():
		if stat.contains('scout'):
			continue
		if stat == 'crit_attack' and slot_res.get(stat) == 50:
			continue 
		if DataManager.default_stats[stat] != slot_res.get(stat):
			var current_locale : String = TranslationServer.get_locale()
			var stat_name : String = DataManager.default_stats_to_rus[stat]
			match current_locale:
				'en_US':
					stat_name = stat.replace('_', ' ')
			if (stat.contains('hit_chance') or stat.contains('crit_attack')) and slot_type == DataManager.SlotType.PERC:
				continue
			if stat.contains('attack_speed') or stat.contains('mult'):
				if slot_type == DataManager.SlotType.PERC:
					if DataManager.default_stats[stat] < slot_res.get(stat):
						if not stat.contains('attack_speed'):
							unit_stats += ('[color=#25562e]%s %.1f\n[/color]') % [stat_name, slot_res.get(stat)]
						else:
							unit_stats += ('[color=#a53030]%s %.1f\n[/color]') % [stat_name, slot_res.get(stat)]
					elif DataManager.default_stats[stat] > slot_res.get(stat):
						if not stat.contains('attack_speed'):
							unit_stats += ('[color=#a53030]%s %.1f\n[/color]') % [stat_name, slot_res.get(stat)]
						else:
							unit_stats += ('[color=#25562e]%s %.1f\n[/color]') % [stat_name, slot_res.get(stat)]
					else:
						unit_stats += ('%s %.1f\n') % [stat_name, slot_res.get(stat)]
				else:
					unit_stats += ('%s %.1f\n') % [stat_name, slot_res.get(stat)]
			else:
				if slot_type == DataManager.SlotType.PERC:
					if DataManager.default_stats[stat] < slot_res.get(stat):
						unit_stats += ('[color=#25562e]%s %d\n[/color]') % [stat_name, slot_res.get(stat)]
					elif DataManager.default_stats[stat] > slot_res.get(stat):
						unit_stats += ('[color=#a53030]%s %d\n[/color]') % [stat_name, slot_res.get(stat)]
					else:
						unit_stats += ('%s %d\n') % [stat_name, slot_res.get(stat)]
				else:
					unit_stats += ('%s %d\n') % [stat_name, slot_res.get(stat)]
				#unit_stats += ('%s %d\n') % [DataManager.default_stats_to_rus[stat], slot_res.get(stat)]

	return unit_stats


func create_tooltip():
	tooltip = tooltip_scene.instantiate()
	tooltip.set_entity_name(slot_name)
	tooltip.set_entity_desc(slot_description)
	tooltip.set_entity_tier(entity_tier)
	tooltip.set_tooltip_owner(self)
	tooltip.set_slot_res(slot_res)
	if slot_type == DataManager.SlotType.UNIT or slot_type == DataManager.SlotType.PERC:
		tooltip.set_stats(generate_unit_stats())
	#tooltip.visible = false


func show_tooltip():
	create_tooltip()
	SignalManager.on_show_tooltip.emit(self, tooltip)
	#tooltip.visible = true


func hide_tooltip():
	SignalManager.on_hide_tooltip.emit(tooltip)
	#tooltip.visible = false


func _on_mouse_entered() -> void:
	#if not is_tooltip_shown:
		#is_tooltip_shown = true
	show_tooltip()


func _on_mouse_exited() -> void:
	#if tooltip and is_tooltip_shown:
		#is_tooltip_shown = false
		#hide_tooltip()
	if tooltip and is_instance_valid(tooltip):
		tooltip.queue_free()


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	# Check if the event is a mouse button press
	if event is InputEventMouseButton:
		# Check specifically for the left mouse button being pressed down
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and is_on_remover_UI:
			SignalManager.on_choose_removed_slot.emit(self)
		elif event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if not is_can_swap:
				return
			if Player.get_is_can_swap():
				hide_tooltip()
				#input_pickable = false
				Player.set_is_can_swap(false)
				set_collision_layer_value(11, false)
				set_collision_mask_value(11, true)
				before_can_swap_position = global_position
				is_in_swap_state = true
				previous_z_index = z_index
				z_index = 100
				# Calculate the offset from the object's origin to the mouse position
				#skill_zone.offset = get_global_mouse_position() - global_position
		else:
			if current_swap_slots.size() > 0:
				is_in_swap_state = false
				z_index = previous_z_index
				move_slots()
			else:
				if is_in_swap_state:
					global_position = before_can_swap_position
					is_in_swap_state = false
					z_index = previous_z_index
					Player.set_is_can_swap(true)
			# вернуть зону в неактивное состояние
			# запустить КД скилла
			# Optional: Add logic here to "drop" the object or apply momentum


func _on_area_entered(area: Area2D) -> void:
	#if is_in_swap_state:
		#var slot : Slot = area
		#slot_for_swap = slot
		#slot_for_swap.input_pickable = false
	if is_in_swap_state:
		var slot : Slot = area
		current_swap_slots.append(slot)
		slot.input_pickable = false


func _on_area_exited(area: Area2D) -> void:
	#if is_in_swap_state:
		#var slot : Slot = area
		#slot_for_swap.input_pickable = true
		#slot_for_swap = null
	if is_in_swap_state:
		var slot : Slot = area
		current_swap_slots.erase(slot)
		slot.input_pickable = true

func move_slots():
	if current_swap_slots.size() > 0:
		slot_for_swap = get_closest_swap_slot()
		if not slot_for_swap:
			return 
		# просто перемещение
		#slot_for_swap.global_position = before_can_swap_position
		#slot_for_swap.z_index = 99
		var my_carousel : SlotCarousel = get_parent()
		var target_carousel : SlotCarousel = slot_for_swap.get_parent()
		var target_slot_position : Vector2 = slot_for_swap.global_position
		# перемещаем таргетный слот
		my_carousel.slots[1] = slot_for_swap
		slot_for_swap.reparent(my_carousel)
		slot_for_swap.global_position = before_can_swap_position
		# перемещаем активный слот
		target_carousel.slots[1] = self
		reparent(target_carousel)
		global_position = target_slot_position
		# прекращаем все движения
		slot_for_swap.input_pickable = true
		slot_for_swap = null
		Player.set_is_can_swap(false)
		SignalManager.on_swap_done.emit()
		if Player.is_tutorial and Player.level.is_tutorial_3_done and not Player.level.is_tutorial_4_done:
			Player.level.is_tutorial_4_done = true
			get_tree().create_timer(1).timeout.connect(Player.show_tutorial)
		#SoundManager.play_ui(self, DataManager.sound_dict[DataManager.SoundType.SWAP])


func get_closest_swap_slot():
	if current_swap_slots.size() > 0:
		current_swap_slots.sort_custom(func(a, b): return abs(a.global_position - global_position) < abs(b.global_position - global_position))
		return current_swap_slots[0]
	else:
		return null
