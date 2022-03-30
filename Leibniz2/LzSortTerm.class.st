Class {
	#name : #LzSortTerm,
	#superclass : #LzOpTerm,
	#instVars : [
		'sortGraph'
	],
	#category : #'Leibniz2-Sorts'
}

{ #category : #accessing }
LzSortTerm >> sortGraph [
	^ sortGraph
]

{ #category : #accessing }
LzSortTerm >> sortGraph: aSortGraph [
	sortGraph := aSortGraph
]
