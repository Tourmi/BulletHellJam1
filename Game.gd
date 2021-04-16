extends Node2D

signal reflect_bullets
var slow_down : bool = false
var speed_up : bool = false
var curr_speed : float = 1
var target_speed : float = 0.1


func _process(delta):
	if slow_down:
		curr_speed -= delta
		if curr_speed <= target_speed:
			curr_speed = target_speed
			$Timer.wait_time = target_speed * 2
			$Timer.start()
			slow_down = false
	elif speed_up:
		curr_speed += delta
		if curr_speed >= target_speed:
			speed_up = false
			curr_speed = target_speed
	
	Engine.time_scale = curr_speed


func _on_CountdownTimer_time_elapsed():
	if $CountdownTimer.counting_down:
		$CountdownTimer.target_time = 10
		target_speed = 0.2
		slow_down = true
		$Player.cant_shoot = true
		$Player.can_bullets_be_reflected = false
	else: 
		$CountdownTimer.target_time = 0
		$Player.can_bullets_be_reflected = true
		$CountdownTimer.start()
	
	$CountdownTimer.counting_down = !$CountdownTimer.counting_down


func _on_Timer_timeout():
	emit_signal("reflect_bullets")
	target_speed = 1
	$Player.cant_shoot = false
	speed_up = true
	$CountdownTimer.start()
