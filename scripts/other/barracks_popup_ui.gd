extends PanelContainer

class_name BarracksPopupUI


@export var current_count : int
@export var next_tier_cost : int
@export var building_owner : Building
@export var upgrade_tier_res : DataManager.ResType

@onready var label_curent_tier: Label = %label_curent_tier
@onready var label_next_tier: Label = %label_next_tier
@onready var button_buy: Button = %button_buy


func _ready() -> void:
	SignalManager.on_get_res.connect(enable_buy_button_if_enough_res)


func initialize():
	await get_tree().process_frame
	if current_count >= DataManager.max_entity_tier - 1:
		label_curent_tier.text = str(current_count)
		label_next_tier.text = 'Вы достигли максимального уровня улучшений'
		button_buy.get_parent().remove_child(button_buy)
		return
	label_curent_tier.text = str(current_count)
	label_next_tier.text += " " + str(current_count + 1)
	button_buy.text = str(next_tier_cost)
	if not Player.check_res(next_tier_cost, upgrade_tier_res):
		button_buy.disabled = true
	SignalManager.on_ready_choose_ui.emit(self)


func set_data(new_building_owner : Building, new_upgrade_tier_cost : int, new_current_tier : int):
	building_owner = new_building_owner
	next_tier_cost = new_upgrade_tier_cost
	current_count = new_current_tier


func _on_button_buy_pressed() -> void:
	SoundManager.play_ui(self, DataManager.sound_dict[DataManager.SoundType.GET_REWARDS])
	tier_up()
	button_buy.disabled = true
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2.ZERO, 0.3)
	tween.tween_callback(self.queue_free).set_delay(0.4)


func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
			visible = false
			var tween = get_tree().create_tween()
			tween.tween_callback(queue_free).set_delay(0.5)


func enable_buy_button_if_enough_res(res_type : DataManager.ResType, res_amount : int):
	if res_type != upgrade_tier_res:
		return
	if Player.check_res(next_tier_cost, upgrade_tier_res):
		button_buy.disabled = false


func tier_up():
	Player.update_bonus(building_owner.current_unit_slot_name, 1)
	Player.get_res(upgrade_tier_res, -next_tier_cost)
	building_owner.upgrade_tier_cost *= 2
	building_owner.current_tier += 1
	
