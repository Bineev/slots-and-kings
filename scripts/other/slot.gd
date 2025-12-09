extends Area2D

class_name Slot

@export var slot_type : DataManager.SlotType
@export var slot_res : SlotRes
@export var slot_content_scene : PackedScene
@export var entity_tier : DataManager.EntityTier
@export var shader : Shader
@export var tooltip_scene : PackedScene

var slot_name : String
var slot_description : String
var slot_unit_tier : DataManager.UnitTier
var unit_types : Array[DataManager.UnitType]
var unit_cost : int
var tooltip : Tooltip

@onready var slot_sprite: AnimatedSprite2D = %slot_sprite
@onready var slot_anim_player: AnimationPlayer = %slot_anim_player
@onready var highlight_sprite: Sprite2D = %highlight_sprite
@onready var shader_rect: ColorRect = %shader_rect


func initialize():
	slot_name = slot_res.slot_name
	slot_description = slot_res.slot_description
	entity_tier = slot_res.entity_tier
	slot_sprite.sprite_frames = SpriteFrames.new()
	slot_sprite.sprite_frames.add_frame("default", slot_res.slot_sprite)
	if slot_type == DataManager.SlotType.UNIT and slot_res is SlotUnitRes:
		slot_unit_tier = slot_res.unit_tier
		unit_types = slot_res.unit_types
		unit_cost = slot_res.unit_cost


func highlight_slot():
	slot_anim_player.play("highlight")
	var shader_material = ShaderMaterial.new()
	shader_material.shader = shader
	shader_rect.material = shader_material


func stop_highlight():
	slot_anim_player.stop()


func show_tooltip():
	if not tooltip:
		print(slot_description)
		tooltip = tooltip_scene.instantiate()
		tooltip.set_entity_name(slot_name)
		tooltip.set_entity_desc(slot_description)
		tooltip.set_entity_tier(entity_tier)
		SignalManager.on_show_tooltip.emit(self, tooltip)


func _on_mouse_entered() -> void:
	show_tooltip()


func _on_mouse_exited() -> void:
	if tooltip:
		tooltip.queue_free()
		tooltip = null
