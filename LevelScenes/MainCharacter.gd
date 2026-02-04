extends CharacterBody3D


@export var input_manager : InputManager
@export var default_collision : CollisionShape3D
@export var slide_collision : CollisionShape3D
@export var character_animation : AnimatedSprite3D

@export var DriftCamera : PhantomCamera3D
@export var OnRailsCamera : PhantomCamera3D

@export var MAX_SPEED = 11.0
@export var ACCELERATION = 0.2
@export var DRIFTSPEED = 1.0
@export var DRIFT_BOOST_SPEED = 1.0
@export var JUMP_VELOCITY = 4.5
@export var MAX_TURNING_MAGNITUDE = 5.0
@export var DRIFTING_RATE = 0.5
@export var SLIDE_DURATION = 0.7
@export var DRIFT_BOOST_MAX_DURATION = 1.4

var accumulated_drift_direction = Vector3(0,0,0)

var trick_in_progress = false

var base_speed = MAX_SPEED
var current_speed = 1

var rotation_accumulatior = 0
var drift_boost_active = false
var active_boost_time = 0

var slide_in_progress = false
var slide_time_accumulator = 0

func _ready() -> void:
	character_animation.play("idle")

func _process(delta:float) -> void:
	if drift_boost_active:
		current_speed = base_speed + DRIFT_BOOST_SPEED*((DRIFT_BOOST_MAX_DURATION - active_boost_time)/DRIFT_BOOST_MAX_DURATION)
		active_boost_time += delta
		if active_boost_time >= DRIFT_BOOST_MAX_DURATION:
			drift_boost_active = false
			active_boost_time = 0
			character_animation.play("idle")
			current_speed = MAX_SPEED
			
	if slide_in_progress:
		slide_time_accumulator+= delta
		if slide_time_accumulator > SLIDE_DURATION:
			slide_in_progress = false
			default_collision.disabled = false
			slide_collision.disabled = true
			slide_time_accumulator = 0
			character_animation.play("idle")
			character_animation.flip_h = false
		

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if is_on_floor_only():
		trick_in_progress = false
		rotation_accumulatior = 0
	# Handle jump.
	if input_manager._is_jump_pressed() and is_on_floor():
		velocity.y = JUMP_VELOCITY
		

		
	var steer_input = -input_manager._get_axis()
		
	if input_manager._is_slide_pressed():
		character_animation.play("slide")
		character_animation.flip_h = true
		default_collision.disabled = true
		slide_collision.disabled = false
		slide_in_progress = true
		
		
	if input_manager._is_drift_pressed() and is_on_floor():
		OnRailsCamera.set_tween_duration(.3)
		DriftCamera.set_priority(1)
		DriftCamera.set_tween_duration(.5)
		OnRailsCamera.set_priority(0)
		character_animation.play("drift")
		
		default_collision.disabled = true
		slide_collision.disabled = false
		var drift_direction = global_basis.z
		rotation.y = rotation.y + (steer_input*delta*DRIFTING_RATE)
		velocity = drift_direction * (DRIFTSPEED)	
	elif input_manager._is_drift_released() and is_on_floor():
		default_collision.disabled = false
		slide_collision.disabled = true
		OnRailsCamera.set_tween_duration(.5)
		DriftCamera.set_priority(0)
		OnRailsCamera.set_priority(1)
		character_animation.play("boost")
		drift_boost_active = true
	else:
		var horizontal_movement = steer_input * global_basis.x
		
		if is_on_floor():
			current_speed = min(MAX_SPEED, current_speed + ACCELERATION*delta)
		var velocity_cruising_magnitude = (current_speed * global_basis.z + horizontal_movement * MAX_TURNING_MAGNITUDE)
		velocity_cruising_magnitude.y = velocity.y
		velocity = velocity_cruising_magnitude
	

	
	
	move_and_slide()
