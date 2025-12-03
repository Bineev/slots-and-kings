extends InfoPopupUI

class_name InfoResPopupUI


@export var res_type : DataManager.ResType
@export var gold_texture : Texture2D
@export var food_texture : Texture2D
@export var token_texture : Texture2D
@export var crystal_texture : Texture2D

@onready var rect_res: TextureRect = %rect_res


func initialize():
	await get_tree().process_frame
	match res_type:
		DataManager.ResType.GOLD:
			rect_res.texture = gold_texture
		DataManager.ResType.FOOD:
			rect_res.texture = food_texture
		DataManager.ResType.SPIN_TOKEN:
			rect_res.texture = token_texture
		DataManager.ResType.CRYSTAL:
			rect_res.texture = crystal_texture
	label_amount.text = str(amount)


func set_data(new_res_type : DataManager.ResType, res_amount : int):
	amount = res_amount
	res_type = new_res_type
