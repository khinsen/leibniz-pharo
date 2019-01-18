"
I represent a rational number in context 'rational-numbers'.
"
Class {
	#name : #LeibnizRationalNumberTerm,
	#superclass : #LeibnizAtomicTerm,
	#instVars : [
		'value'
	],
	#category : #'Leibniz-3-Terms'
}

{ #category : #accessing }
LeibnizRationalNumberTerm >> sort [
	value = 0 ifTrue: [ ^#zero ].
	value isInteger
		ifTrue: [ value positive ifTrue: [ ^#'ℕ.nz' ] ifFalse: [ ^#'ℤ.nz' ] ].
	value positive ifTrue: [ ^#'ℚ.p' ] ifFalse: [ ^#'ℚ.nz' ].

]
