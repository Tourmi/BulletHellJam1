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
	
	if Input.is_action_pressed("shoot") && !cant_shoot:
		for bs in get_tree().get_nodes_in_group("PlayerSpawners"):
			var bulletSpawner := bs as BulletSpawner
			bulletSpawner.bullet_reflectable = can_bullets_be_reflected
			bulletSpawner.shoot_bullets()


# 
func add_upgrade(name : String, value):
	match name:
		"wave":
			$WavyBulletSpawner.bullet_count += value
		"bullet_count":
			$BulletSpawner.bullet_count += value
		"bullet_scale":
			$BulletSpawner.bullet_scale *= value
			$WavyBulletSpawner.bullet_scale *= value
		"bullet_spread":
			$BulletSpawner.bullet_spread *= value
		"bullet_speed":
			$BulletSpawner.bullet_speed *= value
			$WavyBulletSpawner.bullet_speed *= value
		"shooting_cooldown":
			$BulletSpawner.shooting_cooldown *= value
			$WavyBulletSpawner.shooting_cooldown *= value
	

func hit(damage : int):
	can_be_hit = false
	$AnimationPlayer.play("Hit")
	.hit(damage)


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Hit":
		can_be_hit = true
		if health <= 0:
			get_tree().change_scene("res://GameOver.tscn")
