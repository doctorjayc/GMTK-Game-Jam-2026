extends Area2D

var interactable = false
var tween

var snailneutral = "res://assets/portraits/snailneutral.png"
var snailhappy = "res://assets/portraits/snailhappy.png"
var snailrizz = "res://assets/portraits/snailrizz.png"
var snailmad = "res://assets/portraits/snailmad.png"
var snailsad = "res://assets/portraits/snailsad.png"

@export var canvas: Node

# List of Bartholosnail coordinates
# Note: Supposed to have an extra at the end for now
var count_coords: Array[Vector2] = [
	Vector2(44.0, 16.0),
	Vector2(95.0, 16.0),
	Vector2(44.0, 16.0),
	Vector2(95.0, 16.0)
]

# Interaction text blocks (These are all just placeholders for now!)
# The order of the interaction_#_select array is:
#  1: Option A
#  2: Option B
#  3: Option A's portrait
#  4: Option B's portrait
#  5: The correct option
# ALWAYS make them have a size of 5

# First interaction text
var interaction_1_open = [
	"Wh- Who are you?",
	"What are you doing in here?",
	"G- Get out at once!",
]
var interaction_1_select = [
	"Hey!",
	"Hey. (with rizz)",
	snailhappy,
	snailrizz,
	"a"
]
var interaction_1_response_a = [
	"Wh- What? I don't even know who you are! Go away!",
]
var interaction_1_response_b = [
	"AHHHHHH!!!",
	"Get out!!"
]

# Second interaction text
var interaction_2_open = [
	"Why are you still here?",
	"I told you to get out!",
]
var interaction_2_select = [
	"I'm not leaving!",
	"I'm sorry.",
	snailmad,
	snailsad,
	"b"
]
var interaction_2_response_a = [
	"WH- WHAT?!",
	"Guards! Seize her at once!"
]
var interaction_2_response_b = [
	"If you're sorry, then leave!",
	"Whatever your intentions are, they cannot be good!"
]

# Third interaction text
var interaction_3_open = [
	"placeholder",
	"placeholder",
	"placeholder",
]
var interaction_3_select = [
	"placeholder",
	"placeholder",
	snailsad,
	snailneutral,
	"a"
]
var interaction_3_response_a = [
	"placeholder",
	"placeholder"
]
var interaction_3_response_b = [
	"placeholder",
	"placeholder"
]

var interaction_count = 0

func _on_body_entered(body):
	if body.is_in_group("player"):
		interactable = true

func _on_body_exited(body):
	if body.is_in_group("player"):
		interactable = false

# Sends the provided text array to the canvas upon interacting
func _input(event: InputEvent) -> void:
	if interactable:
		if event.is_action_pressed("interact"):
			match interaction_count:
				0:
					canvas.show_text(interaction_1_open, interaction_1_select, interaction_1_response_a, interaction_1_response_b)
					await canvas.move_count
					move_bartholosnail()
				1:
					canvas.show_text(interaction_2_open, interaction_2_select, interaction_2_response_a, interaction_2_response_b)
					await canvas.move_count
					move_bartholosnail()
				2:
					canvas.show_text(interaction_3_open, interaction_3_select, interaction_3_response_a, interaction_3_response_b)
					await canvas.move_count
					move_bartholosnail()
			interaction_count += 1

func move_bartholosnail():
	tween = create_tween()
	tween.tween_property($AnimatedSprite2D, "modulate:a", 0, 0.4)
	await tween.finished
	global_position = count_coords[interaction_count]
	$AnimatedSprite2D.modulate.a = 1
	
