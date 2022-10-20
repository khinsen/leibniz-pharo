Class {
	#name : #LzIntegerTerm,
	#superclass : #LzRationalNumberTerm,
	#category : #'Leibniz2-Terms'
}

{ #category : #rewriting }
LzIntegerTerm >> div: otherInteger [
	| x y |
	x := self value.
	y := otherInteger value.
	(y = 0)
		ifTrue: [ LzRewriteFailure signal: 'division by zero' ].
	^ LzIntegerTerm
		signature: self signature
		value: ((x abs // y abs) * x sign * y sign)
]

{ #category : #rewriting }
LzIntegerTerm >> rem: otherInteger [
	| x y |
	x := self value.
	y := otherInteger value.
	(y = 0)
		ifTrue: [ LzRewriteFailure signal: 'division by zero' ].
	^ LzIntegerTerm
		signature: self signature
		value: ((x abs % y abs) * x sign * y sign)
]

{ #category : #accessing }
LzIntegerTerm >> sort [
	| symbol |
	symbol := value isZero
		ifTrue: [ #zero ]
		ifFalse: [ value positive
					ifTrue: [ value = 1
								ifTrue: [ #one ]
								ifFalse: [ #'ℕ.nz' ] ]
					ifFalse: [ #'ℤ.nz' ] ].
	^ self signature sort: symbol
]
