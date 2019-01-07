"
I represent an operator with given symbol and kind-arity in a LeibnizSignature.
"
Class {
	#name : #LeibnizOperator,
	#superclass : #Object,
	#instVars : [
		'opSymbol',
		'ranks',
		'argKindConstraints',
		'kind'
	],
	#category : #'Leibniz-Core'
}

{ #category : #'instance creation' }
LeibnizOperator class >> symbol: aSymbol argKindConstraints: aKindConstraintArray kind: aKind [
	^ self basicNew
			 initializeWithSymbol: aSymbol argKindConstraints: aKindConstraintArray kind: aKind;
			 yourself.

]

{ #category : #adding }
LeibnizOperator >> addArity: anArgSortConstraintList withSort: aSortSymbol [
	| sort |
	self assert: (kind includes: aSortSymbol)
		  description: 'new rank', anArgSortConstraintList printString,
							'->', aSortSymbol asString,'makes operator non-monotonic'.
	sort := ranks at: anArgSortConstraintList ifAbsentPut: [ aSortSymbol ].
	self assert: sort = aSortSymbol
		  description: 'conflicting earlier operator definition with sort ', sort asString.

]

{ #category : #initializing }
LeibnizOperator >> initializeWithSymbol: aSymbol argKindConstraints: aKindConstraintArray kind: aKind [
	opSymbol := aSymbol.
	argKindConstraints := aKindConstraintArray.
	kind := aKind.
	ranks := Dictionary new.

]
