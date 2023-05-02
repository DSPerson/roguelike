extends Enemy
@onready var hit_box: HitBox = $HitBox

var hitBox_knockback_force: int = 0

func _ready():
	if hitBox_knockback_force != 0:
		hit_box.knockback_force = hitBox_knockback_force

func _physics_process(delta):
	super._physics_process(delta)
	if Engine.get_physics_frames() % 5:
		if is_instance_valid(player):
			if player.global_position.y > global_position.y:
				z_index = 0
			else:
				z_index = 1
## 复制
func dupliate_sime() -> void:
	if scale > Vector2(1, 1):
		var dir = Vector2.RIGHT.rotated(GlobalConst.random.randf_range(0, 2 * PI))
		_spawn_slime(dir)
		_spawn_slime(dir * -1)
## 生成小的Slime
func _spawn_slime(direction: Vector2) -> void:
	var slime = load("res://Scenes/Enemy/Bosses/slime_boss.tscn").instantiate()
	slime.position = position
	slime.scale = scale / 2.0
	slime.hp = max_hp / 2.0
	slime.max_hp = slime.hp
	slime.hitBox_knockback_force = max(hit_box.knockback_force / 2.0, 500)
	add_sibling(slime)
	slime.velocity += direction * 150
	
	
