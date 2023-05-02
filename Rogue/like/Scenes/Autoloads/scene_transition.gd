extends CanvasLayer

var new_scene: String

@onready var animation_player = $AnimationPlayer


func start_transition_to(path_to_scene: String) -> void:
	new_scene = path_to_scene
	animation_player.play("change_scene")
	

func change_scene():
	print_debug("开始转场", Time.get_ticks_msec())
	assert(get_tree().change_scene_to_file(new_scene) == OK)
	print_debug("开始完成",  Time.get_ticks_msec())
