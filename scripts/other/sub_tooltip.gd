extends PanelContainer

class_name SubTooltip


@export var entity_name : String
@export var entity_desc : String
@export var preview_texture : Texture2D

@onready var preview_rect: TextureRect = %preview_rect
@onready var label_name: Label = %label_name
@onready var label_desc: RichTextLabel = %label_desc


func initialize():
	if not get_tree():
		return
	await get_tree().process_frame
	label_name.text = entity_name
	label_desc.text = entity_desc
	preview_rect.texture = preview_texture


func set_entity_name(new_entity_name):
	entity_name = new_entity_name


func set_entity_desc(new_entity_desc):
	entity_desc = new_entity_desc


func set_preview_texture(new_preview_texture : Texture2D):
	preview_texture = new_preview_texture
