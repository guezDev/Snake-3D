extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready():
	monitoring = true
	setNewPosition()
	#gravity_scale = 0.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func setNewPosition():
	Game.apple_position = generatePosition()
	transform.origin = Game.apple_position

# Genere une position pour la pomme
func generatePosition():
	var applePosition = getRandomPosition()
	
	# Vérifie que la position générée pour la pomme n'est pas occupée par le serpent
	while(isPositionOccupied(applePosition)):
		applePosition = getRandomPosition()
	
	return applePosition
	

# Recupere une position aleatoire par rapport aux dimensions du noeud parent (ici le jardin)
func getRandomPosition() -> Vector3:
	var randomIndex = randi() % Game.X_Z_POSITIONS.size()
	var x = Game.X_Z_POSITIONS[randomIndex] 
	randomIndex = randi() % Game.X_Z_POSITIONS.size()
	var z = Game.X_Z_POSITIONS[randomIndex]
	return Vector3(x, 0, z)

# Verifie si la position est occupee par le serpent
func isPositionOccupied(_position: Vector3) -> bool:
	if Game.head.transform.origin==_position:
		return true
	for snake in Game.segments:
		if snake.transform.origin == _position:
			return true
	return false


func _on_area_entered(area):
	setNewPosition()
