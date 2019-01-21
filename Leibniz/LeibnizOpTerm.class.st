"
I represent a standard Leibniz term defined by a operator and its arguments.
"
Class {
	#name : #LeibnizOpTerm,
	#superclass : #LeibnizTerm,
	#instVars : [
		'opSymbol',
		'argList',
		'sort'
	],
	#category : #'Leibniz-3-Terms'
}

{ #category : #'instance creation' }
LeibnizOpTerm class >> symbol: aSymbol args: anArgList sort: aSort forSignature: aSignature [
	^self basicNew
			initializeWithSymbol: aSymbol args: anArgList sort: aSort forSignature: aSignature;
			yourself.

]

{ #category : #initialization }
LeibnizOpTerm >> initializeWithSymbol: aSymbol args: anArgList sort: aSort forSignature: aSignature [
	opSymbol := aSymbol.
	argList := anArgList.
	sort := aSort.
	signature := aSignature.
]

{ #category : #accessing }
LeibnizOpTerm >> sort [
	^sort
]
