Class {
	#name : #LzSortHierarchyRoot,
	#superclass : #Object,
	#traits : 'TSingleton',
	#classTraits : 'TSingleton classTrait',
	#instVars : [
		'sortSignature',
		'sortContext',
		'sortGraph'
	],
	#category : #Leibniz2
}

{ #category : #accessing }
LzSortHierarchyRoot >> sortContext [
	^ sortContext ifNil: [
		sortContext :=
			LzContext new
				signature: self sortSignature.
		"Close the loop"
		self sortGraph sortContext: sortContext.
		sortContext ]
]

{ #category : #accessing }
LzSortHierarchyRoot >> sortGraph [
	^ sortGraph ifNil: [
		sortGraph := LzSortGraph new ]
]

{ #category : #accessing }
LzSortHierarchyRoot >> sortOpName [
	^ LzPrefixOperatorName for: LzConstants opNameSort
]

{ #category : #accessing }
LzSortHierarchyRoot >> sortSignature [
	^ sortSignature ifNil: [
		| op |
		op := LzParser
			parse: LzConstants opNameSort, ' : ', LzConstants opNameSort
			startingAt: #opEnd
			yielding: LzASTOpDeclaration.
		sortSignature :=
			LzSignature new
				sortGraph: self sortGraph;
				operators: (Set with: op);
				variables: Dictionary new]
]

{ #category : #accessing }
LzSortHierarchyRoot >> sortTerm [
	| term |
	term := LzSortTerm new
		signature: self sortSignature;
		opName: self sortOpName;
		arguments: #().
	^ term
		sort: term;
		beRecursivelyReadOnlyObject;
		yourself
]
