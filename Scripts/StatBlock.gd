class_name StatBlock extends Resource

enum Stat {
	POW,
	SNK,
	SPD,
	CHA,
	INT
}

@export var data: Dictionary[Stat, int] = {
	Stat.POW: 0,
	Stat.SNK: 0,
	Stat.SPD: 0,
	Stat.CHA: 0,
	Stat.INT: 0
}

var _polygon: PackedVector2Array;


func get_overlap_area_ratio(other: StatBlock) -> float:
	var _a = _to_packedVector2Array();
	var _b = other._to_packedVector2Array();
	var _overlap = Geometry2D.intersect_polygons(_a, _b)[0];

	var _areaA = _get_area(_a);
	var _areaB = _get_area(_b);
	var _areaO = _get_area(_overlap);

	var ratio = _areaO / _areaB

	return ratio;


func get_overlap_with_other(other: StatBlock) -> PackedVector2Array:
	var _a = _to_packedVector2Array()
	var _b = other._to_packedVector2Array()
	var overlap = Geometry2D.intersect_polygons(_a, _b);
	return overlap

func get_polygon() -> PackedVector2Array:
	if _polygon.size() == 0:
		_polygon = _to_packedVector2Array()

	return _polygon.slice(0, _polygon.size())

 
func _to_packedVector2Array() -> PackedVector2Array:
	const delta = 2 * PI * 0.2
	var points: PackedVector2Array = [
		_get_point(data[Stat.POW], 0 * delta),
		_get_point(data[Stat.SNK], 1 * delta),
		_get_point(data[Stat.SPD], 2 * delta),
		_get_point(data[Stat.CHA], 3 * delta),
		_get_point(data[Stat.INT], 4 * delta)];
	return points

func get_center() -> Vector2:
	var points = _to_packedVector2Array()
	var center = Vector2.ZERO
	var size: float = points.size();
	if points.size() == 0:
		return center;

	for point in points:
		center += point / size;

	return center;


## Converts a radial coord to cartesian coord
func _get_point(radius: int, angle: float) -> Vector2:
	return Vector2(cos(angle), sin(angle)) * radius


func _get_area(points: PackedVector2Array) -> float:
	var area = 0;
	var productA = 0;
	var productB = 0;
	for i in points.size():
		var n = (i + 1) % points.size();
		productA += points[i].x * points[n].y
		productB += points[i].y * points[n].x
		pass
	area = (productA - productB) * 0.5
	
	return area;

func add_stats(other: StatBlock) -> StatBlock:
	return other;