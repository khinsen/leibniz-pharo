Extension { #name : 'Object' }

{ #category : '*Leibniz' }
Object >> leibnizAtomicTermValue [
	LbRewriteFailure signal: 'not an atomic term: ', self asString
]
