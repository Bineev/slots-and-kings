extends PanelContainer

class_name MessageUI


@export var text1 : String
@export var counselor_texture : Texture2D

@onready var label_content: RichTextLabel = %label_content
@onready var counselor_rect: TextureRect = %counselor_rect


func _ready() -> void:
	initialize()


func initialize():
	await get_tree().process_frame
	label_content.text = text1
	counselor_rect.texture = counselor_texture
