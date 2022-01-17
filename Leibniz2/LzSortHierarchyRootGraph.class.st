Class {
	#name : #LzSortHierarchyRootGraph,
	#superclass : #LzSortGraph,
	#instVars : [
		'sortKind',
		'sortFamily'
	],
	#category : #'Leibniz2-Leibniz2'
}

{ #category : #comparing }
LzSortHierarchyRootGraph >> = otherSortGraph [
	^ self == otherSortGraph
]

{ #category : #accessing }
LzSortHierarchyRootGraph >> familyForSortTerm: aTerm [
	^ sortFamily
]

{ #category : #initializing }
LzSortHierarchyRootGraph >> initializeFromSortContext [
	"Minimal initialization for this special sort graph"
	connectingAxioms := Dictionary new.
	connectingPaths := Dictionary new.
]

{ #category : #accessing }
LzSortHierarchyRootGraph >> kindOf: aFamily [
	self assert: aFamily equals: sortFamily.
	^ sortKind
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
LzSortHierarchyRootGraph >> sortFamily: aSortFamily [
	sortFamily := aSortFamily
]

{ #category : #accessing }
LzSortHierarchyRootGraph >> sortKind: aKind [
	sortKind := aKind
]

{ #category : #accessing }
LzSortHierarchyRootGraph >> sortSort: aSort [
	sortSort := aSort
]
