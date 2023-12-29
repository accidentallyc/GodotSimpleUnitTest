extends SimpleTest


func it_is_a_skipped_test(_skip):
	pass

func it_can_skip():
	var r = ["foo"]
	r.has(1)
	
	print("yeet",GD__._property(["0"],r))
	#var r = [
		#{"red":1,"blue":2},	
		#{"red":2,"blue":9},	
		#{"red":2,"blue":5},	
	#]
	#
	#var asdf = GD__.matches({"red":2})
	#for x in r:
		#print("v",asdf.call(x))
	pass
