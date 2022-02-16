Class {
	#name : #LzFloatingPointNumberTerm,
	#superclass : #LzAtomicTerm,
	#category : #'Leibniz2-Terms'
}

{ #category : #accessing }
LzFloatingPointNumberTerm >> sort [
	| symbol |
	symbol := value isNaN
		ifTrue: [ #'FP64.NaN' ]
		ifFalse: [ value isInfinite
					ifTrue: [ #'FP64.inf' ]
					ifFalse: [ #'FP64.number' ] ].
	^ self signature sort: symbol
]
