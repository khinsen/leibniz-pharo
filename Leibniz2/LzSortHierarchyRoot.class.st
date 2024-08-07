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
	#category : #'Leibniz2-Sorts'
}

{ #category : #accessing }
LzSortHierarchyRoot >> initialize [
	| sortTerm sortDeclaration sortOperators sortFamily sortKind |
	sortTerm := LzOpTerm new
		opName: self sortOpName;
		args: #().
	sortSort := LzSort new
		rawTerm: sortTerm.
	sortTerm sort: sortSort.

	sortDeclaration :=
		LzSortDeclaration new
			op: (LzOpDeclaration new
					name: (LzPrefixOpName for: LzConstants opNameSort);
					variables: #();
					args: #()).

	sortGraph := LzSortHierarchyRootGraph new
		sortDeclarations: { sortDeclaration };
		subsortDeclarations: #().
	sortGraph sortSort: sortSort.
	sortSort sortGraph: sortGraph.

	sortContext := LzContext new
		axioms: Set new;
		axiomDeclarations: Set new.
	sortGraph sortContext: sortContext.

	sortOperators := LzOperators new
							sortGraph: self sortGraph;
							operators: Set new.
	sortSignature :=
		LzSignature new
			sortGraph: sortGraph;
			builtins: Set new;
			stateVars: Dictionary new;
			operators: sortOperators;
			stateVarDeclarations: #();
			opDeclarations: (OrderedCollection with: sortDeclaration op).

	sortContext signature: sortSignature.
	sortTerm signature: sortSignature.

	sortFamily :=
		LzOpSortFamily new
			sortGraph: sortGraph.
	sortGraph sortFamily: sortFamily.
	sortKind :=
		LzKind new
			sortGraph: sortGraph;
			sortFamilies: (Set with: sortFamily);
			maximalFamilies: (Set with: sortFamily).
	sortGraph sortKind: sortKind.
	sortOperators addOp: sortDeclaration op.
	sortFamily op: (sortOperators opForTerm: sortTerm).
	sortGraph initializeSortFamilies.
	sortGraph initializeDirectSubFamilyRelations.
	sortGraph initializeSubFamilies.
	sortGraph initializeMaximalFamilies.
	sortGraph initializeKinds.
	sortGraph initializeKindOf.
	
	sortContext rewriteSystem:
		(LzRewriteSystem new
			signature: sortSignature;
			ruleDeclarations: #();
			rules: #()).
]

{ #category : #accessing }
LzSortHierarchyRoot >> selfTest [
	| family kind |
	self assert: sortContext signature == sortSignature.
	self assert: sortSignature sortGraph == sortGraph.
	self assert: sortSort sortGraph == sortGraph.
	self assert: (sortGraph sort: LzConstants opNameSort asString) equals: sortSort.
	family := sortSort family.
	kind := sortSort kind.
	self assert: family kind equals: kind.
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
	^ LzPrefixOpName for: LzConstants opNameSort
]

{ #category : #accessing }
LzSortHierarchyRoot >> sortSignature [
	^ sortSignature
]

{ #category : #accessing }
LzSortHierarchyRoot >> sortSort [
	^ sortSort
]
