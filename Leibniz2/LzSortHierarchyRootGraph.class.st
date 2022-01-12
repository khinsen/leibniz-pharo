Class {
	#name : #LzSortHierarchyRootGraph,
	#superclass : #LzSortGraph,
	#category : #'Leibniz2-Leibniz2'
}

{ #category : #initializing }
LzSortHierarchyRootGraph >> initializeFromSortContext [
	"Minimal initialization for this special sort graph"
	connectingAxioms := Dictionary new.
	connectingPaths := Dictionary new.
]

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
