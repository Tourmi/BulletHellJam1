extends Character


func _process(delta):
	curr_cooldown -= delta
	if curr_cooldown <= 0 && !offscreen:
		curr_cooldown = shooting_cooldown
		$BulletSpawner.shoot_bullets()

func hit(damage : int):
	.hit(damage)
	if health <= 0:
		queue_free()
