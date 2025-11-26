extends Node


func get_random_male_name():
	return DataManager.male_names.pick_random()


func get_random_items(entity_pool : Array[PackedScene], choose_count : int):
	if entity_pool.size() >= choose_count:
		return entity_pool
	var new_entity_pool : Array
	new_entity_pool.append(entity_pool[0])
	while new_entity_pool.size() < choose_count:
		for entity_scene in entity_pool:
			if new_entity_pool.size() == choose_count:
				break
			for inner_entity_scene in new_entity_pool:
				if entity_scene.name != inner_entity_scene.name:
					new_entity_pool.append(entity_scene)
					break
			
	return new_entity_pool
