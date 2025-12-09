extends InfoPopupUI

class_name InfoDamagePopupUI


@export var unit_owner : DataManager.UnitOwner
@export var player_lable_settings : Resource
@export var enemy_lable_settings : Resource


func set_unit_owner(new_unit_owner : DataManager.UnitOwner):
	unit_owner = new_unit_owner


func set_amount(new_amount : int):
	amount = new_amount


func initialize():
	await get_tree().process_frame
	match unit_owner:
		DataManager.UnitOwner.PLAYER:
			label_amount.label_settings = player_lable_settings
		DataManager.UnitOwner.ENEMY:
			label_amount.label_settings = enemy_lable_settings
	label_amount.text = str(amount)
