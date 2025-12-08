extends PanelContainer

class_name RewardUI


@export var popup_UI_scene : PackedScene
@export var popup_UI : Control
@export var reward_type : DataManager.RewardType
@export var entity_tier : DataManager.EntityTier
@export var resources_dict : Dictionary = {
	DataManager.ResType.GOLD : 0,
	DataManager.ResType.FOOD : 0,
	DataManager.ResType.SPIN_TOKEN : 0,
	DataManager.ResType.CRYSTAL : 0,
}

@onready var label_reward_header: Label = %label_reward_header
@onready var label_reward_info: Label = %label_reward_info
@onready var rewards_container: HBoxContainer = %rewards_container
@onready var button_take_rewards: Button = %button_take_rewards


func initialize():
	pass


func show_popup_UI():
	pass


func close_popup_UI():
	pass


func generate_reward_info():
	pass


func generate_reward_header():
	pass


func generate_reward_container():
	pass


func _on_button_take_rewards_pressed() -> void:
	add_resources()
	show_popup_UI()
	visible = false
	get_tree().create_timer(1).timeout.connect(queue_free)


func set_reward_type(new_reward_type : DataManager.RewardType):
	reward_type = new_reward_type


func add_resources():
	for res in resources_dict.keys():
		if resources_dict[res] != 0:
			Player.get_res(res, resources_dict[res])
