extends Area2D

class_name Slot

@export var slot_type : DataManager.SlotType
@export var slot_res : SlotRes
@export var slot_content_scene : PackedScene
@export var entity_tier : DataManager.EntityTier
@export var shader : Shader
@export var tooltip_scene : PackedScene
@export var unit_attack_type : DataManager.AttackType
@export var unit_projectile_texture : Texture2D

var slot_name : String
var slot_description : String
var slot_unit_tier : DataManager.UnitTier
var unit_types : Array[DataManager.UnitType]
var unit_cost : int
var tooltip : Tooltip
var is_tooltip_shown : bool

@onready var slot_sprite: AnimatedSprite2D = %slot_sprite
@onready var slot_anim_player: AnimationPlayer = %slot_anim_player
@onready var highlight_sprite: Sprite2D = %highlight_sprite
@onready var shader_rect: ColorRect = %shader_rect


func initialize():
	slot_name = slot_res.slot_name
	slot_description = slot_res.slot_description
	entity_tier = slot_res.entity_tier
	# баз возник когда добавил апгрейды к спавну
	slot_sprite.sprite_frames = SpriteFrames.new()
	slot_sprite.sprite_frames.add_frame("default", slot_res.slot_sprite)
	if slot_type == DataManager.SlotType.UNIT and slot_res is SlotUnitRes:
		slot_unit_tier = slot_res.unit_tier
		unit_types = slot_res.unit_types
		unit_cost = slot_res.unit_cost
		unit_attack_type = slot_res.unit_attack_type
		unit_projectile_texture = slot_res.unit_projectile_texture
	#create_tooltip()


func highlight_slot():
	slot_anim_player.play("highlight")
	var shader_material = ShaderMaterial.new()
	shader_material.shader = shader
	shader_rect.material = shader_material


func stop_highlight():
	slot_anim_player.stop()


func generate_unit_stats():
	var unit_stats : String
	for stat in DataManager.default_stats.keys():
		if stat.contains('scout'):
			continue
		if stat == 'crit_attack' and slot_res.get(stat) == 50:
			continue 
		if DataManager.default_stats[stat] != slot_res.get(stat):
			if stat.contains('attack_speed') or stat.contains('mult'):
				unit_stats += ('%s: %.1f\n') % [DataManager.default_stats_to_rus[stat], slot_res.get(stat)]
			else:
				unit_stats += ('%s: %d\n') % [DataManager.default_stats_to_rus[stat], slot_res.get(stat)]
	
	return unit_stats


func create_tooltip():
	tooltip = tooltip_scene.instantiate()
	tooltip.set_entity_name(slot_name)
	tooltip.set_entity_desc(slot_description)
	tooltip.set_entity_tier(entity_tier)
	tooltip.set_tooltip_owner(self)
	tooltip.set_slot_res(slot_res)
	if slot_type == DataManager.SlotType.UNIT:
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
		
