extends Node2D

export var BulletScene : PackedScene

export var bullet_origin : Vector2
export var bullet_speed : int = 400
export var bullet_spread : float = 30.0
export var bullet_count : int = 4
export var bullet_scale : float = 0.02
export var bullet_reflectable : bool = false
export var shooting_cooldown : float = 0.5
export var manual : bool = false

func _ready():
	if !manual:
		$Timer.wait_time = shooting_cooldown
		$Timer.start()


func shoot_bullets():
	var odd_correction := 0
	if bullet_count < 1 :
		spawn_bullet(global_rotation_degrees)
		return
	
	var degree_step : float = bullet_spread / (bullet_count - (1 if bullet_spread < 360 else 0))
	for i in bullet_count:
		var degree : float = i * degree_step - bullet_spread / 2
		spawn_bullet(global_rotation_degrees + degree)


func spawn_bullet(bullet_rotation : float):
	var bullet := BulletScene.instance() as Bullet
	
	get_node("/root").add_child(bullet)
	
	if bullet_reflectable:
		var game = find_parent("Game")
		bullet.reflect = true
		bullet.despawn_on_exit = false
		game.connect("reflect_bullets", bullet, "_on_Reflect")
	bullet.global_rotation_degrees = bullet_rotation
	bullet.speed = bullet_speed
	bullet.global_position = global_position + bullet_origin
	bullet.scale = Vector2(bullet_scale, bullet_scale)

func _on_Timer_timeout():
	shoot_bullets()


