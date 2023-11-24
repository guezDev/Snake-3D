extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$HBoxContainer/Score.text = str(Game.scoreFinal)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
