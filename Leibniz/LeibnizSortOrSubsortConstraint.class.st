"
I represent a constraint matching a specific sort and all of its subsorts.
"
Class {
	#name : #LeibnizSortOrSubsortConstraint,
	#superclass : #LeibnizArgSortConstraint,
	#instVars : [
		'sort'
	],
	#category : #'Leibniz-2-Signatures'
}

{ #category : #'instance creation' }
LeibnizSortOrSubsortConstraint class >> sortGraph: aSortGraph sort: aSort [
	^self basicNew
			initializeWithSortGraph: aSortGraph sort: aSort;
			yourself

]

{ #category : #comparing }
LeibnizSortOrSubsortConstraint >> <= aSortConstraint [
	^aSortConstraint equalOrWiderThanSort: self

]

{ #category : #converting }
LeibnizSortOrSubsortConstraint >> asArgSort [
	^sort
]

{ #category : #enumerating }
LeibnizSortOrSubsortConstraint >> conformingSorts [
	^ sortGraph subsortsOf: sort

]

{ #category : #private }
LeibnizSortOrSubsortConstraint >> equalOrWiderThanKind: aKindConstraint [
	^aKindConstraint kind size = 1
		and: [ aKindConstraint kind includes: sort ]

]

{ #category : #private }
LeibnizSortOrSubsortConstraint >> equalOrWiderThanSort: aSubsortConstraint [
	^ sortGraph is: aSubsortConstraint sort subsortOf: sort

]

{ #category : #initialization }
LeibnizSortOrSubsortConstraint >> initializeWithSortGraph: aSortGraph sort: aSort [
	self assert: (aSortGraph includes: aSort)
		  description: 'sort ', aSort asString , ' is not defined in the sort graph'.
	sortGraph := aSortGraph.
	sort := aSort.

]

{ #category : #testing }
LeibnizSortOrSubsortConstraint >> isConformingSort: aSort [
	^ sortGraph is: aSort subsortOf: sort.

]

{ #category : #converting }
LeibnizSortOrSubsortConstraint >> kindConstraint [
	^ LeibnizKindConstraint sortGraph: sortGraph kind: (sortGraph kindOf: sort)

]

{ #category : #printing }
LeibnizSortOrSubsortConstraint >> printAsLeibnizSyntaxOn: aStream [
	aStream nextPutAll: sort asString

]

{ #category : #accessing }
LeibnizSortOrSubsortConstraint >> sort [
	^ sort

]
