Extension { #name : #Object }

{ #category : #'*Leibniz' }
Object >> leibnizAtomicTermValue [
	LeibnizRewriteFailure signal: 'not an atomic term: ', self asString
]
