extends Character

class_name Player

export var slow_speed: int = 150

onready var can_bullets_be_reflected : bool = true

func _ready():
	offscreen = false

func _physics_process(delta):
	var move := Vector2()
	move.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	move.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	move = move.normalized()
	
	move *= (slow_speed if Input.is_action_pressed("slow") else speed)
	
	move_and_slide(move)
	
	global_position = Vector2(clamp(global_position.x, 0, get_viewport_rect().size.x), clamp(global_position.y, 0, get_viewport_rect().size.y))
	
	curr_cooldown -= delta
	if Input.is_action_pressed("shoot") && curr_cooldown <= 0 && !cant_shoot:
		$BulletSpawner.bullet_reflectable = can_bullets_be_reflected
		$BulletSpawner.shoot_bullets()
		curr_cooldown = shooting_cooldown


func hit(damage : int):
	can_be_hit = false
	$AnimationPlayer.play("Hit")
	.hit(damage)


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Hit":
		can_be_hit = true
		if health <= 0:
			get_tree().change_scene("res://GameOver.tscn")
