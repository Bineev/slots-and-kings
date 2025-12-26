extends Tooltip

class_name TooltipSlot


@export var slot_res : SlotRes
@export var stats : String

@onready var label_stats: RichTextLabel = %label_stats


func initialize():
	await get_tree().process_frame
	label_name.text = '(T%d) %s' % [entity_tier, entity_name]
	if slot_res.slot_type == DataManager.SlotType.UNIT:
		var types : String
		for item in slot_res.unit_types:
			types += DataManager.unit_types_table[item] + '\n'
		label_desc.text = types
	else:
		label_desc.text = entity_desc
	label_stats.text = stats
	is_initialized = true


func set_stats(new_stats : String):
	stats = new_stats


func set_slot_res(new_slot_res : SlotRes):
	slot_res = new_slot_res
