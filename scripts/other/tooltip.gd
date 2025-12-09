extends PanelContainer

class_name Tooltip


@export var entity_name : String
@export var entity_desc : String
@export var entity_tier : DataManager.EntityTier

@onready var label_name: Label = %label_name
@onready var label_desc: Label = %label_desc


func initialize():
	pass


func set_entity_name(new_entity_name):
	entity_name = new_entity_name


func set_entity_desc(new_entity_desc):
	entity_desc = new_entity_desc


func set_entity_tier(new_entity_tier : DataManager.EntityTier):
	entity_tier = new_entity_tier
