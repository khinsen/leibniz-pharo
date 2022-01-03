Class {
	#name : #LzSortHierarchyRootGraph,
	#superclass : #LzSortGraph,
	#instVars : [
		'sortSort'
	],
	#category : #'Leibniz2-Leibniz2'
}

{ #category : #constructing }
LzSortHierarchyRootGraph >> parsedSort: anASTPatternNode [
	| termNode |
	self assert: anASTPatternNode variables isEmpty.
	self assert: anASTPatternNode term opName internalSymbol equals: LzConstants opNameSort.
	self assert: anASTPatternNode term args isEmpty.
	^ sortSort.
]

{ #category : #accessing }
LzSortHierarchyRootGraph >> sortSort: aSort [
	sortSort := aSort
]
