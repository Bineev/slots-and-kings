extends Building

class_name BuildingMarket


@export var market_ui_scene : PackedScene


func show_ui():
	if is_in_reward_state:
		return
	pop_up_ui = market_ui_scene.instantiate()
	SignalManager.on_open_building_menu.emit(self, pop_up_ui)


func _on_mouse_entered() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)


func _on_mouse_exited() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
