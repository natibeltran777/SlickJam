extends Node2D
class_name HUD

@export var timer_label : Label
@export var coinCount_label : Label
@export var coinMax_label : Label

var timerUI : TimerUI

func _ready ():
	timerUI = get_tree().get_first_node_in_group("timer")
	
func _process(delta):
	update_timerUI_label()

func update_timerUI_label():
	timer_label.text = timerUI.time_to_string()

func update_coin_count_number(number : int):
	coinCount_label.text = str(number)

func update_coin_max_number(number : int):
	coinMax_label.text = "/" + str(number)
