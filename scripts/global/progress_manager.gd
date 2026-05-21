extends Node


@export var base_progress_empire : PlayerProgress
@export var base_progress_hell : PlayerProgress

@export var current_progress_empire : PlayerProgress
@export var current_progress_hell : PlayerProgress


func get_current_progress_by_family(family : DataManager.UnitFamily):
	var progress : PlayerProgress = load_progress_from_file_by_family(family)
	# Если файла на диске нет, возвращаем дефолтный дубликат
	if not progress:
		return get_base_progress_by_family(family)
	return progress.duplicate()


func get_base_progress_by_family(family : DataManager.UnitFamily):
	match family:
		DataManager.UnitFamily.CASTLE:
			return base_progress_empire.duplicate(true)
		DataManager.UnitFamily.HELL:
			return base_progress_hell.duplicate(true)


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
				# CACHE_MODE_REPLACE заставляет Godot принудительно перечитать файл с диска браузера
				progress = ResourceLoader.load(base_progress_empire.save_path, "", ResourceLoader.CACHE_MODE_REPLACE)
				if progress:
					current_progress_empire = progress
				else:
					current_progress_empire = base_progress_empire
		DataManager.UnitFamily.HELL:
			if ResourceLoader.exists(base_progress_hell.save_path):
				progress = ResourceLoader.load(base_progress_hell.save_path, "", ResourceLoader.CACHE_MODE_REPLACE)
				if progress:
					current_progress_hell = progress
				else:
					# ИСПРАВЛЕНО: заменил base_progress_empire на base_progress_hell
					current_progress_hell = base_progress_hell 
	return progress


func is_progress_exists():
	var progress_empire : PlayerProgress
	if ResourceLoader.exists(base_progress_empire.save_path):
		progress_empire = ResourceLoader.load(base_progress_empire.save_path, "", ResourceLoader.CACHE_MODE_REPLACE)
	var progress_hell : PlayerProgress
	if ResourceLoader.exists(base_progress_hell.save_path):
		progress_hell = ResourceLoader.load(base_progress_hell.save_path, "", ResourceLoader.CACHE_MODE_REPLACE)

	return progress_empire or progress_hell
