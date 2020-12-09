Class {
	#name : #LbCollectionSort,
	#superclass : #LbSort,
	#instVars : [
		'baseSort'
	],
	#category : #'Leibniz-1-SortGraphs'
}

{ #category : #initialization }
LbCollectionSort >> initializeWithName: aSymbol sortGraph: aSortGraph origins: aSet [
	super initializeWithName: aSymbol sortGraph: aSortGraph origins: aSet.
	baseSort := sortGraph sortNamed: (aSymbol allButFirst: 2)
]
