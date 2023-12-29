extends Control



func _on_play_pressed():
	get_tree().change_scene_to_file("res://player_controller_gym.tscn")


func _on_quit_pressed():
	get_tree().quit()
