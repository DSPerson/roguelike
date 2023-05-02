## 继承后在PathFollow2D 下添加对象
extends Area2D

## 物品抛出的速度
@export var speed: float = 200
## 是否是空箱子
var empty: bool = true

@export_file("*.tscn") var pick_up_goods: String

@onready var path_follow_2d = $Path2D/PathFollow2D
@onready var animation_player = $AnimationPlayer
@onready var collision_shape_2d = $CollisionShape2D
## 是否开始抛出
var start_thorw: bool = false
## 物品 可能不存在
var _goods: Node2D

func _ready():
	if path_follow_2d.get_child_count() == 0:
		empty = true
	if not pick_up_goods.is_empty():
		empty = false
		_goods = load(pick_up_goods).instantiate()
		_goods.visible = false
		_goods.position = path_follow_2d.position
		if "can_on_floor" in _goods:
			_goods.can_on_floor = true
		path_follow_2d.call_deferred("add_child", _goods)
	
func _physics_process(delta):
	if empty:
		return
	if start_thorw:
		var p = path_follow_2d.progress
		path_follow_2d.progress = path_follow_2d.progress + speed * delta
		if p == path_follow_2d.progress:
			start_thorw = false


func start_throw_action():
	start_thorw = true
	if _goods:
		_goods.visible = true

func _on_area_entered(_area):
	collision_shape_2d.set_deferred("disabled", true)
	if empty:
		animation_player.play("empty_open")
	else:
		animation_player.play("open")
