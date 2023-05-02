extends Enemy

## 最远距离
@export var max_distance_to_player = 80
## 最近距离
@export var min_distance_to_player = 40

const THROWABLE_KNIFE_SCENE = preload("res://Scenes/Enemy/Goblin/throwable_knife.tscn")

var distance_to_player: float = 0
var random = RandomNumberGenerator.new()
var can_attack: bool = true
## 攻击间距时间
@onready var attack_timer = $AttackTimer
## 敌人攻击碰撞体形状
@onready var hurt_shape = $Hurt/HurtShape
## 射线检测墙壁
@onready var aim_ray_cast = $AimRayCast

func _ready():
	super._ready()
	
func actor_setup():
	await get_tree().physics_frame
	if not is_instance_valid(player):
		stop()
		return
	distance_to_player = player.position.distance_to(global_position)
	# 找到玩家
	if distance_to_player >= max_distance_to_player:
		set_movement_target(player.position)
	elif distance_to_player <= min_distance_to_player:
		# 远离玩家
		far_away_from_player()
	else:
		# 攻击
		maybe_attack()
	

func far_away_from_player():
	var dir: Vector2 = player.position.direction_to(global_position)
	var p: Vector2 = player.position + dir * 100
	set_movement_target(p)


func maybe_attack():
	aim_ray_cast.target_position = player.position - global_position
	## 是否可以攻击
	## 状态为idle
	## 射线检测没有和world相交
	if can_attack and state_machine.state == state_machine.states.idle and not aim_ray_cast.is_colliding():
		can_attack = false
		attack_timer.wait_time = random.randf_range(1.5, 2.0)
		attack_timer.start()
		throw_kinfe()

func throw_kinfe():
	var scene = THROWABLE_KNIFE_SCENE.instantiate()
	scene.launch(global_position, global_position.direction_to(player.position), 100)
	get_tree().current_scene.add_child(scene)


func _on_attack_timer_timeout():
	can_attack = true

func dead_action():
	super.dead_action()
	can_attack = false
	attack_timer.stop()
	
	
