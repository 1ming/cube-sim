extends Node3D

@onready var cube = %Cube

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_button_left_pressed() -> void:
	cube.rotate_left()


func _on_button_yaw_pressed() -> void:
	cube.rotate_yaw()


func _on_button_right_pressed() -> void:
	cube.rotate_right()
