extends Node2D

@onready var camera_2d = $Camera2D
@onready var player: Player = $Player
@onready var mobile_layer = $MainUI/MobileLayer
@onready var skill = $MainUI/Skill


func _ready():
	if not GlobalConst.is_mobile:
		mobile_layer.call_deferred("queue_free")
		mobile_layer = null
	else:
		mobile_layer.visible = true
	player.dead.connect(on_player_dead)
	player.weapon_skill.connect(on_player_used_weapon_skill)
	

func _process(_delta):
	if mobile_layer != null and is_instance_valid(player):
		player.move_direction = mobile_layer.get_node_pos()
		player.joystick_position = player.move_direction
		

func on_player_dead():
	camera_2d.position = player.position
	camera_2d.enabled = true
	camera_2d.make_current()


func on_player_used_weapon_skill(time: float):
	skill.recharge_ability_animation(time)
