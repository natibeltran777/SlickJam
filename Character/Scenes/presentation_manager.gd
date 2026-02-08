extends Node3D
class_name PresentationManager
@export var wheel_spark : CPUParticles3D
@export var boost_sparks : CPUParticles3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _enable_wheel_sparks() -> void:
	wheel_spark.emitting = true
	#wheel_spark_1.emitting = true
	
func _disable_wheel_sparks() -> void:
	wheel_spark.emitting = false
	#wheel_spark_1.emitting = false
	
func _set_wheels_to_blue() -> void:
	wheel_spark.mesh.surface_get_material(0).set("emission", Color(0,0,1))
	
func _set_wheels_to_red() -> void:
	wheel_spark.mesh.surface_get_material(0).set("emission", Color(1,0,0))
	
func _enable_boost_sparks() -> void:
	boost_sparks.emitting = true
	
func _disable_boost_sparks() -> void:
	boost_sparks.emitting = false
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
