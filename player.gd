extends CharacterBody2D


var SPEED = 100
const JUMP_VELOCITY = -100
enum state{fly,roll,normal_walk,fall, jump }
var current_state = state.normal_walk
var dir:float
@export var gravity:float = 6
var flying_speed:float = 150
var last_dir:float = 1
var dash_speed = 400
var flyable:bool = true
@export var  normal_speed = 100
func _physics_process(delta: float) -> void:
	add_gravity()
	dir = Input.get_axis('left','right')
	if	dir !=0:
		last_dir = dir
	print(last_dir)
	velocity.x = move_toward(0,SPEED,0.7)
	movement()
	move_and_slide()

func movement():
	
	match current_state:
		state.normal_walk:
			velocity.x = dir * SPEED
			
			
			if is_on_floor() and  Input.is_action_just_pressed("jump"):
				change_state(state.jump)
			if Input.is_action_just_pressed("dash"):
				change_state(state.roll)
		state.fly:
			
			velocity.x = dir * SPEED
			SPEED = flying_speed
			#JUMP
			
			if is_on_floor():
				change_state(state.normal_walk)
			if velocity.y <0:
				change_state(state.fall	)
				
		state.fall:
			velocity.x = SPEED * dir
			#gravity = 2
			# IF YOU WANT TO CHANGE SOMETHING
			if is_on_floor():
				change_state(state.normal_walk)
			if Input.is_action_just_pressed('jump'):
				change_state(state.fly)
		state.roll:
			print("'rollllld")
			print(last_dir)
			velocity.x = SPEED * last_dir
			var timer = get_tree().create_timer(1)
			#timer.start()
			await timer.timeout
			SPEED = normal_speed
			change_state(state.normal_walk)
		state.jump:
			
			if Input.is_action_just_pressed("jump"):
				change_state(state.fly)
				
				
			if is_on_floor():
				change_state(state.normal_walk)
			if velocity.y <0:
				change_state(state.fall	)
func change_state(state_change):
	match state_change:
		state.normal_walk:
			flyable = true
			current_state  = state.normal_walk
		state.fly:
			if flyable == false:
				return
			velocity.y = JUMP_VELOCITY * 3
			current_state = state.fly
			flyable = false
			#velocity.y = JUMP_VELOCITY
		state.fall:
			current_state = state.fall
		state.roll:
			current_state = state.roll
			SPEED = 300
		state.jump:
			flyable = true
			current_state = state.jump
			velocity.y = JUMP_VELOCITY
func add_gravity():
	if not is_on_floor():
		velocity.y += gravity
