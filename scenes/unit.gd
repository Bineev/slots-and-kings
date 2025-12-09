extends CharacterBody2D

class_name Unit

@export var unit_family : DataManager.UnitFamily
@export var unit_tier : DataManager.UnitTier
@export var unit_types : Array[DataManager.UnitType]
@export var unit_cost : int
@export var entity_tier : DataManager.EntityTier
# stats and multiplicators
var stats : Dictionary = {
	'health' : 0,
	'health_mult' : 1,
	'armor' : 0,
	'armor_mult' : 1,
	'physical_attack' : 0,
	'physical_attack_mult' : 1,
	'magical_attack' : 0,
	'magical_attack_mult' : 1,
	'hit_chance' : 100,
	'hit_chance_mult' : 1,
	'crit_chance' : 0,
	'crit_chance_mult' : 1,
	'crit_attack' : 50,
	'crit_attack_mult' : 1,
	'evade' : 0,
	'evade_mult' : 1,
	'shield' : 0,
	'shield_mult' : 1,
	'attack_speed' : 0,
	'attack_speed_mult' : 1,
	'move_speed' : 0,
	'move_speed_mult' : 1,
	'attack_range' : 0,
	'attack_range_mult' : 1,
	'life_steal' : 0,
	'life_steal_mult' : 1,
	'health_regen' : 0,
	'health_regen_mult' : 1,
	'health_regen_interval' : INF,
	'health_regen_interval_mult' : 1,
	'true_damage' : 0,
	'true_damage_mult' : 0,
	'scout_range' : 0,
	'scout_range_mult' : 1,
	'damage_mult_vs_all' : 1,
	'damage_mult_vs_castle' : 1,
	'damage_mult_vs_hell' : 1,
	'damage_mult_vs_forest' : 1,
	'inc_damage_magic_mult' : 1,
	'inc_damage_physical_mult' : 1,
	'inc_damage_mult_vs_all' : 1,
	'inc_damage_mult_vs_castle' : 1,
	'inc_damage_mult_vs_hell' : 1,
	'inc_damage_mult_vs_forest' : 1
}

@export var unit_state : DataManager.UnitState
@export var unit_owner : DataManager.UnitOwner
@export var unit_name : String
@export var unit_desc : String
@export var is_active : bool
@export var get_target_setting : DataManager.TargetSetting
@export var fight_point : Node2D

var is_should_change_state : bool 
var is_can_attack : bool = true
var current_target : Unit
var enemies_in_range : Array[Unit]
var is_in_fight : bool
var previous_state : DataManager.UnitState
var drop_chances : Dictionary

var current_health : float
var current_armor : float
var current_physical_attack : float
var current_magical_attack : float
var current_hit_chance : float
var current_crit_chance : float
var current_crit_attack : float
var current_evade : float
var current_shield : float
var current_attack_speed : float
var current_move_speed : float
var current_attack_range : float
var current_life_steal : float
var current_health_regen : float
var current_health_regen_interval : float
var current_true_damage : float
var current_scout_range : float
var current_damage_mult_vs_all : float
var current_damage_mult_vs_castle : float
var current_damage_mult_vs_hell : float
var current_damage_mult_vs_forest : float
var current_inc_damage_magic_mult : float
var current_inc_damage_physical_mult : float
var current_inc_damage_mult_vs_all : float
var current_inc_damage_mult_vs_castle : float
var current_inc_damage_mult_vs_hell : float
var current_inc_damage_mult_vs_forest : float

var actual_health : float

@onready var attack_range_collision: CollisionShape2D = %attack_range_collision
@onready var unit_anim_player: AnimationPlayer = %unit_anim_player
@onready var scout_range_collision: CollisionShape2D = %scout_range_collision
@onready var unit_sprite: Sprite2D = %unit_sprite
@onready var unit_collision: CollisionShape2D = %unit_collision
@onready var timer_aspd: Timer = %timer_aspd
@onready var attack_range: Area2D = %attack_range


func _ready() -> void:
	SignalManager.on_wave_done.connect(set_not_is_in_fight)
	SignalManager.on_unit_die.connect(clear_target)
	SignalManager.on_start_spawn.connect(set_is_in_fight)


func _process(delta: float) -> void:
	if not is_active:
		return

	match unit_state:
		DataManager.UnitState.WALK:
			if current_target and current_target.unit_state != DataManager.UnitState.DIED and current_target.unit_state != DataManager.UnitState.DEAD:
				var direction : Vector2 = (current_target.global_position - global_position).normalized()
				velocity = current_move_speed * direction
				move_and_slide()
				unit_sprite.flip_h = current_target and current_target.global_position.x < global_position.x
				# возможно здесь косяк
				if enemies_in_range.has(current_target):
					change_state(DataManager.UnitState.IDLE)
			else:
				current_target = get_enemy_on_field()
				if not current_target or current_target.unit_state == DataManager.UnitState.DIED or current_target.unit_state == DataManager.UnitState.DEAD:
					change_state(DataManager.UnitState.IDLE)
		DataManager.UnitState.IDLE:
			if is_in_fight and is_can_attack and Player.check_enemies(unit_owner):
				fight()
			else:
				if not check_is_on_point():
					change_state(DataManager.UnitState.WALK_TO_CASTLE)
		DataManager.UnitState.WALK_TO_CASTLE:
			var direction : Vector2
			if unit_owner == DataManager.UnitOwner.ENEMY:
				direction = (fight_point.global_position - global_position).normalized()
			else:
				direction = (fight_point.global_position - global_position).normalized()
			velocity = current_move_speed * direction
			move_and_slide()
			unit_sprite.flip_h = fight_point and fight_point.global_position.x < global_position.x
			if Player.check_enemies(unit_owner) or check_is_on_point():
				change_state(DataManager.UnitState.IDLE)


func generate_drop_chances():
	var drop_gold : int = entity_tier * DataManager.gold_drop_default + DataManager.gold_drop_default
	var drop_gold_chance : int = 100
	var drop_tokens : int = 1
	var drop_tokens_chance : int = DataManager.tokens_drop_chance
	var drop_food : int = 1
	var drop_food_chance : int = DataManager.food_drop_chance
	var drop_crystals : int = 1
	var drop_crystals_chance : int = DataManager.crystals_drop_chance * entity_tier
	drop_chances['drop_gold'] = drop_gold
	drop_chances['drop_gold_chance'] = drop_gold_chance
	drop_chances['drop_tokens'] = drop_tokens
	drop_chances['drop_tokens_chance'] = drop_tokens_chance
	drop_chances['drop_food'] = drop_food
	drop_chances['drop_food_chance'] = drop_food_chance
	drop_chances['drop_crystals'] = drop_crystals
	drop_chances['drop_crystals_chance'] = drop_crystals_chance

func apply_stats():
	current_health = stats.health * stats.health_mult
	current_armor = stats.armor * stats.armor_mult
	current_physical_attack = stats.physical_attack * stats.physical_attack_mult
	current_magical_attack = stats.magical_attack * stats.magical_attack_mult
	current_hit_chance = stats.hit_chance * stats.hit_chance_mult
	current_crit_chance = stats.crit_chance * stats.crit_chance_mult
	current_crit_attack = stats.crit_attack * stats.crit_attack_mult
	current_evade = stats.evade * stats.evade_mult
	current_shield = stats.shield * stats.shield_mult
	current_attack_speed = stats.attack_speed * stats.attack_speed_mult
	current_move_speed = stats.move_speed * stats.move_speed_mult
	current_attack_range = stats.attack_range * stats.attack_range_mult
	current_life_steal = stats.life_steal * stats.life_steal_mult
	current_health_regen = stats.health_regen * stats.health_regen_mult
	current_health_regen_interval = stats.health_regen_interval * stats.health_regen_interval_mult
	current_true_damage = stats.true_damage * stats.true_damage_mult
	current_scout_range = stats.scout_range * stats.scout_range_mult


func initialize(slot : Slot, owner : DataManager.UnitOwner):
	await get_tree().process_frame
	unit_owner = owner
	unit_state = DataManager.UnitState.IDLE
	unit_name = slot.slot_name
	unit_desc = slot.slot_description
	unit_types = slot.unit_types
	unit_cost = slot.unit_cost
	unit_family = slot.slot_res.unit_family
	unit_tier = slot.slot_unit_tier
	entity_tier = slot.entity_tier
	unit_sprite.texture = slot.slot_res.unit_sprite
	var ar_shape = CircleShape2D.new()
	ar_shape.radius = stats.attack_range
	attack_range_collision.shape  = ar_shape
	#var sr_shape = RectangleShape2D.new()
	#sr_shape.size = Vector2(stats.scout_range, 50)
	#scout_range_collision.shape  = sr_shape
	unit_anim_player.get_animation("attack").loop_mode = Animation.LOOP_LINEAR
	change_state(DataManager.UnitState.ATTACK)
	if unit_owner == DataManager.UnitOwner.ENEMY:
		unit_sprite.flip_h = true
	set_collisions_by_owner()
	Player.apply_heroes_skills(self)
	apply_stats()
	generate_drop_chances()
	actual_health = current_health
	if unit_owner == DataManager.UnitOwner.PLAYER:
		z_index = 3
	elif unit_owner == DataManager.UnitOwner.ENEMY:
		z_index = 2


func get_state() -> DataManager.UnitState:
	return unit_state


func set_active():
	await get_tree().process_frame
	is_active = true
	change_state(DataManager.UnitState.IDLE)
	unit_anim_player.get_animation("attack").loop_mode = Animation.LOOP_NONE


func set_collisions_by_owner():
	if unit_owner == DataManager.UnitOwner.PLAYER:
		set_collision_layer_value(2, true)
		attack_range.set_collision_mask_value(3, true)
	else:
		set_collision_layer_value(4, true)
		set_collision_layer_value(3, true)
		attack_range.set_collision_mask_value(2, true)


func parse_stats():
	var unique_stats : Dictionary
	for stat in DataManager.default_stats.keys():
		if  get('current_' + stat) == DataManager.default_stats[stat] or stat.contains('mult') or stat.contains('scout'):
			continue
		unique_stats[DataManager.default_stats_to_rus[stat]] = get('current_' + stat) if stat.contains('attack_speed') else int(get('current_' + stat)) 
	
	return unique_stats


func change_state(new_state : DataManager.UnitState):
	is_should_change_state = true
	previous_state = unit_state
	unit_state = new_state
	apply_state()


func apply_state():
	match unit_state:
		DataManager.UnitState.IDLE:
			if unit_state != DataManager.UnitState.DIED and unit_state != DataManager.UnitState.DEAD:
				#unit_anim_player.stop()
				unit_anim_player.play('idle')
		DataManager.UnitState.WALK:
			#unit_anim_player.stop()
			unit_anim_player.play('walk')
		DataManager.UnitState.ATTACK:
			#unit_anim_player.stop()
			unit_anim_player.play('attack')
		DataManager.UnitState.DIED:
			#unit_anim_player.stop()
			unit_anim_player.play('died')
		DataManager.UnitState.DEAD:
			#unit_anim_player.stop()
			unit_anim_player.play('dead')
		DataManager.UnitState.WALK_TO_CASTLE:
			#unit_anim_player.stop()
			unit_anim_player.play('walk')

	is_should_change_state = false
	# можно привязать логику к аним треку (дроп ресурса, стата, исчезновение, мб звук)


func _on_attack_range_body_entered(body: Node2D) -> void:
	var unit : Unit = body
	if unit.unit_owner == unit_owner:
		return
	if not enemies_in_range.has(unit) and unit.get_state() != DataManager.UnitState.DIED and unit.get_state() != DataManager.UnitState.DEAD:
		enemies_in_range.append(unit)


func _on_attack_range_body_exited(body: Node2D) -> void:
	var unit : Unit = body
	if unit.unit_owner == unit_owner:
		return
	enemies_in_range.erase(unit)


func fight():
	if unit_state == DataManager.UnitState.DIED or unit_state == DataManager.UnitState.DEAD:
		return
	
	current_target = get_target_by_setting()
	# если есть живой таргет в ренже атаки

	if current_target and current_target.unit_state != DataManager.UnitState.DIED and current_target.unit_state != DataManager.UnitState.DEAD:
		attack()
		return
	else:
		current_target = get_enemy_on_field()
	# если есть живой таргет на поле, то идем к нему, пока не дойдем в ренж атаки
	if current_target and current_target.unit_state != DataManager.UnitState.DIED and current_target.unit_state != DataManager.UnitState.DEAD:
		change_state(DataManager.UnitState.WALK)
	# если живого таргета нет, встаем в idle
	else:
		change_state(DataManager.UnitState.IDLE)


func stop_fight():
	is_in_fight = false


func attack():
	if not is_can_attack or timer_aspd.time_left > 0:
		return
	# установить скорость анимации исходя из скорости атаки
	unit_sprite.flip_h = current_target and current_target.global_position.x < global_position.x
	change_state(DataManager.UnitState.ATTACK)
	is_can_attack = false
	timer_aspd.wait_time = stats.attack_speed
	timer_aspd.start()
	apply_damage()


func attack_castle():
	var attack : float
	if unit_types.has(DataManager.UnitType.MAGE):
		attack = current_magical_attack
	elif unit_types.has(DataManager.UnitType.ASSASSIN):
		attack = current_true_damage
	elif unit_types.has(DataManager.UnitType.PHYS):
		attack = current_physical_attack
	Player.get_damage(round(attack))
	
	

func get_target_by_setting():
	var targets : Array[Unit]
	# понадобится проверка на освобожден
	for unit in enemies_in_range:
		if unit.get_state() != DataManager.UnitState.DIED and unit.get_state() != DataManager.UnitState.DEAD:
			targets.append(unit)
	if targets.size() == 0:
		return null
		
	match get_target_setting:
		DataManager.TargetSetting.CLOSEST:
			targets.sort_custom(custom_sort_closest)
		DataManager.TargetSetting.MAX_HP:
			targets.sort_custom(custom_sort_max_hp)
		DataManager.TargetSetting.LOW_HP:
			targets.sort_custom(custom_sort_low_hp)
	
	return targets[0]


func custom_sort_closest(a : Unit, b : Unit):
	return abs(global_position.distance_to(a.global_position)) < abs(global_position.distance_to(b.global_position))


func custom_sort_max_hp(a : Unit, b : Unit):
	return a.current_health > b.current_health


func custom_sort_low_hp(a : Unit, b : Unit):
	return a.current_health < b.current_health


func get_enemy_on_field():
	var targets : Array[Unit] = Player.get_enemies() if unit_owner == DataManager.UnitOwner.PLAYER else Player.get_player_units()
	if targets.size() == 0:
		return null
	# потом можно через match и target_setting
	targets.sort_custom(custom_sort_closest)
	return targets[0]


func get_damage(damage, damage_owner):
	if not is_active:
		return
	if actual_health - damage <= 0:
		actual_health = 0
		timer_aspd.stop()
		is_in_fight = false
		is_can_attack = false
		if unit_owner == DataManager.UnitOwner.PLAYER:
			Player.remove_unit_from_player_units(self)
		elif unit_owner == DataManager.UnitOwner.ENEMY:
			Player.remove_unit_from_enemy_units(self)
		z_index = 1
		is_active = false
		SignalManager.on_unit_die.emit(self)
		change_state(DataManager.UnitState.DIED)
		return
	actual_health -= damage


func set_not_is_in_fight():
	is_in_fight = false


func _on_timer_aspd_timeout() -> void:
	if unit_state == DataManager.UnitState.DIED or unit_state == DataManager.UnitState.DEAD:
		timer_aspd.stop()
	is_can_attack = true
	current_target = null
	change_state(DataManager.UnitState.IDLE)


func apply_damage():
	if not current_target or current_target.get_state() == DataManager.UnitState.DIED or current_target.get_state() == DataManager.UnitState.DEAD:
		change_state(DataManager.UnitState.IDLE)
		is_can_attack = true
		return
	
	# берем нужный тип атаки
	var attack : float
	
	if unit_types.has(DataManager.UnitType.MAGE):
		attack = current_magical_attack
	elif unit_types.has(DataManager.UnitType.ASSASSIN):
		attack = current_true_damage
	elif unit_types.has(DataManager.UnitType.PHYS):
		attack = current_physical_attack
	
	
	# проверка на хит
	var hit_chance : float = (current_hit_chance - current_target.current_evade) / 100
	var hit_check : float = randf()
	var is_hit : bool = hit_check <= hit_chance
	if not is_hit:
		# показать popup "промах"
		return
	
	# проверка на крит
	var crit_chance : float = current_crit_chance / 100
	var crit_check : float = randf()
	var is_crit : bool = crit_check <= crit_chance
	if is_crit:
		# поменять цвет попапа и размер
		attack += attack * (current_crit_attack / 100)

	if not current_target:
		return
	# проверка на броню
	if current_target.current_armor > 0:
		var armor = current_target.current_armor if current_target.current_armor < DataManager.max_armor else DataManager.max_armor 
		attack = attack * (1 - current_target.current_armor / 100)
		
	if not current_target:
		return
	# проверка на тип урона
	if unit_types.has(DataManager.UnitType.MAGE):
		attack *= (1 - current_target.current_inc_damage_magic_mult / 100)
	elif unit_types.has(DataManager.UnitType.ASSASSIN):
		attack *= (1 - current_target.current_inc_damage_physical_mult / 100)
	
	if not current_target:
		return
	# проверка на увеличение/уменьшение урона
	var global_mult : float
	match current_target.unit_family:
		DataManager.UnitFamily.CASTLE:
			global_mult += current_damage_mult_vs_castle 
		DataManager.UnitFamily.HELL:
			global_mult += current_damage_mult_vs_hell 
		DataManager.UnitFamily.FOREST:
			global_mult += current_damage_mult_vs_forest 
	match unit_family:
		DataManager.UnitFamily.CASTLE:
			global_mult -= current_target.current_inc_damage_mult_vs_castle 
		DataManager.UnitFamily.HELL:
			global_mult -= current_target.current_inc_damage_mult_vs_hell 
		DataManager.UnitFamily.FOREST:
			global_mult -= current_target.current_inc_damage_mult_vs_forest 
	global_mult += current_damage_mult_vs_all - current_target.current_inc_damage_mult_vs_all
	attack *= (1 - global_mult)
	if not current_target:
		return
	# применить урон к цели
	current_target.get_damage(round(attack), self)
	print('%s наносит %f урона %s' % [self.unit_name, attack, current_target.unit_name])


func die():
	change_state(DataManager.UnitState.DEAD)
	fight_point.is_filled = false
	drop_res()


func clear_target(unit : Unit):
	if current_target == unit:
		await get_tree().process_frame
		current_target = null


func drop_res():
	# голд дропает всегда
	var drop_check : float = randf()
	Player.get_res(DataManager.ResType.GOLD, drop_chances.drop_gold)
	# остальные ресурсы с шансом
	if drop_check <= drop_chances.drop_crystals_chance:
		Player.get_res(DataManager.ResType.CRYSTAL, drop_chances.drop_crystals)
		return
	if drop_check <= drop_chances.drop_food_chance:
		Player.get_res(DataManager.ResType.FOOD, drop_chances.drop_food)
		return
	if drop_check <= drop_chances.drop_tokens_chance:
		Player.get_res(DataManager.ResType.SPIN_TOKEN, drop_chances.drop_tokens)
		return


func set_is_in_fight():
	is_in_fight = true


func check_is_on_point():
	if fight_point:
		return abs(fight_point.global_position.x - global_position.x) < 10 and abs(fight_point.global_position.y - global_position.y) < 10
	return false
