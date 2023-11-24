extends Node

const GARDEN_CELL_SIDE_SIZE = 1

const VECTOR3_RIGHT = Vector3(1, 0, 0)
const VECTOR3_LEFT = Vector3(-1, 0, 0)
const VECTOR3_DOWN = Vector3(0, 0, 1)
const VECTOR3_UP = Vector3(0, 0, -1)

const X_Z_POSITIONS = [-4.5, -3.5, -2.5, -1.5, -0.5, 0.5, 1.5, 2.5, 3.5, 4.5]

var apple_position

var head
var segments := []

var scoreFinal
