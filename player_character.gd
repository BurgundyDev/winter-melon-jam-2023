extends CharacterBody2D

enum states 
{
	facing_left,
	facing_right
}


# ------ PHYSICS --------

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var player_sprite = $PlayerSprite

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var curr_state = states.facing_right


func _physics_process(delta):
	
	if (velocity.x > 1 || velocity.x < -1): #pause the animation instead of resetting it 
		player_sprite.play("move")
	else:
		player_sprite.pause()
		
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED * get_speed_modifier()
		print(velocity.x)
		curr_state = states.facing_left if velocity.x < 0 else states.facing_right
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	
	
	player_sprite.flip_h = (
		curr_state == states.facing_left
		)

# --- change velocity depending on distance to RAM  ---
@onready var player_character = $"."
@onready var ram = $"../RAM"

func get_distance_to_ram():
	var p_position = player_character.global_position
	var r_position = ram.global_position
	return p_position.distance_to(r_position)

#modify here to tweak delta of player's velocity 
func process_v_change(x):
	return 500/x #1 over x is SLOW AS FUCK

func get_speed_modifier():
	var temp = get_distance_to_ram()
	return process_v_change(temp)
	

	




		
			
