extends HitBox
## 延迟开始时间
@export var delay_start: float = 0
@onready var animation_player = $AnimationPlayer


func _ready():
	if delay_start != 0:
		var timer = get_tree().create_timer(delay_start)
		timer.timeout.connect(start_play)
	else:
		start_play()
func _on_body_entered(area: Area2D) -> void:
	super._on_body_entered(area)
	
func body_entered(body: Character) -> void:
	if not body.flying:
		knockback_direction = global_position.direction_to(body.global_position)
		super.body_entered(body)

func start_play():
	animation_player.play("pierce")

func pause_play():
	animation_player.pause()
