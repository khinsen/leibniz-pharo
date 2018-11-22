enumerating
withSubsortRelationsDo: aBlockClosure 
	supersorts associationsDo:
		[ :assoc | assoc value do:
					[ :sort | aBlockClosure value: (assoc key) value: sort ]]
