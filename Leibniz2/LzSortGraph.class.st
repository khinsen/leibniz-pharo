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
		'connectingPaths',
		'subFamilies',
		'maximalFamilies',
		'kinds',
		'kindOf'
	],
	#category : #'Leibniz2-Leibniz2'
}

{ #category : #accessing }
LzSortGraph >> axiomsConnecting: aFamily to: anotherFamily [
	^ connectingAxioms
		at: { aFamily. anotherFamily }
		ifAbsent: [ #() ]
]

{ #category : #initializing }
LzSortGraph >> familyForSortTerm: aTerm [
	^ aTerm isVarTerm
		ifTrue: [ anySortFamily ]
		ifFalse: [ sortFamilies at: (sortContext signature operators opForTerm: aTerm) ]
]

{ #category : #inspecting }
LzSortGraph >> graphFor: aView restrictedTo: aSet highlight: aBlock [
	aSet isEmpty ifTrue: [ ^ aView empty ].
	^ aView mondrian
		title: 'Graph';
		priority: 0;
		painting: [ :view | 
			| edges |
			view nodes
				shape: [ :x | self graphNodeForSort: x highlight: (aBlock cull: x) ];
				with: aSet.
			view edges
				shape: [ :x | LbGraphicsElements graphArrow ];
				fromCenterTop;
				toCenterBottom;
				connect: connectingAxioms values
					from: [ :each | self familyForSortTerm: each anyOne subsort ]
					to: [ :each | self familyForSortTerm: each anyOne supersort ];
				yourself.
			view layout
				custom: (GtGradVerticalDominanceTreeLayout new reverse: true) ]
]

{ #category : #inspecting }
LzSortGraph >> graphNodeForSort: aSortFamily highlight: aBoolean [
	^ LzGraphicsElements
		graphNodeLabelled: aSortFamily asLeibnizSyntaxString
		highlightColor: (aBoolean ifTrue: [ Color black ] ifFalse: [ nil ])
]

{ #category : #inspecting }
LzSortGraph >> gtGraphFor: aView [
	<gtView>
	^ self
		graphFor: aView
		restrictedTo: (sortFamilies copyWithout: anySortFamily)
		highlight: [ false ]
]

{ #category : #initializing }
LzSortGraph >> initializeDirectSubFamilyRelations [
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
	self initializeDirectSubFamilyRelations.
	self initializeSubFamilies.
	self initializeMaximalFamilies.
	self initializeKinds.
	self initializeKindOf.
]

{ #category : #initializing }
LzSortGraph >> initializeKindOf [
	kindOf := Dictionary new.
	kinds do: [ :eachKind |
		eachKind sortFamilies do: [ :eachFamily |
			kindOf at: eachFamily put: eachKind ] ]
]

{ #category : #initializing }
LzSortGraph >> initializeKinds [
	"A special kind only the 'anySort' family."
	| candidates |
	kinds := Set with:
		(LzKind new
			sortGraph: self;
			sortFamilies: (Set with: anySortFamily);
			maximalFamilies: (Set with: anySortFamily)).
	"A kind can have multiple maximal families. In that case, candidates
	 contains multiple sets that have a non-empty intersection, and which
	 must be merged to obtain the kind."
	candidates := maximalFamilies asOrderedCollection
		collect: [ :sort | subFamilies at: sort ].
	[ candidates isEmpty ] whileFalse: [
		| kind hasCommonSorts |
		kind := candidates first.
		hasCommonSorts :=
			candidates allButFirst groupedBy: [ :each |
				(kind intersection: each) isNotEmpty ].
		#(true false) do: [ :b |
			hasCommonSorts at: b ifAbsentPut: OrderedCollection new. ].
		kind := ((hasCommonSorts at: true)
						inject: kind into: [ :k :c | k union: c ]).
		kinds add: (LzKind new
						sortGraph: self;
						sortFamilies: kind;
						maximalFamilies: (maximalFamilies select: [ :each |
								kind includes: each ])).
		candidates := hasCommonSorts at: false. ]
]

{ #category : #accessing }
LzSortGraph >> initializeMaximalFamilies [
	maximalFamilies :=
		(directSubFamilies values)
			inject: sortFamilies asSet
			into: [ :ms :ss | ms difference: ss ]
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

{ #category : #initializing }
LzSortGraph >> initializeSubFamilies [
	subFamilies := Dictionary new.
	directSubFamilies keysDo: [ :family |
		self initializeSubFamiliesFor: family ]	
]

{ #category : #initializing }
LzSortGraph >> initializeSubFamiliesFor: aFamily [
	| dssf ssf |
	(subFamilies includes: aFamily) ifTrue: [ ^ self ].
	dssf := directSubFamilies at: aFamily.
	ssf := dssf copy.
	dssf do: [ :eachSsf1 |
		| issf |
		self initializeSubFamiliesFor: eachSsf1.
		issf := subFamilies at: eachSsf1.
		ssf := ssf union: issf.
		issf do: [ :eachSsf2 |
			eachSsf2 = eachSsf1 ifFalse: [
				| paths |
				paths := connectingPaths at: { eachSsf2. aFamily }
							ifAbsentPut: [ Set new ].
				(connectingPaths at: { eachSsf2. eachSsf1 }) do: [ :segment1 |
					(connectingPaths at: { eachSsf1. aFamily }) do: [ :segment2 |
						paths add: segment1, segment2 ] ] ] ] ].
	(ssf includes: aFamily) ifTrue: [
		self error: 'Cycle in subsort relations involving ',
						aFamily asLeibnizSyntaxString ].
	ssf add: aFamily.
	subFamilies at: aFamily put: ssf
]

{ #category : #constructing }
LzSortGraph >> parsedSort: anASTPatternNode [
	^ self sortWithTerm:
		(self sortContext parsedPattern: anASTPatternNode)
]

{ #category : #accessing }
LzSortGraph >> parsedSortTerm: anASTTermNode variables: anArrayOfASTVarNodes [
	^ self parsedSort: 
		(LzASTPattern new
			variables: anArrayOfASTVarNodes;
			term: anASTTermNode)
]

{ #category : #accessing }
LzSortGraph >> pathsConnecting: aFamily to: anotherFamily [
	^ connectingPaths
		at: { aFamily. anotherFamily }
		ifAbsent: (Set new)
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

{ #category : #constructing }
LzSortGraph >> sortWithTerm: aTerm [
	^ LzSort new
		sortGraph: self;
		term: aTerm;
		beRecursivelyReadOnlyObject;
		yourself
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
