extends HitBox


func _on_body_entered(area: Area2D) -> void:
	if area.collision_layer == GlobalConst.CollistionMaskLayerValue.Projectile:
		enter_destory(area)
	else:
		super._on_body_entered(area)

func enter_destory(area: Area2D):
	if area.has_method("enter_destory"):
		area.enter_destory(area)
