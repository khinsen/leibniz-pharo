"
I build LeibnizSignatures from a sequence of operator and variable declarations.
"
Class {
	#name : #LeibnizSignatureBuilder,
	#superclass : #Object,
	#instVars : [
		'sortGraph',
		'operators',
		'variables'
	],
	#category : #'Leibniz-Core'
}

{ #category : #'instance creation' }
LeibnizSignatureBuilder class >> sortGraph: aSortGraph [
	^self basicNew
			initializeWithSortGraph: aSortGraph;
			yourself.


]

{ #category : #adding }
LeibnizSignatureBuilder >> addOp: anOpSymbol ofSort: aSortSymbol [
	self addOp: anOpSymbol withArgs: #() ofSort: aSortSymbol
]

{ #category : #adding }
LeibnizSignatureBuilder >> addOp: anOpSymbol withArgs: anArgList ofSort: aSortSymbol [
	| sort argKinds operator |
	anArgList ifEmpty:
		[ sort := variables at: anOpSymbol ifAbsent: nil.
		  self assert: sort isNil
				 description: 'conflicting earlier variable definition with sort ', sort asString. ].
	argKinds := anArgList collect: [ :s | sortGraph kindOf: s ].
	operator := (operators at: anOpSymbol ifAbsentPut: Dictionary new) at: argKinds
					ifAbsentPut: (LeibnizOperator symbol: anOpSymbol argKinds: argKinds).
	operator addArgs: anArgList ofSort: aSortSymbol.


]

{ #category : #adding }
LeibnizSignatureBuilder >> addVar: aVarSymbol ofSort: aSortSymbol [
	| op sort |
	op := operators at: aVarSymbol ifAbsent: nil.
	op ifNotNil:
		[ sort := (operators at: aVarSymbol) at: #() ifAbsent: nil.
		  self assert: sort isNil
				 description: 'conflicting earlier operator definition with sort', sort asString ].
	sort := variables at: aVarSymbol ifAbsentPut: aSortSymbol.
	self assert: sort = aSortSymbol
		  description: 'conflicting earlier variable definition with sort ', sort asString.

]

{ #category : #initializing }
LeibnizSignatureBuilder >> initializeWithSortGraph: aSortGraph [
	sortGraph := aSortGraph.
	operators := Dictionary new.
	variables := Dictionary new.

]

{ #category : #accessing }
LeibnizSignatureBuilder >> signature [
	^ LeibnizSignature sortGraph: sortGraph operators: operators variables: variables.


]

{ #category : #private }
LeibnizSignatureBuilder >> sortGraph: aSortGraph [
	sortGraph := aSortGraph

]
