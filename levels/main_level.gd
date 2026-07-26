extends Node2D

@onready var  current_check_point = $Check_point.global_position
@onready var  player = $Player
var map_to_local
var grid
var _set_grid:bool = false
func _ready() -> void:
	#player spawns here and current check point value can be changed
	player.global_position = current_check_point
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	conveyer_belt()
	
func _on_reset_current_pos_pressed() -> void:
	player.die()
	
func conveyer_belt():
	#spagetti
	for i in get_tree().get_nodes_in_group('conveyer'):
		map_to_local = $Conveyer.to_local(i.global_position)
		grid = $Conveyer.local_to_map(map_to_local)
		
	
		if grid in $Conveyer.get_used_cells():
		
			print(grid,'grid')
			var cell = $Conveyer.get_cell_tile_data(grid).get_custom_data('conveyer')
			i.global_position += Vector2(cell)* 3
							#MAKING FRAvity 0
			if i is CharacterBody2D:
				
				i.gravity = 0
			elif i is RigidBody2D:
				i.gravity_scale = 0
			elif  i ==  null:
				pass
			_set_grid = true

		else:
			if _set_grid:
				if i is CharacterBody2D:
					i.gravity = 6
				elif i is RigidBody2D:
					i.gravity_scale = 0.4
					
				
				_set_grid = false
				
				
		
			
				
