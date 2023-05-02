extends "res://addons/imjp94.yafsm/src/StateMachinePlayer.gd"

@onready var parent: Character = get_parent()
@onready var animation_player: AnimationPlayer = parent.get_node("AnimationPlayer")

func _on_updated(state, delta):
	match state:
		"idle":
			if parent.distance_to_player > parent.max_distance_to_player or parent.distance_to_player < parent.min_distance_to_player:
				set_trigger("jump")
			if parent.distance_to_player < parent.max_distance_to_player and parent.distance_to_player > parent.min_distance_to_player:
				set_trigger("idled")


func _globin_on_entered(to):
	pass # Replace with function body.


func _on_state_machine_player_transited(from, to):
	match to:
		"idle":
			animation_player.play("idle")
		"move":
			animation_player.play("move")
