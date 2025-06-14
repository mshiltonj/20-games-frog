class_name Util
extends Node

static func _camel_to_snake_reducer(accum: String, part: String) -> String:
		accum += part
		return accum


static func camel_to_snake(camel_string : String) -> String:
	var snake_string_ary : Array[String] = []
	var upper_case_regex : RegEx = RegEx.new()
	upper_case_regex.compile('[A-Z]')
	
	for letter : String in camel_string:
		if upper_case_regex.search(letter):
			snake_string_ary.push_back("_")	
		snake_string_ary.push_back(letter.to_lower())
		if snake_string_ary[0] == "_":
			snake_string_ary.pop_front()

	return snake_string_ary.reduce(_camel_to_snake_reducer, "")
	
