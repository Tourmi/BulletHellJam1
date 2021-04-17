extends Node2D

class_name BulletSpawner

export var BulletScene : PackedScene
export var is_enemy : bool = true
export var bullet_origin : Vector2
export var bullet_speed : int = 400
export var bullet_spread : float = 30.0
export var bullet_count : int = 1
export var bullet_scale : float = 0.02
export var bullet_reflectable : bool = false
export var shooting_cooldown : float = 0.5
export var manual : bool = false

var curr_cooldown : float = 0

const ENEMY_COLOR := Color(1, 0.1, 0.1)
const ALLY_COLOR := Color(0.1, 1, 0.4)


func _ready():
	if !manual:
		$Timer.wait_time = shooting_cooldown
		$Timer.start()

func _process(delta):
	curr_cooldown -= delta

func shoot_bullets():
	if curr_cooldown > 0 : return
	curr_cooldown = shooting_cooldown
	var odd_correction := 0
	if bullet_count <= 0 : return
	if bullet_count == 1 :
		spawn_bullet(global_rotation_degrees, 0)
		return
	
	var degree_step : float = bullet_spread / (bullet_count - (1 if bullet_spread < 360 else 0))
	for i in bullet_count:
		var degree : float = i * degree_step - bullet_spread / 2
		spawn_bullet(global_rotation_degrees + degree, i)


func spawn_bullet(bullet_rotation : float, count : int):
	var bullet := BulletScene.instance() as Bullet
	
	if bullet_reflectable:
		var game = find_parent("Game")
		bullet.reflect = true
		bullet.despawn_on_exit = false
		if game != null: game.connect("reflect_bullets", bullet, "_on_Reflect")
	if bullet is WavyBullet: bullet.is_mirrored = count % 2 == 1
	bullet.set_color(ENEMY_COLOR if is_enemy else ALLY_COLOR)
	bullet.hurts_enemies = !is_enemy
	bullet.hurts_player = is_enemy
	bullet.despawn_on_exit = is_enemy
	bullet.global_rotation_degrees = bullet_rotation
	bullet.speed = bullet_speed
	bullet.global_position = global_position + bullet_origin
	bullet.scale = Vector2(bullet_scale, bullet_scale)
	get_node("/root").add_child(bullet)

func _on_Timer_timeout():
	shoot_bullets()


