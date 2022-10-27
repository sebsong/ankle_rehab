extends "res://Exercise/Exercise.gd"


func _ready():
	exercise_name = "Alphabet"
	exercise_type = Progress.ExerciseType.MOBILITY
	Progress.register_exercise(exercise_name, exercise_type)
