extends Node2D

func _ready():
	start_timer(Progress.current_timer_time)

func _process(_delta):
	$TimeLeft.text = String(int($Timer.time_left))

func start_timer(timer_secs):
	$Timer.start(timer_secs)
	
func stop_timer():
	$Timer.stop()
	$FinishSound.play()

func _on_Timer_timeout():
	stop_timer()

func _on_FinishSound_finished():
	Progress.try_decr()
	get_tree().change_scene("res://Main.tscn")


func _on_Cancel_pressed():
	get_tree().change_scene("res://Main.tscn")
