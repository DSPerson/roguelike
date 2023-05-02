@icon("res://Art/all/heroes/knight/weapon_sword_1.png")
extends Node2D
class_name Weapon

signal weapon_skill(time)
## 是否放在地板上                                        
@export var can_on_floor: bool = false
## 武器技能冷却时间
@export var ability_cooldown: float = 3
## 是否是远程武器
@export var ranged_weapon: bool = false
## 默认_旋转角度
@export var rotation_offset: float = 0
## 动画
@onready var animation_player: AnimationPlayer = $AnimationPlayer
## 粒子效果
@onready var charge_particles: GPUParticles2D = $Node2D/Sprite2D/GPUParticles2D
## 攻击区域
@onready var hit_box = $Node2D/Sprite2D/HitBox
## 攻击蓄能动画
const ANIMATION_PLAYER_CHARGE = "charge"
## 强力攻击
const ANIMATION_PLAYER_STRONG_ATTACK = "strong_attack"

@onready var player_detector = $PlayerDetector
## 投掷动画
var throw_tween: Tween
## 武器技能冷却
@onready var cool_down_timer = $CoolDownTimer
## 武器
@onready var sprite_2d = $Node2D/Sprite2D

func _ready():
	check_need_add_player_detector()
	self.visibility_changed.connect(_visibility_changedAction)

## 获取输入, 每一帧都会执行
func get_input() -> void:
	if Input.is_action_just_pressed("ui_attack") and not animation_player.is_playing():
		animation_player.play(ANIMATION_PLAYER_CHARGE)
	elif Input.is_action_just_released("ui_attack"): ## 长按松手后执行的操作
		if animation_player.is_playing() and animation_player.current_animation == "charge":
			animation_player.play("attack")
		elif charge_particles.emitting: ## 蓄力完成了 开始播放粒子动画的时候
			animation_player.play(ANIMATION_PLAYER_STRONG_ATTACK)
	elif (Input.is_action_just_pressed("ui_active_ability") and
		animation_player.has_animation("active_ability") and
		not is_busy() and cool_down_timer.is_stopped()):
		animation_player.play("active_ability")
		cool_down_timer.wait_time = ability_cooldown
		cool_down_timer.start()
#		ui_weapon.recharge_ability_animation(ability_cooldown)
		emit_signal("weapon_skill", ability_cooldown)
		#var cool_down_tween = get_tree().create_tween()
		
		
## 移动时候根据鼠标进行旋转
func move(mouse_direction: Vector2) -> void:
	if ranged_weapon:
		rotation_degrees = rad_to_deg(mouse_direction.angle()) + rotation_offset
	else:
		if not animation_player.is_playing() or animation_player.current_animation == ANIMATION_PLAYER_CHARGE:
			hit_box.knockback_direction = mouse_direction
			## 左右翻转
			if not GlobalConst.is_mobile:
				rotation = mouse_direction.angle()
				if scale.y == 1 and mouse_direction.x < 0:
					scale.y = -1
				elif scale.y == -1 and mouse_direction.x > 0:
					scale.y = 1
			else:
				if scale.x == 1 and mouse_direction.x < 0:
					scale.x = -1
				elif scale.x == -1 and mouse_direction.x > 0:
					scale.x = 1
			
		
## 取消攻击, 
func cancel_attack(force: bool = false):
	if animation_player.current_animation != ANIMATION_PLAYER_STRONG_ATTACK or force:
		animation_player.play("cancel_attack")

## 当前状态是否处于忙碌
func is_busy() -> bool:
	if animation_player.is_playing() or charge_particles.emitting:
		return true
	return false

func check_need_add_player_detector():
	if not can_on_floor:
		remove_player_detecor_mask()
		
func remove_player_detecor_mask():
	player_detector.set_collision_mask_value(GlobalConst.CollistionMaskLayer.World, false)
	player_detector.set_collision_mask_value(GlobalConst.CollistionMaskLayer.Player, false)

func pick_up_reset_animation():
	animation_player.play("RESET")


## 检测到玩家进入
## 当on_floor存在时有效
func _on_player_detector_area_entered(area: Area2D):
	if area.collision_layer == GlobalConst.CollistionMaskLayerValue.Player:
		var player: Node = area.get_parent()
		remove_player_detecor_mask()
		player.pick_up_weapon(self)
		position = Vector2.ZERO
		
	
## 补间动画 投掷武器
func interpolate_pos(initial_pos: Vector2, final_pos: Vector2) -> void:
	if throw_tween:
		throw_tween.kill()
	position = initial_pos
	player_detector.set_collision_mask_value(GlobalConst.CollistionMaskLayer.World, true)
	throw_tween = get_tree().create_tween()
	throw_tween.tween_property(self, "position", final_pos, 0.4).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	throw_tween.finished.connect(throw_tween_finshed)

## 投掷武器动画结束
func throw_tween_finshed():
	player_detector.set_collision_mask_value(GlobalConst.CollistionMaskLayer.Player, true)

##  碰到墙壁 的时候触发
func _on_player_detector_body_entered(_body):
	if throw_tween:
		throw_tween.kill()
#		throw_tween.stop()
		throw_tween = null
		player_detector.set_collision_mask_value(GlobalConst.CollistionMaskLayer.Player, true)


## 武器技能冷却时间
func _on_cool_down_timer_timeout():
	pass # Replace with function body.

func _visibility_changedAction():
	pass

func get_texture() -> Texture:
	return sprite_2d.texture
