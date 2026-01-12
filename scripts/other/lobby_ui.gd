extends PanelContainer

class_name LobbyUI


var level_scenes : Array[PackedScene]

@onready var label_castle_name: Label = %label_castle_name
@onready var levels_container: HBoxContainer = %levels_container
@onready var label_level_name: Label = %label_level_name
@onready var label_level_desc: Label = %label_level_desc
@onready var rewards_container: HBoxContainer = %rewards_container


func initialize():
	for scene in level_scenes:
		# создать левел итем, при нажатии на который будет меняться представление
		pass


func set_data():
	pass
