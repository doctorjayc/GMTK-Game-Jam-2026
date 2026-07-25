extends Node2D

@export var interactablevalue:int
@export var gate_timer:int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	$Snailset1_4.show()
	$Snailset1_5.hide()
	var doors =  get_tree().get_nodes_in_group('door')
	for i in doors:
			if i.door_interactable_value == interactablevalue:
				print(i)
				i.open()
func _on_area_2d_body_exited(body: Node2D) -> void:
	$Snailset1_5.show()
	$Snailset1_4.hide()
	var doors =  get_tree().get_nodes_in_group('door')
	for i in doors:
			if i.door_interactable_value == interactablevalue:
				var timer = get_tree().create_timer(gate_timer)
				await timer.timeout
				i.close()
