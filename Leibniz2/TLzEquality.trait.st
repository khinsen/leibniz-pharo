Trait {
	#name : #TLzEquality,
	#category : #'Leibniz2-Infrastructure'
}

{ #category : #comparing }
TLzEquality >> = anObject [
	| debug |
	debug := false.
	self == anObject ifTrue: [ ^true ].
	self class == anObject class ifFalse: [ ^false ].
	self referenceSlots do: [ :name |
		(self instVarNamed: name) == (anObject instVarNamed: name)
			ifFalse: [ ^ false ] ].
	debug
		ifTrue: [
			| cache |
			self valueSlots ifEmpty: [ ^ true ].
			cache := IdentitySet with: self with: anObject.
			self valueSlots do: [ :name |
				((self instVarNamed: name) isEqualTo: (anObject instVarNamed: name) cache: cache)
					ifFalse: [ ^ false ] ]  ]
		ifFalse: [
			self valueSlots do: [ :name |
				(self instVarNamed: name) = (anObject instVarNamed: name)
					ifFalse: [ ^ false ] ] ].
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

{ #category : #comparing }
TLzEquality >> isEqualTo: anObject cache: anIdentitySet [
	| extendedSet |
	self == anObject ifTrue: [ ^true ].
	self class == anObject class ifFalse: [ ^false ].
	(anIdentitySet includes: self)
		ifTrue: [ self error: 'Already seen' ].
	(anIdentitySet includes: anObject)
		ifTrue: [ self error: 'Already seen' ].
	self referenceSlots do: [ :name |
		(self instVarNamed: name) == (anObject instVarNamed: name)
			ifFalse: [ ^ false ] ].
	self valueSlots ifEmpty: [ ^ true ].
	extendedSet := anIdentitySet copy.
	extendedSet add: self.
	extendedSet add: anObject.
	self valueSlots do: [ :name |
		((self instVarNamed: name) isEqualTo: (anObject instVarNamed: name) cache: extendedSet)
			ifFalse: [ ^ false ] ].
	^ true
]

{ #category : #accessing }
TLzEquality >> referenceSlots [
	^ #()
]

{ #category : #accessing }
TLzEquality >> valueSlots [
	self notYetImplemented
]
