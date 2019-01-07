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
