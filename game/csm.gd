# By firebelley's github gist (slightly modified)
class_name CallableStateMachine

signal state_changed(state: Callable)

var state_dictionary : Dictionary[Callable, Dictionary] = {}
var current_state: Callable:
	set(val): printerr("Use change_state instead")

func add_states(
	normal_state: Callable,
	enter_state: Callable = Callable(),
	leave_state: Callable = Callable()
):
	state_dictionary[normal_state] = {
		&"normal": normal_state,
		&"enter": enter_state,
		&"leave": leave_state
	}
	

func set_initial_state(state: Callable):
	if state_dictionary.has(state):
		_set_state(state)
	else:
		push_warning("No state with name ", state)

func update():
	if current_state != null and state_dictionary.has(current_state):
		var normal : Callable = state_dictionary[current_state].normal
		if normal.is_valid():
			normal.call()
		else:
			push_warning("Nonexistent normal callable for state: ", current_state)

func change_state(state: Callable):
	state_changed.emit(state)
	if state_dictionary.has(state):
		_set_state.call_deferred(state)
	else:
		push_warning("No state with name ", state)

func _set_state(state: Callable):
	if current_state and state_dictionary.has(current_state):
		var leave : Callable = state_dictionary[current_state].leave
		await leave.call()
	
	current_state = state
	
	var enter = state_dictionary[current_state].enter
	await enter.call()
