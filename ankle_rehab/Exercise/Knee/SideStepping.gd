extends "res://Exercise/Exercise.gd"


func _ready():
	exercise_name = "Side Stepping"
	exercise_type = Progress.ExerciseType.SIDE_STEPPING
	Progress.register_exercise(exercise_name, exercise_type)
