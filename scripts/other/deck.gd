extends Node2D

class_name Deck


@export var slot_scenes : Array[PackedScene]
@export var deck_type : DataManager.SlotType

var slots : Array[Slot]


func initialize_slots():
	for scene in slot_scenes:
		var slot = scene.instantiate()
		slots.append(slot)


func get_copy_slots():
	var new_slots : Array[Slot]
	for slot in slots:
		var new_slot : Slot = slot.duplicate()
		new_slots.append(new_slot)
	return new_slots
