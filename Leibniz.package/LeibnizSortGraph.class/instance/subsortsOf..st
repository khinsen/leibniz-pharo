accessing
subsortsOf: aSymbol
	| ss |
	ss := (subsorts at: aSymbol) deepCopy.
	^ ss inject: ss into: [ :total :sort | total union: (self subsortsOf: sort) ]