Class {
	#name : #LzIntegerTerm,
	#superclass : #LzRationalNumberTerm,
	#category : #'Leibniz2-Terms'
}

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
