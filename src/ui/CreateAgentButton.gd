extends TextureButton

@export var agentType : Cell.TYPES

func _pressed():
	owner.instantiateAgent.emit(agentType)
