extends Area2D

@export var target_level : String

func _ready():
	$RamSprite.play("default")

func _on_body_entered(body):
	if(body.get_name() == "Player_character"):
		get_tree().change_scene_to_file(target_level)
