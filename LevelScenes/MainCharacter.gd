extends CharacterBody3D


@export var input_manager : InputManager
@export var presentation_manager : PresentationManager
@export var default_collision : CollisionShape3D
@export var slide_collision : CollisionShape3D
@export var character_animation : AnimatedSprite3D

@export var DriftCamera : PhantomCamera3D
@export var OnRailsCamera : PhantomCamera3D

@export var RightCollider : Area3D
@export var LeftCollider : Area3D

@export var MAX_SPEED = 11.0
@export var ACCELERATION = 0.2
@export var DRIFTSPEED = 1.0
@export var DRIFT_BOOST_SPEED = 1.0
@export var JUMP_VELOCITY = 4.5
@export var MAX_TURNING_MAGNITUDE = 5.0
@export var DRIFTING_RATE = 0.5
@export var TURNING_RATE = 0.2
@export var SLIDE_DURATION = 0.7
@export var DRIFT_BOOST_MAX_DURATION = 1.4
@export var DRIFT_SPEED_DECAY_RATE = 2.5
@export var WALL_JUMP_MAX_DURATION = 0.8
@export var WALL_JUMP_MAGNITUDE = 20
@export var DECELERATION_RATE = 20

@export var MIN_WINDOW_TIME_DRIFT_FOR_BOOST = 1.1
@export var MAX_WINDOW_TIME_DRIFT_FOR_BOOST = 1.6

var coin_counter = 0

var accumulated_drift_direction = Vector3(0,0,0)

var trick_in_progress = false

var base_speed = MAX_SPEED
var current_speed = 1

var rotation_accumulatior = 0
var drift_boost_active = false
var active_boost_time = 0

var drift_time_accumulator = 0


var slide_in_progress = false
var slide_time_accumulator = 0

var is_turning_left = false
var is_turning_right = false
var is_not_turning = true

var wall_jump_enabled = false
var apply_wall_normal = false
var wall_jump_time = 0
var previous_wall_normal = Vector3()

var accumulated_deceleration = 0

func _ready() -> void:
	character_animation.play("idle")

func _process(delta:float) -> void:
	if drift_boost_active:
		current_speed = base_speed + DRIFT_BOOST_SPEED*((DRIFT_BOOST_MAX_DURATION - active_boost_time)/DRIFT_BOOST_MAX_DURATION)
		active_boost_time += delta
		if active_boost_time >= DRIFT_BOOST_MAX_DURATION:
			drift_boost_active = false
			active_boost_time = 0
			#character_animation.play("idle")
			current_speed = MAX_SPEED
			presentation_manager._disable_boost_sparks()
			presentation_manager._set_wheels_to_red()
			
	if slide_in_progress:
		slide_time_accumulator+= delta
		if slide_time_accumulator > SLIDE_DURATION:
			slide_in_progress = false
			default_collision.disabled = false
			slide_collision.disabled = true
			slide_time_accumulator = 0
			#character_animation.play("idle")
			character_animation.flip_h = false
	#if apply_wall_normal:
		#wall_jump_time += delta
		#if wall_jump_time > WALL_JUMP_MAX_DURATION:
			#wall_jump_time = 0
			#apply_wall_normal = false
			#previous_wall_normal = Vector3(0,0,0)
		

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if is_on_floor_only():
		trick_in_progress = false
		rotation_accumulatior = 0
		#character_animation.play("idle")
	# Handle jump.
	if input_manager._is_jump_pressed() and is_on_floor():
		velocity.y = JUMP_VELOCITY
		#character_animation.play("Jump")
		
	if input_manager._is_jump_released():
		character_animation.play("Jump")
		

		
	var steer_input = -input_manager._get_axis()
		
	if input_manager._is_slide_pressed():
		character_animation.play("slide")
		character_animation.flip_h = true
		default_collision.disabled = true
		slide_collision.disabled = false
		slide_in_progress = true
		
	if input_manager._is_decelerate_pressed():
		accumulated_deceleration += DECELERATION_RATE * delta 
		
	if input_manager._is_deceleration_released():
		accumulated_deceleration = 0
		
	# TODO: Wall Jump
	#if not is_on_floor():
		#
		#var rightColliderHit = RightCollider.has_overlapping_bodies()
		#var leftColliderHit = LeftCollider.has_overlapping_bodies()
		#
		#if is_on_wall():
			#if rightColliderHit and not leftColliderHit:
				#wall_jump_enabled = true
				#character_animation.play("wall_ride_left")
			#elif not rightColliderHit and leftColliderHit:
				#character_animation.play("wall_ride_right")
				#wall_jump_enabled = true
			#else:
				#wall_jump_enabled = false
			
	
	if input_manager._is_drift_pressed() and is_on_floor():
		if drift_time_accumulator > 0:
			presentation_manager._set_wheels_to_red()
			presentation_manager._enable_wheel_sparks()
		
		character_animation.play("drift") 
		OnRailsCamera.set_tween_duration(.3)
		DriftCamera.set_priority(1)
		DriftCamera.set_tween_duration(.5)
		OnRailsCamera.set_priority(0)
		drift_time_accumulator += delta
		default_collision.disabled = true
		slide_collision.disabled = false
		var drift_direction = global_basis.z
		rotation.y = rotation.y + (steer_input*delta*DRIFTING_RATE)
		
		if drift_time_accumulator > MIN_WINDOW_TIME_DRIFT_FOR_BOOST:
			presentation_manager._set_wheels_to_blue()
		if drift_time_accumulator > MAX_WINDOW_TIME_DRIFT_FOR_BOOST:
			presentation_manager._set_wheels_to_red()
		velocity = drift_direction * (DRIFTSPEED - drift_time_accumulator*DRIFT_SPEED_DECAY_RATE)	
	elif input_manager._is_drift_released() and is_on_floor():
		
		presentation_manager._disable_wheel_sparks()
		presentation_manager._set_wheels_to_red()
		
		
		default_collision.disabled = false
		slide_collision.disabled = true
		OnRailsCamera.set_tween_duration(.5)
		DriftCamera.set_priority(0)
		OnRailsCamera.set_priority(1)
		
		if drift_time_accumulator > MIN_WINDOW_TIME_DRIFT_FOR_BOOST and drift_time_accumulator < MAX_WINDOW_TIME_DRIFT_FOR_BOOST:
			presentation_manager._enable_boost_sparks()
			presentation_manager._set_wheels_to_blue()
			character_animation.play("boost")
			drift_boost_active = true
		
		drift_time_accumulator = 0
		
		
		
	else:
		var horizontal_movement = steer_input * global_basis.x
		if not slide_in_progress and not input_manager._is_drift_pressed() and is_on_floor():
			if steer_input > 0 and not is_turning_right:
				character_animation.play("right_turn")
				is_turning_left = false
				is_turning_right = true
			elif steer_input < 0 and not is_turning_left:
				character_animation.play("left_turn")
				is_turning_left = true
				is_turning_right = false
			elif steer_input == 0:
				is_turning_left = false
				is_turning_right = false
				if not drift_boost_active:
					character_animation.play("idle")
			
		
		rotation.y = rotation.y + (steer_input*delta*TURNING_RATE)
		if is_on_floor():
			current_speed = min(MAX_SPEED, max(current_speed + ACCELERATION*delta - accumulated_deceleration,0))
		var velocity_cruising_magnitude = (current_speed * global_basis.z)  #+(horizontal_movement * (max(MAX_TURNING_MAGNITUDE - 0,0))))
		velocity_cruising_magnitude.y = velocity.y
		velocity = velocity_cruising_magnitude
	

	
	
	move_and_slide()
	
func _on_collectable_detector_area_entered(area: Area3D) -> void:
	print("collide")
	if area.is_in_group("coin"):
		set_coin(coin_counter + 1)
		print(coin_counter)

func set_coin(new_coin_count: int) -> void:
	coin_counter = new_coin_count
	

	
	
