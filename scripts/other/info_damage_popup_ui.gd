extends InfoPopupUI

class_name InfoDamagePopupUI


@export var unit_owner : DataManager.UnitOwner
@export var player_lable_settings : Resource
@export var enemy_lable_settings : Resource
@export var is_crit : bool

func set_unit_owner(new_unit_owner : DataManager.UnitOwner):
	unit_owner = new_unit_owner


func set_amount(new_amount : int):
	amount = new_amount


func set_is_crit(new_is_crit : bool):
	is_crit = new_is_crit


func initialize():
	await get_tree().process_frame
	match unit_owner:
		DataManager.UnitOwner.PLAYER:
			label_amount.label_settings = player_lable_settings
		DataManager.UnitOwner.ENEMY:
			label_amount.label_settings = enemy_lable_settings
	label_amount.text = str(amount) if amount > 0 else 'промах'
	if is_crit:
		scale = Vector2(1.5, 1.5)
