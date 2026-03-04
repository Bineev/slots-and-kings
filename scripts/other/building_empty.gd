extends Building

class_name BuildingEmpty


func _ready() -> void:
	initialize()
	building_progress_bar.visible = false


func show_ui():
	if Player.is_message_tutorial and not Player.is_roulette_info:
		return
	if is_in_reward_state:
		return
	pop_up_ui = pop_up_ui_scene.instantiate()
	pop_up_ui.prebuilding = self
	SignalManager.on_pop_up_UI.emit(pop_up_ui)


func close_ui():
	pass


func _on_mouse_entered() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)


func _on_mouse_exited() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
