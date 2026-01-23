extends Node


@export var empire_unit_reses : Array[Resource]
@export var hell_unit_reses : Array[Resource]
@export var forest_unit_reses : Array[Resource]

@export var spawn_scene : PackedScene = preload("res://scenes/enemy_spawn.tscn")
@export var wave_scene : PackedScene = preload('res://scenes/wave.tscn')

var current_enemy_families : Array[DataManager.UnitFamily]


func _ready() -> void:
	current_enemy_families = [DataManager.UnitFamily.CASTLE]


func create_spawn_by_wave_count(wave_count : int, diff_count : int):
	var spawn : EnemySpawn = spawn_scene.instantiate()
	spawn.time_between_units = 0.1
	spawn.unit_factory = Player.get_unit_factory().duplicate()
	var progress : PlayerProgress = ProgressManager.get_base_progress_by_family(DataManager.UnitFamily.HELL)
	var enemies_count : int = clampf(ceil(float(wave_count) * 1.2 + 1.3) + floor(float(diff_count) / 1.5), 5, 11 + diff_count)
	var spawn_coeff : int = diff_count if diff_count != 0 else 1
	
	var T0_units_pool : Array[Resource] = progress.units_T0_pool.duplicate(true)
	var T1_units_pool : Array[Resource] = progress.units_T1_pool.duplicate(true) 
	var T2_units_pool : Array[Resource] = progress.units_T2_pool.duplicate(true) 
	var T3_units_pool : Array[Resource] = progress.units_T3_pool.duplicate(true) 
	var T4_units_pool : Array[Resource] = progress.units_T4_pool.duplicate(true) 
	var T1_upgrades_pool : Array[Resource] = progress.upgrades_T1_pool.duplicate(true) 
	var T2_upgrades_pool : Array[Resource] = progress.upgrades_T2_pool.duplicate(true) 
	var T3_upgrades_pool : Array[Resource] = progress.upgrades_T3_pool.duplicate(true) 
	var T4_upgrades_pool : Array[Resource] = progress.upgrades_T4_pool.duplicate(true) 
	var special_pool : Array[Resource] = progress.special_upgrades_reses.duplicate(true)

	if diff_count > 2:
		enemies_count += 1
	elif diff_count > 5:
		enemies_count += 2
	elif diff_count > 7:
		enemies_count += 3


	
	var diff_coeff : float = 1.5
	
	# сделать более плавное усиление врагов (менять проценты появления
	# топ тир врагов постепенно
	
	
	var T4_limit : float = 0
	var T3_limit : float = 0
	var T2_limit : float = 0
	var T1_limit : float = 0.3
	var T0_limit : float = 1
	
	# замедлить появление злых
	# возможно, уменьшить кол-во юнитова
	# возможно, оставить один спавн
	if wave_count >= 28:
		T4_limit = 0.3 + diff_count * diff_coeff / 100
		T3_limit = 0.6 + diff_count * diff_coeff / 100
		T2_limit = 1
	elif wave_count >= 25:
		T4_limit = 0.2 + diff_count * diff_coeff / 100
		T3_limit = 0.5 + diff_count * diff_coeff / 100
		T2_limit = 1
	elif wave_count >= 22:
		T4_limit = 0.2 + diff_count * diff_coeff / 100
		T3_limit = 0.4 + diff_count * diff_coeff / 100
		T2_limit = 1
	elif wave_count >= 19:
		T4_limit = 0.15 + diff_count * diff_coeff / 100
		T3_limit = 0.35 + diff_count * diff_coeff / 100
		T2_limit = 0.8
		T1_limit = 1
	elif wave_count >= 16:
		T4_limit = 0.1 + diff_count * diff_coeff / 100
		T3_limit = 0.35 + diff_count * diff_coeff / 100
		T2_limit = 0.7
		T1_limit = 1
	elif wave_count >= 13:
		T4_limit = 0.05 + diff_count * diff_coeff / 100
		T3_limit = 0.25 + diff_count * diff_coeff / 100
		T2_limit = 0.6
		T1_limit = 1
	elif wave_count >= 10:
		T4_limit = 0 + diff_count * diff_coeff / 100
		T3_limit = 0.15 + diff_count * diff_coeff / 100
		T2_limit = 0.4
		T1_limit = 0.9
	elif wave_count >= 7:
		T4_limit = 0
		T3_limit = 0.05 + diff_count * diff_coeff / 100 
		T2_limit = 0.2
		T1_limit = 0.8
	elif wave_count >= 4:
		T4_limit = 0
		T3_limit = 0
		T2_limit = 0.15
		T1_limit = 0.5
	
	
	for i in range(enemies_count):
		var unit_res : Resource
		var chance : float = randf()
		if chance <= T4_limit:
			unit_res = T4_units_pool.pick_random()
		elif chance <= T3_limit:
			unit_res = T3_units_pool.pick_random()
		elif chance <= T2_limit:
			unit_res = T2_units_pool.pick_random()
		elif chance <= T1_limit:
			unit_res = T1_units_pool.pick_random()
		elif chance <= T0_limit:
			unit_res = T0_units_pool.pick_random()
		spawn.unit_reses.append(unit_res)
	var upgrade_reses : Array[Resource] 

	if wave_count >= 28:
		if diff_count >= 8:
			var rand : float = randf()
			if rand < T4_limit + diff_coeff * diff_count / 100:
				upgrade_reses.append(special_pool.pick_random())
			elif rand < T3_limit + diff_coeff * diff_count / 100:
				upgrade_reses.append(special_pool.pick_random())
		elif diff_count >= 6:
			var rand : float = randf()
			if rand < T4_limit + diff_coeff * diff_count / 100:
				upgrade_reses.append(special_pool.pick_random())
			elif rand < T3_limit + diff_coeff * diff_count / 100:
				upgrade_reses.append(special_pool.pick_random())
		elif diff_count >= 4:
			var rand : float = randf()
			if rand < T3_limit + diff_coeff * diff_count / 100:
				upgrade_reses.append(special_pool.pick_random())
			elif rand < T2_limit + diff_coeff * diff_count / 100:
				upgrade_reses.append(T3_upgrades_pool.pick_random())
		elif diff_count >= 2:
			var rand : float = randf()
			if rand < T3_limit + diff_coeff * diff_count / 100:
				upgrade_reses.append(T4_upgrades_pool.pick_random())
			elif rand < T2_limit + diff_coeff * diff_count / 100:
				upgrade_reses.append(T3_upgrades_pool.pick_random())
		spawn.upgrades_reses = upgrade_reses
	elif wave_count >= 21:
		if diff_count >= 8:
			var rand : float = randf()
			if rand < T4_limit + diff_coeff * diff_count / 100:
				upgrade_reses.append(special_pool.pick_random())
			elif rand < T3_limit + diff_coeff * diff_count / 100:
				upgrade_reses.append(special_pool.pick_random())
		elif diff_count >= 6:
			var rand : float = randf()
			if rand < T4_limit + diff_coeff * diff_count / 100:
				upgrade_reses.append(special_pool.pick_random())
			elif rand < T3_limit + diff_coeff * diff_count / 100:
				upgrade_reses.append(T4_upgrades_pool.pick_random())
		elif diff_count >= 4:
			var rand : float = randf()
			if rand < T3_limit + diff_coeff * diff_count / 100:
				upgrade_reses.append(special_pool.pick_random())
			elif rand < T2_limit + diff_coeff * diff_count / 100:
				upgrade_reses.append(T4_upgrades_pool.pick_random())
		elif diff_count >= 2:
			var rand : float = randf()
			if rand < T3_limit + diff_coeff * diff_count / 100:
				upgrade_reses.append(T4_upgrades_pool.pick_random())
			elif rand < T2_limit + diff_coeff * diff_count / 100:
				upgrade_reses.append(T3_upgrades_pool.pick_random())
		spawn.upgrades_reses = upgrade_reses
	elif wave_count >= 14:
		if diff_count >= 8:
			var rand : float = randf()
			if rand < T4_limit + diff_coeff * diff_count / 100:
				upgrade_reses.append(special_pool.pick_random())
			elif rand < T3_limit + diff_coeff * diff_count / 100:
				upgrade_reses.append(special_pool.pick_random())
		elif diff_count >= 6:
			var rand : float = randf()
			if rand < T4_limit + diff_coeff * diff_count / 100:
				upgrade_reses.append(special_pool.pick_random())
			elif rand < T3_limit + diff_coeff * diff_count / 100:
				upgrade_reses.append(T4_upgrades_pool.pick_random())
		elif diff_count >= 4:
			var rand : float = randf()
			if rand < T3_limit + diff_coeff * diff_count / 100:
				upgrade_reses.append(special_pool.pick_random())
			elif rand < T2_limit + diff_coeff * diff_count / 100:
				upgrade_reses.append(T3_upgrades_pool.pick_random())
		elif diff_count >= 2:
			var rand : float = randf()
			if rand < T3_limit + diff_coeff * diff_count / 100:
				upgrade_reses.append(T4_upgrades_pool.pick_random())
			elif rand < T2_limit + diff_coeff * diff_count / 100:
				upgrade_reses.append(T3_upgrades_pool.pick_random())
		spawn.upgrades_reses = upgrade_reses
	elif wave_count >=7:
		if diff_count >= 8:
			var rand : float = randf()
			if rand < T3_limit + diff_coeff * diff_count / 100:
				upgrade_reses.append(special_pool.pick_random())
			elif rand < T2_limit + diff_coeff * diff_count / 100:
				upgrade_reses.append(special_pool.pick_random())
		elif diff_count >= 6:
			var rand : float = randf()
			if rand < T3_limit + diff_coeff * diff_count / 100:
				upgrade_reses.append(special_pool.pick_random())
			elif rand < T2_limit + diff_coeff * diff_count / 100:
				upgrade_reses.append(T3_upgrades_pool.pick_random())
		elif diff_count >= 4:
			var rand : float = randf()
			if rand < T3_limit + diff_coeff * diff_count / 100:
				upgrade_reses.append(special_pool.pick_random())
			elif rand < T2_limit + diff_coeff * diff_count / 100:
				upgrade_reses.append(T2_upgrades_pool.pick_random())
		elif diff_count >= 2:
			var rand : float = randf()
			if rand < T3_limit + diff_coeff * diff_count / 100:
				upgrade_reses.append(T3_upgrades_pool.pick_random())
			elif rand < T2_limit + diff_coeff * diff_count / 100:
				upgrade_reses.append(T2_upgrades_pool.pick_random())
		spawn.upgrades_reses = upgrade_reses
	else:
		if diff_count >= 8:
			for i in range(3):
				var rand : float = randf()
				if rand < T2_limit + diff_coeff * diff_count / 100:
					upgrade_reses.append(special_pool.pick_random())
				elif rand < T1_limit + diff_coeff * diff_count / 100:
					upgrade_reses.append(special_pool.pick_random())
		elif diff_count >= 6:
			for i in range(2):
				var rand : float = randf()
				if rand < T2_limit + diff_coeff * diff_count / 100:
					upgrade_reses.append(special_pool.pick_random())
				elif rand < T1_limit + diff_coeff * diff_count / 100:
					upgrade_reses.append(T2_upgrades_pool.pick_random())
		elif diff_count >= 4:
			var rand : float = randf()
			if rand < T2_limit + diff_coeff * diff_count / 100:
				upgrade_reses.append(special_pool.pick_random())
			elif rand < T1_limit + diff_coeff * diff_count / 100:
				upgrade_reses.append(T1_upgrades_pool.pick_random())
		elif diff_count >= 2:
			var rand : float = randf()
			if rand < T2_limit + diff_coeff * diff_count / 100:
				upgrade_reses.append(T2_upgrades_pool.pick_random())
			elif rand < T1_limit + diff_coeff * diff_count / 100:
				upgrade_reses.append(T1_upgrades_pool.pick_random())
		spawn.upgrades_reses = upgrade_reses
	
	var new_spawn_scene : PackedScene = PackedScene.new()
	new_spawn_scene.pack(spawn)
	
	return new_spawn_scene


func get_waves_by_diff_and_count(difficulty_count : int, waves_count : int):
	var wave_scenes : Array[PackedScene]
	var spawn_count : int = 2
	var time_between_waves: int = 40
	for i in range(1, waves_count + 1):
		var wave : Wave = wave_scene.instantiate()
		var regul_coeff : int
		if i * difficulty_count > 110:
			regul_coeff = 6
		if i * difficulty_count > 80:
			regul_coeff = 5
		elif i * difficulty_count > 50:
			regul_coeff = 4
		elif i * difficulty_count > 30:
			regul_coeff = 3
		elif i * difficulty_count > 15:
			regul_coeff = 2
		else:
			regul_coeff = 1
			
		var time_between_spawns : float = clamp(20 - i * difficulty_count / regul_coeff, 10, 30)
		wave.time_to_next_spawn = time_between_spawns
		wave.time_to_next_wave = time_between_waves
		
		for j in range(spawn_count):
			var spawn_scene : PackedScene = create_spawn_by_wave_count(i, difficulty_count)
			wave.enemy_spawn_scenes.append(spawn_scene)
		
		var new_wave_scene : PackedScene = PackedScene.new()
		new_wave_scene.pack(wave)
		wave_scenes.append(new_wave_scene)
		
	return wave_scenes
