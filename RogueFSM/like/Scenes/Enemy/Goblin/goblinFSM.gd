extends Node

@onready var parent = get_parent()
@onready var animation_player = $"../AnimationPlayer"
@onready var state_machine_player: StateMachinePlayer = $"../StateMachinePlayer"

func _on_state_machine_player_updated(state, _delta):
	match state:
		"idle":
			if parent.distance_to_player > parent.max_distance_to_player or parent.distance_to_player < parent.min_distance_to_player:
				state_machine_player.set_trigger("move")
		"move":
			if parent.distance_to_player < parent.max_distance_to_player and parent.distance_to_player > parent.min_distance_to_player:
				state_machine_player.set_trigger("idle")
		"hurt":
			if not animation_player.is_playing():
				state_machine_player.set_trigger("idle")
	if state == "move":
		parent.chase()
		parent.move()

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
