
@icon("res://Art/all/enemies/goblin/goblin_idle_anim_f0.png")
extends Character

class_name Enemy

## 展示导航箭头
@export var debugShowAgent: bool = false
## ready后马上追击玩家
@export var ready_chase: bool = true

## 最远放弃距离; 暂时未使用
#@export var maxDistanceGiveUp: float = 50
## 移动速度
var movement_speed: float = 30.0
## 目标位置
var movement_target_position: Vector2 = Vector2(60.0,180.0)

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var player: Character = get_tree().current_scene.get_node("Player")
@onready var path_timer = $PathTimer


func _ready():
	add_to_group("enemy")
	if is_instance_valid(navigation_agent):
		navigation_agent.path_desired_distance = 8
		navigation_agent.target_desired_distance = 8
	if debugShowAgent:
		navigation_agent.debug_enabled = true
	# Make sure to not await during _ready.
	if ready_chase:
		call_deferred("actor_setup")
	self.tree_exited.connect(Callable(get_parent().get_parent(), "_on_enemy_killed"))
	
func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame
	if not is_instance_valid(player):
		stop(true)
		return
	set_movement_target(player.position)

func set_movement_target(movement_target: Vector2):
	if is_instance_valid(navigation_agent):
		navigation_agent.target_position = movement_target

func stop(timer: bool = false):
	move_direction = Vector2.ZERO
	set_movement_target(global_position)
	if timer:
		path_timer.stop()
	
func _on_path_timer_timeout() -> void:
	actor_setup()

## 敌人的朝向问题
func checkFace() -> bool:
	var p = player.global_position
	var e = global_position
	var ep2 = e.direction_to(p)
	var direction = Vector2.LEFT if animated_sprite_2d.flip_h else Vector2.RIGHT
	var d = ep2.dot(direction) > 0
	return d
	
func chase() -> void:
	if not is_instance_valid(navigation_agent):
		return
#	var distance = global_position.distance_to(player.global_position)
#	if distance > maxDistanceGiveUp:
#		move_direction = Vector2.ZERO
#		stop()
#		return
	if navigation_agent.is_navigation_finished():
#		stop()
		return
	var vector_to_next_point: Vector2 = navigation_agent.get_next_path_position() - global_position
	move_direction = vector_to_next_point
	adjustFace()
	
## 调整面目朝向
func adjustFace():
	if move_direction.x > 0 and animated_sprite_2d.flip_h:
		animated_sprite_2d.flip_h = false
	elif move_direction.x < 0 and not animated_sprite_2d.flip_h:
		animated_sprite_2d.flip_h = true
		
