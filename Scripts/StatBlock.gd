class_name StatBlock
extends Resource

# The type of stats
enum Stat {
	POW,
	SNK,
	SPD,
	CHA,
	INT
}

# Dictionary of stats the character or job has
@export var _data: Dictionary[Stat, int] = {
	Stat.POW: 0,
	Stat.SNK: 0,
	Stat.SPD: 0,
	Stat.CHA: 0,
	Stat.INT: 0
}

# A reference to the calculated polygon produced by the stats
var _polygon: PackedVector2Array


# Get a stat
func get_stat(stat: Stat) -> int:
	return _data[stat]


# Set a stat
func set_stat(stat: Stat, value: int) -> void:
	_data[stat] = value
	_polygon = _to_packedVector2Array()
	

# Calculate the percentage of overlap a statblock has on another statblock
func get_overlap_area_ratio(other: StatBlock) -> float:
	var a = _to_packedVector2Array();
	var b = other._to_packedVector2Array();
	var overlap = Geometry2D.intersect_polygons(a, b)[0];
	
	# Currently not needed
	# var areaA = _get_area(a); 
	var areaB = _get_area(b);
	var areaO = _get_area(overlap);
	var ratio = areaO / areaB

	return ratio;


# Get a new polygon based on overlap
func get_overlap_with_other(other: StatBlock) -> PackedVector2Array:
	var _a = _to_packedVector2Array()
	var _b = other._to_packedVector2Array()
	var overlap = Geometry2D.intersect_polygons(_a, _b);
	return overlap


# Get the Polygon of the stat block
func get_polygon() -> PackedVector2Array:
	if _polygon.size() == 0:
		print("polygon is size 0")
		_polygon = _to_packedVector2Array()

	return _polygon.duplicate()


# converts the stats to a polygon
func _to_packedVector2Array() -> PackedVector2Array:
	const delta = 2 * PI * 0.2
	const offset = - PI * 0.5
	var points: PackedVector2Array = [
		_get_point(_data[Stat.POW], offset + 0 * delta),
		_get_point(_data[Stat.SNK], offset + 1 * delta),
		_get_point(_data[Stat.SPD], offset + 2 * delta),
		_get_point(_data[Stat.CHA], offset + 3 * delta),
		_get_point(_data[Stat.INT], offset + 4 * delta)];
	return points


# Converts a radial coord to cartesian coord
func _get_point(radius: int, angle: float) -> Vector2:
	return Vector2(cos(angle), sin(angle)) * radius


# Get the area of a polygon
func _get_area(points: PackedVector2Array) -> float:
	# https://www.wikihow.com/Calculate-the-Area-of-a-Polygon#:~:text=70%2E-,Part,3
	# From my understanding, this converts all the points into triangles to calculate each area.
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


# Add a statblock with another. The max stat is probably 10?
func get_combine(other: StatBlock) -> StatBlock:
	const MAX_VALUE: int = 10;
	var result = StatBlock.new()
	result._data = {
		Stat.POW: min(_data[Stat.POW] + other._data[Stat.POW], MAX_VALUE),
		Stat.SNK: min(_data[Stat.SNK] + other._data[Stat.SNK], MAX_VALUE),
		Stat.SPD: min(_data[Stat.SPD] + other._data[Stat.SPD], MAX_VALUE),
		Stat.CHA: min(_data[Stat.CHA] + other._data[Stat.CHA], MAX_VALUE),
		Stat.INT: min(_data[Stat.INT] + other._data[Stat.INT], MAX_VALUE),
	}
	return result;