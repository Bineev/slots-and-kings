extends PanelContainer

class_name UpgradesMenuUI


@export var current_tier : DataManager.EntityTier
@export var next_tier_cost : int
@export var building_owner : Building
@export var upgrade_tier_res : DataManager.ResType

@onready var label_curent_tier: Label = %label_curent_tier
@onready var label_next_tier: Label = %label_next_tier
@onready var button_buy: Button = %button_buy


func initialize():
	await get_tree().process_frame
	if current_tier >= DataManager.max_entity_tier - 1:
		label_curent_tier.text = DataManager.EntityTier.keys()[current_tier]
		label_next_tier.text = 'Вы достигли максимального уровня улучшений'
		button_buy.get_parent().remove_child(button_buy)
		return
	label_curent_tier.text = DataManager.EntityTier.keys()[current_tier]
	label_next_tier.text += " " + DataManager.EntityTier.keys()[current_tier + 1]
	button_buy.text = str(next_tier_cost)


func set_data(new_current_tier : DataManager.EntityTier, new_next_tier_cost : int, new_upgrade_tier_res : DataManager.ResType, new_building_owner : Building):
	current_tier = new_current_tier
	next_tier_cost = new_next_tier_cost
	building_owner = new_building_owner
	upgrade_tier_res = new_upgrade_tier_res


func _on_button_buy_pressed() -> void:
	building_owner.tier_up()
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
