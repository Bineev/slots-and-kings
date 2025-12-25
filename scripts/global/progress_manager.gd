extends Node


@export var base_progress_empire : PlayerProgress
@export var base_progress_hell : PlayerProgress

@export var current_progress_empire : PlayerProgress
@export var current_progress_hell : PlayerProgress


func get_current_progress_by_family(family : DataManager.UnitFamily):
	var progress : PlayerProgress
	match family:
		DataManager.UnitFamily.CASTLE:
			progress = current_progress_empire if current_progress_empire else base_progress_empire
		DataManager.UnitFamily.HELL:
			progress = current_progress_hell if current_progress_hell else base_progress_hell
	return progress.duplicate()


func get_base_progress_by_family(family : DataManager.UnitFamily):
	match family:
		DataManager.UnitFamily.CASTLE:
			return base_progress_empire.duplicate()
		DataManager.UnitFamily.HELL:
			return base_progress_hell.duplicate()


func save_progress_by_family(family : DataManager.UnitFamily):
	pass
