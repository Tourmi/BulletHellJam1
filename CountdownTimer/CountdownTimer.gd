extends Label

export var time : float = 10
export var target_time : float = 0
export var running : bool = false
export var counting_down : bool = true

signal time_elapsed

func _ready():
	running = true
	update_text()

func _process(delta):
	if !running: return
	var corrected_delta = delta if counting_down else -1 * delta
	time -= corrected_delta
	if counting_down && time <= target_time:
		time = target_time
		stop()
		emit_signal("time_elapsed")
	else: if !counting_down && time >= target_time:
		time = target_time
		stop()
		emit_signal("time_elapsed")
	
	update_text()

func update_text():
	text = "%2.3f" % time

func stop():
	running = false

func start():
	running = true
