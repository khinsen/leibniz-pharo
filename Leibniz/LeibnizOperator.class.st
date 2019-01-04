"
I represent an operator with given symbol and kind-arity in a LeibnizSignature.
"
Class {
	#name : #LeibnizOperator,
	#superclass : #Object,
	#instVars : [
		'opSymbol',
		'argKinds',
		'ranks'
	],
	#category : #'Leibniz-Core'
}

{ #category : #'instance creation' }
LeibnizOperator class >> symbol: aSymbol argKinds: aKindArray [
	^ self basicNew
			 initializeWithSymbol: aSymbol argKinds: aKindArray;
			 yourself.

]

{ #category : #adding }
LeibnizOperator >> addArgs: anArgList ofSort: aSortSymbol [
	| sort |
	sort := ranks at: anArgList ifAbsentPut: aSortSymbol.
	self assert: sort = aSortSymbol
		  description: 'conflicting earlier operator definition with sort ', sort asString.

]

{ #category : #initializing }
LeibnizOperator >> initializeWithSymbol: aSymbol argKinds: aKindArray [
	opSymbol := aSymbol.
	argKinds := aKindArray.
	ranks := Dictionary new.

]
