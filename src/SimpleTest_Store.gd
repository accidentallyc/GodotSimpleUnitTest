class_name SimpleTest_Store

static var canvas: SimpleTest_Canvas

static func safe_register_callback(fn:Callable):
	if canvas.is_node_ready():
		fn.call()
	else:
		canvas.ready.connect(fn)
