extends Area2D

var interactable = false

@export var displayed_text: Array[String]
@export var canvas: Node

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
			canvas.show_text(displayed_text)
