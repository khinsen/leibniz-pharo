"
I represent an integer in context 'integers'.
"
Class {
	#name : #LeibnizIntegerTerm,
	#superclass : #LeibnizRationalNumberTerm,
	#category : #'Leibniz-3-Terms'
}

{ #category : #acccessing }
LeibnizIntegerTerm >> sort [
	value = 0 ifTrue: [ ^#zero ].
	value positive ifTrue: [ ^#'ℕ.nz' ] ifFalse: [ ^#'ℤ.nz' ].

]
