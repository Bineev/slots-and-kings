extends Tooltip

class_name TooltipUnit


@export var preview_texture : Texture2D
@export var unit_types : String
@export var stats : String

@onready var rect_preview: TextureRect = %rect_preview
@onready var label_stats: RichTextLabel = %label_stats
@onready var label_unit_types: RichTextLabel = %label_unit_types


func set_preview_texture(new_preview_texture : Texture2D):
	preview_texture = new_preview_texture


func set_stats(new_stats : String):
	stats = new_stats


func initialize():
	await get_tree().process_frame
	label_name.text = '(T%d) %s' % [entity_tier, entity_name]
	label_desc.text = entity_desc
	rect_preview.texture = preview_texture
	label_unit_types.text = unit_types
	label_stats.text = stats
	for subtooltip in subtooltips:
		sub_tooltips_container.add_child(subtooltip)
		subtooltip.initialize()
	is_initialized = true


func set_unit_types(new_unit_types : String):
	unit_types = new_unit_types


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if (event.button_index == MOUSE_BUTTON_LEFT or event.button_index == MOUSE_BUTTON_RIGHT) and event.pressed:
			#if tooltip_owner and tooltip_owner.is_tooltip_shown:
				#SignalManager.on_hide_unit_tooltip.emit(self)
			queue_free()
