Extension { #name : #Object }

{ #category : #'*Leibniz2' }
Object >> isEqualTo: anObject cache: anIdentitySet [
	^ self = anObject
]

{ #category : #'*Leibniz2' }
Object >> isLzASTNode [
	^ false
]

{ #category : #'*Leibniz2' }
Object >> lzAtomicTermValue [
	LzRewriteFailure signal: 'not an atomic term: ', self asString
]
