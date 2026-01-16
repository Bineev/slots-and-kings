extends PanelContainer

class_name MetaShop


@onready var meta_items_container: GridContainer = %meta_items_container


func initialize():
	await get_tree().process_frame
	for item in meta_items_container.get_children():
		item.initialize()
