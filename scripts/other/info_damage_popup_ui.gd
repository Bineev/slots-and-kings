extends InfoPopupUI

class_name InfoDamagePopupUI


@export var unit_owner : DataManager.UnitOwner
@export var player_label_settings : Resource
@export var enemy_label_settings : Resource
@export var heal_label_settings : Resource
@export var is_crit : bool
@export var action_type : DataManager.ActionType


func set_unit_owner(new_unit_owner : DataManager.UnitOwner):
	unit_owner = new_unit_owner


func set_amount(new_amount : int):
	amount = new_amount


func set_is_crit(new_is_crit : bool):
	is_crit = new_is_crit


func set_action_type(new_action_type : DataManager.ActionType):
	action_type = new_action_type


func initialize():
	await get_tree().process_frame
	match unit_owner:
		DataManager.UnitOwner.PLAYER:
			label_amount.label_settings = player_label_settings
		DataManager.UnitOwner.ENEMY:
			label_amount.label_settings = enemy_label_settings
	if action_type == DataManager.ActionType.HEAL:
		label_amount.label_settings = heal_label_settings
		#scale = Vector2(1.5, 1.5)
	label_amount.text = str(amount) if amount > 0 else 'промах'
	if is_crit:
		scale = Vector2(1.5, 1.5)
