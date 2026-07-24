extends Camera2D
@onready var base_offset = offset
var screen_shake:float
var screen_decay:float = 0.2

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if screen_shake <= 0:
		return
	screen_shake = max( 0,screen_shake-screen_decay)
	offset = base_offset +Vector2(randf_range(-1,1)* screen_shake,randf_range(-1,1)* screen_shake)
func set_screen_shake(value:float):
	screen_shake = value
