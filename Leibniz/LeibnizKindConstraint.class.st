Class {
	#name : #LeibnizKindConstraint,
	#superclass : #LeibnizArgSortConstraint,
	#instVars : [
		'kind'
	],
	#category : #'Leibniz-Core'
}

{ #category : #'instance creation' }
LeibnizKindConstraint class >> sortGraph: aSortGraph kind: aKind [
	^self basicNew
			initializeWithSortGraph: aSortGraph kind: aKind;
			yourself

]

{ #category : #'instance creation' }
LeibnizKindConstraint class >> sortGraph: aSortGraph sort: aSort [
	^self basicNew
			initializeWithSortGraph: aSortGraph sort: aSort;
			yourself

]

{ #category : #comparing }
LeibnizKindConstraint >> <= aSortConstraint [
	^aSortConstraint equalOrWiderThanKind: self

]

{ #category : #converting }
LeibnizKindConstraint >> asArgSort [
	self assert: kind maximalSorts size == 1
		  description: 'Kind has more than one maximal sort'.
	^kind maximalSorts anyOne
]

{ #category : #enumerating }
LeibnizKindConstraint >> conformingSorts [
	^kind asSet

]

{ #category : #private }
LeibnizKindConstraint >> equalOrWiderThanKind: aKindConstraint [
	^aKindConstraint kind = kind

]

{ #category : #private }
LeibnizKindConstraint >> equalOrWiderThanSort: aSubsortConstraint [
	^kind includes: aSubsortConstraint sort

]

{ #category : #initialization }
LeibnizKindConstraint >> initializeWithSortGraph: aSortGraph kind: aKind [
	self assert: (aSortGraph kinds includes: aKind)
		  description: 'kind ', aKind asString , 'is not defined in the sort graph'.
	sortGraph := aSortGraph.
	kind := aKind.
]

{ #category : #testing }
LeibnizKindConstraint >> isConformingSort: aSort [
	^ kind includes: aSort

]

{ #category : #accessing }
LeibnizKindConstraint >> kind [
	^ kind

]

{ #category : #converting }
LeibnizKindConstraint >> kindConstraint [
	^ self

]

{ #category : #printing }
LeibnizKindConstraint >> printAsLeibnizSyntaxOn: aStream [
	kind printAsLeibnizSyntaxOn: aStream.

]
