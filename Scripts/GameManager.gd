class_name GameManager
extends Node

@export var job_stat_block: StatBlock;
@export var team_stat_block: StatBlock;
@export var job_display: StatDisplay;
@export var team_display: StatDisplay;
@export var ball: BouncingBall;


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	job_display.set_stat_block(job_stat_block)
	team_display.set_stat_block(team_stat_block)
	ball.reset()

	var result = team_stat_block.get_overlap_area_ratio(job_stat_block)
	print(result);
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == 1: # Left Click
			ball.handle_start()
			pass
		elif event.button_index == 2: # Right Click
			ball.reset()
			pass
		elif event.button_index == 3: # Middle Click
			ball.startDrag = true
			pass

func set_current_team(team: StatBlock):
	team_display.set_stat_block(team)
