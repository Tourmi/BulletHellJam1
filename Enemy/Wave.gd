extends Path2D

export var character : PackedScene
export var distance_between_characters : int = 500
export var loop : bool = true
export var character_count : int = 1
export var character_rotation : int = -90

var all_spawned : bool = false
var curr_path_follow_offset : float = 0
var speed : float
var characters : Array

func _ready():
	characters = []
	characters.append(character.instance())
	add_child(characters[0])
	speed = characters[0].speed

func _process(delta):
	curr_path_follow_offset += speed * delta
	for i in character_count:
		var curr_offset : float =  curr_path_follow_offset - i * distance_between_characters
		if curr_offset > 0 || all_spawned:
			if characters.size() <= i:
				characters.append(character.instance())
				add_child(characters[i])
			if characters[i] == null:
				continue;
			$PathFollow2D.offset = curr_offset
			characters[i].global_position = $PathFollow2D/Position2D.global_position
			characters[i].global_rotation_degrees = character_rotation
	
	if characters.size() == character_count:
		all_spawned = true
	

func free_if_all_dead():
	if !all_spawned : return
	for i in characters.size():
		if characters[i] != null: return
	queue_free()
	
