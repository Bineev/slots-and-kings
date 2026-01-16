extends RewardItem

class_name RewardItemRes


@export var res_type : DataManager.ResType
@export var res_count : int
@export var res_texture_gold : Texture2D
@export var res_texture_food : Texture2D
@export var res_texture_tokens : Texture2D
@export var res_texture_crystal : Texture2D
@export var res_texture_souls : Texture2D

@onready var label_res_count: Label = %label_res_count
@onready var rect_res: TextureRect = %rect_res


func initialize():
	await get_tree().process_frame
	label_res_count.text = str(res_count)
	match res_type:
		DataManager.ResType.GOLD:
			rect_res.texture = res_texture_gold
		DataManager.ResType.FOOD:
			rect_res.texture = res_texture_food
		DataManager.ResType.SPIN_TOKEN:
			rect_res.texture = res_texture_tokens
		DataManager.ResType.CRYSTAL:
			rect_res.texture = res_texture_crystal
		DataManager.ResType.SOULS:
			rect_res.texture = res_texture_souls


func set_res_type(new_res_type : DataManager.ResType):
	res_type = new_res_type


func set_res_count(new_res_count : int):
	res_count = new_res_count
