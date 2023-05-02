extends HitBox

@export var collision_to_wall_save = false
var direction: Vector2 = Vector2.ZERO
var knife_speed: int = 0 
var area_exit_from_enemy = false
var stop = false
@onready var sprite_2d = $Sprite2D

func launch(initial_position: Vector2, dir: Vector2, speed: int) -> void:
	position = initial_position
	direction = dir
	knockback_direction = dir
	knife_speed = speed
	rotation = dir.angle() + PI/4

func _physics_process(delta):
	if stop:
		return
	position += direction * knife_speed * delta

## 可以被摧毁
func can_destory() -> bool:
	return true

func enter_destory(_area: Area2D) -> void:
	set_collision_layer_value(GlobalConst.CollistionMaskLayer.Projectile, false)
	set_collision_mask_value(GlobalConst.CollistionMaskLayer.Player, false)
	set_collision_mask_value(GlobalConst.CollistionMaskLayer.Enemy, true)
	sprite_2d.flip_h = true
	sprite_2d.flip_v = true
	direction *= -1
	knockback_direction = direction
	
func set_collistion_layer():
	pass
#	return;
#	if not area_exit_from_enemy:
#		area_exit_from_enemy = true

#func _on_area_entered(area: Area2D):
#	var player = area.get_parent()
#	if player is Character:
#		player.take_damage(damage, knockback_direction, knockback_force)
#		queue_free()
func _on_body_entered(area: Area2D) -> void:
	super._on_body_entered(area)
	print(area.collision_layer)
	if area.collision_layer == GlobalConst.CollistionMaskLayerValue.Enemy:
		queue_free()

func _on_body_entered_action(_body):
	stop = true
	if not collision_to_wall_save:
			queue_free()
	else:
		call_deferred("disabled_collistion_shape")
	
func disabled_collistion_shape():
	collision_shape.disabled = true
