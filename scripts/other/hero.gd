extends PanelContainer

class_name Hero


@export var hero_name : String
@export var hero_family : DataManager.UnitFamily
@export var hero_class : DataManager.HeroClass
@export var hero_level : int = 1
@export var hero_gender : DataManager.HeroGender
@export var hero_portrait : Texture2D
@export var passives_reses : Array[Resource]
@export var actives_reses : Array[Resource]
@export var hero_slot_res : SlotResUtil
@export var hero_slot : Slot

var passives : Array[PassiveSkill]
var actives : Array[ActiveSkill]
var is_active : bool
var previous_position : Vector2
var slot_container : BoxContainer

# мощь атакующих заклинаний
# урон заклинания = базовый урон + базовый урон / 4 * power
@export var power : int
# скорость восстановления заклинаний
# кд = базовый кд = базовый кд / 20 * quickness
@export var quickness : int
# размер зоны
# базовый радиус = базовый радиус + базовый радиус / 10 * mastery
@export var mastery : int
# сила бафов / лечения и продолжительность 
# размер лечения = базовое лечение + базовое лечение / 4 * grace
# размер бафа = базовый баф + базовый баф / 10 * grade (может быть 10 = 15)
# длительность бафа = базовая длительность + базовая длительность / 10
@export var grace : int

@onready var label_hero_name: Label = %label_hero_name
@onready var rect_hero_portrait: TextureRect = %rect_hero_portrait
@onready var skills: VBoxContainer = %skills
@onready var active_container: HBoxContainer = %active_container
@onready var passive_container: HBoxContainer = %passive_container
@onready var label_hero_class: Label = %label_hero_class
@onready var label_hero_level: Label = %label_hero_level
@onready var hero_info_cont: HBoxContainer = %hero_info_cont
@onready var hero_level_cont: HBoxContainer = %hero_level_cont
@onready var filler: Control = %filler


func initialize():
	await get_tree().process_frame
	var current_locale : String = TranslationServer.get_locale()
	var current_hero_class_table : Dictionary
	match current_locale:
		'en_US':
			current_hero_class_table = DataManager.hero_classes_table_en
		'ru_RU':
			current_hero_class_table = DataManager.hero_classes_table
	label_hero_name.text = hero_name
	rect_hero_portrait.texture = hero_portrait
	label_hero_class.text = current_hero_class_table[hero_class]
	update_hero_level()
	# добавляем скиллы
	# скорректировать
	for res in passives_reses:
		var passive : Skill = Player.create_passive_skill(res)
		# установить нужные данные для скилла
		passive_container.add_child(passive)
		passive.set_skill_owner(self)
		passive.initialize()
		#passives.append(passive)
		add_passive_skill(passive)
	for res in actives_reses:
		var active : Skill = Player.create_active_skill(res)
		# установить нужные данные для скилла
		active_container.add_child(active)
		active.set_skill_owner(self)
		active.initialize()
		add_active_skill(active)
		#actives.append(active)
	is_active = true
	slot_container = BoxContainer.new()
	slot_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	slot_container.size = DataManager.slot_size
	slot_container.size_flags_horizontal = Control.SIZE_SHRINK_END
	hero_level_cont.add_child(slot_container)
	hero_slot = Player.create_slot_scene(hero_slot_res).instantiate()
	slot_container.add_child(hero_slot)
	hero_slot.initialize()
	hero_slot.input_pickable = true
	await get_tree().process_frame
	hero_slot.slot_back_sprite.hide()


func set_stats(new_power : int, new_quickness : int, new_mastery : int, new_grace : int):
	power = new_power
	quickness = new_quickness
	mastery = new_mastery
	grace = new_grace


func set_hero_level(new_level : int):
	hero_level = new_level


func set_portrait(new_portrait : Texture2D):
	hero_portrait = new_portrait


func set_hero_family(new_hero_family : DataManager.UnitFamily):
	hero_family = new_hero_family


func set_hero_class(new_hero_class : DataManager.HeroClass):
	hero_class = new_hero_class


func set_hero_gender(new_hero_gender : DataManager.HeroGender):
	hero_gender = new_hero_gender


func apply_passives(unit : Unit):
	for passive in passives:
		passive.apply(unit)


func add_passive_skill(new_skill : Skill):
	passives.append(new_skill)


func add_active_skill(new_skill : Skill):
	actives.append(new_skill)


func add_passive_reses(new_skill_res : Resource):
	passives_reses.append(new_skill_res)


func add_active_reses(new_skill_res : Resource):
	actives_reses.append(new_skill_res)


func set_hero_name(new_hero_name : String):
	hero_name = new_hero_name


func set_slot_res(new_hero_slot_res : SlotResUtil):
	hero_slot_res = new_hero_slot_res


func level_up():
	hero_level += 1


func set_skills_is_active():
	for active in actives:
		active.set_is_active(true)


func set_skills_is_inactive():
	for active in actives:
		active.set_is_active(false)


func update_hero_level():
	var current_locale : String = TranslationServer.get_locale()
	var level_prefix : String
	match current_locale:
		'en_US':
			level_prefix = 'level %d'
		'ru_RU':
			level_prefix = 'уровень %d'
	label_hero_level.text = level_prefix % hero_level


func remove_hero_slot():
	slot_container.queue_free()
	filler.queue_free()
