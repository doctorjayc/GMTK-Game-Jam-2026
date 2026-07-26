extends RigidBody2D

var interactable = false




func _on_area_2d_body_exited(body: Node2D) -> void:
	set_collision_mask_value(1,true)
	pass
func die():
	var player = get_tree().get_first_node_in_group('player')
	player.die()
		
