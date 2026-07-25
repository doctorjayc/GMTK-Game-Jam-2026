extends CanvasLayer

signal advance

@onready var textbox = $TextBox
@onready var label = $TextBox/TextContainer/Label
var tween
var is_ready = true
var running = false

const TEXT_SPEED = 0.05

func _ready() -> void:
	hide_text()

# Hides text box and resets the text
func hide_text():
	label.text = ""
	label.visible_ratio = 0.0
	textbox.hide()

# Displays the strings in the provided array in the text box
func show_text(text_content):
	if !running:
		textbox.show()
		running = true
		for i in text_content:
			tween = create_tween()
			label.text = i
			label.visible_ratio = 0.0
			tween.tween_property(label, "visible_ratio", 1.0, len(i) * TEXT_SPEED)
			await advance
		hide_text()
		running = false

# Skips the current text being displayed, or advances if text is finished
func _input(event: InputEvent) -> void:
	if running:
		if event.is_action_pressed("l_click"):
			if label.visible_ratio != 1.0:
				tween.set_speed_scale(999.9)
			else:
				advance.emit()
