Class {
	#name : #LzIntegerTerm,
	#superclass : #LzAtomicTerm,
	#category : #'Leibniz2-Leibniz2'
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
