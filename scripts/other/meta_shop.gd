extends PanelContainer

class_name MetaShop


@onready var meta_items_container: GridContainer = %meta_items_container
@onready var label_res_souls: Label = %label_res_souls


func _ready() -> void:
	SignalManager.on_buy_meta.connect(update_souls)


func initialize():
	await get_tree().process_frame
	if Player.current_runs_count == 0:
		modulate = Color8(0, 0, 0, 0)
	label_res_souls.text = str(Player.current_souls)
	for item in meta_items_container.get_children():
		item.initialize()


func update_souls():
	label_res_souls.text = str(Player.current_souls)
