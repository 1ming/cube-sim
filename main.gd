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


func _on_x_full_pressed() -> void:
	cube.rotate_blocks("x", cube.Rot.FULL)


func _on_x_neg_pressed() -> void:
	cube.rotate_blocks("x", cube.Rot.LOWER)


func _on_x_pos_pressed() -> void:
	cube.rotate_blocks("x", cube.Rot.UPPER)


func _on_y_pos_pressed() -> void:
	cube.rotate_blocks("y", cube.Rot.UPPER)


func _on_y_neg_pressed() -> void:
	cube.rotate_blocks("y", cube.Rot.LOWER)


func _on_y_full_pressed() -> void:
	cube.rotate_blocks("y", cube.Rot.FULL)


func _on_z_pos_pressed() -> void:
	cube.rotate_blocks("z", cube.Rot.UPPER)


func _on_z_neg_pressed() -> void:
	cube.rotate_blocks("z", cube.Rot.LOWER)


func _on_z_full_pressed() -> void:
	cube.rotate_blocks("z", cube.Rot.FULL)
