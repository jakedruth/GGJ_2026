class_name StatDisplay
extends Polygon2D

@onready var line2D = get_node("Line2D") as Line2D
var stat_block: StatBlock

@export var jitter_offset: float = 0.05
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
	if stat_block == null:
		return

	_jitter_timer -= delta
	if _jitter_timer <= 0:
		_jitter_timer = randf_range(min_jitter, max_jitter)
		var jp: PackedVector2Array = stat_block.get_polygon()
		for i in jp.size():
			var angle = randf_range(0, TAU)
			jp[i] += Vector2.RIGHT.rotated(angle) * jitter_offset
		_update_polygon(jp)


func _update_polygon(points: PackedVector2Array):
	polygon = points;
	line2D.points = points;
	for i in points.size():
		(get_child(i + 1) as Node2D).position = points[i]
