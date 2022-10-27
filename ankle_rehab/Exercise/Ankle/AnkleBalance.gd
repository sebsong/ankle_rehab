extends "res://Exercise/Exercise.gd"


func _ready():
	exercise_name = "Ankle Balance"
	exercise_type = Progress.ExerciseType.BALANCE
	Progress.register_exercise(exercise_name, exercise_type)
	
