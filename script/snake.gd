extends Area3D

# Direction dans laquelle le serpent va commencer à se deplacer
var direction := Game.VECTOR3_RIGHT

var time_passed = 0.0
var time_interval = 1.0
var time_passed_update_direction = 0.0
var time_interval_update_direction = 0.8

var nb_sous_partie = 0

var directions := []

var lastSegmentDirection 

var j:=0

var score :=0

# Called when the node enters the scene tree for the first time.
func _ready():
	$"../../Node2D/nbPommes".text = str(score)
	Game.head=self
	monitoring = true
	transform.origin = Vector3(-4.5, 0, -4.5)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta): 
	time_passed += delta
	if time_passed >= time_interval:
		translate(direction)
		for i in range(nb_sous_partie):
			Game.segments[i].translate(directions[i])
			
		
		var tempo
		if nb_sous_partie > 0:
			lastSegmentDirection = directions[nb_sous_partie-1]
			tempo = directions[0]
			directions[0]=direction
		for i in range(nb_sous_partie):
			if i!=0:
				var tp=directions[i]
				directions[i]=tempo
				tempo=tp
		
		time_passed = 0.0
		manage_garden_exits()
			
	update_direction(delta)
	
# Met a jour la direction en fonction des touches de deplacement
func update_direction(delta):
	time_passed_update_direction += delta
	
	if Input.is_action_pressed("ui_right") and direction != Game.VECTOR3_LEFT:
		if time_passed_update_direction >= time_interval_update_direction:
			direction = Game.VECTOR3_RIGHT
			time_passed_update_direction = 0.0
	if Input.is_action_pressed("ui_left") and direction != Game.VECTOR3_RIGHT:
		if time_passed_update_direction >= time_interval_update_direction:
			direction = Game.VECTOR3_LEFT
			time_passed_update_direction = 0.0
	if Input.is_action_pressed("ui_down") and direction != Game.VECTOR3_UP:
		if time_passed_update_direction >= time_interval_update_direction:
			direction = Game.VECTOR3_DOWN
			time_passed_update_direction = 0.0
	if Input.is_action_pressed("ui_up") and direction != Game.VECTOR3_DOWN:
		if time_passed_update_direction >= time_interval_update_direction:	
			direction = Game.VECTOR3_UP
			time_passed_update_direction = 0.0
	

# Gère les sortie du jardin, si le serpent sort d'un cote, il doit entrer par le cote oppose
func manage_garden_exits():
	# s'il sort par le cote droit, il entre par le cote gauche
	if(transform.origin.x > 4.5):
		transform.origin.x = -4.5
	# s'il sort par le cote gauche, il entre par le cote droit
	if(transform.origin.x < -4.5):
		transform.origin.x = 4.5
	# s'il sort par le bas, il entre par le haut
	if(transform.origin.z > 4.5):
		transform.origin.z = -4.5
	# s'il sort par le haut, il entre par le bas
	if(transform.origin.z < -4.5):
		transform.origin.z = 4.5
		
	for i in range(nb_sous_partie):
		if(Game.segments[i].transform.origin.x > 4.5):
			Game.segments[i].transform.origin.x = -4.5
			
		if(Game.segments[i].transform.origin.x < -4.5):
			Game.segments[i].transform.origin.x = 4.5
			
		if(Game.segments[i].transform.origin.z > 4.5):
			Game.segments[i].transform.origin.z = -4.5
			
		if(Game.segments[i].transform.origin.z < -4.5):
			Game.segments[i].transform.origin.z = 4.5


func _on_area_entered(area):
	
	if area in Game.segments:
		Game.scoreFinal = score
		get_tree().change_scene_to_file("res://scene/game_over.tscn")
		
	score+=1
	time_interval-=0.05
	$"../../Node2D/nbPommes".text = str(score)
	print("Score : ", score)

	var snake_scene = preload("res://scene/snake.tscn")

	# Instancie un nouveau serpent
	var new_snake = snake_scene.instantiate()
	
	var material = StandardMaterial3D.new()

	material.albedo_color = Color(1,0,1)
	new_snake.get_node("MeshInstance3D").material_override = material
	
	if nb_sous_partie==0:
		new_snake.transform.origin= self.transform.origin
	else:
		new_snake.transform.origin= Game.segments[nb_sous_partie-1].transform.origin
		
	if nb_sous_partie > 0:
		if lastSegmentDirection == Game.VECTOR3_RIGHT:
			new_snake.transform.origin.x-=1
		elif lastSegmentDirection == Game.VECTOR3_LEFT:
			new_snake.transform.origin.x+=1
		elif lastSegmentDirection == Game.VECTOR3_UP:
			new_snake.transform.origin.z+=1
		elif lastSegmentDirection == Game.VECTOR3_DOWN:
			new_snake.transform.origin.z-=1
		
	else:
		if direction == Game.VECTOR3_RIGHT:
			new_snake.transform.origin.x-=1
		elif direction == Game.VECTOR3_LEFT:
			new_snake.transform.origin.x+=1
		elif direction == Game.VECTOR3_UP:
			new_snake.transform.origin.z+=1
		elif direction == Game.VECTOR3_DOWN:
			new_snake.transform.origin.z-=1
	
	#new_snake.transform.origin=Vector3(-4.5, 0, -4.5)
	
	Game.segments.insert(nb_sous_partie, new_snake)
	if nb_sous_partie == 0:
		directions.insert(0, direction)
	else:
		#directions[j-1]=lastSegmentDirection
		directions.insert(j, lastSegmentDirection)
	nb_sous_partie+=1
	
	j+=1

	
	get_parent().add_child(new_snake)
