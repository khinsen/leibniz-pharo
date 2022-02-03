Class {
	#name : #LzBooleanTerm,
	#superclass : #LzOpTerm,
	#category : #'Leibniz2-Terms'
}

{ #category : #accessing }
LzBooleanTerm >> value: aBoolean [
	self opName: (LzPrefixOperatorName for: aBoolean printString asSymbol).
	self args: #()
]
