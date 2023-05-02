extends Enemy

@onready var hit_box: HitBox = get_node("HitBox")


func _process(_delta):
	hit_box.knockback_direction = velocity.normalized()
