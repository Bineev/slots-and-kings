extends Building

class_name BuildingEco


@export var res_type : DataManager.ResType
@export var res_amount : int
@export var get_res_interval : float
@export var info_popup_UI_scene : PackedScene


func initialize():
	super.initialize()
	res_amount = building_res.produce_amount
	get_res_interval = building_res.produce_interval
	generate_timer.wait_time = get_res_interval
	generate_timer.start()


func get_res():
	Player.get_res(res_type, res_amount)


func show_getting_res():
	var info_popup_UI : InfoResPopupUI = info_popup_UI_scene.instantiate()
	info_popup_UI.set_data(res_type, res_amount)
	SignalManager.on_show_info_res_popup.emit(self, info_popup_UI)


func _on_generate_timer_timeout() -> void:
	get_res()
	show_getting_res()
