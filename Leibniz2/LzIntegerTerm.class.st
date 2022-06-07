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
LzIntegerTerm >> pred [
	(self value > 0)
		ifTrue: [ ^ LzIntegerTerm signature: self signature value: self value - 1 ]
		ifFalse: [ LzRewriteFailure signal: self value asString, ' < 1' ]
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
					ifTrue: [ #'ℕ.nz' ]
					ifFalse: [ #'ℤ.nz' ] ].
	^ self signature sort: symbol
]

{ #category : #rewriting }
LzIntegerTerm >> succ [
	(self value >= 0)
		ifTrue: [ ^ LzIntegerTerm signature: self signature value: self value + 1 ]
		ifFalse: [ LzRewriteFailure signal: self value asString, ' < 0' ]
]
