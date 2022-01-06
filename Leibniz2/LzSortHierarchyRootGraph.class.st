Class {
	#name : #LzSortHierarchyRootGraph,
	#superclass : #LzSortGraph,
	#instVars : [
		'rootSortSort'
	],
	#category : #'Leibniz2-Leibniz2'
}

{ #category : #constructing }
LzSortHierarchyRootGraph >> parsedSort: anASTPatternNode [
	| termNode |
	self assert: anASTPatternNode variables isEmpty.
	self assert: anASTPatternNode term opName internalSymbol equals: LzConstants opNameSort.
	self assert: anASTPatternNode term args isEmpty.
	^ rootSortSort.
]

{ #category : #accessing }
LzSortHierarchyRootGraph >> rootSortSort: aSort [
	rootSortSort := aSort
]
