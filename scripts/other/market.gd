extends PanelContainer

class_name MarketUI


@export var resousces_dict : Dictionary = {
	DataManager.ResType.GOLD : preload("res://img/res_gold.png"),
	DataManager.ResType.SPIN_TOKEN : preload("res://img/res_token.png"),
	DataManager.ResType.FOOD : preload("res://img/res_food.png"),
	DataManager.ResType.CRYSTAL : preload("res://img/res_crystal.png")
}

var source_res : DataManager.ResType
var target_res : DataManager.ResType
var source_res_count : int
var target_res_count : int
var target_res_min_count : int = 1
var res_chain_count : int
var default_market_coeffs_dict : Dictionary
var current_commission : float
var total_commission : int

@onready var label_res_source: Label = %label_res_source
@onready var rect_res_source: TextureRect = %rect_res_source
@onready var label_res_target: Label = %label_res_target
@onready var rect_res_target: TextureRect = %rect_res_target
@onready var change_res_up_button: TextureButton = %change_res_up_button
@onready var change_res_down_button: TextureButton = %change_res_down_button
@onready var target_res_up_button: TextureButton = %target_res_up_button
@onready var target_res_down_button: TextureButton = %target_res_down_button
@onready var change_target_res_up_button: TextureButton = %change_target_res_up_button
@onready var change_target_res_down_button: TextureButton = %change_target_res_down_button
@onready var choose_button: Button = %choose_button
@onready var label_commission_count: Label = %label_commission_count
@onready var label_commission: Label = %label_commission


func initialize():
	await get_tree().process_frame
	default_market_coeffs_dict = DataManager.default_market_coeffs_dict.duplicate()
	source_res = DataManager.ResType.GOLD
	target_res = DataManager.ResType.FOOD
	current_commission = DataManager.default_market_commission
	if Player.current_wave_count >= 22:
		current_commission = 0.7
	elif Player.current_wave_count >= 20:
		current_commission = 0.6
	elif Player.current_wave_count >= 18:
		current_commission = 0.5
	elif Player.current_wave_count >= 16:
		current_commission = 0.4
	elif Player.current_wave_count >= 14:
		current_commission = 0.3
	elif Player.current_wave_count >= 12:
		current_commission = 0.2

	label_commission.text = tr(label_commission.text) + ' ' + str(int(current_commission * 100)) + '%'
	set_icons_by_res()
	setup_min_target_res_count()
	target_res_count = target_res_min_count
	calculate()
	calculate_commission()
	update_res_counts_ui()
	SignalManager.on_ready_choose_ui.emit(self)
	get_tree().paused = true


func change_source_res():
	set_icons_by_res()
	setup_min_target_res_count()
	calculate()
	update_res_counts_ui()


func change_target_res():
	set_icons_by_res()
	setup_min_target_res_count()
	calculate()
	update_res_counts_ui()


func deal():
	Player.get_res(target_res, target_res_count)
	Player.get_res(source_res, -source_res_count)
	Player.get_res(DataManager.ResType.GOLD, -total_commission)
	update_res_counts_ui()


func increase():
	target_res_count += target_res_min_count
	calculate()
	calculate_commission()
	update_res_counts_ui()


func decrease():
	if target_res_count == 0:
		return
	target_res_count -= target_res_min_count
	calculate()
	calculate_commission()
	update_res_counts_ui()


func set_icons_by_res():
	rect_res_source.texture = resousces_dict[source_res]
	rect_res_target.texture = resousces_dict[target_res]


func swap_source_res_up():
	#setup_min_target_res_count()
	if source_res == DataManager.market_res_chain.size() - 1:
		source_res = DataManager.market_res_chain[0]
	else:
		source_res = DataManager.market_res_chain[source_res + 1]


func swap_target_res_up():
	#setup_min_target_res_count()
	if target_res == DataManager.market_res_chain.size() - 1:
		target_res = DataManager.market_res_chain[0]
	else:
		target_res = DataManager.market_res_chain[target_res + 1]


func swap_source_res_down():
	#setup_min_target_res_count()
	if source_res == 0:
		source_res = DataManager.market_res_chain[DataManager.market_res_chain.size() - 1]
	else:
		source_res = DataManager.market_res_chain[source_res - 1]


func swap_target_res_down():
	#setup_min_target_res_count()
	if target_res == 0:
		target_res = DataManager.market_res_chain[DataManager.market_res_chain.size() - 1]
	else:
		target_res = DataManager.market_res_chain[target_res - 1]


func setup_min_target_res_count():
	if default_market_coeffs_dict[target_res] > default_market_coeffs_dict[source_res]:
		target_res_min_count = 1
	else:
		target_res_min_count = default_market_coeffs_dict[source_res] / default_market_coeffs_dict[target_res]


func calculate():
	source_res_count = target_res_count * default_market_coeffs_dict[target_res] / default_market_coeffs_dict[source_res]


func update_res_counts_ui():
	label_res_source.text = str(source_res_count)
	label_res_target.text = str(target_res_count)
	label_commission_count.text = str(total_commission)
	if not check_is_enough():
		choose_button.disabled = true
	else:
		choose_button.disabled = false


func check_is_enough():
	if source_res != DataManager.ResType.GOLD:
		return Player.check_res(source_res_count, source_res) and Player.check_res(total_commission, DataManager.ResType.GOLD)
	else:
		return Player.check_res(source_res_count + total_commission, source_res)


func _on_choose_button_pressed() -> void:
	SoundManager.play_ui(self, DataManager.sound_dict[DataManager.SoundType.UI])
	deal()


func _on_change_res_up_button_pressed() -> void:
	SoundManager.play_ui(self, DataManager.sound_dict[DataManager.SoundType.UI])
	swap_source_res_up()
	set_icons_by_res()
	setup_min_target_res_count()
	target_res_count = target_res_min_count
	calculate()
	calculate_commission()
	update_res_counts_ui()


func _on_change_res_down_button_pressed() -> void:
	SoundManager.play_ui(self, DataManager.sound_dict[DataManager.SoundType.UI])
	swap_source_res_down()
	set_icons_by_res()
	setup_min_target_res_count()
	target_res_count = target_res_min_count
	calculate()
	calculate_commission()
	update_res_counts_ui()


func _on_target_res_up_button_pressed() -> void:
	SoundManager.play_ui(self, DataManager.sound_dict[DataManager.SoundType.UI])
	increase()


func _on_target_res_down_button_pressed() -> void:
	SoundManager.play_ui(self, DataManager.sound_dict[DataManager.SoundType.UI])
	decrease()


func _on_change_target_res_up_button_pressed() -> void:
	SoundManager.play_ui(self, DataManager.sound_dict[DataManager.SoundType.UI])
	swap_target_res_up()
	set_icons_by_res()
	setup_min_target_res_count()
	target_res_count = target_res_min_count
	calculate()
	calculate_commission()
	update_res_counts_ui()


func _on_change_target_res_down_button_pressed() -> void:
	SoundManager.play_ui(self, DataManager.sound_dict[DataManager.SoundType.UI])
	swap_target_res_down()
	set_icons_by_res()
	setup_min_target_res_count()
	target_res_count = target_res_min_count
	calculate()
	calculate_commission()
	update_res_counts_ui()


func _input(event):

	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
			get_tree().paused = false
			visible = false
			get_tree().paused = false
			queue_free()


func calculate_commission():
	total_commission = float(target_res_count) * float(default_market_coeffs_dict[target_res]) * current_commission
