Class {
	#name : #LzSortHierarchyRootGraph,
	#superclass : #LzSortGraph,
	#instVars : [
		'sortTerm'
	],
	#category : #'Leibniz2-Leibniz2'
}

{ #category : #constructing }
LzSortHierarchyRootGraph >> parsedSort: anASTPatternNode [
	| termNode |
	self assert: anASTPatternNode variables isEmpty.
	self assert: anASTPatternNode term opName internalSymbol equals: LzConstants opNameSort.
	self assert: anASTPatternNode term args isEmpty.
	^ sortTerm.
]

{ #category : #accessing }
LzSortHierarchyRootGraph >> sortTerm: aSortTerm [
	sortTerm := aSortTerm
]
