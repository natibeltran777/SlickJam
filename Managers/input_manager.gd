extends Node
class_name InputManager

func _is_deceleration_released() -> bool:
	return Input.is_action_just_released("decelerate_pressed");

func _is_decelerate_pressed() -> bool:
	return Input.is_action_pressed("decelerate_pressed");

func _is_slide_pressed() -> bool:
	return Input.is_action_just_pressed("slide_pressed");
	
func _is_drift_pressed() -> bool:
	return Input.is_action_pressed("drift_pressed");
	
func _is_drift_released() -> bool:
	return Input.is_action_just_released("drift_pressed");

func _is_jump_pressed() -> bool:
	return Input.is_action_just_pressed("jump_pressed");
	
func _is_jump_released() -> bool:
	return Input.is_action_just_released("jump_pressed");
	
func _is_trick_pressed() -> bool:
	return Input.is_action_just_pressed("trick_pressed");
	
func _get_axis() -> float:
	return Input.get_axis("left_pressed", "right_pressed");
