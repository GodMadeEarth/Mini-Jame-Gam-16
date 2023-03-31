extends AnimationPlayer

# @Mayples
# Animation for Boot Jam Logo. On end play team name scene
func _on_animation_finished(_self):
	get_tree().change_scene_to_file("res://mayples/menu_seq/PLAYABLE/SPLASH_TEAM.tscn")
	pass # Replace with function body.
