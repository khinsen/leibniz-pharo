"
I represent a rational number in context 'rational-numbers'.
"
Class {
	#name : #LbRationalNumberTerm,
	#superclass : #LbAtomicTerm,
	#category : #'Leibniz-3-Terms'
}

{ #category : #'instance creation' }
LbRationalNumberTerm class >> value: aNumber forSignature: aSignature [
	aNumber isInteger
		ifTrue: [ ^ LbIntegerTerm value: aNumber forSignature: aSignature ]
		ifFalse: [ ^self basicNew
						initializeWithValue: aNumber forSignature: aSignature;
						yourself ]
]

{ #category : #printing }
LbRationalNumberTerm >> printAsLeibnizSyntaxOn: aStream [
	"Remove the parentheses that Pharo adds around fractions."
	value isInteger
		ifTrue: [ value printOn: aStream ]
		ifFalse: [ aStream nextPutAll: value asString allButFirst allButLast ]

]

{ #category : #accessing }
LbRationalNumberTerm >> sort [
	value = 0 ifTrue: [ ^#zero ].
	value isInteger
		ifTrue: [ value positive ifTrue: [ ^#'ℕ.nz' ] ifFalse: [ ^#'ℤ.nz' ] ].
	value positive ifTrue: [ ^#'ℚ.p' ] ifFalse: [ ^#'ℚ.nz' ].

]
