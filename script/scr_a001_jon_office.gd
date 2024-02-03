extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	change_scene()


func _on_trans_a_002_hallway_body_entered(body):
	if body.has_method("player"):
		global.transition_scene = true

# Reset / Keeping everything in check if entered() fails
func _on_trans_a_002_hallway_body_exited(body):
	if body.has_method("player"):
		global.transition_scene = false

func change_scene() -> void: 
	if global.transition_scene:
		if global.current_scene == "env_a001_jon_office":
			get_tree().change_scene_to_file("res://environment/env_a002_hallway.tscn")
			global.finish_scene_change()
