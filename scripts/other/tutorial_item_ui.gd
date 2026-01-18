extends PanelContainer

class_name TutorialItemUI


@export var tutorial_desc_1 : String
@export var tutorial_desc_2 : String
@export var tutorial_desc_3 : String
@export var tutorial_texture : Texture2D
@export var tutorial_texture2 : Texture2D
@export var tutorial_texture3 : Texture2D

@onready var show_tutorial_button: Button = %show_tutorial_button
@onready var hide_tutorial_button: Button = %hide_tutorial_button
@onready var texture_tutorial: TextureRect = %texture_tutorial
@onready var texture_tutorial_2: TextureRect = %texture_tutorial2
@onready var texture_tutorial_3: TextureRect = %texture_tutorial3
@onready var label_desc: Label = %label_desc
@onready var label_desc_2: Label = %label_desc2
@onready var label_desc_3: Label = %label_desc3
@onready var content_container: MarginContainer = %content_container


func initialize():
	await get_tree().process_frame
	if tutorial_texture:
		texture_tutorial.texture = tutorial_texture
	if tutorial_texture2:
		texture_tutorial_2.texture = tutorial_texture2
	if tutorial_texture3:
		texture_tutorial_3.texture = tutorial_texture3
	if tutorial_desc_1 != '':
		label_desc.text = tutorial_desc_1
	if tutorial_desc_2 != '':
		label_desc_2.text = tutorial_desc_2
	if tutorial_desc_3 != '':
		label_desc_3.text = tutorial_desc_3


func _on_show_tutorial_button_pressed() -> void:
	show_tutorial_button.visible = false
	content_container.visible = true


func _on_hide_tutorial_button_pressed() -> void:
	get_tree().paused = false
	show_tutorial_button.visible = true
	content_container.visible = false
