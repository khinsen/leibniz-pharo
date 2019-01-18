"
I represent a constraint that defines which sorts are permissible for an argument of an operator.

"
Class {
	#name : #LeibnizArgSortConstraint,
	#superclass : #Object,
	#traits : 'EqualityThroughVariables',
	#classTraits : 'EqualityThroughVariables classTrait',
	#instVars : [
		'sortGraph'
	],
	#category : #'Leibniz-2-Signature'
}

{ #category : #comparing }
LeibnizArgSortConstraint >> <= aSortConstraint [
	self subclassResponsibility.

]

{ #category : #converting }
LeibnizArgSortConstraint >> asArgSort [
	self subclassResponsibility
]

{ #category : #enumerating }
LeibnizArgSortConstraint >> conformingSorts [
	self subclassResponsibility

]

{ #category : #comparing }
LeibnizArgSortConstraint >> equalOrWiderThanKind: aKindConstraint [
	self subclassResponsibility.

]

{ #category : #comparing }
LeibnizArgSortConstraint >> equalOrWiderThanSort: aSubsortConstraint [
	self subclassResponsibility.

]

{ #category : #testing }
LeibnizArgSortConstraint >> isConformingSort: aSort [
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
