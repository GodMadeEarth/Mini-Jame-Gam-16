extends AnimationPlayer

# @Mayples
# Animation for Boot TEAM Logo. On end play menu scene
func _on_animation_finished(_self):
	get_tree().change_scene_to_file("res://mayples/menu_seq/PLAYABLE/PLAYER_menu_splash.tscn")
	pass # Replace with function body.
