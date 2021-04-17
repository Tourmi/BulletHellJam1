extends Bullet

class_name WavyBullet

export var wave_width : int = 75
export var wave_length : int = 300

var travelled : float = 0
var real_position : Vector2 = Vector2()
var is_mirrored : bool = false

func _ready():
	real_position = global_position

func _process(delta):
	var to_travel = delta * speed
	travelled += to_travel
	var mirror := -1 if is_mirrored else 1
	var offset : float = mirror * wave_width * sin(travelled * 2 * PI/wave_length)
	
	real_position += to_travel * Vector2(cos(rotation), -sin(rotation))
	global_position = real_position + Vector2(sin(rotation) * offset, cos(rotation) * offset)


func _on_Reflect():
	if reflected : return
	._on_Reflect()
	if !reflected : return
	travelled = -travelled
