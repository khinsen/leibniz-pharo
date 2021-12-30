Class {
	#name : #LzSortGraph,
	#superclass : #Object,
	#instVars : [
		'sortContext'
	],
	#category : #'Leibniz2-Leibniz2'
}

{ #category : #'instance creation' }
LzSortGraph class >> fromSortContext: aSortContext [
	^ self new
		sortContext: aSortContext;
		beRecursivelyReadOnlyObject;
		yourself
]

{ #category : #accessing }
LzSortGraph >> sortContext: aSortContext [
	sortContext := aSortContext
]
