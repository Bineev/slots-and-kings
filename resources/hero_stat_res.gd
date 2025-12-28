extends Resource

class_name HeroStatRes


@export var hero_type : DataManager.HeroType
@export var hero_class : DataManager.HeroClass
@export var hero_gender : DataManager.HeroGender
@export var hero_family : DataManager.UnitFamily

@export var portraits_pool : Array[Texture2D]
@export var hero_names_pool : Array[String]
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
