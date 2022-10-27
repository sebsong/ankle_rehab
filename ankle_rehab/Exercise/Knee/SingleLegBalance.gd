extends "res://Exercise/Exercise.gd"


func _ready():
	exercise_name = "Single Leg Balance"
	exercise_type = Progress.ExerciseType.SINGLE_LEG_BALANCE
	Progress.register_exercise(exercise_name, exercise_type)
