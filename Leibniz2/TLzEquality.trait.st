Trait {
	#name : #TLzEquality,
	#category : #'Leibniz2-Infrastructure'
}

{ #category : #comparing }
TLzEquality >> = anObject [
	self == anObject ifTrue: [ ^true ].
	self class == anObject class ifFalse: [ ^false ].
	self referenceSlots do: [ :name |
		(self instVarNamed: name) == (anObject instVarNamed: name)
			ifFalse: [ ^ false ] ].
	self valueSlots do: [ :name |
		(self instVarNamed: name) = (anObject instVarNamed: name)
			ifFalse: [ ^ false ] ].
	^ true
]

{ #category : #comparing }
TLzEquality >> hash [
	| hash |
	hash := self class hash.
	self valueSlots do: [ :name |
		hash := hash bitXor: (self instVarNamed: name) hash ].
	^ hash
]

{ #category : #accessing }
TLzEquality >> referenceSlots [
	^ #()
]

{ #category : #accessing }
TLzEquality >> valueSlots [
	self notYetImplemented
]
