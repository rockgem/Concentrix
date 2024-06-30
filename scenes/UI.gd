extends CanvasLayer

var world_ref


func _ready():
	await get_tree().process_frame
	
	world_ref = get_tree().get_nodes_in_group('World')[0]
	
	$Control/CircleAmountChanger/CirclesAmount.value = world_ref.circles_count


func _on_circles_amount_value_changed(value):
	world_ref.circles_count = value


func _on_add_pressed():
	world_ref.add_station_to_circle($Control/StationAdder/StationSelection.value - 1, $Control/StationAdder/Amount.value)
