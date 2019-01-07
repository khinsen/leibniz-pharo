"
I represent a constraint matching a specific sort and all of its subsorts.
"
Class {
	#name : #LeibnizSortOrSubsortConstraint,
	#superclass : #LeibnizArgSortConstraint,
	#instVars : [
		'sort'
	],
	#category : #'Leibniz-Core'
}

{ #category : #'instance creation' }
LeibnizSortOrSubsortConstraint class >> sortGraph: aSortGraph sort: aSort [
	^self basicNew
			initializeWithSortGraph: aSortGraph sort: aSort;
			yourself

]

{ #category : #initialization }
LeibnizSortOrSubsortConstraint >> initializeWithSortGraph: aSortGraph sort: aSort [
	self assert: (aSortGraph includes: aSort)
		  description: 'sort ', aSort asString , 'is not defined in the sort graph'.
	sortGraph := aSortGraph.
	sort := aSort.

]

{ #category : #private }
LeibnizSortOrSubsortConstraint >> isAtLeastAsStrictAsKind: aKindConstraint [
	^ aKindConstraint kind includes: sort

]

{ #category : #private }
LeibnizSortOrSubsortConstraint >> isAtLeastAsStrictAsSubsortsOf: aSubsortConstraint [
	^ sortGraph is: sort subsortOf: aSubsortConstraint sort

]

{ #category : #testing }
LeibnizSortOrSubsortConstraint >> isConformingSort: aSort [
	^ sortGraph is: aSort subsortOf: sort.

]

{ #category : #testing }
LeibnizSortOrSubsortConstraint >> isConformingSortConstraint: aSortConstraint [
	^ aSortConstraint isAtLeastAsStrictAsSubsortsOf: self

]

{ #category : #accessing }
LeibnizSortOrSubsortConstraint >> sort [
	^ sort

]
