class_name Stats extends Resource

@export var POW: int = 0
@export var SNK: int = 0
@export var SPD: int = 0
@export var CHA: int = 0
@export var INT: int = 0


func get_overlap_area_ratio(other: Stats) -> float:
	var poly = get_polygon()
	var _otherPoly = other.get_polygon()

	for p in poly:
		print("point:", p.x, "\t", p.y)
		pass

	return other.POW;

 
func get_polygon() -> Array[Vector2]:
	const delta = 2 * PI * 0.2;
	var arr: Array[Vector2] = [
		_get_point(POW, 0 * delta),
		_get_point(SNK, 1 * delta),
		_get_point(SPD, 2 * delta),
		_get_point(CHA, 3 * delta),
		_get_point(INT, 4 * delta),
	];
	return arr


## Converts a radial coord to cartesian coord
func _get_point(radius: int, angle: float) -> Vector2:
	return Vector2(cos(angle), sin(angle)) * radius
