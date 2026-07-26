extends StaticBody2D

@export var door_interactable_value:int
@export var number_of_buttons:int 
@export var number_of_levers:int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func open():
	print('open',number_of_buttons,number_of_levers)
	if number_of_buttons <=0 and number_of_levers <=0:
		
		$CollisionShape2D.set_deferred("disabled", true)
		#call_deferred(disable)
		$Snailset1_4.hide()
		$Snailset1_5.show()
		var player = get_tree().get_first_node_in_group('player')
		player.add_screen_shake(9)
func close():
	$CollisionShape2D.disabled = false
	$Snailset1_5.hide()
	$Snailset1_4.show()
	print('close')
func disable():
	$CollisionShape2D.disabled = true
