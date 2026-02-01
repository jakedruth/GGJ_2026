class_name Thief
extends Resource

signal on_level_up(level)
signal on_health_state_changed(state)
signal on_work_state_changed(state)

enum HealthState {
	healthy,
	hurt,
	beat_up,
	near_death,
	dead
}

enum WorkState {
	ready,
	heading_out,
	on_job,
	heading_in,
	resting
}

@export var name: String
@export var stat_block: StatBlock
@export var abilities: Array[Ability]
@export var mask: Texture2D
@export var color: Color = Color.RED

var _health_state: HealthState = HealthState.healthy
var _work_state: WorkState = WorkState.ready
var level: int = 1
var experience: int = 0
var gold: int = 0
var _timer: float;


func _init() -> void:
	_timer = 0;


func set_timer(value: float):
	_timer = value


func update(dt: float):
	_timer -= dt


func get_work_state() -> WorkState:
	return _work_state

func go_to_next_state():
	match WorkState:
		WorkState.ready:
			set_work_state(WorkState.heading_out)
			pass
		WorkState.heading_out:
			set_work_state(WorkState.on_job)
			pass
		WorkState.on_job:
			set_work_state(WorkState.heading_in)
			pass
		WorkState.heading_in:
			set_work_state(WorkState.resting)
			pass
		WorkState.resting:
			set_work_state(WorkState.ready)
			pass


func set_work_state(state: WorkState):
	match state:
		WorkState.ready:
			pass
		WorkState.heading_out:
			pass
		WorkState.on_job:
			pass
		WorkState.heading_in:
			pass
		WorkState.resting:
			pass
	
	_work_state = state
	on_work_state_changed.emit(_work_state)

func get_health() -> HealthState:
	return _health_state


func take_damage():
	if _health_state == HealthState.dead:
		return
	
	_health_state = (_health_state + 1 as HealthState)
	on_health_state_changed.emit(_health_state)

	
func gain_experience(amount: int):
	experience += amount
	while experience >= level:
		experience -= level
		level += 1
		on_level_up.emit(level)

	
func gain_gold(amount: int):
	gold += amount
	pass
