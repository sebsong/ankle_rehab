extends "res://Exercise/Exercise.gd"


func _ready():
	exercise_name = "Heel Raises"
	exercise_type = Progress.ExerciseType.HEEL_RAISES
	Progress.register_exercise(exercise_name, exercise_type)
