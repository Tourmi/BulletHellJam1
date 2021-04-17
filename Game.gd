extends Node2D

export(Array, PackedScene) var levels : Array = []

signal reflect_bullets

var slow_down : bool = false
var speed_up : bool = false
var curr_speed : float = 1
var target_speed : float = 0.1
var curr_level : int = 0

func _ready():
	var level = levels[0].instance()
	level.connect("level_completed", self, "_on_level_completed")
	add_child(level)

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

func _on_level_completed():
	curr_level += 1
	var root_children = get_tree().root.get_children()
	for c in root_children:
		if c is Bullet: c.queue_free()
	if curr_level >= levels.size():
		get_tree().change_scene("res://GameWon.tscn")
		return
	
	$Player.add_upgrade("wave", 2)
	$Player.add_upgrade("shooting_cooldown", 0.85)
	$Player.add_upgrade("bullet_scale", 1.15)
	$Player.add_upgrade("bullet_count", 2)
	$Player.add_upgrade("bullet_speed", 1.15)
	$CountdownTimer.target_time = 0
	$CountdownTimer.time = 10
	$CountdownTimer.counting_down = true
	curr_speed = 1
	target_speed = 0.1
	slow_down = false
	speed_up = false
	$Timer.stop()
	var level = levels[curr_level].instance()
	level.connect("level_completed", self, "_on_level_completed")
	add_child(level)

