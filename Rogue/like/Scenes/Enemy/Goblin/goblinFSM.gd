extends FiniteStateMachine

func _init():
	_add_state("idle")
	_add_state("move")
	_add_state("hurt")
	_add_state("dead")

func _ready():
	state = states.idle
	

func _state_logic(_delta: float) -> void:
	if state == states.move:
		parent.chase()
		parent.move()


func _get_transition() -> int:
	match state:
		states.idle:
			if parent.distance_to_player > parent.max_distance_to_player or parent.distance_to_player < parent.min_distance_to_player:
				state = states.move
		states.move:
			if parent.distance_to_player < parent.max_distance_to_player and parent.distance_to_player > parent.min_distance_to_player:
				state = states.idle
		states.hurt:
			if not animation_player.is_playing():
				state = states.move
	return -1

func _enter_state(_previous_state: int, _new_state: int):
	match _new_state:
		states.idle:
			animation_player.play("idle")
		states.move:
			animation_player.play("move")
		states.dead:
			animation_player.play("dead")
		states.hurt:
			animation_player.play("hurt")	
