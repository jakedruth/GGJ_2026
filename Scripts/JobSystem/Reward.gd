class_name Reward
extends Resource

enum RewardType {
	gold,
	xp,
	quest,
}

@export var rewardType: RewardType
@export var gold: float
@export var xp: float
@export var jobs: Array[Job]

# TODO - update all of this when the functions actually exists
func claim(manager: Node, _args: Array) -> void:
	match rewardType:
		RewardType.gold:
			manager.emit_signal("gain_gold:", gold)
			pass
		RewardType.xp:
			manager.emit_signal("gain_xp:", xp)
			pass
		RewardType.quest:
			manager.emit_signal("add_job_to_pool:", jobs)
			pass
	pass