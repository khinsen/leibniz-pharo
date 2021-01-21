Class {
	#name : #LbDependentSortGraph,
	#superclass : #Object,
	#traits : 'EqualityThroughVariables',
	#classTraits : 'EqualityThroughVariables classTrait',
	#instVars : [
		'context',
		'sortSort',
		'directSubsorts',
		'subsorts',
		'sortFamilies',
		'kindOf',
		'kindFamilies',
		'maximalSortFamilies'
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

{ #category : #copying }
LbDependentSortGraph >> copy [
	^ self
]

{ #category : #copying }
LbDependentSortGraph >> deepCopy [
	^ self
]

{ #category : #lookup }
LbDependentSortGraph >> directSupersortsOf: aSortTerm [
	| supersorts |
	supersorts := Set new.
	context axioms subsortAxioms do: [ :each |
		(each supersortOf: aSortTerm)
			ifNotNil: [ :term | supersorts add: (self sortFor: term) ] ].
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
	self isEmpty ifTrue: [ ^ aView empty ].
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
				connect: context axioms subsortAxioms
					from: [ :each | self sortFamilyForTerm: each subsort ]
					to:  [ :each | self sortFamilyForTerm: each supersort ];
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
	^ self graphFor: aView restrictedTo: sortFamilies highlight: nil
]

{ #category : #accessing }
LbDependentSortGraph >> includes: aSortTerm [
	self flag: #todo.
	^ true.
]

{ #category : #initialization }
LbDependentSortGraph >> initializeDirectSubsorts [
	directSubsorts := Dictionary new.
	sortFamilies do: [ :each |
		directSubsorts at: each put: Set new ].
	context axioms subsortAxioms do: [ :each |
		 each subsort = each supersort ifFalse: [
			| subsort supersort |
			subsort := self sortFamilyForTerm: each subsort.
			supersort := self sortFamilyForTerm: each supersort.
			(directSubsorts at: supersort) add: subsort ] ].
]

{ #category : #initialization }
LbDependentSortGraph >> initializeKindFamilies [
	| candidates kindFamily hasCommonSorts |
	candidates := maximalSortFamilies asOrderedCollection
		collect: [ :sort | subsorts at: sort ].
	"A kind can have multiple maximal sorts. In that case, kindCandidates
	 contains multiple sets that have a non-empty intersection, and which
	 must be merged to obtain the kind."
	kindFamilies := Set new.
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
							sorts: kindFamily
							maximalSorts: (maximalSortFamilies select: [ :each |
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
LbDependentSortGraph >> initializeMaximalSorts [
	maximalSortFamilies :=
		(directSubsorts values)
			inject: sortFamilies asSet
			into: [ :ms :ss | ms difference: ss ]
]

{ #category : #initialization }
LbDependentSortGraph >> initializeSortFamilies [
	sortFamilies :=
		(context signature opsOfKind: sortSort kind)
			collect: [ :each | LbDependentSortFamily sortGraph: self sortOp: each ]
]

{ #category : #initialization }
LbDependentSortGraph >> initializeSubsorts [
	subsorts := Dictionary new.
	directSubsorts keysDo: [ :sort |
		self initializeSubsortsFor: sort ]	
]

{ #category : #initialization }
LbDependentSortGraph >> initializeSubsortsFor: aSort [
	| dss ss |
	(subsorts includes: aSort) ifTrue: [ ^ self ].
	dss := directSubsorts at: aSort.
	ss := dss copy.
	dss do: [ :sort |
		self initializeSubsortsFor: sort.
		ss := ss union: (subsorts at: sort) ].
	(ss includes: aSort) ifTrue: [
		self error: 'Cycle in subsort relations involving ',
						aSort asLeibnizSyntaxString ].
	ss add: aSort.
	subsorts at: aSort put: ss
]

{ #category : #initialization }
LbDependentSortGraph >> initializeWithSortContext: anLbContext [
	context := anLbContext.
	sortSort := context sortGraph sortNamed: #sort.
	self initializeSortFamilies.
	self initializeDirectSubsorts.
	self initializeSubsorts.
	self initializeMaximalSorts.
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
LbDependentSortGraph >> sortContext [
	^ context
]

{ #category : #lookup }
LbDependentSortGraph >> sortFamilyForTerm: aTerm [
	| sortOp sortFamily |
	sortOp := context signature
		opNamed: aTerm opName
		withArgs: (aTerm arguments collect: #sort).
	sortFamily := LbDependentSortFamily sortGraph: self sortOp: sortOp.
	self assert: (sortFamilies includes: sortFamily).
	^ sortFamily
]

{ #category : #accessing }
LbDependentSortGraph >> sortFor: aSortTerm [
	self assert: aSortTerm sort <= sortSort.
	^ LbDependentSort sortGraph: self term: aSortTerm
]

{ #category : #lookup }
LbDependentSortGraph >> sortNamed: aSymbol [
	self flag: #legacy.
	^ self parseSort: aSymbol
]
