extends StaticBody2D

@onready var animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func open() -> void:
	animation_player.play("open")
	print_debug("门已经打开")
