// Load a module into a local variable, allowing it to be reassigned at will.
// e.g. player = import("playerBehaviors")
globals.require = function(moduleName)
	import moduleName
	return locals[moduleName]
end function

globals.iif = function(value, ifTrue, ifFalse)
	if value then return ifTrue
	return ifFalse
end function
