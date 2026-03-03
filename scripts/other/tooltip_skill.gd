extends Tooltip

class_name TooltipSkill

@export var stats : String

var is_should_hide_label_close : bool

@onready var label_stats: RichTextLabel = %label_stats
@onready var label_close: Label = %label_close


func initialize():
	await get_tree().process_frame
	label_name.text = entity_name
	label_desc.text = entity_desc
	label_stats.text = stats
	for subtooltip in subtooltips:
		sub_tooltips_container.add_child(subtooltip)
		subtooltip.initialize()
	if is_should_hide_label_close:
		hide_label_close()
	is_initialized = true


func set_stats(new_stats : String):
	stats = new_stats


func hide_label_close():
	label_close.hide()


func set_is_should_hide_label_close(new_is_should_hide_label_close : bool):
	is_should_hide_label_close = new_is_should_hide_label_close
