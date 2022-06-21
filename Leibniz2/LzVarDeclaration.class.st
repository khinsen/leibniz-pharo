"
Represents a variable declaration in a term, rule, or axiom declaration.

Variable declarations can be put in front of the term, rule, or axiom that refer to them, or inside those declarations. In order to allow reconstruction of the input syntax, var declarations store additional information that has no impact on the context that they will later be part of. A declaration extracted from a term has `isDerived` set to `true`, which ensures that the declaration is not printed at all in front of the main item. It's the {{gtClass:name=LzVarTermDeclaration}} in the terms, which have a non-`nil` `sort` slot, that will be printed as declarations instead.
 
"
Class {
	#name : #LzVarDeclaration,
	#superclass : #LzDeclaration,
	#instVars : [
		'sort',
		'name',
		'isDerived'
	],
	#category : #'Leibniz2-Declarations'
}

{ #category : #converting }
LzVarDeclaration >> addAsRopedTextTo: aRopedText [
	self
		do: [ :t |
			name addAsRopedTextTo: t.
			t append:
				(':' asRopedText attribute: LzColonAttribute new).
			self
				do: [ :tt | sort addAsRopedTextTo: tt ]
				to: t
				withAttribute: LzSortAttribute new ]
		to: aRopedText
		withAttribute: LzVarDeclarationAttribute new
]

{ #category : #accessing }
LzVarDeclaration >> beDerived [
	isDerived := true
]

{ #category : #initialization }
LzVarDeclaration >> initialize [
	super initialize.
	isDerived := false
]

{ #category : #accessing }
LzVarDeclaration >> isDerived [
	^ isDerived
]

{ #category : #testing }
LzVarDeclaration >> isSortVar [
	^ name asSymbol endsWith: '__' 
]

{ #category : #accessing }
LzVarDeclaration >> name [
	^ name
]

{ #category : #accessing }
LzVarDeclaration >> name: anObject [
	name := anObject
]

{ #category : #printing }
LzVarDeclaration >> printAsLeibnizSyntaxOn: aStream [
	name printAsLeibnizSyntaxOn: aStream.
	aStream nextPut: $:.
	sort printAsLeibnizSyntaxOn: aStream.
]

{ #category : #accessing }
LzVarDeclaration >> sort [

	^ sort
]

{ #category : #accessing }
LzVarDeclaration >> sort: anObject [

	sort := anObject
]

{ #category : #accessing }
LzVarDeclaration >> valueSlots [
	^ #(name sort)
]
