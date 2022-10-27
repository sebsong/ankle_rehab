extends "res://Exercise/Exercise.gd"


func _ready():
	exercise_name = "Single Heel Raise"
	exercise_type = Progress.ExerciseType.SINGLE_HEEL_RAISE
	Progress.register_exercise(exercise_name, exercise_type)
