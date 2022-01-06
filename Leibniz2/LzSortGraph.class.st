Class {
	#name : #LzSortGraph,
	#superclass : #Object,
	#traits : 'TLzEquality',
	#classTraits : 'TLzEquality classTrait',
	#instVars : [
		'sortContext',
		'subsortDeclarations',
		'sortDeclarations',
		'sortSort',
		'sortFamilies',
		'anySortFamily'
	],
	#category : #'Leibniz2-Leibniz2'
}

{ #category : #initializing }
LzSortGraph >> initializeFromSortContext [
	sortSort := self sortContext sortGraph sort: LzConstants opNameSort.
	self initializeSortFamilies.
]

{ #category : #initializing }
LzSortGraph >> initializeSortFamilies [
	sortFamilies :=
		(self sortContext signature opsOfKind: sortSort kind)
			collect: [ :each |
				LzOpSortFamily new
					sortGraph: self;
					op: each ].
	"A special sort family represents the variable of sort #sort."
	anySortFamily := LzUniversalSortFamily new
						sortGraph: self.
	sortFamilies := sortFamilies copyWith: anySortFamily.
]

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

{ #category : #initializing }
LzSortGraph >> sortContext: aSortContext [
	sortContext := aSortContext.
	self initializeFromSortContext
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
