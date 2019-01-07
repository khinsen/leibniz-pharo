"
I represent a constraint that defines which sorts are permissible for an argument of an operator.

"
Class {
	#name : #LeibnizArgSortConstraint,
	#superclass : #Object,
	#instVars : [
		'sortGraph'
	],
	#category : #'Leibniz-Core'
}

{ #category : #enumerating }
LeibnizArgSortConstraint >> conformingSorts [
	self subclassResponsibility

]

{ #category : #private }
LeibnizArgSortConstraint >> isAtLeastAsStrictAsKind: aKindConstraint [
	self subclassResponsibility
]

{ #category : #private }
LeibnizArgSortConstraint >> isAtLeastAsStrictAsSubsortsOf: aSubsortConstraint [
	self subclassResponsibility
]

{ #category : #testing }
LeibnizArgSortConstraint >> isConformingSort: aSort [
	self subclassResponsibility.

]

{ #category : #testing }
LeibnizArgSortConstraint >> isConformingSortConstraint: aSortConstraint [
	self subclassResponsibility.

]

{ #category : #converting }
LeibnizArgSortConstraint >> kindConstraint [
	self subclassResponsibility

]

{ #category : #printing }
LeibnizArgSortConstraint >> printAsLeibnizSyntaxOn: aStream [
	self subclassResponsibility
]

{ #category : #printing }
LeibnizArgSortConstraint >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	self printAsLeibnizSyntaxOn: aStream.
	aStream nextPut: $).

]
