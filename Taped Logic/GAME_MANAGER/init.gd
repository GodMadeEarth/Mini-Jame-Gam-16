extends Node2D
##
##
## This is a place holder boot screen. if we need to run logic /preload etc during splash or start a manager
##
###

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().change_scene_to_file("res://mayples/menu_seq/PLAYABLE/BOOT_SPLASH.tscn")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
