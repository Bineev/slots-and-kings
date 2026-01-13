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
	match family:
		DataManager.UnitFamily.CASTLE:
			current_progress_empire = Player.current_progress
		DataManager.UnitFamily.HELL:
			current_progress_hell = Player.current_progress
	save_progress_to_file(Player.current_progress)

func save_progress_to_file(progress : PlayerProgress):
	var error = ResourceSaver.save(progress, progress.save_path)
	if error == OK:
		print('saved')
	else:
		print('unlucky')


func load_progress_from_file_by_family(family : DataManager.UnitFamily):
	var progress : PlayerProgress
	match family:
		DataManager.UnitFamily.CASTLE:
			if ResourceLoader.exists(base_progress_empire.save_path):
				progress = ResourceLoader.load(base_progress_empire.save_path)
				if progress:
					current_progress_empire = progress
				else:
					current_progress_empire = base_progress_empire
		DataManager.UnitFamily.HELL:
			if ResourceLoader.exists(base_progress_hell.save_path):
				progress = ResourceLoader.load(base_progress_hell.save_path)
				if progress:
					current_progress_hell = progress
				else:
					current_progress_hell = base_progress_empire
