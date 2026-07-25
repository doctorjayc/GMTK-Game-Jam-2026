extends StaticBody2D
#To each lever or button you assign a number that lever opens that specific door
@export var interactablevalue:int
var Change_state:bool = false
@onready var player:CharacterBody2D =  get_tree().get_first_node_in_group('player')
@onready var shell =  get_tree().get_first_node_in_group('shell')
var on:bool = false
# Called when the node enters the scene tree for the first time.
#jay SHELL TOUCHING LEVER DOES NOT WORK YET
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if shell!=null:
		if shell.global_position.distance_to(self.global_position)  < 30:
			change_state()
	if not Input.is_action_just_pressed("interact_e"):
		return
	if player.global_position.distance_to(self.global_position)  < 30:
		change_state()
		
		
func change_state():
	
	if on == false:
		$On.show()
		$Off.hide()
		print('CHANGING')
		var doors =  get_tree().get_nodes_in_group('door')
		for i in doors:
			if i.door_interactable_value == interactablevalue:
				i.number_of_levers -=1
				i.open()
		on = true
