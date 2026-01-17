extends Building

class_name BuildingMarket


@export var market_ui_scene : PackedScene


func show_ui():
	pop_up_ui = market_ui_scene.instantiate()
	SignalManager.on_open_building_menu.emit(self, pop_up_ui)
