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

{ #category : #initialization }
LeibnizKindConstraint >> initializeWithSortGraph: aSortGraph kind: aKind [
	self assert: (aSortGraph kinds includes: aKind)
		  description: 'kind ', aKind asString , 'is not defined in the sort graph'.
	sortGraph := aSortGraph.
	kind := aKind.
]

{ #category : #private }
LeibnizKindConstraint >> isAtLeastAsStrictAsKind: aKindConstraint [
	^ self kind = aKindConstraint kind

]

{ #category : #private }
LeibnizKindConstraint >> isAtLeastAsStrictAsSubsortsOf: aSubsortConstraint [
	^ (self size = 1) and: [ kind includes: aSubsortConstraint sort ]
]

{ #category : #testing }
LeibnizKindConstraint >> isConformingSort: aSort [
	^ kind includes: aSort

]

{ #category : #testing }
LeibnizKindConstraint >> isConformingSortConstraint: aSortConstraint [
	^ aSortConstraint isAtLeastAsStrictAsKind: self

]

{ #category : #accessing }
LeibnizKindConstraint >> kind [
	^ kind

]
