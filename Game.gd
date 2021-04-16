extends Node2D

signal reflect_bullets

func _on_CountdownTimer_time_elapsed():
	if $CountdownTimer.counting_down:
		emit_signal("reflect_bullets")
		$CountdownTimer.target_time = 10
	else: 
		$CountdownTimer.target_time = 0
	
	$CountdownTimer.counting_down = !$CountdownTimer.counting_down
	$CountdownTimer.start()
