class_name StatDisplay
extends Polygon2D

@onready var line2D = get_node("Line2D") as Line2D
var _stat_block: StatBlock
var _collision_poly: PackedVector2Array

@export var polygon_scale: float = 16.0
@export var jitter_offset: float = 1.5
@export var min_jitter: float = 0.25
@export var max_jitter: float = 1.0
var _jitter_timer: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var c = color;
	c.a = 1;
	line2D.default_color = c;
	var count = get_child_count()
	for i in (count - 1):
		(get_child(i + 1) as Sprite2D).modulate = c;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if _stat_block == null:
		return

	_jitter_timer -= delta
	if _jitter_timer <= 0:
		_jitter_timer = randf_range(min_jitter, max_jitter)
		var jp: PackedVector2Array = _collision_poly.duplicate()
		for i in jp.size():
			var angle = randf_range(0, TAU)
			jp[i] += Vector2.RIGHT.rotated(angle) * jitter_offset
		_update_polygon(jp)


func _update_polygon(points: PackedVector2Array):
	polygon = points;
	line2D.points = points;
	for i in points.size():
		(get_child(i + 1) as Node2D).position = points[i]

	
func set_stat_block(sb: StatBlock):
	_stat_block = sb;
	_collision_poly = sb.get_polygon();
	for i in _collision_poly.size():
		_collision_poly[i] *= polygon_scale
	_update_polygon(_collision_poly)


func get_collision() -> PackedVector2Array:
	return _collision_poly


# Find the center of the polygon
func get_center() -> Vector2:
	var center = Vector2.ZERO
	var size: float = _collision_poly.size();
	if _collision_poly.size() == 0:
		return center;

	for point in _collision_poly:
		center += point / size;

	return center;