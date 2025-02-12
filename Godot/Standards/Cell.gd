extends CollisionShape2D
class_name Cell

#-- Variables --
var cellID : String
var type : String
var tags : Array # Eats, Uneatable
var energy_consumption = 1.0
var connections : Array
var input : float
var output : float

#-- Math Functions --
func weighted_clamp(number):
	return (0.5**abs(number)-1)*sign(number)*-1

func get_from_sauce(special_sauce : String, values : Array):
	"""
	Values:
		bool : 1 -> bool
		weight : 1 -> 0 - 9
		angle : 2 -> -pi - pi
	"""
	var toReturn : Array
	for value in values:
		match value:
			"bool":
				toReturn.append(bool(int(special_sauce[0])%2))
				special_sauce = special_sauce.substr(1,special_sauce.length()-1)
			"weight":
				toReturn.append(int(special_sauce[0]))
				special_sauce = special_sauce.substr(1,special_sauce.length()-1)
			"angle":
				toReturn.append( (float(special_sauce.substr(0,2)) / 100) * 2 * PI - PI )
				special_sauce = special_sauce.substr(2, special_sauce.length()-2)
			_:
				print_rich("[rainbow]You made a typo!!!")
				print_rich("[rainbow]Silly you, " + value + " isn't a valid sauce value![/rainbow]")
				print_rich("[img]res://Misc/ohnocat.jpg[img]")
	return toReturn

#-- Interface With Creature --
func unpack(RNA, ID):
	cellID = ID
	name = cellID
	type = RNA['Type']
	connections = RNA['Connections']
	position = RNA['Position']
	shape = load("res://Standards/cell_shape.tres")
	_interpret_special_sauce(RNA['Special Sauce'])
	
func remove_connections(cellIDs : Array):
	var temporary_array = []
	for connection in connections:
		if not connection in cellIDs:
			temporary_array.append(connection)

func update_output():
	_update_output(input)

func read_and_act(delta):
	input = 0.0
	for connection in connections:
		var other_cell = get_parent().get_node(connection)
		input += other_cell.output
	input = weighted_clamp(input)
	
	_act(input, delta)

#-- Cell Type Unique Functions --
func _interpret_special_sauce(special_sauce): # And add tags
	pass

func _update_output(input):
	pass
	

func _act(input, delta):
	pass
