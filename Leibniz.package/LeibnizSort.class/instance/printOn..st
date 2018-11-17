printing
printOn: aStream
   aStream nextPutAll: self className.
   aStream nextPut: Character space.
	aStream nextPutAll: symbol asString
	