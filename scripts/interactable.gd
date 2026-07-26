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
	Vector2(208, 0),
	Vector2(531.0, -64.0),
	Vector2(715.0, -64.0),
	Vector2(856.0, -80.0),
	Vector2(951.0, -96.0),
	Vector2(1072.0, -144.0),
	Vector2(1261.0, -144.0),
	Vector2(1489.0, -144.0),
	Vector2(208, 0)
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
	"Hi! I'm Bethsnailsda!",
	"Well hey there cutie.",
	snailhappy,
	snailrizz,
	"a"
]
var interaction_1_response_a = [
	"And what are you doing in here? I do not recall inviting guests! Leave!",
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
	"Really? You still won't leave?",
	"It's money you're after, isn't it?",
	"How much do you want? I'll give any amount for you to leave!",
]
var interaction_3_select = [
	"I just wanna have a chat!",
	"It's you I'm after baby.",
	snailhappy,
	snailrizz,
	"a"
]
var interaction_3_response_a = [
	"Well, fine. I am John Bartholosnail, owner of this land and mansion for generations.",
	"You know, the one that you broke into?",
	"Is that enough of a chat for you? Now get out!"
]
var interaction_3_response_b = [
	"EW!!",
	"I have no intentions of talking with you further!"
]

# Fourth interaction text
var interaction_4_open = [
	"If you don't get out right now, I'm seriously going to call the guards on you!",
	"I mean it!"
]
var interaction_4_select = [
	"Please don't! I want to stay and talk!",
	"How could you! Meanie!",
	snailsad,
	snailmad,
	"a"
]
var interaction_4_response_a = [
	"*sigh*",
	"Listen.",
	"I'm a busy man.",
	"I don't have the time to talk with the likes of you."
]
var interaction_4_response_b = [
	"Don't act like you're somehow innocent in all this!",
	"The guards are on their way as we speak!"
]

# GOOD ROUTE

# Fifth interaction text A
var interaction_5_open = [
	"*sigh*",
	"What is it now?"
]
var interaction_5_select = [
	"So, uh... How's the weather?",
	"So, what food do you like to eat?",
	snailneutral,
	snailhappy,
	"b"
]
var interaction_5_response_a = [
	"...",
	"......",
	".........Seriously?"
]
var interaction_5_response_b = [
	"Hmm...",
	"I suppose I do enjoy a mushroom.",
	"...",
	"Why am I talking to you?"
]

# Sixth interaction text A
var interaction_6_open = [
	"Oh, it's you.",
	"Bethsnailsda, was it?",
	"What do you want?",
]
var interaction_6_select = [
	"Care to join me for dinner later?",
	"*sing him a song*",
	snailrizz,
	snailhappy,
	"a"
]
var interaction_6_response_a = [
	"No, I'm busy.",
	"Goodbye."
]
var interaction_6_response_b = [
	"AHHHHH!!!",
	"MY EARS!!!"
]

# Seventh interaction text A
var interaction_7_open = [
	"Listen...",
	"I'm sorry about earlier.",
	"I'm just a little busy and don't have time for guests.",
]
var interaction_7_select = [
	"Seriously? But look at how cute I am!",
	"It's ok... I understand...",
	snailmad,
	snailsad,
	"b"
]
var interaction_7_response_a = [
	"No.",
	"I don't."
]
var interaction_7_response_b = [
	"Perhaps next time?"
]

# Eighth interaction text A
var interaction_8_open = [
	"Hey! I was just thinking about you.",
	"I'm free now. Want to have dinner with me?",
]
var interaction_8_select = [
	"Of course!",
	"Of course... NOT!",
	snailhappy,
	snailmad,
	"a"
]
var interaction_8_response_a = [
	"Wonderful!",
	"So... Mushrooms?"
]
var interaction_8_response_b = [
	"W-What?",
	"B-But...",
	"...",
	"Fine! I never wanted to eat with you anyway! Hmph!"
]

# BAD ROUTE

# Fifth interaction text B
var interaction_5_open2 = [
	"*sigh*",
	"Why me?",
]
var interaction_5_select2 = [
	"Heyyy!",
	"I'm really sorry about earlier...",
	snailhappy,
	snailsad,
	"b"
]
var interaction_5_response_a2 = [
	"Leave me alone, please!",
]
var interaction_5_response_b2 = [
	"I don't care!",
	"I'm busy! I don't have time for this!"
]

# Sixth interaction text B
var interaction_6_open2 = [
	"AHH!!!",
	"Don't scare me like that!",
]
var interaction_6_select2 = [
	"I'm sorry...",
	"Boo.",
	snailsad,
	snailrizz,
	"a"
]
var interaction_6_response_a2 = [
	"Whatever.",
	"Just stay away!"
]
var interaction_6_response_b2 = [
	"Jerk!",
]

# Seventh interaction text B
var interaction_7_open2 = [
	"Oh no...",
]
var interaction_7_select2 = [
	"tee-hee",
	"*sing him a song*",
	snailhappy,
	snailrizz,
	"a"
]
var interaction_7_response_a2 = [
	"Is this funny to you?",
]
var interaction_7_response_b2 = [
	"AHHHHH!!!",
	"MY EARS!!!"
]

# Eighth interaction text B
var interaction_8_open2 = [
	"Gulp.",
]
var interaction_8_select2 = [
	"Hey cutie.",
	"Hey cutie.",
	snailrizz,
	snailrizz,
	"b"
]
var interaction_8_response_a2 = [
	"HEEEEEELP!!!",
]
var interaction_8_response_b2 = [
	"HEEEEEELP!!!",
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
				3:
					canvas.show_text(interaction_4_open, interaction_4_select, interaction_4_response_a, interaction_4_response_b)
					await canvas.move_count
					move_bartholosnail()
				4:
					if(canvas.current_love >= 37.5):
						canvas.show_text(interaction_5_open, interaction_5_select, interaction_5_response_a, interaction_5_response_b)
						await canvas.move_count
						move_bartholosnail()
					else:
						canvas.show_text(interaction_5_open2, interaction_5_select2, interaction_5_response_a2, interaction_5_response_b2)
						await canvas.move_count
						move_bartholosnail()
				5:
					if(canvas.current_love >= 50):
						canvas.show_text(interaction_6_open, interaction_6_select, interaction_6_response_a, interaction_6_response_b)
						await canvas.move_count
						move_bartholosnail()
					else:
						canvas.show_text(interaction_6_open2, interaction_6_select2, interaction_6_response_a2, interaction_6_response_b2)
						await canvas.move_count
						move_bartholosnail()
				6:
					if(canvas.current_love >= 50):
						canvas.show_text(interaction_7_open, interaction_7_select, interaction_7_response_a, interaction_7_response_b)
						await canvas.move_count
						move_bartholosnail()
					else:
						canvas.show_text(interaction_7_open2, interaction_7_select2, interaction_7_response_a2, interaction_7_response_b2)
						await canvas.move_count
						move_bartholosnail()
				7:
					if(canvas.current_love >= 50):
						canvas.show_text(interaction_8_open, interaction_8_select, interaction_8_response_a, interaction_8_response_b)
						await canvas.move_count
						move_bartholosnail()
					else:
						canvas.show_text(interaction_8_open2, interaction_8_select2, interaction_8_response_a2, interaction_8_response_b2)
						await canvas.move_count
						move_bartholosnail()
			interaction_count += 1

func move_bartholosnail():
	tween = create_tween()
	tween.tween_property($AnimatedSprite2D, "modulate:a", 0, 0.4)
	await tween.finished
	global_position = count_coords[interaction_count]
	$AnimatedSprite2D.modulate.a = 1
