testing
testCyclesForbidden
	self should: [ sortGraph1 make: #D subsortOf: #A ] raise: Error.