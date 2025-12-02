extends PanelContainer

class_name ResourcesUI


@onready var label_res_gold: Label = %label_res_gold
@onready var label_res_food: Label = %label_res_food
@onready var label_res_tokens: Label = %label_res_tokens
@onready var label_res_crystals: Label = %label_res_crystals


func _ready() -> void:
	SignalManager.on_res_change.connect(update_resources)
	set_resources()


func set_resources():
	await self.ready
	label_res_gold.text = str(Player.get_gold())
	label_res_food.text = str(Player.get_food())
	label_res_tokens.text = str(Player.get_tokens())
	label_res_crystals.text = str(Player.get_crystals())


func update_resources(res_type : DataManager.ResType):
	match res_type:
		DataManager.ResType.GOLD:
			label_res_gold.text = str(Player.get_gold())
		DataManager.ResType.FOOD:
			label_res_food.text = str(Player.get_food())
		DataManager.ResType.SPIN_TOKEN:
			label_res_tokens.text = str(Player.get_tokens())
		DataManager.ResType.CRYSTAL:
			label_res_crystals.text = str(Player.get_crystals())
