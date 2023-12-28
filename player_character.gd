extends CharacterBody2D

enum states 
{
	facing_left,
	facing_right
}

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	
	

# ------ PHYSICS --------

# consts 
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const speed = 50
const jump_power = 800
const stopping_friction = 0.6
const running_friction = 0.9


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
		
	

	 #Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY * get_jump_modifier()
		

	 #Get the input direction and handle the movement/deceleration.
	 #As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED * get_speed_modifier()
		print(velocity.x)
		curr_state = states.facing_left if velocity.x < 0 else states.facing_right
	else:
		velocity.x = move_toward(
			velocity.x,
			0,
			get_friction()
			)

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
	
func process_jump_change(x):
	return 500/x

func get_jump_modifier():
	var temp = get_distance_to_ram()
	return process_jump_change(temp)

func process_friction_change(x):
	return 5000/x
	
func get_friction():
	var temp = get_distance_to_ram()
	return process_friction_change(temp)


	



		
			
