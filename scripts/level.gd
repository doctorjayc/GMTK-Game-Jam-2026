extends Node2D

@onready var  current_check_point = $"Spawn pos".global_position
@onready var  player = $Player
var map_to_local
var grid
func _ready() -> void:
	#player spawns here and current check point value can be changed
	player.global_position = current_check_point
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	conveyer_belt()

func _on_reset_current_pos_pressed() -> void:
	player.die()
	
func conveyer_belt():
	var current_grid_coord
	for i in get_tree().get_nodes_in_group('conveyer'):
		map_to_local = $conveyer.to_local(i.global_position)
		grid = $conveyer.local_to_map(map_to_local)
		print(grid,'grid')
		print($c)
	
		if grid in $conveyer.get_used_cells():
			var current_grid
			
			current_grid = grid
			print(grid)
			var cell = $conveyer.get_cell_tile_data(grid).get_custom_data('conveyer')
			i.position += Vector2(cell)* 0.6
			if i.has_method('add_gravity'):
				#MAKING FRAvity 0
				i.SPEED =0
				i.gravity = 0
				
				
		
			
				
