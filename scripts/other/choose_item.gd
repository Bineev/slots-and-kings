extends VBoxContainer

class_name ChooseItem

var slot_scene : PackedScene
var slot_res : SlotRes
var slot_type : DataManager.SlotType

@onready var label_item_name: Label = %label_item_name
@onready var item_texture: TextureRect = %item_texture
@onready var label_item_desc: Label = %label_item_desc
@onready var choose_button: Button = %choose_button


func initialize():
	label_item_name.text = slot_res.slot_name
	label_item_desc.text = slot_res.slot_description
	choose_button.text = 'ВЫБРАТЬ'
	item_texture.texture = slot_res.slot_sprite
	slot_type = slot_res.slot_type


func _on_choose_button_pressed() -> void:
	SignalManager.on_choose_item.emit(slot_scene, slot_type)
