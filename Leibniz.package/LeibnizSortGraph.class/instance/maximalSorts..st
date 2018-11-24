accessing
maximalSorts: aCollection 
	^ aCollection select: [ :sort | (supersorts at: sort) size = 0 ]