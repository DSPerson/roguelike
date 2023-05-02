extends FiniteStateMachine

## 跳转倒计时
@onready var jump_timer: Timer = $"../JumpTimer"
@onready var path_timer: Timer = $"../PathTimer"
@onready var hit_box: HitBox = $"../HitBox"
@onready var navigation_agent_2d = $"../NavigationAgent2D"


var can_jump = false

func _init():
	_add_state("idle")
	_add_state("jump")
	_add_state("hurt")
	_add_state("dead")
	
func _ready():
	state = states.idle

func _state_logic(_delta: float) -> void:
	if state == states.jump:
		parent.chase()
		parent.move()
		
		
func _get_transition() -> int:
	match state:
		states.idle:
			if can_jump:
				return states.jump
		states.jump:
			if not animation_player.is_playing():
				return states.idle
		states.hurt:
			if not animation_player.is_playing():
				return states.idle
	return -1



func _enter_state(_previous_state: int, _new_state: int):
	match _new_state:
		states.idle:
			animation_player.play("idle")
		states.jump:
			hit_box.knockback_direction = parent.global_position.direction_to(navigation_agent_2d.get_next_path_position()) 
			animation_player.play("jump")
		states.dead:
			animation_player.play("dead")
		states.hurt:
			animation_player.play("RESET")
			## 防止卡在空中
			await animation_player.animation_finished
			animation_player.play("hurt")

func _exit_state(_state_exited: int):
	if state == states.jump:
		can_jump = false
		jump_timer.wait_time = GlobalConst.random.randf_range(2, 4)
		jump_timer.start()


func _on_jump_timer_timeout():
	can_jump = true
