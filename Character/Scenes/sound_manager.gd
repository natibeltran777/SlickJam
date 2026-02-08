extends Node3D
class_name SoundManager

@export var bike_drone_sound : AudioStreamPlayer3D
@export var boost_sound : AudioStreamPlayer3D
@export var jump_sound : AudioStreamPlayer3D
@export var land_sound : AudioStreamPlayer3D
@export var drift_sound : AudioStreamPlayer3D

var max_pitch = 2
# Called when the node enters the scene tree for the first time.
func _update_bike_sound(value: float, max_speed:float) -> void:
	
	bike_drone_sound.pitch_scale= 1 + (value / max_speed) *max_pitch ;
	
func _play_boost_sound() -> void:
	boost_sound.play()
	
func _play_jump() -> void:
	jump_sound.play()
	
func _play_landing() -> void:
	land_sound.play()

func _play_drift() -> void:
	drift_sound.play()
