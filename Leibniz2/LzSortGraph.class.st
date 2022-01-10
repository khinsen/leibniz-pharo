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
		'anySortFamily',
		'directSubFamilies',
		'directSuperFamilies',
		'connectingAxioms',
		'connectingPaths'
	],
	#category : #'Leibniz2-Leibniz2'
}

{ #category : #initializing }
LzSortGraph >> familyForSortTerm: aTerm [
	^ aTerm isVarTerm
		ifTrue: [ anySortFamily ]
		ifFalse: [ sortFamilies at: (sortContext signature operators opForTerm: aTerm) ]
]

{ #category : #initializing }
LzSortGraph >> initializeDirectSubsortRelations [
	directSubFamilies := Dictionary new.
	directSuperFamilies := Dictionary new.
	connectingAxioms := Dictionary new.
	connectingPaths := Dictionary new.
	sortFamilies values do: [ :each |
		directSubFamilies at: each put: Set new.
		directSuperFamilies at: each put: Set new ].
	sortContext subsortAxioms do: [ :each |
		 each subsort = each supersort ifFalse: [
			| subsort supersort |
			subsort := self familyForSortTerm: each subsort.
			supersort := self familyForSortTerm: each supersort.
			(directSubFamilies at: supersort) add: subsort.
			(directSuperFamilies at: subsort) add: supersort.
			(connectingAxioms at: { subsort. supersort }
				ifAbsentPut: [ Set new ])
				add: each.
			connectingPaths at: { subsort. supersort }
				put: (Set with: (OrderedCollection with: { subsort. supersort }))] ].
]

{ #category : #initializing }
LzSortGraph >> initializeFromSortContext [
	sortSort := self sortContext sortGraph sort: LzConstants opNameSort.
	self initializeSortFamilies.
	self initializeDirectSubsortRelations.
]

{ #category : #initializing }
LzSortGraph >> initializeSortFamilies [
	sortFamilies := Dictionary new.
	(self sortContext signature opsOfKind: sortSort kind) do: [ :each |
		sortFamilies at: each put:
			(LzOpSortFamily new
				sortGraph: self;
				op: each) ].
	"A special sort family represents the variable of sort #sort."
	anySortFamily := LzUniversalSortFamily new
						sortGraph: self.
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
