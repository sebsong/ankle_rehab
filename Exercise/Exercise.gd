extends Node2D

var exercise_type
var exercise_name

func get_tracker() -> Array:
	return Progress.exercise_name_to_tracker[exercise_name]

func get_time():
	return Progress.EXERCISE_TYPE_TO_DATA[exercise_type][2]

func _process(delta):
	#if get_time() == Progress.NO_TIME_DATA:
	#	$Start.text = "Log Rep"
	$ExerciseName.text = exercise_name
	$SetRepCount.text = String(get_tracker()[0]) + " : " + String(get_tracker()[1])
	#$RepCount.text = "Reps Left: " + String(get_tracker()[1])

func _on_Start_pressed():
	if get_time() == Progress.NO_TIME_DATA:
		Progress.decrement_rep(exercise_name, exercise_type)
		return
	Progress.current_timer_time = get_time()
	Progress.queue_decr(exercise_name, exercise_type)
	get_tree().change_scene("res://Timer/TimerNode.tscn")

func _on_AddRep_pressed():
	$AddRepSound.play()
	Progress.increment_rep(exercise_name, exercise_type)

func _on_MinusRep_pressed():
	$MinusRepSound.play()
	Progress.decrement_rep(exercise_name, exercise_type)
