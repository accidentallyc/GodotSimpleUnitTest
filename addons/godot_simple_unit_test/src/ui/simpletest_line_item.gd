extends VBoxContainer

@export_group("Internal Wires")
@export var statusNode:Label
@export var descpNode:Label
@export var childContainerNode:Control
@export var rerunButton:Button
@export var collapse_toggle:Button

var _runner:Variant # Do not set to runner type, causes cyclical deps

var status = &"":
	get:
		return status
	set(v):
		status = v
		sync_gui()
			
var description = &"":
	get:
		return description
	set(v):
		description = v
		sync_gui()

var _is_ready = false
var parent_ln_item
var case
const collapse_txt = &" ➖ "	
const uncollapse_txt = &" ➕ "	

var ready_promise:SimpleTest_Promise = SimpleTest_Promise.new()

signal on_rerun_request()

func _enter_tree() -> void:
	rerunButton.pressed.connect(func (): on_rerun_request.emit())

func _ready():
	collapse_toggle.text = uncollapse_txt
	_is_ready = true
	ready_promise.resolve()
	sync_gui()
	
	
func set_runner(runner):
	_runner = runner
	_runner.on_toggle_show_passed_tests.connect(sync_gui)
	

func sync_gui():
	if !_is_ready: return
	
	# Update Status
	statusNode.text = status.capitalize()
	var HAS_PASSED = status.contains(&"PASS")
	match status:
		&"FAIL":
			statusNode.modulate = Color.RED
			statusNode.show()
			HAS_PASSED = false
		&"PASS":
			statusNode.modulate = Color.GREEN
			statusNode.show()
			HAS_PASSED = true
		&"PASS (SOLO)":
			statusNode.modulate = Color.DARK_TURQUOISE
			statusNode.show()
			HAS_PASSED = true
		&"SKIPPED":
			statusNode.modulate = Color.MAGENTA
			statusNode.show()
			HAS_PASSED = true
		_:
			HAS_PASSED = false
			statusNode.hide()
		
	# Visibility logic
	if HAS_PASSED and _runner._should_show_passed_tests or HAS_PASSED == false:
		self.show()
	else:
		self.hide()
		
	# Description Logic
	var tmp = description
	if statusNode.visible:
		tmp = "  -  " + description
	descpNode.text = tmp
	name = "Description" + tmp

func add_block(block:Control):
	childContainerNode.add_child.call_deferred(block)
	# originally hidden, but adding 1 child means you can collapse it
	collapse_toggle.show() 
	
func clear_blocks():
	if childContainerNode:
		for c in childContainerNode.get_children():
			c.queue_free()
			
	# no children means cant collapse
	collapse_toggle.hide()
	
	
func set_collapse(is_collapse:bool):
	if is_collapse:
		childContainerNode.hide()
		collapse_toggle.text = uncollapse_txt
		return
	childContainerNode.show()
	collapse_toggle.text = collapse_txt
		

func _on_collapse_toggle_button_up(force_collapse = null):
	set_collapse(childContainerNode.visible)
