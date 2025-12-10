extends Tooltip

class_name TooltipSlot


func initialize():
	await get_tree().process_frame
	label_name.text = '(T%d) %s' % [entity_tier, entity_name]
	label_desc.text = entity_desc
	is_initialized = true
