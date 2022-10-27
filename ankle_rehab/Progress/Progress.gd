extends Node2D

const NO_TIME_DATA = -1

######################### BEGIN ANKLE #############################
#enum ExerciseType {
#	PRESS,
#	BALANCE,
#	STRETCH,
#	MOBILITY
#}
#
## Data takes the form of [num_sets, num_reps, num_secs]
#const PRESS_DATA = [2, 10, 6]
#const BALANCE_DATA = [2, 6, 60]
#const STRETCH_DATA = [2, 1, 30]
#const MOBILITY_DATA = [2, 1, NO_TIME_DATA]
#
#const EXERCISE_TYPE_TO_DATA : Dictionary = {
#	ExerciseType.PRESS : PRESS_DATA,
#	ExerciseType.BALANCE : BALANCE_DATA,
#	ExerciseType.STRETCH : STRETCH_DATA,
#	ExerciseType.MOBILITY : MOBILITY_DATA
#}
######################### END ANKLE #############################

######################### BEGIN KNEE #############################
enum ExerciseType {
	HAMSTRING_STRETCH,
	FIG_4_HIP_STRETCH,
	KNEE_HUG,
	CLAMS,
	HEEL_RAISES,
	SINGLE_HEEL_RAISE,
	CALF_STRETCH,
	SINGLE_LEG_BALANCE,
	SQUATS,
	SINGLE_LEG_SQUAT,
	SIDE_STEPPING
}

# Data takes the form of [num_sets, num_reps, num_secs]
const HAMSTRING_STRETCH_DATA = [8, 2, NO_TIME_DATA]
const FIG_4_HIP_STRETCH_DATA = [9, 2, 15]
const KNEE_HUG_DATA = [9, 2, 15]
const CLAMS_DATA = [1, 3, 30]
const HEEL_RAISES_DATA = [1, 10, NO_TIME_DATA]
const SINGLE_HEEL_RAISE_DATA = [2, 10, NO_TIME_DATA]
const CALF_STRETCH_DATA = [3, 2, 30]
const SINGLE_LEG_BALANCE_DATA = [1, 2, 30]
const SQUATS_DATA = [1, 1, 10]
const SINGLE_LEG_SQUAT_DATA = [4, 5, NO_TIME_DATA]
const SIDE_STEPPING_DATA = [3, 1, 45]

const EXERCISE_TYPE_TO_DATA : Dictionary = {
	ExerciseType.HAMSTRING_STRETCH : HAMSTRING_STRETCH_DATA,
	ExerciseType.FIG_4_HIP_STRETCH : FIG_4_HIP_STRETCH_DATA,
	ExerciseType.KNEE_HUG : KNEE_HUG_DATA,
	ExerciseType.CLAMS : CLAMS_DATA,
	ExerciseType.HEEL_RAISES : HEEL_RAISES_DATA,
	ExerciseType.SINGLE_HEEL_RAISE : SINGLE_HEEL_RAISE_DATA,
	ExerciseType.CALF_STRETCH : CALF_STRETCH_DATA,
	ExerciseType.SINGLE_LEG_BALANCE : SINGLE_LEG_BALANCE_DATA,
	ExerciseType.SQUATS : SQUATS_DATA,
	ExerciseType.SINGLE_LEG_SQUAT : SINGLE_LEG_SQUAT_DATA,
	ExerciseType.SIDE_STEPPING : SIDE_STEPPING_DATA,
}
######################### END KNEE #############################

const SAVE_FILE_PATH = "user://save_file.save"

# Reset daily at 4am
const RESET_HOUR_CUTOFF = 4
const SECONDS_PER_DAY = 24 * 60 * 60

# turns out i don't know how to make and use classes yet
#class SetsRepsTracker:
#	var sets_left
#	var reps_left
#	
#	func SetsRepsTracker(exercise_type):
#		var exercise_data = EXERCISE_TYPE_TO_DATA[exercise_type]
#		sets_left = exercise_data[0]
#		reps_left = exercise_data[1]

#var exercise_type_to_tracker : Dictionary = {
#	ExerciseType.PRESS : SetsRepsTracker(ExerciseType.PRESS),
#	ExerciseType.BALANCE : SetsRepsTracker(ExerciseType.BALANCE),
#	ExerciseType.STRETCH : SetsRepsTracker(ExerciseType.STRETCH)
#}

# Persistent data
var exercise_name_to_tracker : Dictionary = {}
var last_reset_datetime : Dictionary = {}

var current_timer_time = 10
var exercise_name_to_decr
var exercise_type_to_decr

func _ready():
	load_progress()

func register_exercise(exercise_name, exercise_type):
	if exercise_name in exercise_name_to_tracker:
		# already registered
		return
	var data = EXERCISE_TYPE_TO_DATA[exercise_type]
	exercise_name_to_tracker[exercise_name] = [data[0], data[1]]
	save_progress()

func reset():
	get_tree().change_scene("res://Reset/Reset.tscn")

func reset_progress():
	exercise_name_to_tracker.clear()
	last_reset_datetime = Time.get_datetime_dict_from_system()
	save_progress()
	
func queue_decr(exercise_name, exercise_type):
	exercise_name_to_decr = exercise_name
	exercise_type_to_decr = exercise_type
	
func try_decr():
	if exercise_name_to_decr != null and exercise_type_to_decr != null:
		decrement_rep(exercise_name_to_decr, exercise_type_to_decr)
		exercise_name_to_decr = null
		exercise_type_to_decr = null

func _process(_delta):
	if check_completion():
		get_tree().change_scene("res://Success/Success.tscn")
	
	check_reset()

func check_reset():
	if last_reset_datetime.empty():
		reset()
	else:
		var current_datetime_unix = Time.get_unix_time_from_datetime_dict(Time.get_datetime_dict_from_system())
		var cutoff_datetime_unix = get_reset_cutoff_datetime_unix()
		if current_datetime_unix > cutoff_datetime_unix:
			reset()
		

func get_reset_cutoff_datetime_unix():
	var cutoff_datetime
	if last_reset_datetime["hour"] >= RESET_HOUR_CUTOFF:
		# Need to increment to next day
		var unix_time = Time.get_unix_time_from_datetime_dict(last_reset_datetime)
		cutoff_datetime = Time.get_date_dict_from_unix_time(unix_time + SECONDS_PER_DAY)
	else:
		cutoff_datetime = last_reset_datetime.duplicate()
	# "snap" time to reset cutoff
	cutoff_datetime["hour"] = RESET_HOUR_CUTOFF
	cutoff_datetime["minute"] = 0
	cutoff_datetime["second"] = 0
	return Time.get_unix_time_from_datetime_dict(cutoff_datetime)

func check_completion() -> bool:
	if exercise_name_to_tracker.empty():
		return false
	for tracker in exercise_name_to_tracker.values():
		for count in tracker:
			if count != 0:
				return false
	return true

func get_tracker(exercise_name) -> Array:
	return exercise_name_to_tracker[exercise_name]

func is_set_complete(exercise_name):
	return get_tracker(exercise_name)[0] == 0

func is_set_max(exercise_name, exercise_type):
	return get_tracker(exercise_name)[0] == EXERCISE_TYPE_TO_DATA[exercise_type][0]

func decrement_set(exercise_name):
	if is_set_complete(exercise_name):
		return
	get_tracker(exercise_name)[0] -= 1
	save_progress()

func increment_set(exercise_name, exercise_type):
	if is_set_max(exercise_name, exercise_type):
		return
	get_tracker(exercise_name)[0] += 1
	save_progress()

func decrement_rep(exercise_name, exercise_type):
	if get_tracker(exercise_name)[1] == 0:
		return
	
	var new_reps = get_tracker(exercise_name)[1] - 1
	if new_reps == 0:
		decrement_set(exercise_name)
		if is_set_complete(exercise_name):
			get_tracker(exercise_name)[1] = 0
		else:
			# reset number of reps
			get_tracker(exercise_name)[1] = EXERCISE_TYPE_TO_DATA[exercise_type][1]
	else:
		get_tracker(exercise_name)[1] = new_reps
	save_progress()

func increment_rep(exercise_name, exercise_type):
	if get_tracker(exercise_name)[1] == EXERCISE_TYPE_TO_DATA[exercise_type][1]:
		if is_set_max(exercise_name, exercise_type):
			return
		increment_set(exercise_name, exercise_type)
		get_tracker(exercise_name)[1] = 1
	elif is_set_complete(exercise_name):
		increment_set(exercise_name, exercise_type)
		get_tracker(exercise_name)[1] = 1
	else:
		get_tracker(exercise_name)[1] += 1
	save_progress()

func save_progress():
	var save_file = File.new()
	save_file.open(SAVE_FILE_PATH, File.WRITE)
	save_file.store_line(to_json(exercise_name_to_tracker))
	save_file.store_line(to_json(last_reset_datetime))
	save_file.close()

func load_progress():
	var save_file = File.new()
	if save_file.file_exists(SAVE_FILE_PATH):
		save_file.open(SAVE_FILE_PATH, File.READ)
		var progress_json = save_file.get_line()
		exercise_name_to_tracker = parse_json(progress_json)
		
		var last_reset_datetime_json = save_file.get_line()
		last_reset_datetime = parse_json(last_reset_datetime_json)
	
				
