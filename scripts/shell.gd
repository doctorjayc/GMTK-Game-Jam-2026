extends RigidBody2D

var interactable = false
var jump_velocity = -400

func _ready() -> void:
	print("YESSSSSSSZ302")

func _on_area_2d_body_exited(body: Node2D) -> void:
	set_collision_mask_value(1,true)
	pass
func die():
	var player = get_tree().get_first_node_in_group('player')
	player.die()
		
	



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group('bounce'):
		linear_velocity.y = jump_velocity
		print('bounce me')
