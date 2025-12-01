extends ChooseUI


func close_choose_UI(item : ChooseItem):
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2.ZERO, 0.3)
	tween.tween_callback(queue_free).set_delay(0.4)
