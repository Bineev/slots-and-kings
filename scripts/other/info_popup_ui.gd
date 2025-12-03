extends PanelContainer

class_name InfoPopupUI


var amount : int

@onready var label_amount: Label = %label_amount


func initialize():
	pass


func show_popup(popup_owner):
	SignalManager.on_show_info_popup.emit(self, popup_owner)


func close_popup():
	queue_free()
