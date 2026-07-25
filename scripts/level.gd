extends Node2D

@onready var  current_check_point = $"Spawn pos".global_position
@onready var  player = $Player
func _ready() -> void:
	#player spawns here and current check point value can be changed
	player.global_position = current_check_point
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_reset_current_pos_pressed() -> void:
	player.die()
	
