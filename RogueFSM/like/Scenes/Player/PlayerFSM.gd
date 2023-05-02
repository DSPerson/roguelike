extends Node

@onready var parent: Character = get_parent()
@onready var animation_player = $"../AnimationPlayer"
@onready var state_machine_player: StateMachinePlayer = $"../StateMachinePlayer"



func _on_state_machine_player_updated(state, _delta):
	if state != "dead":
		parent.get_input()
		parent.move()
	state_machine_player.set_param("velocity", parent.velocity.length())
	if state == "hurt" and not animation_player.is_playing():
		state_machine_player.set_trigger("idle")

func _on_state_machine_player_transited(_from, to):
	match to:
		"idle":
			animation_player.play("idle")
		"move":
			animation_player.play("move")
		"hurt":
			animation_player.play("hurt")
		"dead":
			animation_player.play("dead")
