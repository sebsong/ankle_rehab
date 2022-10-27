extends "res://Exercise/Exercise.gd"


func _ready():
	exercise_name = "Single Leg Squat"
	exercise_type = Progress.ExerciseType.SINGLE_LEG_SQUAT
	Progress.register_exercise(exercise_name, exercise_type)
