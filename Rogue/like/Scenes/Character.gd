## 运动物体
## 玩家、敌人 都继承此脚本
@icon("res://Art/all/heroes/knight/knight_idle_anim_f0.png")
extends CharacterBody2D
class_name Character

## 血量变化
signal hp_changed(new)
## 更新最大血量
signal max_hp_changed(new)
## 死亡
signal dead
## 使用技能 time 冷却时间
signal weapon_skill(time)

## 移动差值时候使用
const FRICTION: float = 0.15
## 加速度
@export var acceleration: int = 40
## 最大速度 
@export var max_speed: int = 100
## 血量的最大值 ps: 如果是玩家, 需要在PlayerSaveData中修改
@export var max_hp: int = 2:
	set(value):
		max_hp = value
		emit_signal("max_hp_changed", value)
## 血量 ps: 如果是玩家, 需要在PlayerSaveData中修改
@export var hp: int = 2:
	set(value):
		hp = clamp(value, 0, max_hp)
		emit_signal("hp_changed", value)

## 打击效果
const HIT_EFFECT_SCENE = preload("res://Scenes/Player/hit_effect.tscn")
var hit_effect: EffectOnlyAnimationPlayer

## 死亡时候被击退的距离 倍数
@export var deadMultiDistance: float = 1.5
## 是否是飞行的物体, 如果是, 地刺将无法对齐造成伤害
@export var flying: bool = false

## 移动方向
var move_direction: Vector2 = Vector2.ZERO
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var state_machine: FiniteStateMachine = $FiniteStateMachine

func _ready():
	pass

func _physics_process(_delta: float) -> void:
	move_and_slide()
	velocity = lerp(velocity, Vector2.ZERO, FRICTION)

## 重写输入
func get_input() -> void:
	pass

## 执行移动函数
func move():
	move_direction = move_direction.normalized()
	velocity += move_direction * acceleration
	velocity.x = clamp(velocity.x, -max_speed, max_speed)
	velocity.y = clamp(velocity.y, -max_speed, max_speed)
	
## 受伤
func take_damage(damage:int, knockback_direction: Vector2, knockback_force: int):
#	if self is Enemy:
#	else:
	if self is Enemy:
		hp -= damage
#		print_debug("敌人受伤次数", damage)
		switch_take_damage(damage, knockback_direction, knockback_force)
	else:
		if state_machine.state != state_machine.states.hurt and state_machine.state != state_machine.states.dead:
			hp -= damage
			PlayerSaveData.hp = hp
			switch_take_damage(damage, knockback_direction, knockback_force)
#			print_debug("玩家受伤次数", damage)
	
func switch_take_damage(_damage:int, knockback_direction: Vector2, knockback_force: int):
	_spawn_hit_effect()
	if hp > 0:
		state_machine.state = state_machine.states.hurt
		velocity += (knockback_direction * knockback_force)	
	else:
		state_machine.state = state_machine.states.dead
		velocity += (knockback_direction * knockback_force * deadMultiDistance)
		dead_action()
	
	
## 发送死亡信号
## 重写记得调用 super.dead_action()
func dead_action():
	call_deferred("emit_signal", "dead")

## 捡起武器
func pick_up_weapon(_weapon: Weapon):
	pass
## 扔掉武器
func drop_weapon():
	pass

## 生成打击效果
func _spawn_hit_effect() -> void:
	if hit_effect == null:
		hit_effect = HIT_EFFECT_SCENE.instantiate()
		add_child(hit_effect)
	else:
		hit_effect.reset_play()
