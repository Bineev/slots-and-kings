extends Node

@onready var vp = get_tree().get_root()
@onready var base_size = Vector2(1920, 1080)

func _ready():
	var window_size = DisplayServer.screen_get_size()
	var res = float(window_size.x) / 960
	var temp = abs(res - int(res))
	if abs(res - int(res)) > 0 and res < 2:
		get_tree().root.content_scale_stretch = Window.CONTENT_SCALE_STRETCH_FRACTIONAL
		Player.is_should_shader_work = false
	#if window_size.x < 1920:
		#get_tree().root.content_scale_stretch = Window.CONTENT_SCALE_STRETCH_FRACTIONAL
	
	#get_tree().root.content_scale_size = Vector2(window_size.x / 960, window_size.y / 540)
		# При изменении разрешения я обнаружил, что положение окна не всегда было 0,0
	#DisplayServer.set_windows_po   set_window_position(Vector2(0, 0)) 
	#vp.set_attach_to_screen_rect(screen_rect)
