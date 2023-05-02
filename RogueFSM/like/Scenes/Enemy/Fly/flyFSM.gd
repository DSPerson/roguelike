extends Node

@onready var animation_player = $"../AnimationPlayer"
@onready var state_machine_player: StateMachinePlayer = $"../StateMachinePlayer"

@onready var parent = get_parent()

func _on_state_machine_player_transited(_from, to):
	match to:
		"chase":
			animation_player.play("fly")
		"hurt":
			animation_player.play("hurt")
		"dead":
			animation_player.play("dead")
			


func _on_state_machine_player_updated(state, _delta):
	if state == "hurt" and not animation_player.is_playing():
		state_machine_player.set_trigger("chase")
	if state == "chase":
		parent.move()
		parent.chase()
