extends Node

var current_scene : String = "env_a001_jon_office"
var transition_scene : bool = false

var player_exit_pos : Vector2 = Vector2(0,0)
var player_start_pos : Vector2 =  Vector2(0,0)

func finish_scene_change() -> void:
	if transition_scene:
		transition_scene = false
		if current_scene == "env_a001_jon_office":
			current_scene = "env_a002_hallway"
		else:
			current_scene = "env_a001_jon_office" 
