"
I represent a Leibniz variable.
"
Class {
	#name : #LeibnizVarTerm,
	#superclass : #LeibnizTerm,
	#instVars : [
		'varSymbol',
		'sort'
	],
	#category : #'Leibniz-3-Terms'
}

{ #category : #'instance creation' }
LeibnizVarTerm class >> symbol: aSymbol sort: aSort forSignature: aSignature [
	^self basicNew
			initializeWithSymbol: aSymbol sort: aSort forSignature: aSignature;
			yourself.

]

{ #category : #initialization }
LeibnizVarTerm >> initializeWithSymbol: aSymbol sort: aSort forSignature: aSignature [
	varSymbol := aSymbol.
	sort := aSort.
	signature := aSignature.

]

{ #category : #accessing }
LeibnizVarTerm >> sort [
	^sort
]
