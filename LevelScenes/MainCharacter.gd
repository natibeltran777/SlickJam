extends CharacterBody3D


@export var input_manager : InputManager
@export var character_model: MeshInstance3D

@export var DriftCamera : PhantomCamera3D
@export var OnRailsCamera : PhantomCamera3D

@export var SPEED = 5.0
@export var DRIFTSPEED = 1.0
@export var DRIFT_BOOST_SPEED = 1.0
@export var JUMP_VELOCITY = 4.5
@export var MAX_TURNING_MAGNITUDE = 5.0
@export var DRIFTING_RATE = 0.5

var accumulated_drift_direction = Vector3(0,0,0)

var trick_in_progress = false

var rotation_accumulatior = 0
var drift_boost_active = false
var draft_boost_max_duration = .7
var active_boost_time = 0


func _process(delta:float) -> void:
	if drift_boost_active:
		SPEED = SPEED + DRIFT_BOOST_SPEED*((draft_boost_max_duration - active_boost_time)/draft_boost_max_duration)
		active_boost_time += delta
		if active_boost_time >= draft_boost_max_duration:
			drift_boost_active = false
			active_boost_time = 0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	
	OnRailsCamera.look_at_target
			
	if is_on_floor_only():
		trick_in_progress = false
		character_model.rotation.y = PI/2
		rotation_accumulatior = 0
	# Handle jump.
	if input_manager._is_jump_pressed():
		velocity.y = JUMP_VELOCITY
		trick_in_progress = true
		
	if trick_in_progress:
		rotation_accumulatior += delta*17
		character_model.rotation.y = rotation_accumulatior

		
	var steer_input = -input_manager._get_axis()
		
	character_model.rotation.x = steer_input * 0.2
		
	if input_manager._is_drift_pressed():
		#DriftCamera.set_priority(1)
		#OnRailsCamera.set_priority(0)
		var drift_direction = global_basis.z
		rotation.y = rotation.y + (steer_input*delta*DRIFTING_RATE)
		velocity = drift_direction * DRIFTSPEED	
	elif input_manager._is_drift_released():
		#DriftCamera.set_priority(0)
		#OnRailsCamera.set_priority(1)
		SPEED = DRIFT_BOOST_SPEED
	else:
		var horizontal_movement = steer_input * global_basis.x
		
		var velocity_cruising_magnitude = (SPEED * global_basis.z + horizontal_movement * MAX_TURNING_MAGNITUDE)
		velocity_cruising_magnitude.y = velocity.y
		velocity = velocity_cruising_magnitude
	

	
	
	move_and_slide()
