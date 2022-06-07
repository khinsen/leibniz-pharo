Class {
	#name : #LzRationalNumberTerm,
	#superclass : #LzAtomicTerm,
	#category : #'Leibniz2-Terms'
}

{ #category : #'instance creation' }
LzRationalNumberTerm class >> signature: aSignature value: anObject [
	| class |
	class := anObject isInteger
		ifTrue: [ LzIntegerTerm ]
		ifFalse: [ LzRationalNumberTerm ].
	^ class new
		signature: aSignature;
		value: anObject;
		beRecursivelyReadOnlyObject;
		yourself
]

{ #category : #rewriting }
LzRationalNumberTerm >> * otherNumberTerm [
	^ self class
		signature: self signature
		value: self value * otherNumberTerm value
]

{ #category : #rewriting }
LzRationalNumberTerm >> + otherNumberTerm [
	^ self class
		signature: self signature
		value: self value + otherNumberTerm value
]

{ #category : #rewriting }
LzRationalNumberTerm >> - otherNumberTerm [
	^ self class
		signature: self signature
		value: self value - otherNumberTerm value
]

{ #category : #rewriting }
LzRationalNumberTerm >> / otherNumberTerm [
	^ self class
		signature: self signature
		value: self value / otherNumberTerm value
]

{ #category : #rewriting }
LzRationalNumberTerm >> < otherNumberTerm [
	^ LzBooleanTerm
		signature: self signature
		value: (self value < otherNumberTerm value)
]

{ #category : #rewriting }
LzRationalNumberTerm >> <= otherNumberTerm [
	^ LzBooleanTerm
		signature: self signature
		value: (self value <= otherNumberTerm value)
]

{ #category : #rewriting }
LzRationalNumberTerm >> > otherNumberTerm [
	^ LzBooleanTerm
		signature: self signature
		value: (self value > otherNumberTerm value)
]

{ #category : #rewriting }
LzRationalNumberTerm >> >= otherNumberTerm [
	^ LzBooleanTerm
		signature: self signature
		value: (self value >= otherNumberTerm value)
]

{ #category : #rewriting }
LzRationalNumberTerm >> ensureNumber [
]

{ #category : #rewriting }
LzRationalNumberTerm >> negated [
	^ self class
		signature: self signature
		value: self value negated
]

{ #category : #rewriting }
LzRationalNumberTerm >> raisedTo: otherNumberTerm [
	^ self class
		signature: self signature
		value: (self value raisedTo: otherNumberTerm value)
]

{ #category : #accessing }
LzRationalNumberTerm >> sort [
	| symbol |
	symbol := value isZero
		ifTrue: [ #zero ]
		ifFalse: [ value isInteger
					ifTrue: [  value positive
								ifTrue: [ #'ℕ.nz' ]
								ifFalse: [ #'ℤ.nz' ]]
					ifFalse: [ value positive
								ifTrue: [ #'ℚ.p' ]
								ifFalse: [ #'ℚ.nz' ] ] ].
	^ self signature sort: symbol
]
