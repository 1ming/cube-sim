extends Node3D

@onready var cube = %Cube

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_button_x_pressed() -> void:
	cube.rot_x()


func _on_button_y_pressed() -> void:
	cube.rot_y()


func _on_button_z_pressed() -> void:
	cube.rot_z()
