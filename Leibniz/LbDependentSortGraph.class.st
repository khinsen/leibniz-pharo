Class {
	#name : #LbDependentSortGraph,
	#superclass : #Object,
	#traits : 'EqualityThroughVariables',
	#classTraits : 'EqualityThroughVariables classTrait',
	#instVars : [
		'context',
		'sortSort',
		'sortFamilies',
		'kindOf',
		'kindFamilies',
		'maximalSortFamilies',
		'directSubsortFamilies',
		'subsortFamilies',
		'connectingAxioms',
		'directSupersortFamilies',
		'connectingPaths',
		'anySortFamily'
	],
	#category : #'Leibniz-7-DependentSorts'
}

{ #category : #'instance creation' }
LbDependentSortGraph class >> sortContext: aContext [
	^ self basicNew
		initializeWithSortContext: aContext;
		yourself
]

{ #category : #'instance creation' }
LbDependentSortGraph class >> sortContext: aContext directSubsorts: aSubsortDictionary [
	^ self basicNew
		initializeWithSortContext: aContext
		directSubsorts: aSubsortDictionary;
		yourself
]

{ #category : #comparing }
LbDependentSortGraph >> = anObject [
	| class instVarNames |
	self == anObject ifTrue: [ ^true ].
	class := self class.
	class = anObject class ifFalse: [ ^false ].
	instVarNames := class allInstVarNames difference: self instVarsExcludedFromEquality.
	instVarNames do:
		[ :name |
			(self instVarNamed: name) = (anObject instVarNamed: name)
				ifFalse: [^false]. ].
	class isVariable
		ifTrue:
			[ self basicSize = anObject basicSize ifFalse: [^false].
			  1 to: self basicSize do:
				[ :index |
					(self basicAt: index) = (anObject basicAt: index)
						ifFalse: [ ^false ] ] ].
	^true

]

{ #category : #accessing }
LbDependentSortGraph >> axiomsConnecting: aSortFamily to: anotherSortFamily [
	^ connectingAxioms
		at: { aSortFamily. anotherSortFamily }
		ifAbsent: [ #() ]
]

{ #category : #copying }
LbDependentSortGraph >> copy [
	^ self
]

{ #category : #copying }
LbDependentSortGraph >> deepCopy [
	^ self
]

{ #category : #lookup }
LbDependentSortGraph >> directSubsortsOf: aSortTerm [
	| subsorts family |
	subsorts := Set new.
	family := self sortFamilyForTerm: aSortTerm.
	family = anySortFamily ifTrue: [ ^ subsorts ].
	"First step: subsorts via the sort family graph."
	(directSubsortFamilies at: family) do: [ :eachFamily |
		(connectingAxioms at: { eachFamily. family }) do: [ :eachAxiom |
			(eachAxiom subsortOf: aSortTerm)
				ifNotNil: [ :term | subsorts add: (self sortFor: term) ]] ].
	"Second step: subsorts via argument subsorts."
	(aSortTerm arguments 
		collect: [ :each | each sort asLeibnizSyntaxString = #sort
							ifTrue: [ (self directSubsortsOf: each) collect: #term ]
							ifFalse: [ Set with: each ] ])
		cartesianProductDo: [ :args |
			| term |
			term := context signature
						nonZeroArgTermNamed: aSortTerm opName withArgs: args.
			term = aSortTerm
				ifFalse: [ subsorts add: (self sortFor: term) ] ].
	^ subsorts
]

{ #category : #lookup }
LbDependentSortGraph >> directSupersortsOf: aSortTerm [
	| supersorts family |
	supersorts := Set new.
	family := self sortFamilyForTerm: aSortTerm.
	family = anySortFamily ifTrue: [ ^ supersorts ].
	"First step: supersorts via the sort family graph."
	(directSupersortFamilies at: family) do: [ :eachFamily |
		(connectingAxioms at: { family. eachFamily }) do: [ :eachAxiom |
			(eachAxiom supersortOf: aSortTerm)
				ifNotNil: [ :term | supersorts add: (self sortFor: term) ]] ].
	"Second step: supersorts via argument subsorts."
	(aSortTerm arguments 
		collect: [ :each | each sort asLeibnizSyntaxString = #sort
							ifTrue: [ (self directSupersortsOf: each) collect: #term ]
							ifFalse: [ Set with: each ] ])
		cartesianProductDo: [ :args |
			| term |
			term := context signature
						nonZeroArgTermNamed: aSortTerm opName withArgs: args.
			term = aSortTerm
				ifFalse: [ supersorts add: (self sortFor: term) ] ].
	^ supersorts
]

{ #category : #inspecting }
LbDependentSortGraph >> graphArrowForSubsortRelation: aSubsortAxiom [
	| color |
	color := aSubsortAxiom "isFromInclude" isNil
		ifTrue: [ Color r: 83 g: 101 b: 201 range: 255 ]
		ifFalse: [ Color gray ].
	^ BlLineElement new
		toHead: (BlArrowheadSimpleArrow new
					border: (BlBorder paint: color width: 1));
		border: (BlBorder paint: color width: 1)
]

{ #category : #inspecting }
LbDependentSortGraph >> graphFor: aView restrictedTo: aSet highlight: aSort [
	aSet isEmpty ifTrue: [ ^ aView empty ].
	^ aView mondrian
		title: 'Graph';
		priority: 0;
		painting: [ :view | 
			| edges |
			view nodes
				shape: [ :x | self graphNodeForSort: x highlight: (x = aSort) ];
				with: aSet.
			view edges
				shape: [ :x | self graphArrowForSubsortRelation: x ];
				fromCenterTop;
				toCenterBottom;
				connect: connectingAxioms values
					from: [ :each | self sortFamilyForTerm: each anyOne subsort ]
					to: [ :each | self sortFamilyForTerm: each anyOne supersort ];
				yourself.
			view layout
				custom: (GtGradVerticalDominanceTreeLayout new reverse: true) ]
]

{ #category : #inspecting }
LbDependentSortGraph >> graphNodeForSort: aSortFamily highlight: aBoolean [
	| text color label rectangle |
	text := aSortFamily asLeibnizSyntaxString asRopedText.
	text fontName: (LbCodeFont defaultFamily).
	aSortFamily "isFromInclude" isNil
		ifTrue: [
			color := Color r: 63 g: 81 b: 181 range: 255 ]
		ifFalse: [ color := Color black ].
	text foreground: color.
	label := BlTextElement new text: text.

	aBoolean ifFalse:
		[ ^ label
			padding:
				(BlInsets top: 3 right: 3 bottom: 3 left: 3);
			yourself ].

	rectangle := BlElement new
		background: color;
		geometry: (BlRoundedRectangleGeometry cornerRadius: 2);
		padding: (BlInsets top: 3 right: 3 bottom: 3 left: 3);
		layout: BlLinearLayout horizontal;
		constraintsDo: [ :c |
			c horizontal fitContent.
			c vertical fitContent ].
	text foreground: Color white.
	rectangle addChild: label.
	^ rectangle
]

{ #category : #inspecting }
LbDependentSortGraph >> gtGraphFor: aView [
	<gtView>
	^ self
		graphFor: aView
		restrictedTo: (sortFamilies copyWithout: anySortFamily)
		highlight: nil
]

{ #category : #testing }
LbDependentSortGraph >> includes: aSort [
	^ sortFamilies includes: aSort family
]

{ #category : #initialization }
LbDependentSortGraph >> initializeDirectSubsortRelations [
	directSubsortFamilies := Dictionary new.
	directSupersortFamilies := Dictionary new.
	connectingAxioms := Dictionary new.
	connectingPaths := Dictionary new.
	sortFamilies do: [ :each |
		directSubsortFamilies at: each put: Set new.
		directSupersortFamilies at: each put: Set new ].
	context axioms subsortAxioms do: [ :each |
		 each subsort = each supersort ifFalse: [
			| subsort supersort |
			subsort := self sortFamilyForTerm: each subsort.
			supersort := self sortFamilyForTerm: each supersort.
			(directSubsortFamilies at: supersort) add: subsort.
			(directSupersortFamilies at: subsort) add: supersort.
			(connectingAxioms at: { subsort. supersort }
				ifAbsentPut: [ Set new ])
				add: each.
			connectingPaths at: { subsort. supersort }
				put: (Set with: (OrderedCollection with: { subsort. supersort }))] ].
]

{ #category : #initialization }
LbDependentSortGraph >> initializeKindFamilies [
	| anySort candidates kindFamily hasCommonSorts |
	"A special kind family contains only the 'anySort' sort family."
	kindFamilies := Set with:
		(LbDependentKindFamily
			sortGraph: self
			sortFamilies: (Set with: anySort)
			maximalSortFamilies: (Set with: anySortFamily)).
	"A kind can have multiple maximal sorts. In that case, kindCandidates
	 contains multiple sets that have a non-empty intersection, and which
	 must be merged to obtain the kind."
	candidates := maximalSortFamilies asOrderedCollection
		collect: [ :sort | subsortFamilies at: sort ].
	[ candidates isEmpty ] whileFalse: [
		kindFamily := candidates first.
		hasCommonSorts :=
			candidates allButFirst groupedBy: [ :each |
				(kindFamily intersection: each) isNotEmpty ].
		#(true false) do: [ :b |
			hasCommonSorts at: b ifAbsentPut: OrderedCollection new. ].
		kindFamily := ((hasCommonSorts at: true)
						inject: kindFamily into: [ :k :c | k union: c ]).
		kindFamilies add: (LbDependentKindFamily
							sortGraph: self
							sortFamilies: kindFamily
							maximalSortFamilies: (maximalSortFamilies select: [ :each |
								kindFamily includes: each ])).
		candidates := hasCommonSorts at: false. ]
]

{ #category : #initialization }
LbDependentSortGraph >> initializeKindOf [
	kindOf := Dictionary new.
	kindFamilies do: [ :eachKind |
		eachKind asSet do: [ :eachSortFamily |
			kindOf at: eachSortFamily put: eachKind ] ]
]

{ #category : #initialization }
LbDependentSortGraph >> initializeMaximalSortFamilies [
	maximalSortFamilies :=
		(directSubsortFamilies values)
			inject: sortFamilies asSet
			into: [ :ms :ss | ms difference: ss ]
]

{ #category : #initialization }
LbDependentSortGraph >> initializeSortFamilies [
	sortFamilies :=
		(context signature opsOfKind: sortSort kind)
			collect: [ :each | LbDependentSortFamily sortGraph: self sortOp: each ].
	"A special sort family represents the variable of sort #sort."
	anySortFamily := LbDependentSortFamily anySortInSortGraph: self.
	sortFamilies add: anySortFamily.
]

{ #category : #initialization }
LbDependentSortGraph >> initializeSubsortFamilies [
	subsortFamilies := Dictionary new.
	directSubsortFamilies keysDo: [ :sort |
		self initializeSubsortFamiliesFor: sort ]	
]

{ #category : #initialization }
LbDependentSortGraph >> initializeSubsortFamiliesFor: aSort [
	| dssf ssf |
	(subsortFamilies includes: aSort) ifTrue: [ ^ self ].
	dssf := directSubsortFamilies at: aSort.
	ssf := dssf copy.
	dssf do: [ :each |
		| issf |
		self initializeSubsortFamiliesFor: each.
		issf := subsortFamilies at: each.
		ssf := ssf union: issf.
		issf do: [ :eachSsf |
			eachSsf = each ifFalse: [
				| paths |
				paths := connectingPaths at: { eachSsf. aSort }
							ifAbsentPut: [ Set new ].
				(connectingPaths at: { eachSsf. each }) do: [ :segment1 |
					(connectingPaths at: { each. aSort }) do: [ :segment2 |
						paths add: segment1, segment2 ] ] ] ] ].
	(ssf includes: aSort) ifTrue: [
		self error: 'Cycle in subsort relations involving ',
						aSort asLeibnizSyntaxString ].
	ssf add: aSort.
	subsortFamilies at: aSort put: ssf
]

{ #category : #initialization }
LbDependentSortGraph >> initializeWithSortContext: anLbContext [
	context := anLbContext.
	sortSort := context sortGraph sortNamed: #sort.
	self initializeSortFamilies.
	self initializeDirectSubsortRelations.
	self initializeSubsortFamilies.
	self initializeMaximalSortFamilies.
	self initializeKindFamilies.
	self initializeKindOf.
	self beRecursivelyReadOnlyObject
]

{ #category : #comparing }
LbDependentSortGraph >> instVarsExcludedFromEquality [
	"The only instance variable used in comparison is 'context', since all the
	 others are derived from it."

	^ self class instVarNames reject: [ :each | each = #context ]
]

{ #category : #testing }
LbDependentSortGraph >> isEmpty [
	^ sortFamilies isEmpty
]

{ #category : #private }
LbDependentSortGraph >> kindFamilyForTerm: aSortTerm [
	^ (self sortFamilyForTerm: aSortTerm) kindFamily
]

{ #category : #lookup }
LbDependentSortGraph >> kindOf: aSortFamily [
	^ kindOf at: aSortFamily
]

{ #category : #accessing }
LbDependentSortGraph >> normalizedSortFor: aSortTerm [
	self assert: aSortTerm sort <= sortSort.
	^ LbDependentSort sortGraph: self term: (context reduce: aSortTerm)
]

{ #category : #lookup }
LbDependentSortGraph >> parseSort: aString [
	^ self sortFor: (context parseTerm: aString)
]

{ #category : #accessing }
LbDependentSortGraph >> pathsConnecting: aSortFamily to: anotherSortFamily [
	^ connectingPaths
		at: { aSortFamily. anotherSortFamily }
		ifAbsent: (Set new)
]

{ #category : #accessing }
LbDependentSortGraph >> sortContext [
	^ context
]

{ #category : #lookup }
LbDependentSortGraph >> sortFamilyForTerm: aTerm [
	| sortOp sortFamily |
	aTerm isVariable
		ifTrue: [ ^ LbDependentSortFamily anySortInSortGraph: self ].
	sortOp := context signature
		opNamed: aTerm opName
		withArgs: (aTerm arguments collect: #sort).
	sortFamily := LbDependentSortFamily sortGraph: self sortOp: sortOp.
	self assert: (sortFamilies includes: sortFamily).
	^ sortFamily
]

{ #category : #lookup }
LbDependentSortGraph >> sortFor: aSortTerm [
	self assert: aSortTerm sort <= sortSort.
	^ LbDependentSort sortGraph: self term: aSortTerm
]

{ #category : #lookup }
LbDependentSortGraph >> sortNamed: aSymbol [
	self flag: #legacy.
	^ self parseSort: aSymbol
]
