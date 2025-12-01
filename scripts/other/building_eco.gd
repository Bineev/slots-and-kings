extends Building

class_name BuildingEco


@export var res_type : DataManager.ResType
@export var res_amount : int
@export var get_res_interval : float


func initialize():
	super.initialize()
	res_amount = building_res.produce_amount
	get_res_interval = building_res.produce_interval
	generate_timer.wait_time = get_res_interval
	generate_timer.start()


func get_res():
	SignalManager.on_get_res.emit(res_type, res_amount)


func show_getting_res():
	pass


func _on_generate_timer_timeout() -> void:
	get_res()
	show_getting_res()
