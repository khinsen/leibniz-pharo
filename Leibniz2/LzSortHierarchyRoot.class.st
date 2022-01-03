Class {
	#name : #LzSortHierarchyRoot,
	#superclass : #Object,
	#traits : 'TSingleton',
	#classTraits : 'TSingleton classTrait',
	#instVars : [
		'sortSignature',
		'sortContext',
		'sortGraph',
		'sortSort'
	],
	#category : #Leibniz2
}

{ #category : #accessing }
LzSortHierarchyRoot >> initialize [
	"The sortTerm is lacking its signature, but that doesn't matter. It is fully
	 operational for the bootstrap."
	| sortTerm sortOperators |
	sortTerm := LzOpTerm new
		opName: self sortOpName;
		args: #().
	sortSort := LzSort new
		term: sortTerm.
	sortTerm sort: sortSort.

	sortGraph := LzSortHierarchyRootGraph new.
	sortGraph sortSort: sortSort.
	sortSort sortGraph: sortGraph.
	
	sortContext := LzContext new.
	sortGraph sortContext: sortContext.

	sortOperators := LzOperators new
							sortGraph: self sortGraph;
							operators: Set new.
	sortSignature :=
		LzSignature new
			sortGraph: sortGraph;
			variables: Dictionary new;
			operators: sortOperators.

	sortContext signature: sortSignature.
	sortTerm signature: sortSignature.

	sortOperators addOp:
		(LzParser
			parse: LzConstants opNameSort, ' : ', LzConstants opNameSort
			startingAt: #opEnd
			yielding: LzASTOp).
]

{ #category : #accessing }
LzSortHierarchyRoot >> sortContext [
	^ sortContext
]

{ #category : #accessing }
LzSortHierarchyRoot >> sortGraph [
	^ sortGraph
]

{ #category : #accessing }
LzSortHierarchyRoot >> sortOpName [
	^ LzPrefixOperatorName for: LzConstants opNameSort
]

{ #category : #accessing }
LzSortHierarchyRoot >> sortSignature [
	^ sortSignature
]

{ #category : #accessing }
LzSortHierarchyRoot >> sortSort [
	^ sortSort
]
