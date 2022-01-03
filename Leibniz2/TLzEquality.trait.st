Trait {
	#name : #TLzEquality,
	#category : #'Leibniz2-Leibniz2'
}

{ #category : #comparing }
TLzEquality >> = anObject [
	self == anObject ifTrue: [ ^true ].
	self class == anObject class ifFalse: [ ^false ].
	self fieldNames do: [ :name |
		(self instVarNamed: name) = (anObject instVarNamed: name)
			ifFalse: [^false] ].
	^ true
]

{ #category : #accessing }
TLzEquality >> fieldNames [
	self notYetImplemented
]

{ #category : #comparing }
TLzEquality >> hash [
	| hash |
	hash := self class hash.
	self fieldNames do: [ :name |
		hash := hash bitXor: (self instVarNamed: name) hash ].
	^ hash
]
