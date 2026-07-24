class_name Block
extends Node3D

const AREA_NAMES = {
	"XBox": "x",
	"YBox": "y",
	"ZBox": "z",
}

enum {
	STATIONARY,
	PIVOT,
}

@export var id: String
var rot_group = STATIONARY

var rot_areas = {
	"x": false,
	"y": false,
	"z": false,
}

func _on_area_3d_area_entered(area: Area3D) -> void:
	rot_areas[AREA_NAMES[area.name]] = true


func _on_area_3d_area_exited(area: Area3D) -> void:
	rot_areas[AREA_NAMES[area.name]] = false

func in_rot_area(axis: String):
	return rot_areas[axis]
