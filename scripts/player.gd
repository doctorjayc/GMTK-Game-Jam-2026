extends CharacterBody2D

@export var normal_speed = 50
@export var gravity:float = 6

# Note: Moved jump and fall states as they would overwrite other states, added still state as well for when the snail is not jumping or falling
enum state{fly, roll, normal_walk}
enum height_state{jump, fall, still}
var current_state = state.normal_walk
var current_height_state = height_state.still

var SPEED = 50
const JUMP_VELOCITY = -100
var dir:float
var flying_speed:float = 100
var last_dir:float = 1
var dash_speed = 250
var flyable:bool = true
var shell_spawned:bool = false
var deletable:bool = false
var shell_instance: Node

@onready var sprite = $AnimatedSprite2D

# Loads shell
# IMPORTANT: If the shell path is changed this needs to be updated
@onready var shell_object = preload("res://scenes/shell.tscn")

func _physics_process(_delta: float) -> void:
	add_gravity()
	dir = Input.get_axis('left','right')
	if dir != 0:
		last_dir = dir
	
	# Flips the sprite based on the current direction
	if dir < 0:
		sprite.flip_h = true
	elif dir > 0:
		sprite.flip_h = false
	
	velocity.x = move_toward(0,SPEED,0.7)
	movement()
	move_and_slide()

func movement():
	match current_state:
		state.normal_walk:
			velocity.x = dir * SPEED
			if is_on_floor() and Input.is_action_just_pressed("jump"):
				change_height_state(height_state.jump)
			if Input.is_action_just_pressed("dash"):
				change_state(state.roll)
		
		state.fly:
			velocity.x = dir * SPEED
			SPEED = flying_speed
			# Note: Not being able to jump here is expected for now, since you should fly eventually
			
			# Removes the shell and enters normal state when interacting next to a shell
			if Input.is_action_just_pressed('interact'):
				if deletable:
					remove_shell()
					change_state(state.normal_walk)
		
		# Note: I have not touched this yet, it is still unfinished
		state.roll:
			print("'rollllld")
			print(last_dir)
			velocity.x = SPEED * last_dir
			var timer = get_tree().create_timer(1)
			#timer.start()
			await timer.timeout
			change_state(state.normal_walk)
		
	match current_height_state:
		height_state.fall:
			velocity.x = SPEED * dir
			if is_on_floor():
				change_height_state(height_state.still)
			if Input.is_action_just_pressed('jump'):
				change_state(state.fly)
		
		height_state.jump:
			if is_on_floor():
				change_state(state.normal_walk)
			if velocity.y > 0:
				change_height_state(height_state.fall)
			if velocity.y == 0:
				change_height_state(height_state.still)
			if Input.is_action_just_pressed('jump') and velocity.y > -50:
				change_state(state.fly)

func change_state(state_change):
	match state_change:
		state.normal_walk:
			SPEED = normal_speed
			flyable = true
			current_state  = state.normal_walk
			sprite.play("idle")
		
		state.fly:
			if flyable == false:
				return
			current_state = state.fly
			spawn_shell()
			flyable = false
			sprite.play("no_shell")
			# Double jump effect
			velocity.y = JUMP_VELOCITY * 1.5
		
		state.roll:
			current_state = state.roll
			SPEED = 300

func change_height_state(height_state_change):
	match height_state_change:
		height_state.jump:
			flyable = true
			current_height_state = height_state.jump
			velocity.y = JUMP_VELOCITY
		
		height_state.fall:
			current_height_state = height_state.fall
		
		height_state.still:
			current_height_state = height_state.still

func add_gravity():
	if not is_on_floor():
		velocity.y += gravity

# Spawns the shell object next to the player based on where they are facing
func spawn_shell():
	shell_spawned = true
	shell_instance = shell_object.instantiate()
	get_tree().current_scene.add_child(shell_instance)
	if dir < 0:
		shell_instance.set_position(Vector2((position.x + 10), (position.y)))
	elif dir > 0:
		shell_instance.set_position(Vector2((position.x - 10), (position.y)))

func remove_shell():
	shell_spawned = false
	shell_instance.queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("shell"):
		deletable = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("shell"):
		deletable = false
