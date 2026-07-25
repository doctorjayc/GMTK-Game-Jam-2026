extends CanvasLayer

signal advance
signal move_count

@onready var textbox = $TextBox
@onready var label = $TextBox/TextContainer/Label
@onready var snail_icon = $TextBox/Panel/snail_portrait.get_theme_stylebox("panel") as StyleBoxTexture
@onready var response_a = $TextBox/TextContainer/HBoxContainer/VBoxOptions/OptionA
@onready var response_b = $TextBox/TextContainer/HBoxContainer/VBoxOptions/OptionB
@onready var selector_a = $TextBox/TextContainer/HBoxContainer/VBoxSelector/SelectorA
@onready var selector_b = $TextBox/TextContainer/HBoxContainer/VBoxSelector/SelectorB
@onready var love_meter = $TextBox/Panel/love_meter
var tween
var love_tween
var current_option = "a"
var current_love = 0
var love_change_percent = 25
var portrait_a = "res://assets/portraits/snailneutral.png"
var portrait_b = "res://assets/portraits/snailneutral.png"
var is_ready = true
var running = false
var awaiting_response = false

const TEXT_SPEED = 0.05

func _ready() -> void:
	hide_text()

# Hides text box and resets the text
func hide_text():
	label.text = ""
	response_a.text = ""
	response_b.text = ""
	selector_a.text = ""
	selector_b.text = ""
	label.visible_ratio = 0.0
	current_option = "a"
	snail_icon.texture = load("res://assets/portraits/snailneutral.png")
	textbox.hide()

# Displays the strings in the provided array in the text box
# Note: Sorry for spaghetti code here :(
func show_text(initial_text_content, option_text_content, end_text_content_a, end_text_content_b):
	if !running:
		textbox.show()
		running = true
		
		# Shows the initial text
		for i in initial_text_content:
			tween = create_tween()
			label.text = i
			label.visible_ratio = 0.0
			tween.tween_property(label, "visible_ratio", 1.0, len(i) * TEXT_SPEED)
			await advance
		
		# Gives options and takes selection
		label.text = ""
		response_a.text = option_text_content[0]
		response_b.text = option_text_content[1]
		portrait_a = option_text_content[2]
		portrait_b = option_text_content[3]
		snail_icon.texture = load(portrait_a)
		selector_a.text = ">"
		selector_b.text = ""
		awaiting_response = true
		await advance
		awaiting_response = false
		response_a.text = ""
		response_b.text = ""
		selector_a.text = ""
		selector_b.text = ""
		
		# Shows ending text based on which option was selected, and adds love to love meter if the correct option was chosen
		if current_option == "a":
			# Changes love meter
			if current_option == option_text_content[4]:
				if current_love <= 100:
					current_love += love_change_percent
				else:
					current_love = 100
				love_tween = create_tween()
				love_tween.tween_property(love_meter, "value", current_love, 1)
			# Shows text
			for i in end_text_content_a:
				tween = create_tween()
				label.text = i
				label.visible_ratio = 0.0
				tween.tween_property(label, "visible_ratio", 1.0, len(i) * TEXT_SPEED)
				await advance
		elif current_option == "b":
			# Changes love meter
			print("The correct option was " + option_text_content[4])
			if current_option == option_text_content[4]:
				if current_love <= 100:
					current_love += love_change_percent
				else:
					current_love = 100
				love_tween = create_tween()
				love_tween.tween_property(love_meter, "value", current_love, 1)
			# Shows text
			for i in end_text_content_b:
				tween = create_tween()
				label.text = i
				label.visible_ratio = 0.0
				tween.tween_property(label, "visible_ratio", 1.0, len(i) * TEXT_SPEED)
				await advance
		
		hide_text()
		running = false
		move_count.emit()

# Skips the current text being displayed, or advances if text is finished
func _input(event: InputEvent) -> void:
	if running:
		if event.is_action_pressed("l_click"):
			if label.visible_ratio != 1.0:
				tween.set_speed_scale(999.9)
			else:
				advance.emit()
		elif awaiting_response:
			if event.is_action_pressed("selection_up"):
				selector_a.text = ">"
				selector_b.text = ""
				current_option = "a"
				snail_icon.texture = load(portrait_a)
			elif event.is_action_pressed("selection_down"):
				selector_a.text = ""
				selector_b.text = ">"
				current_option = "b"
				snail_icon.texture = load(portrait_b)
			elif event.is_action_pressed("l_click"):
				advance.emit()
