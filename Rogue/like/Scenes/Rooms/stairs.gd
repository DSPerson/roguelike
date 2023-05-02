## 楼梯
extends Area2D

## 下一个关卡
@export_file("*.tscn") var next_scene: String
@onready var collision_shape = $CollisionShape2D



func _on_area_entered(_area):
	collision_shape.set_deferred("disabled", true)
	if next_scene != null:
		SceneTransition.start_transition_to(next_scene)
	else:
		pass
