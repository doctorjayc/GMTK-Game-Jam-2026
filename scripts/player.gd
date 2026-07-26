extends CharacterBody2D

@export var normal_speed = 50
@export var gravity:float =6
@export var fly_acceleration:float = 7.5
@export var fly_speed_max:float = -100   # top upward speed, negative = up
@export var fly_decay:float = 8          # how fast upward speed bleeds off after release
@export var max_fly_time:float = 3
@export var spring_velocity:float = -300
@export var conveyor_speed:float = 60
@export var squash_duration:float = 0.9
@export var jump_squash:Vector2 = Vector2(0.8, 1.2)
@export var land_squash:Vector2 = Vector2(1.25, 0.75)
@export var fly_squash:Vector2 = Vector2(0.8, 1.2)
var fly_time_left:float = max_fly_time
var squash_tween:Tween
#SPAWNING SPAWNS ANOTHER SHELL
#CONVEYERS DONT WORK YET
#NEITHER DO BOUNCE PLATFORMS
# Note: Moved jump and fall states as they would overwrite other states, added still state as well for when the snail is not jumping or falling
enum state{fly, roll, normal_walk}
enum height_state{jump, fall, still}
var current_state = state.normal_walk
var current_height_state = height_state.still


var SPEED = 55
const JUMP_VELOCITY = -150
var dir:float
var flying_speed:float = 100
var last_dir:float = 1
var dash_speed = 250
var flyable:bool = true
var shell_spawned:bool = false
var deletable:bool = false
var shell_instance: Node
#var actual_gravity = 0.7
var actual_speed = 50
@export var timer_time_left:float = 20
@onready var sprite = $AnimatedSprite2D
var jumpable:bool
# Loads shell
# IMPORTANT: If the shell path is changed this needs to be updated
@onready var shell_object = preload("res://scenes/shell.tscn")
var bouncing:bool = false
func _ready() -> void:
	pass
func _physics_process(delta: float) -> void:

	add_gravity()
	$CanvasLayer/Snail_timer_label.text = str($Snail_timer.time_left)
	dir = Input.get_axis('left','right')
	if dir != 0:
		last_dir = dir
		#dont know why bounce doesent work ytet
	#if get_slide_collision(0):
		#if get_slide_collision(0).get_collider() in get_tree().get_nodes_in_group('bounce') and bouncing:
			#
			#velocity = velocity.bounce(get_slide_collision(0).get_normal()) * 100
			#print('BOUNCE')
			#var timer = get_tree().create_timer(3)
			#await  timer.timeout
			#bouncing = false
			#
	#if bouncing :
		#return
	
	# Flips the sprite based on the current direction
	if dir < 0:
		sprite.flip_h = true
	elif dir > 0:
		sprite.flip_h = false
	if shell_instance == null:
		$Snail_timer.wait_time = timer_time_left
		$Snail_timer.stop()
	velocity.x = move_toward(0,SPEED,0.7)
	movement()
	move_and_slide()
	check_spring_bounce()
	check_conveyor()

func check_spring_bounce():
	for i in get_slide_collision_count():
		var collider = get_slide_collision(i).get_collider()
		if collider.is_in_group("bounce"):
			velocity.y = spring_velocity
			change_height_state(height_state.fall)
			
func check_conveyor():
	for i in get_slide_collision_count():
		var collider = get_slide_collision(i).get_collider()
		if collider.is_in_group("conveyor_right"):
			velocity.x += conveyor_speed
		elif collider.is_in_group("conveyor_left"):
			velocity.x -= conveyor_speed

func movement():
	if Input.is_action_just_pressed('interact') and deletable:
		remove_shell()
		change_state(state.normal_walk)
	
	match current_state:
		state.normal_walk:
			velocity.x = dir * SPEED
			if is_on_floor() and Input.is_action_just_pressed("jump"):
				change_height_state(height_state.jump)
			if Input.is_action_just_pressed("dash"):
				change_state(state.roll)
		
		state.fly:
			velocity.x = dir * SPEED
			fly_time_left -= get_physics_process_delta_time()
			if Input.is_action_pressed("jump") and fly_time_left > 0:
				velocity.y = max(velocity.y - fly_acceleration, fly_speed_max)
			else:
				velocity.y = move_toward(velocity.y, 0, fly_decay)
				if velocity.y >= -5:
					gravity = 6
					change_state(state.normal_walk)
					change_height_state(height_state.fall)
			if is_on_floor():
				gravity = 6
				change_state(state.normal_walk)
				change_height_state(height_state.still)
				flyable = true
		state.roll:
			print("'rollllld")
			print(last_dir)
			gravity = 2
			velocity.x = SPEED * last_dir
			var timer = get_tree().create_timer(0.3)
			#timer.start()
			await timer.timeout
			change_state(state.normal_walk)
		
	match current_height_state:
		height_state.fall:
			velocity.x = SPEED * dir
			if is_on_floor():
				change_height_state(height_state.still)
				fly_time_left = max_fly_time
				flyable = true
				sprite.play('no_shell' if shell_instance != null else 'idle')
				squash_stretch(land_squash)
			elif Input.is_action_just_pressed('jump') and flyable:
				change_state(state.fly)

		height_state.jump:
			if is_on_floor() and velocity.y >= 0:
				change_state(state.normal_walk)
				change_height_state(height_state.still)
				flyable = true
			elif velocity.y > 0:
				change_height_state(height_state.fall)
			elif Input.is_action_just_pressed('jump') and velocity.y > -50 and flyable:
				change_state(state.fly)

		height_state.still:
			if Input.is_action_just_pressed("jump"):
				change_height_state(height_state.jump)
func change_state(state_change):
	match state_change:
		state.normal_walk:
			SPEED = normal_speed
			flyable = true
			current_state = state.normal_walk
			sprite.play('no_shell' if shell_instance != null else 'idle')
					
		state.fly:
			if flyable == false:
				return
			gravity = 2
			current_state = state.fly
			spawn_shell()
			flyable = false
			sprite.play("fly")
			squash_stretch(fly_squash)
					# Double jump effect . I am removing this for the flying
					#velocity.y = JUMP_VELOCITY * 1.5
				
		state.roll:
			current_state = state.roll
			SPEED = 300

func squash_stretch(from_scale:Vector2, duration:float = squash_duration):
	if squash_tween:
		squash_tween.kill()
	sprite.scale = from_scale
	squash_tween = create_tween()
	squash_tween.tween_property(sprite, "scale", Vector2.ONE, duration).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	
func change_height_state(height_state_change):
	match height_state_change:
		height_state.jump:
			
			flyable = true
			current_height_state = height_state.jump
			velocity.y = JUMP_VELOCITY
			squash_stretch(jump_squash)
		
		height_state.fall:
			current_height_state = height_state.fall
			gravity = 6
		height_state.still:
			current_height_state = height_state.still

func add_gravity():
	if not is_on_floor():
		velocity.y += gravity

# Spawns the shell object next to the player based on where they are facing
func spawn_shell():
	if shell_instance == null:
		shell_spawned = true
		shell_instance = shell_object.instantiate()
		get_tree().current_scene.add_child(shell_instance)
		var spawn_pos = self.global_position + Vector2(0, -8)
		shell_instance.global_position = spawn_pos

func remove_shell():
	shell_spawned = false
	shell_instance.queue_free()
	shell_instance = null
	print('remove')
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("shell"):
		deletable = true
		print("testd")

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("shell"):
		deletable = false
		
func add_screen_shake(amount:float):
	$Camera2D.set_screen_shake(amount)

	
func die():
	
	var level =  get_tree().get_first_node_in_group('level')
	global_position = level.current_check_point
	if shell_instance!= null:
		remove_shell()
	change_height_state(height_state.still)
	change_state(state.normal_walk)


func _on_snail_timer_timeout() -> void:
	if shell_instance == null:
		return
	die()
