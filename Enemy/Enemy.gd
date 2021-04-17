extends Character


func _process(delta):
	if !offscreen:
		$BulletSpawner.shoot_bullets()


func hit(damage : int):
	.hit(damage)
	if health <= 0:
		queue_free()
