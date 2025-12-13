extends Tooltip

class_name TooltipSkill

@export var stats : String

@onready var label_stats: RichTextLabel = %label_stats


func initialize():
	await get_tree().process_frame
	label_name.text = '(T%d) %s' % [entity_tier, entity_name]
	label_desc.text = entity_desc
	label_stats.text = stats
	for subtooltip in subtooltips:
		sub_tooltips_container.add_child(subtooltip)
		subtooltip.initialize()
	is_initialized = true


func set_stats(new_stats : String):
	stats = new_stats
