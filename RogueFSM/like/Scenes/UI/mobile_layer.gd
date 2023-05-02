extends Node2D
@onready var joystick = $Joystick
@onready var button = $Button
@onready var timer = $Timer


func get_node_pos() -> Vector2:
	return joystick.get_node_pos()
