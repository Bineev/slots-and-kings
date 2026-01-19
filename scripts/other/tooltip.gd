extends PanelContainer

class_name Tooltip


@export var entity_name : String
@export var entity_desc : String
@export var entity_tier : DataManager.EntityTier
@export var subtooltip_scene : PackedScene
@export var subtooltips : Array[SubTooltip]

var tooltip_owner : Object
var is_initialized : bool

@onready var label_name: Label = %label_name
@onready var label_desc: Label = %label_desc
@onready var sub_tooltips_container: VBoxContainer = %sub_tooltips_container


func initialize():
	await get_tree().process_frame
	if tooltip_owner is not Skill:
		label_name.text = '(T%d) %s' % [entity_tier, entity_name]
	else:
		label_name.text = entity_name
	label_desc.text = entity_desc
	for subtooltip in subtooltips:
		sub_tooltips_container.add_child(subtooltip)
		subtooltip.initialize()
	is_initialized = true


func set_entity_name(new_entity_name):
	entity_name = new_entity_name


func set_entity_desc(new_entity_desc):
	entity_desc = new_entity_desc


func set_entity_tier(new_entity_tier : DataManager.EntityTier):
	entity_tier = new_entity_tier


func set_tooltip_owner(new_tooltip_owner : Object):
	tooltip_owner = new_tooltip_owner


func add_subtooltip(new_subtooltip : SubTooltip):
	subtooltips.append(new_subtooltip)
