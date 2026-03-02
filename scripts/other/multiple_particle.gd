extends Node2D

class_name MultipleParticle


@export var particle_textures : Array[Texture2D] = [preload("res://img/roulette_smile.png"), preload("res://img/roulette_star.png"), preload("res://img/roulette_square.png")]
@export var preparticle : PackedScene
@export var emits_count : int = 3
@export var emits_interval : float = 0.1


func _ready() -> void:
	for i in range(emits_count):
		var particle : CPUParticles2D = preparticle.instantiate()
		particle.texture = particle_textures.pick_random()
		particle.modulate
		add_child(particle)
