extends Area2D

class_name Bullet

export var speed : int = 400
export var despawn_on_exit : bool = true
export var hurts_player : bool = true
export var hurts_enemies : bool = false
export var reflect : bool = false

onready var reflected : bool = false
onready var onscreen : bool = true


func _process(delta):
	global_position += delta * speed * Vector2(cos(rotation), -sin(rotation))


func _on_VisibilityNotifier2D_screen_exited():
	onscreen = false
	if despawn_on_exit: 
		queue_free()


func _on_VisibilityNotifier2D_screen_entered():
	if !onscreen:
		despawn_on_exit = true

func _on_Bullet_body_entered(body):
	if body is Character:
		var character : Character = body as Character
		var can_hit : bool = character.can_be_hit && (hurts_player && !character.is_enemy || hurts_enemies && character.is_enemy)
		if can_hit:
			character.hit(1)
			queue_free()

func _on_Reflect():
	if reflect && !reflected:
		reflected = true
		rotation_degrees += 180
		hurts_player = true

func _on_Timer_timeout():
	queue_free()

