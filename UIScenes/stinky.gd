extends Node
#class_name TimerUI

static var time = 120.0
static var stopped = false
#signal time_depleted

#func _process(delta):
#	if stopped:
#		return
#	time -= delta
#	if time <= 0.0:
#		stopped = true
#		time_depleted.emit()

#func reset():
#	time = 120.0	

#func time_to_string() -> String:
#	#Turn the time var into a string for UI display
#	var msec = fmod(time, 1) * 1000
#	var sec = fmod(time, 60)
#	var mins = time / 60
#	var format_string = "%02d : %02d : %02d"
#	var actual_string = format_string % [mins, sec, msec]
#	return actual_string
