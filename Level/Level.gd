extends Node2D

signal level_completed

export(Array, PackedScene) var waves : Array = []
# A negative value starts the wave after all the previous ones are dead, 
# while any other number is the amount of time to wait between the previous wave and the current
export(Array, int) var waves_timing : Array = []


var time_past : float = 0
var curr_wave : int = 0
var waves_alive : int = 0

func _process(delta):
	time_past += delta
	
	while (curr_wave < waves_timing.size()):
		if waves_timing[curr_wave] < 0 && waves_alive == 0:
			var wave = waves[curr_wave].instance()
			curr_wave += 1
			waves_alive += 1
			wave.connect("wave_completed", self, "_on_wave_completed")
			add_child(wave)
		
		elif time_past >= waves_timing[curr_wave]:
			time_past -= waves_timing[curr_wave]
			var wave = waves[curr_wave].instance()
			curr_wave += 1
			waves_alive += 1
			wave.connect("wave_completed", self, "_on_wave_completed")
			add_child(wave)
		
		else : return


func _on_wave_completed():
	waves_alive -= 1
	if curr_wave >= waves.size() && waves_alive == 0:
		emit_signal("level_completed")
		queue_free()
