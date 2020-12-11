Class {
	#name : #LbCollectionSort,
	#superclass : #LbSort,
	#instVars : [
		'baseSort'
	],
	#category : #'Leibniz-1-SortGraphs'
}

{ #category : #accessing }
LbCollectionSort class >> splitName: aSymbol [
	| prefix |
	prefix := self sortNamePrefix.
	^ { prefix. aSymbol allButFirst: prefix size }
]

{ #category : #initialization }
LbCollectionSort >> initializeWithName: aSymbol sortGraph: aSortGraph origins: aSet [
	super initializeWithName: aSymbol sortGraph: aSortGraph origins: aSet.
	baseSort := sortGraph sortNamed: (self class splitName: aSymbol) second
]
