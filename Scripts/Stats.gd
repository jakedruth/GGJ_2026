class_name Stats extends Resource

@export var POW: int = 0
@export var SNK: int = 0
@export var SPD: int = 0
@export var CHA: int = 0
@export var INT: int = 0

func get_overlap_area_ratio(other: Stats) -> float:
	var _a = to_polygon2D();
	var _b = other.to_polygon2D();
	var _overlap = Geometry2D.intersect_polygons(_a, _b)[0];

	var _areaA = _get_area(_a);
	var _areaB = _get_area(_b);
	var _areaO = _get_area(_overlap);

	var ratio = _areaO / _areaB

	return ratio;


func get_overlap_with_other(other: Stats) -> PackedVector2Array:
	var _a = to_polygon2D()
	var _b = other.to_polygon2D()
	var overlap = Geometry2D.intersect_polygons(_a, _b);
	return overlap

 
func to_polygon2D() -> PackedVector2Array:
	const delta = 2 * PI * 0.2
	var verts: PackedVector2Array = [
		_get_point(POW, 0 * delta),
		_get_point(SNK, 1 * delta),
		_get_point(SPD, 2 * delta),
		_get_point(CHA, 3 * delta),
		_get_point(INT, 4 * delta)];
	return verts


## Converts a radial coord to cartesian coord
func _get_point(radius: int, angle: float) -> Vector2:
	return Vector2(cos(angle), sin(angle)) * radius

func _get_area(verts: PackedVector2Array) -> float:
	var area = 0;
	var productA = 0;
	var productB = 0;
	for i in verts.size():
		var n = (i + 1) % verts.size();
		productA += verts[i].x * verts[n].y
		productB += verts[i].y * verts[n].x
		pass
	area = (productA - productB) * 0.5
	
	return area;
