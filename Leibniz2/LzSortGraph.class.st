Class {
	#name : #LzSortGraph,
	#superclass : #Object,
	#traits : 'TLzEquality',
	#classTraits : 'TLzEquality classTrait',
	#instVars : [
		'sortContext',
		'subsortDeclarations',
		'sortDeclarations'
	],
	#category : #'Leibniz2-Leibniz2'
}

{ #category : #constructing }
LzSortGraph >> parsedSort: anASTPatternNode [
	^ LzSort new
		sortGraph: self;
		term: (self sortContext parsedPattern: anASTPatternNode);
		beRecursivelyReadOnlyObject;
		yourself
]

{ #category : #accessing }
LzSortGraph >> parsedSortTerm: anASTTermNode variables: anArrayOfASTVarNodes [
	^ self parsedSort: 
		(LzASTPattern new
			variables: anArrayOfASTVarNodes;
			term: anASTTermNode)
]

{ #category : #constructing }
LzSortGraph >> sort: aString [
	| astNode |
	astNode := LzParser parse: aString startingAt: #patternEnd yielding: LzASTPattern.
	^ self parsedSort: astNode
]

{ #category : #accessing }
LzSortGraph >> sortContext [
	^ sortContext
]

{ #category : #accessing }
LzSortGraph >> sortContext: aSortContext [
	sortContext := aSortContext
]

{ #category : #accessing }
LzSortGraph >> sortDeclarations [
	^ sortDeclarations
]

{ #category : #accessing }
LzSortGraph >> sortDeclarations: aCollection [
	sortDeclarations := aCollection
]

{ #category : #accessing }
LzSortGraph >> subsortDeclarations [
	^ subsortDeclarations
]

{ #category : #accessing }
LzSortGraph >> subsortDeclarations: aCollection [
	subsortDeclarations := aCollection
]

{ #category : #accessing }
LzSortGraph >> valueSlots [
	^ #(sortContext)
]
