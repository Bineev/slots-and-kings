extends Node2D

class_name SlotMachine


func _ready() -> void:
	spin_columns()


func spin_columns():
	SignalManager.spin_columns.emit()
