extends Area2D

class_name Unit

@export var unit_family : DataManager.UnitFamily
@export var unit_tier : DataManager.UnitTier
@export var unit_types : Array[DataManager.UnitType]
@export var unit_cost : int
@export var entity_tier : DataManager.EntityTier
@export var info_popup_UI_scene : PackedScene
@export var info_damage_popup_ui_scene : PackedScene
@export var blood_particle_scene : PackedScene
@export var slot_resources : Array[Resource]
@export var slot_unit_res : SlotUnitRes
@export var tooltip_scene : PackedScene
@export var tooltip : TooltipUnit
@export var subtooltip_scene : PackedScene
@export var unit_attack_type : DataManager.AttackType
@export var unit_projectile_texture : Texture2D
@export var projectile_scene : PackedScene
# stats and multiplicators
var stats : Dictionary = {
	'health' : 0,
	'health_mult' : 1,
	'armor' : 0,
	'armor_mult' : 1,
	'magic_defence' : 0,
	'magic_defence_mult' : 1,
	'physical_attack' : 0,
	'physical_attack_mult' : 1,
	'magical_attack' : 0,
	'magical_attack_mult' : 1,
	'hit_chance' : 0,
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
	'true_damage_mult' : 1,
	'scout_range' : 0,
	'scout_range_mult' : 1,
	'damage_mult_vs_all' : 1,
	'damage_mult_vs_castle' : 1,
	'damage_mult_vs_hell' : 1,
	'damage_mult_vs_forest' : 1,
	'inc_damage_mult_vs_all' : 1,
	'inc_damage_mult_vs_castle' : 1,
	'inc_damage_mult_vs_hell' : 1,
	'inc_damage_mult_vs_forest' : 1,
	'projectile_speed' : 0,
	'projectile_speed_mult' : 1,
	'projectile_attack_range' : 0,
	'projectile_attack_range_mult' : 1,
}

@export var unit_state : DataManager.UnitState
@export var unit_owner : DataManager.UnitOwner
@export var unit_name : String
@export var unit_desc : String
@export var is_active : bool
@export var get_target_setting : DataManager.TargetSetting
@export var fight_point : Node2D
@export var is_tooltip_shown : bool

var slots : Array[Slot]
var is_should_change_state : bool 
var is_can_attack : bool = true
var current_target : Unit
var enemies_in_range : Array[Unit]
var is_in_fight : bool
var previous_state : DataManager.UnitState
var drop_chances : Dictionary
var unique_stats : Dictionary
var unique_stats_related : Dictionary
var current_health : float
var current_armor : float
var current_magic_defence : float
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
var current_health_mult : float
var current_armor_mult : float
var current_magic_defence_mult : float
var current_physical_attack_mult : float
var current_magical_attack_mult : float
var current_hit_chance_mult : float
var current_crit_chance_mult : float
var current_crit_attack_mult : float
var current_evade_mult : float
var current_shield_mult : float
var current_attack_speed_mult : float
var current_move_speed_mult : float
var current_attack_range_mult : float
var current_life_steal_mult : float
var current_health_regen_mult : float
var current_health_regen_interval_mult : float
var current_true_damage_mult : float
var current_scout_range_mult : float
var current_damage_mult_vs_all : float
var current_damage_mult_vs_castle : float
var current_damage_mult_vs_hell : float
var current_damage_mult_vs_forest : float
var current_inc_damage_mult_vs_all : float
var current_inc_damage_mult_vs_castle : float
var current_inc_damage_mult_vs_hell : float
var current_inc_damage_mult_vs_forest : float
var current_projectile_speed : float
var current_projectile_attack_range : float

var actual_health : float

var movement_offset : Vector2

@onready var attack_range_collision: CollisionShape2D = %attack_range_collision
@onready var unit_anim_player: AnimationPlayer = %unit_anim_player
@onready var scout_range_collision: CollisionShape2D = %scout_range_collision
@onready var unit_sprite: Sprite2D = %unit_sprite
@onready var unit_collision: CollisionShape2D = %unit_collision
@onready var timer_aspd: Timer = %timer_aspd
@onready var attack_range: Area2D = %attack_range
@onready var unit_status_sprite: Sprite2D = %unit_status_sprite
@onready var timer_regen: Timer = %timer_regen
@onready var collide_range: Area2D = %collide_range
@onready var unit_shadow_sprite: Sprite2D = %unit_shadow_sprite


func _ready() -> void:
	SignalManager.on_wave_done.connect(set_not_is_in_fight)
	#SignalManager.on_unit_die.connect(clear_target)
	SignalManager.on_start_spawn.connect(set_is_in_fight)
	SignalManager.on_hide_unit_tooltip.connect(hide_unit_tooltip)


func _process(delta: float) -> void:
	if not is_active:
		return

	match unit_state:
		DataManager.UnitState.WALK:
			if enemies_in_range.size() > 0:
				if is_in_fight and is_can_attack:
					fight()
					return
			if global_position.y < DataManager.upper_fight_limit or global_position.y > DataManager.bottom_fight_limit:
				movement_offset *= -1 
			current_target = get_enemy_on_field()
			if current_target and current_target.unit_state != DataManager.UnitState.DIED and current_target.unit_state != DataManager.UnitState.DEAD:
				var direction : Vector2 = (current_target.global_position - global_position).normalized()
				global_position += current_move_speed * (direction + movement_offset) * DataManager.action_speed_coeff * DataManager.move_speed_coeff * delta
				#move_and_slide()
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
			if Player.check_enemies(unit_owner) or check_is_on_point():
				change_state(DataManager.UnitState.IDLE)
				return
			var direction : Vector2
			if unit_owner == DataManager.UnitOwner.ENEMY:
				direction = (fight_point.global_position - global_position).normalized()
				global_position += current_move_speed * direction * DataManager.action_speed_coeff * DataManager.move_speed_coeff * delta
			else:
				direction = (fight_point.global_position - global_position).normalized()
				global_position += current_move_speed * direction * DataManager.action_speed_coeff * DataManager.move_speed_coeff * delta
			#move_and_slide()
			unit_sprite.flip_h = fight_point and fight_point.global_position.x < global_position.x
			# здесь баг?


func generate_drop_chances():
	var drop_gold : int = entity_tier * DataManager.gold_drop_default + DataManager.gold_drop_default
	var drop_gold_chance : float = 100
	var drop_tokens : int = 1
	var drop_tokens_chance : float = DataManager.tokens_drop_chance
	var drop_food : int = 1
	var drop_food_chance : float = DataManager.food_drop_chance
	var drop_crystals : int = 1
	var drop_crystals_chance : float = DataManager.crystals_drop_chance * entity_tier
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
	current_magic_defence = stats.magic_defence * stats.magic_defence_mult
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
	current_damage_mult_vs_all = stats.damage_mult_vs_all
	current_damage_mult_vs_castle = stats.damage_mult_vs_castle
	current_damage_mult_vs_hell = stats.damage_mult_vs_hell
	current_damage_mult_vs_forest = stats.damage_mult_vs_forest
	current_inc_damage_mult_vs_all = stats.inc_damage_mult_vs_all
	current_inc_damage_mult_vs_castle = stats.inc_damage_mult_vs_castle
	current_inc_damage_mult_vs_hell = stats.inc_damage_mult_vs_hell
	current_inc_damage_mult_vs_forest = stats.inc_damage_mult_vs_forest
	current_projectile_speed = stats.projectile_speed * stats.projectile_speed_mult
	current_projectile_attack_range = stats.projectile_attack_range * stats.projectile_attack_range_mult
	current_health_mult = stats.health_mult
	current_armor_mult = stats.armor_mult
	current_magic_defence_mult = stats.magic_defence_mult
	current_physical_attack_mult = stats.physical_attack_mult
	current_magical_attack_mult = stats.magical_attack_mult
	current_hit_chance_mult = stats.hit_chance_mult
	current_crit_chance_mult = stats.crit_chance_mult
	current_crit_attack_mult = stats.crit_attack_mult
	current_evade_mult = stats.evade_mult
	current_shield_mult = stats.shield_mult
	current_attack_speed_mult = stats.attack_speed_mult
	current_move_speed_mult = stats.move_speed_mult
	current_attack_range_mult = stats.attack_range_mult
	current_life_steal_mult = stats.life_steal_mult
	current_health_regen_mult = stats.health_regen_mult
	current_health_regen_interval_mult = stats.health_regen_interval_mult
	current_true_damage_mult = stats.true_damage_mult
	current_scout_range_mult = stats.scout_range_mult


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
	unit_attack_type = slot.unit_attack_type
	unit_sprite.texture = slot.slot_res.unit_sprite
	slot_unit_res = slot.slot_res
	if unit_types.has(DataManager.UnitType.RANGE):
		unit_projectile_texture = slot.unit_projectile_texture

	#var sr_shape = RectangleShape2D.new()
	#sr_shape.size = Vector2(stats.scout_range, 50)
	#scout_range_collision.shape  = sr_shape
	#unit_anim_player.get_animation("attack").loop_mode = Animation.LOOP_LINEAR
	change_state(DataManager.UnitState.ATTACK)
	if unit_owner == DataManager.UnitOwner.ENEMY:
		unit_sprite.flip_h = true
	set_collisions_by_owner()
	#Player.apply_heroes_skills(self)
	apply_stats()
	generate_drop_chances()
	var ar_shape = CircleShape2D.new()
	ar_shape.radius = current_attack_range
	attack_range_collision.shape  = ar_shape
	actual_health = current_health
	if unit_owner == DataManager.UnitOwner.PLAYER:
		z_index = 3
	elif unit_owner == DataManager.UnitOwner.ENEMY:
		z_index = 2
	setup_target_setting_by_type()
	set_unit_collistion_params()
	set_shadow()
	movement_offset = Vector2(0, randf_range(DataManager.movement_offset_min, DataManager.movement_offset_max))
	#parse_stats()
	#create_tooltip()
	# can be bug
	#slots.clear()
	# перевод?
	if entity_tier == DataManager.EntityTier.T3 or entity_tier == DataManager.EntityTier.T4:
		if unit_name != 'баллиста' and unit_name != 'оружейная башня':
			scale = Vector2(0.8, 0.8)


func get_state() -> DataManager.UnitState:
	return unit_state


func set_active():
	await get_tree().process_frame
	is_active = true
	unit_anim_player.stop()
	unit_anim_player.get_animation("attack").loop_mode = Animation.LOOP_NONE
	change_state(DataManager.UnitState.IDLE)
	timer_regen.wait_time = current_health_regen_interval
	timer_regen.start()

func set_collisions_by_owner():
	if unit_owner == DataManager.UnitOwner.PLAYER:
		set_collision_layer_value(2, true)
		#collide_range.set_collision_layer_value(10, true)
		#collide_range.set_collision_mask_value(10, true)
		#set_collision_layer_value(10, true)
		#set_collision_mask_value(10, true)
		attack_range.set_collision_mask_value(3, true)
	else:
		set_collision_layer_value(4, true)
		set_collision_layer_value(3, true)
		#collide_range.set_collision_layer_value(11, true)
		#collide_range.set_collision_mask_value(11, true)
		#set_collision_layer_value(11, true)
		#set_collision_mask_value(11, true)
		attack_range.set_collision_mask_value(2, true)


func parse_stats():
	var current_locale : String = TranslationServer.get_locale()
	var current_stat_names_table : Dictionary
	match current_locale:
		'en_US':
			current_stat_names_table = DataManager.default_stats_to_en
		'ru_RU':
			current_stat_names_table = DataManager.default_stats_to_rus
	unique_stats = {}
	for stat in DataManager.default_stats.keys():
		if get('current_' + stat) == DataManager.default_stats[stat] or stat.contains('mult') or stat.contains('scout'):
			continue
		generate_related_stats(stat, current_stat_names_table)
		unique_stats[current_stat_names_table[stat]] = get('current_' + stat) if stat.contains('attack_speed') else int(get('current_' + stat)) 
	
	return unique_stats


func generate_related_stats(stat, current_stat_names_table):
	if get('current_' + stat) == slot_unit_res[stat]:
		unique_stats_related[current_stat_names_table[stat]] = DataManager.RelateType.EQUAL
	elif get('current_' + stat) > slot_unit_res[stat]:
		unique_stats_related[current_stat_names_table[stat]] = DataManager.RelateType.GREATER
	elif get('current_' + stat) < slot_unit_res[stat]:
		unique_stats_related[current_stat_names_table[stat]] = DataManager.RelateType.LESSER
	if stat == 'attack_speed':
		if unique_stats_related[current_stat_names_table[stat]] == DataManager.RelateType.GREATER:
			unique_stats_related[current_stat_names_table[stat]] = DataManager.RelateType.LESSER
		elif unique_stats_related[current_stat_names_table[stat]] == DataManager.RelateType.LESSER:
			unique_stats_related[current_stat_names_table[stat]] = DataManager.RelateType.GREATER
			
			
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
				unit_anim_player.speed_scale = DataManager.action_speed_coeff
		DataManager.UnitState.WALK:
			#unit_anim_player.stop()
			unit_anim_player.play('walk')
			unit_anim_player.speed_scale = current_move_speed / 30 * DataManager.action_speed_coeff
		DataManager.UnitState.ATTACK:
			#unit_anim_player.stop()
			unit_anim_player.play('attack')
		DataManager.UnitState.DIED:
			#unit_anim_player.stop()
			unit_anim_player.play('died')
			unit_anim_player.speed_scale = DataManager.action_speed_coeff
		DataManager.UnitState.DEAD:
			#unit_anim_player.stop()
			unit_anim_player.play('dead')
			unit_anim_player.speed_scale = DataManager.action_speed_coeff
		DataManager.UnitState.WALK_TO_CASTLE:
			#unit_anim_player.stop()
			unit_anim_player.play('walk')
			unit_anim_player.speed_scale = current_move_speed / 30 * DataManager.action_speed_coeff

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

	if current_target and is_instance_valid(current_target) and current_target.unit_state != DataManager.UnitState.DIED and current_target.unit_state != DataManager.UnitState.DEAD:
		attack()
		return
	else:
		current_target = get_enemy_on_field()
	# если есть живой таргет на поле, то идем к нему, пока не дойдем в ренж атаки
	if current_target and is_instance_valid(current_target) and current_target.unit_state != DataManager.UnitState.DIED and current_target.unit_state != DataManager.UnitState.DEAD:
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
	unit_anim_player.speed_scale = 2 / current_attack_speed * DataManager.action_speed_coeff
	change_state(DataManager.UnitState.ATTACK)
	is_can_attack = false
	if unit_types.has(DataManager.UnitType.MELEE):
		SoundManager.play(self, DataManager.sound_dict[DataManager.SoundType.MELEE])
		if unit_attack_type == DataManager.AttackType.AOE:
			var enemies : Array[Unit] = enemies_in_range.duplicate()
			for target in enemies:
				apply_damage(target)
		else:
			apply_damage(current_target)
	elif unit_types.has(DataManager.UnitType.RANGE):
		SoundManager.play(self, DataManager.sound_dict[DataManager.SoundType.RANGE])
		create_projectile(current_target)
	timer_aspd.wait_time = current_attack_speed / DataManager.action_speed_coeff
	timer_aspd.start()


func attack_castle():
	#var attack : float
	#if unit_types.has(DataManager.UnitType.MAGE):
		#attack = current_magical_attack
	#elif unit_types.has(DataManager.UnitType.ASSASSIN):
		#attack = current_true_damage
	#elif unit_types.has(DataManager.UnitType.PHYS):
		#attack = current_physical_attack
	SoundManager.play(self, DataManager.sound_dict[DataManager.SoundType.CASTLE_HIT])
	Player.get_damage(ceil(DataManager.default_damage_to_base / (5 - entity_tier)))
	
	

func get_target_by_setting():
	var targets : Array[Unit]
	# понадобится проверка на освобожден
	for unit in enemies_in_range:
		if unit.unit_state != DataManager.UnitState.DIED and unit.unit_state != DataManager.UnitState.DEAD:
			targets.append(unit)
	if targets.size() == 0:
		return null
		
	#match get_target_setting:
		#DataManager.TargetSetting.CLOSEST:
			#targets.sort_custom(custom_sort_closest)
		#DataManager.TargetSetting.MAX_HP:
			#targets.sort_custom(custom_sort_max_hp)
		#DataManager.TargetSetting.LOW_HP:
			#targets.sort_custom(custom_sort_low_hp)
	targets.shuffle()
	
	return targets[0]


func custom_sort_closest(a : Unit, b : Unit):
	return abs(global_position.distance_to(a.global_position)) < abs(global_position.distance_to(b.global_position))


func custom_sort_closest_y(a : Unit, b : Unit):
	return abs(global_position.y - a.global_position.y) < abs(global_position.y - b.global_position.y)


func custom_sort_max_hp(a : Unit, b : Unit):
	return a.current_health > b.current_health


func custom_sort_low_hp(a : Unit, b : Unit):
	return a.current_health < b.current_health


func setup_target_setting_by_type():
	if unit_types.has(DataManager.UnitType.RANGE):
		get_target_setting = DataManager.TargetSetting.CLOSEST
	elif unit_types.has(DataManager.UnitType.MELEE):
		if randf() < 0.3:
			get_target_setting = DataManager.TargetSetting.MAX_HP
		else:
			get_target_setting = DataManager.TargetSetting.CLOSEST_Y
	elif unit_types.has(DataManager.UnitType.TANK):
		get_target_setting = DataManager.TargetSetting.LOW_HP


func get_enemy_on_field():
	var targets : Array[Unit] = Player.get_enemies() if unit_owner == DataManager.UnitOwner.PLAYER else Player.get_player_units()
	if targets.size() == 0:
		return null
	# потом можно через match и target_setting
	match get_target_setting:
		DataManager.TargetSetting.CLOSEST:
			targets.sort_custom(custom_sort_closest)
		DataManager.TargetSetting.MAX_HP:
			targets.sort_custom(custom_sort_max_hp)
		DataManager.TargetSetting.LOW_HP:
			targets.sort_custom(custom_sort_low_hp)
		DataManager.TargetSetting.CLOSEST_Y:
			targets.sort_custom(custom_sort_closest_y)

	return targets[0]


func get_damage(damage : int, damage_owner : Object, is_crit : bool = false):
	if not is_active:
		return
	show_damage(damage, is_crit)
	show_blood()
	if unit_owner == DataManager.UnitOwner.PLAYER:
		SoundManager.play(self, DataManager.sound_dict[DataManager.SoundType.HIT_SELF])
	else:
		SoundManager.play(self, DataManager.sound_dict[DataManager.SoundType.HIT_ENEMY])
	if actual_health - damage <= 0:
		if unit_owner == DataManager.UnitOwner.PLAYER:
			SoundManager.play(self, DataManager.sound_dict[DataManager.SoundType.DIED_SELF])
		Player.update_statistics(unit_owner)
		actual_health = 0
		timer_aspd.stop()
		timer_regen.stop()
		is_in_fight = false
		is_can_attack = false
		input_pickable = false
		set_deferred('monitorable', false)
		collide_range.set_deferred('monitoring', false)
		unit_collision.set_deferred('disabled', true)
		if tooltip:
			hide_tooltip()
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



func apply_damage(new_current_target : Unit):
	current_target = new_current_target
	if not current_target or not is_instance_valid(current_target) or current_target.get_state() == DataManager.UnitState.DIED or current_target.get_state() == DataManager.UnitState.DEAD:
		return
	
	# берем нужный тип атаки
	var attack : float
	
	if unit_types.has(DataManager.UnitType.MAGE):
		attack = current_magical_attack
	elif unit_types.has(DataManager.UnitType.ASSASSIN):
		attack = current_true_damage
	elif unit_types.has(DataManager.UnitType.PHYS):
		attack = current_physical_attack
	
	
	# проверка на хит (мдля маг урона не работает эвейд)
	var hit_chance : float = (current_hit_chance - current_target.current_evade if current_target.current_evade <= DataManager.default_evade else DataManager.default_evade) / 100 if not unit_types.has(DataManager.UnitType.MAGE) else current_hit_chance / 100
	var hit_check : float = randf()
	var is_hit : bool = hit_check <= hit_chance
	if not is_hit:
		# показать popup "промах"
		show_miss()
		return
	
	# проверка на крит
	var crit_chance : float = current_crit_chance / 100
	var crit_check : float = randf()
	var is_crit : bool = crit_check <= crit_chance
	if is_crit:
		# поменять цвет попапа и размер
		attack += attack * (current_crit_attack / 100)

	if not current_target or not is_instance_valid(current_target):
		return
	# проверка на броню
	var armor = current_target.current_armor if current_target.current_armor < DataManager.max_armor else DataManager.max_armor
	var magic_defence = current_target.current_magic_defence if current_target.current_magic_defence < DataManager.max_armor else DataManager.max_armor
	if unit_types.has(DataManager.UnitType.MAGE):
		attack *= ((100 - magic_defence) / 100)
	elif unit_types.has(DataManager.UnitType.PHYS):
		attack *= ((100 - armor) / 100)

	if not current_target or not is_instance_valid(current_target):
		return
	# проверка на увеличение/уменьшение урона
	var global_mult : float = 1
	match current_target.unit_family:
		DataManager.UnitFamily.CASTLE:
			global_mult += abs(1 - current_damage_mult_vs_castle) 
		DataManager.UnitFamily.HELL:
			global_mult += abs(1 - current_damage_mult_vs_hell) 
		DataManager.UnitFamily.FOREST:
			global_mult += abs(1 - current_damage_mult_vs_forest) 
	match unit_family:
		DataManager.UnitFamily.CASTLE:
			global_mult += (1 - current_target.current_inc_damage_mult_vs_castle) 
		DataManager.UnitFamily.HELL:
			global_mult += (1 - current_target.current_inc_damage_mult_vs_hell) 
		DataManager.UnitFamily.FOREST:
			global_mult += (1 - current_target.current_inc_damage_mult_vs_forest) 
	global_mult += current_damage_mult_vs_all - current_target.current_inc_damage_mult_vs_all
	attack = attack * global_mult if global_mult > DataManager.min_damage_mult else attack * DataManager.min_damage_mult
	if not current_target or not is_instance_valid(current_target):
		return
	# применить урон к цели
	#print('%s наносит %f урона %s' % [self.unit_name, attack, current_target.unit_name])
	if current_life_steal > 0 and current_target and is_instance_valid(current_target) and current_target.get_state() != DataManager.UnitState.DIED and current_target.get_state() != DataManager.UnitState.DEAD:
		get_health(round(attack / 100 * current_life_steal))
	current_target.get_damage(round(attack), self, is_crit)


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
	show_getting_res(DataManager.ResType.GOLD, drop_chances.drop_gold, 0)
	# остальные ресурсы с шансом
	if drop_check <= drop_chances.drop_crystals_chance:
		Player.get_res(DataManager.ResType.CRYSTAL, drop_chances.drop_crystals)
		show_getting_res(DataManager.ResType.CRYSTAL, drop_chances.drop_crystals, 10)
		return
	if drop_check <= drop_chances.drop_food_chance:
		Player.get_res(DataManager.ResType.FOOD, drop_chances.drop_food)
		show_getting_res(DataManager.ResType.FOOD, drop_chances.drop_food, 10)
		return
	if drop_check <= drop_chances.drop_tokens_chance:
		Player.get_res(DataManager.ResType.SPIN_TOKEN, drop_chances.drop_tokens)
		show_getting_res(DataManager.ResType.SPIN_TOKEN, drop_chances.drop_tokens, 10)
		return


func set_is_in_fight():
	is_in_fight = true


func check_is_on_point():
	if fight_point:
		return abs(fight_point.global_position.x - global_position.x) < 5 and abs(fight_point.global_position.y - global_position.y) < 5
	return false


func show_getting_res(res_type, res_amount, x_offset : float):
	var info_popup_UI : InfoResPopupUI = info_popup_UI_scene.instantiate()
	info_popup_UI.set_data(res_type, res_amount)
	SignalManager.on_drop_res_popup.emit(self, info_popup_UI, x_offset)


func show_damage(damage : int, is_crit):
	var info_damage_popup_ui : InfoDamagePopupUI = info_damage_popup_ui_scene.instantiate()
	info_damage_popup_ui.set_unit_owner(unit_owner)
	info_damage_popup_ui.set_amount(damage)
	info_damage_popup_ui.set_is_crit(is_crit)
	SignalManager.on_show_damage.emit(self, info_damage_popup_ui)


func show_miss():
	if current_target:
		var info_damage_popup_ui : InfoDamagePopupUI = info_damage_popup_ui_scene.instantiate()
		info_damage_popup_ui.set_unit_owner(current_target.unit_owner)
		info_damage_popup_ui.set_amount(0)
		SignalManager.on_show_damage.emit(current_target, info_damage_popup_ui)


func show_blood():
	var blood_particle : CPUParticles2D = blood_particle_scene.instantiate()
	add_child(blood_particle)
	blood_particle.emitting = true
	

func add_slot_res(new_slot_res : Resource):
	if tr(new_slot_res.slot_name) == DataManager.empty_slot_name or tr(new_slot_res.slot_name) == DataManager.empty_slot_name_en:
		return
	slot_resources.append(new_slot_res)


func create_tooltip():
	# проверяем статы и парсим новый
	parse_stats()
	tooltip = tooltip_scene.instantiate()
	tooltip.set_tooltip_owner(self)
	tooltip.set_entity_name(unit_name)
	tooltip.set_entity_desc(unit_desc)
	tooltip.set_entity_tier(entity_tier)
	# set unit types str
	var unit_types_str : String
	var current_locale : String = TranslationServer.get_locale()
	var current_unit_types_table : Dictionary
	var current_stats_table : Dictionary
	match current_locale:
		'en_US':
			current_unit_types_table = DataManager.unit_types_table_en
			current_stats_table = DataManager.default_stats_to_en
		'ru_RU':
			current_unit_types_table = DataManager.unit_types_table
			current_stats_table = DataManager.default_stats_to_rus
	for type in unit_types:
		unit_types_str += current_unit_types_table[type]
		unit_types_str += '\n'
	tooltip.set_unit_types(unit_types_str)
	# set preview texture
	tooltip.set_preview_texture(slot_unit_res.slot_sprite)
	# set stats
	var unit_stats : String
	for stat in unique_stats.keys():
		var pre_string : String
		if stat.contains('здоровье') or stat.contains('health'):
			pre_string = '%s %s/%s' % [stat.replace('_', ' '), int(actual_health), unique_stats[stat]]
		else:
			pre_string = '%s %s' % [stat.replace('_', ' '), unique_stats[stat]]
		if stat.contains('точность') or stat.contains('шанс') or stat.contains('уворот') or stat.contains('chance') or stat.contains('accuracy') or stat.contains('dodge'):
			pre_string += '%'
		if unique_stats_related[stat] == DataManager.RelateType.EQUAL:
			pre_string = '[color=#341c27]%s[/color]' % pre_string
		elif unique_stats_related[stat] == DataManager.RelateType.GREATER:
			pre_string = '[color=#25562e]%s[/color]' % pre_string
		elif unique_stats_related[stat] == DataManager.RelateType.LESSER:
			pre_string = '[color=#a53030]%s[/color]' % pre_string
		unit_stats += pre_string + '\n'
	tooltip.set_stats(unit_stats)
	# create subtooltips
	for slot_res in slot_resources:
		var subtooltip : SubTooltip = subtooltip_scene.instantiate()
		subtooltip.set_entity_name(slot_res.slot_name)
		subtooltip.set_entity_desc(slot_res.slot_description)
		subtooltip.set_preview_texture(slot_res.slot_sprite)
		tooltip.add_subtooltip(subtooltip)


func show_tooltip():
	create_tooltip()
	SignalManager.on_show_tooltip.emit(self, tooltip)
	get_tree().create_timer(10).timeout.connect(hide_tooltip)


func hide_tooltip():
	if tooltip and is_instance_valid(tooltip):
		tooltip.queue_free()


func hide_unit_tooltip(new_tooltip : Tooltip):
	if new_tooltip == tooltip:
		hide_tooltip()


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			#if not is_tooltip_shown:
				#is_tooltip_shown = true
			show_tooltip()


func add_slot(slot : Slot):
	slots.append(slot)


func _on_timer_regen_timeout() -> void:
	apply_regen()


func apply_regen():
	if unit_state == DataManager.UnitState.DIED or unit_state == DataManager.UnitState.DEAD:
		return  
	if current_health_regen < 0:
		get_damage(-current_health_regen, self)
		return
	get_health(current_health_regen)


func get_health(health_amount : int):
	if actual_health >= current_health or health_amount == 0:
		return
	var actual_health_amount : int = health_amount if actual_health + health_amount <= current_health else current_health - actual_health
	actual_health += actual_health_amount
	show_heal(actual_health_amount)


func show_heal(actual_health_amount : int):
	var info_heal_popup_ui : InfoDamagePopupUI = info_damage_popup_ui_scene.instantiate()
	info_heal_popup_ui.set_unit_owner(unit_owner)
	info_heal_popup_ui.set_amount(actual_health_amount)
	info_heal_popup_ui.set_action_type(DataManager.ActionType.HEAL)
	SignalManager.on_show_damage.emit(self, info_heal_popup_ui)


func update_health_regen_interval():
	timer_regen.stop()
	timer_regen.wait_time = current_health_regen_interval
	timer_regen.start()


func show_buff():
	unit_status_sprite.frame = 0
	unit_status_sprite.show()


func show_debuff():
	unit_status_sprite.frame = 1
	unit_status_sprite.show()


func hide_status():
	unit_status_sprite.hide()


#func _on_collide_range_area_entered(area: Area2D) -> void:
	#var new_velocity : Vector2
	#var new_unit_velocity : Vector2
	#var unit : Unit = area.get_parent()
	## чекаем в какую сторону смотрим
	#var is_to_left = unit_sprite.flip_h
	#var unit_is_to_left = unit.unit_sprite.flip_h
	## если мы смотрим в одну сторону
	#if is_to_left == unit_is_to_left:
		## обрабатываем только когда отстаем
		#if is_to_left and global_position.x < unit.global_position.x:
			#return
		#if not is_to_left and global_position.x > unit.global_position.x:
			#return
		## обработка
		## чуть отскакиваем назад
		#if is_to_left:
			#new_velocity.x = current_move_speed * 3
		#else:
			#new_velocity.x = -current_move_speed * 3
		#if unit.unit_state != DataManager.UnitState.ATTACK:
			#new_unit_velocity.x = -new_velocity.x
		## пытаемся обойти снизу
		#if global_position.y >= unit.global_position.y:
			#new_velocity.y = current_move_speed * 3
		#else:
			#new_velocity.y = -current_move_speed * 3
#
	#velocity = new_velocity
	#unit.velocity = new_unit_velocity
	#move_and_slide()
	##unit.move_and_slide()


func set_unit_collistion_params():
	var frame_size : Vector2 = Vector2(unit_sprite.texture.get_height() / 5, unit_sprite.texture.get_height() / 5)
	var capsule_shape = CapsuleShape2D.new()
	# Ensure collision shape dimensions match the mesh dimensions
	var coeff : float = 1
	if entity_tier == DataManager.EntityTier.T3 or entity_tier == DataManager.EntityTier.T4:
		if unit_name != 'баллиста' and unit_name != 'оружейная башня':
			coeff = 0.8
	capsule_shape.radius = frame_size.x / 4 * coeff
	capsule_shape.height = frame_size.y * 2 / 3 * coeff
	unit_collision.shape = capsule_shape
	unit_collision.position.y = frame_size.y / 6 * coeff

 
func set_shadow():
	var frame_size : Vector2 = Vector2(unit_sprite.texture.get_height() / 5, unit_sprite.texture.get_height() / 5)
	unit_shadow_sprite.position.y = frame_size.y / 2 - frame_size.y / 100
	unit_shadow_sprite.scale = Vector2(frame_size.y / unit_shadow_sprite.texture.get_height() / 7, frame_size.y / unit_shadow_sprite.texture.get_height() / 7)


func create_projectile(target : Unit):
	var projectile : Projectile = projectile_scene.instantiate()
	projectile.set_projectile_owner(self)
	projectile.set_projectile_speed(current_projectile_speed)
	projectile.set_target(target)
	projectile.set_unit_projectile_texture(unit_projectile_texture)
	#var initial_offset = -unit_sprite.texture.get_width() / 2 if global_position.x >= target.global_position.x else unit_sprite.texture.get_width() / 2
	var initial_offset = 0
	SignalManager.on_create_projectile.emit(projectile, Vector2(global_position.x + initial_offset, global_position.y))


func _on_attack_range_area_entered(area: Area2D) -> void:
	var unit : Unit = area
	if unit.unit_owner == unit_owner:
		return
	if not enemies_in_range.has(unit) and unit.get_state() != DataManager.UnitState.DIED and unit.get_state() != DataManager.UnitState.DEAD:
		enemies_in_range.append(unit)


func _on_attack_range_area_exited(area: Area2D) -> void:
	var unit : Unit = area
	if unit.unit_owner == unit_owner:
		return
	enemies_in_range.erase(unit)
