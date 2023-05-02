## 攻击脚本
## 绑定到玩家的武器上或者是敌人的身体上
extends Area2D

class_name HitBox

@export_group("伤害控制")
## 伤害值
@export var damage: int = 1
## 击退方向
var knockback_direction: Vector2 = Vector2.ZERO
## 击退力度
@export var knockback_force: int = 350
## 碰撞体形状
@onready var collision_shape = $CollisionShape2D


func _init():
	self.area_entered.connect(_on_body_entered)

func _ready():
	assert(collision_shape != null)

## 被攻击对象进入
func _on_body_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if not (parent is Character) or not is_instance_valid(parent):
#		push_error("这是个错误信息", parent)
		return
	assert(parent != null)
	body_entered(parent)

func body_entered(body: Character) -> void:
	if body == null or not body.has_method("take_damage"):
		queue_free()
	else:
		body.take_damage(damage, knockback_direction, knockback_force)
## 是否能被摧毁掉
func can_destory() -> bool:
	return false
## 执行摧毁函数
func enter_destory(_area: Area2D) -> void:
	pass
	
