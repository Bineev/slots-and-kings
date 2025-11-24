extends Area2D

class_name Slot


@export var slot_type : DataManager.SlotType
@export var slot_res : SlotRes
@export var slot_content_scene : PackedScene

var slot_name : String
var slot_description : String
var slot_unit_tier : DataManager.UnitTier

@onready var slot_sprite: AnimatedSprite2D = %slot_sprite


func initialize():
	slot_name = slot_res.slot_name
	slot_description = slot_res.slot_description
	slot_sprite.sprite_frames = SpriteFrames.new()
	slot_sprite.sprite_frames.add_frame("default", slot_res.slot_sprite)
	if slot_type == DataManager.SlotType.UNIT and slot_res is SlotUnitRes:
		slot_unit_tier == slot_res.unit_tier
