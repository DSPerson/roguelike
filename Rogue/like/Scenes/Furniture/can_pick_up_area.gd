extends Area2D
## 物品图片资源
@export_file("*.png") var goods_texture: String
## 物品资源标识
@export var goods_identifier: String
## 当物品被拾起时候触发
signal pick_up_action(identifier: String)

@onready var sprite = $Sprite2D
@onready var collision_shape_2d = $CollisionShape2D

var _send_once = true

func _ready():
	if not goods_texture.is_empty():
		sprite.texture = load(goods_texture)
		assert(not goods_identifier.is_empty())
	else:
		collision_shape_2d.set_deferred("disabled", true)	

func _on_area_entered(_area):
	if !_send_once:
		return
	_send_once = false
	collision_shape_2d.set_deferred("disabled", true)
	var tween = get_tree().create_tween()
	tween.parallel().tween_property(self, "modulate", Color(1, 1, 1, 0), 0.6).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.parallel().tween_property(self, "position", position + Vector2.UP * 10, 0.6).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	emit_signal("pick_up_action", goods_identifier)
