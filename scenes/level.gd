extends Node2D

@onready var  current_check_point = $"Spawn pos".global_position
@onready var  player = $Player
var map_to_local
var gridcoords
func _ready() -> void:
	#player spawns here and current check point value can be changed
	player.global_position = current_check_point
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	conveyer()

func _on_reset_current_pos_pressed() -> void:
	player.die()
	
func conveyer():
	
	for i in get_tree().get_nodes_in_group('conveyer'):
		map_to_local = $conveyer.local_to_map(i.global_position)
		gridcoords = $conveyer.local_to_map(map_to_local)
		
		if gridcoords in $conveyer.get_used_cells():
			var cell_vector = $conveyer.get_cell_tile_data(gridcoords).get_custom_data('conveyer')
			i.global_position  = i.global_position + cell_vector * 2
