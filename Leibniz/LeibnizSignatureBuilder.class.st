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
	#category : #'Leibniz-2-Signature'
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
	| sort arity kindArity operator |
	anArgList ifEmpty:
		[ sort := variables at: anOpSymbol ifAbsent: nil.
		  self assert: sort isNil
				 description: 'conflicting earlier variable definition with sort ', sort asString. ].
	arity := self arityFor: anArgList.
	kindArity := arity liftToKindLevel.
	operator := (operators at: anOpSymbol
								  ifAbsentPut: [ Dictionary new ])
						at: kindArity
						ifAbsentPut: [ LeibnizOperator symbol: anOpSymbol
																argKindConstraints: kindArity
																kind: (sortGraph kindOf: aSortSymbol) ].
	operator addArity: arity withSort: aSortSymbol.


]

{ #category : #adding }
LeibnizSignatureBuilder >> addOpsFromSignature: aSignature [
	aSignature withOperatorsDo:
		[ :symbol :args :sort |
		  self addOp: symbol withArgs: args ofSort: sort ].

]

{ #category : #adding }
LeibnizSignatureBuilder >> addVar: aVarSymbol ofSort: aSortSymbol [
	| op sort |
	op := operators at: aVarSymbol ifAbsent: nil.
	op ifNotNil:
		[ sort := op at: (self arityFor: #()) ifAbsent: nil.
		  self assert: sort isNil
				 description: 'conflicting earlier operator definition with sort', sort asString ].
	sort := variables at: aVarSymbol ifAbsentPut: aSortSymbol.
	self assert: sort = aSortSymbol
		  description: 'conflicting earlier variable definition with sort ', sort asString.

]

{ #category : #adding }
LeibnizSignatureBuilder >> addVarsFromSignature: aSignature [
	aSignature withVariablesDo:
		[ :symbol :sort |
		  self addVar: symbol ofSort:  sort ].

]

{ #category : #private }
LeibnizSignatureBuilder >> arityFor: anArgList [
	| arity |
	arity := LeibnizArity sortGraph: sortGraph size: anArgList size.
	anArgList collect: [ :s | LeibnizSortOrSubsortConstraint sortGraph: sortGraph sort: s ]
				 into: arity.
	arity beRecursivelyReadOnlyObject.
	^arity

]

{ #category : #initializing }
LeibnizSignatureBuilder >> initializeWithSortGraph: aSortGraph [
	sortGraph := aSortGraph.
	operators := Dictionary new.
	variables := Dictionary new.

]

{ #category : #accessing }
LeibnizSignatureBuilder >> signature [
	^ LeibnizSignature sortGraph: sortGraph operators: operators deepCopy variables: variables deepCopy.


]

{ #category : #private }
LeibnizSignatureBuilder >> sortGraph: aSortGraph [
	sortGraph := aSortGraph

]
