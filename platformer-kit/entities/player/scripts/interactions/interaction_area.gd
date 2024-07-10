extends Area2D
class_name InteractionArea


# Expect to only interact with 1 area at a time
func get_interaction_event() -> InteractionEvent:
	if not has_overlapping_areas():
		return InteractionEvent.new(null, InteractionTypes.NoOp)
	# Get the first overlapping area
	var area = get_overlapping_areas()[0]
	var parent = area.get_parent()
	if parent is Gem:
		return InteractionEvent.new(parent, InteractionTypes.Gem)
	return InteractionEvent.new(null, InteractionTypes.NoOp)