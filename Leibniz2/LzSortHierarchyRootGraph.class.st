Class {
	#name : #LzSortHierarchyRootGraph,
	#superclass : #LzSortGraph,
	#instVars : [
		'sortKind',
		'sortFamily'
	],
	#category : #'Leibniz2-Sorts'
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

{ #category : #initializing }
LzSortHierarchyRootGraph >> initializeSortFamilies [
	sortFamilies := Dictionary with: sortFamily op -> sortFamily.
	anySortFamily := LzUniversalSortFamily new
						sortGraph: self.
]

{ #category : #accessing }
LzSortHierarchyRootGraph >> kindOf: aFamily [
	self assert: aFamily equals: sortFamily.
	^ sortKind
]

{ #category : #constructing }
LzSortHierarchyRootGraph >> parsedSort: anASTPatternNode [
	^ self
		parsedSort: anASTPatternNode term
		variables: Dictionary new
]

{ #category : #constructing }
LzSortHierarchyRootGraph >> parsedSort: anASTTermNode variables: aDictionary [
	self assert: aDictionary isEmpty.
	self assert: anASTTermNode opName internalSymbol equals: LzConstants opNameSort.
	self assert: anASTTermNode args isEmpty.
	^ sortSort
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
