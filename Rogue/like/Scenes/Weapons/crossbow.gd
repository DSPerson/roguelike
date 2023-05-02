extends Weapon
## 箭头
const ARROW_SCENE: PackedScene = preload("res://Scenes/Weapons/arrow.tscn")
## 箭矢速度
@export var arrow_speed: int = 400
## 伤害
@export var arrow_damage: int = 1
## 箭矢击退力度
@export var arrow_knockback_force: int = 350

func shoot(offset: int) -> void:
	var arrow = ARROW_SCENE.instantiate()
	arrow.damage = arrow_damage
	arrow.knockback_force = arrow_knockback_force
	get_tree().current_scene.add_child(arrow)
	var dir = Vector2.LEFT.rotated(deg_to_rad(rotation_degrees + offset))
	arrow.launch(global_position, dir, arrow_speed)

func triple_shoot() -> void:
	shoot(0)
	shoot(12)
	shoot(-12)
