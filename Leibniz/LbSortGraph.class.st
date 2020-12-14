"
!!Sorts, sort graphs, and kinds

Sorts are names given to sets of values. They are similar to types in programming languages. Sorts are instances of ${class:name=LbSort}$.

A sort can be declared to be a subsort of another sort, meaning that its values are in a subset of the set rof values epresented by the supersort. A graph formed by subsort relations is called a sort graph, represented by this class.

The connected components of a sort graph are called kinds (see ${class:name=LbKind}$). Sorts that are in different kinds are completely unrelated.

As an example, let's look at the sort graph of the built-in context 'real-numbers':

[[[
LbBuiltinContexts realNumberContext sortGraph
]]]

It consists of two kinds, one of which contains a single sort, ==#boolean==. The second kind groups together all the number sorts built into Leibniz. The suffix ==.nz== stands for non-zero, ==.p== stands for positive, and ==.nn== stands for non-negative.

Sort graphs are immutable objects. They are constructed by a ${class:name=LbSortGraphBuilder}$.

"
Class {
	#name : #LbSortGraph,
	#superclass : #Object,
	#traits : 'EqualityThroughVariables',
	#classTraits : 'EqualityThroughVariables classTrait',
	#instVars : [
		'kinds',
		'maximalSorts',
		'directSubsortsOf',
		'subsortsOf',
		'kindsOf',
		'origins',
		'derivedSubsortsOf'
	],
	#category : #'Leibniz-1-SortGraphs'
}

{ #category : #'instance creation' }
LbSortGraph class >> fromSubsortRelations: aSubsetDictionary andCollectionSorts: aCollectionSortDictionary origins: anOriginDictionary [
	^ self basicNew
			initializeWithSubsortRelations: aSubsetDictionary
			andCollectionSorts: aCollectionSortDictionary
			origins: anOriginDictionary;
			yourself
]

{ #category : #converting }
LbSortGraph >> asSet [
   ^ directSubsortsOf keys asSet collect: [ :each | self sortNamed: each ]
]

{ #category : #converting }
LbSortGraph >> asSortGraphBuilder [
	^ LbSortGraphBuilder new addSortGraph: self
]

{ #category : #copying }
LbSortGraph >> copy [
	^self
]

{ #category : #accessing }
LbSortGraph >> declarations [
	| sorts subsorts |
	sorts := directSubsortsOf keys sorted.
	subsorts := OrderedCollection new.
	sorts do: [ :eachSort |
		(directSubsortsOf at: eachSort)
			asArray sorted do: [ :eachSubsort |
				subsorts add: eachSubsort, ' ⊆ ', eachSort ] ].
	^ Dictionary
		with: #sorts -> sorts
		with: #subsorts -> subsorts
]

{ #category : #copying }
LbSortGraph >> deepCopy [
	^self
]

{ #category : #accessing }
LbSortGraph >> directSubsortsOf: aSymbol [
	^ (directSubsortsOf at: aSymbol) collect: [ : each | self sortNamed: each ]
]

{ #category : #viewing }
LbSortGraph >> graphArrowForSubsortRelation: aSubsortRelation [
	| color |
	color := aSubsortRelation isFromInclude
		ifTrue: [ Color r: 83 g: 101 b: 201 range: 255 ]
		ifFalse: [ Color gray ].
	^ BlLineElement new
		toHead: (BlArrowheadSimpleArrow new
					border: (BlBorder paint: color width: 1));
		border: (BlBorder paint: color width: 1)
]

{ #category : #inspecting }
LbSortGraph >> graphEdgesForSubset: aSet [
	| edges |
	edges := OrderedCollection new.
	self withAllSubsortRelationsDo: [ :ssr |
		((aSet includes: ssr subsort)
			and: [ aSet includes: ssr supersort ])
			ifTrue: [ edges add: ssr ] ].
	^ edges
]

{ #category : #viewing }
LbSortGraph >> graphNodeForSort: aSort highlight: aBoolean [
	| text color label rectangle |
	text := aSort name asString asRopedText.
	text fontName: (LbCodeFont defaultFamily).
	aSort isFromInclude
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

{ #category : #viewing }
LbSortGraph >> grayArrow [
	^ BlLineElement new
		toHead: (BlArrowheadSimpleArrow new
					border: (BlBorder paint: Color gray width: 1));
		border: (BlBorder paint: Color gray width: 1)
]

{ #category : #accessing }
LbSortGraph >> gtDeclarationsFor: aView [
	<gtView>
	self isEmpty
		ifTrue: [ ^ aView empty ].
	^ aView tree
		title: 'Declarations' translated;
		priority: 1;
		items: [ | d |
			d := self declarations.
			{{'Sorts'.
			((d at: #sorts)
				collect: [ :each | 
					{each.
					#()} ])}.
			{'Subsorts'.
			((d at: #subsorts)
				collect: [ :each | 
					{each.
					#()} ])}} ];
		itemLbCode: [ :each | each first ];
		children: [ :each | each second ];
		expandOneLevel;
		yourself
]

{ #category : #inspecting }
LbSortGraph >> gtGraphFor: aView [
	<gtView>
	self isEmpty ifTrue: [ ^ aView empty ].
	^ aView mondrian
		title: 'Graph';
		priority: 0;
		painting: [ :view | 
			| edges |
			view nodes
				shape: [ :x | self graphNodeForSort: x highlight: false ];
				with: self asSet.
			view edges
				shape: [ :x | self graphArrowForSubsortRelation: x ];
				fromCenterTop;
				toCenterBottom;
				connect: (self graphEdgesForSubset: self asSet)
					from: #subsort
					to: #supersort.
			view layout
				custom: (GtGradVerticalDominanceTreeLayout new reverse: true) ]
]

{ #category : #initializing }
LbSortGraph >> initializeDerivedSubsortsFrom: collectionSortsOf [
	derivedSubsortsOf := Dictionary new.
	directSubsortsOf keysAndValuesDo: [ :superSort :subSorts |
		collectionSortsOf at: superSort ifPresent: [ :collectionSuperSorts |
			| prefixes |
			prefixes := collectionSuperSorts keys asSet.
			subSorts do: [ :subSort |
				collectionSortsOf at: subSort ifPresent: [ :collectionSubSorts |
				(collectionSubSorts keys asSet intersection: prefixes) do: [ :each |
					| cSubSort cSuperSort |
					cSubSort := collectionSubSorts at: each.
					cSuperSort := collectionSuperSorts at: each.
					(derivedSubsortsOf at: cSuperSort
						ifAbsentPut: [ Set new ])
						add: cSubSort.
					origins at: { cSubSort. cSuperSort } put:
						(origins at: { subSort. superSort }) ] ] ] ] ]
]

{ #category : #initializing }
LbSortGraph >> initializeKinds [
	| kindCandidates kind hasCommonSorts |
	kindCandidates := maximalSorts asOrderedCollection collect: [ :sort | subsortsOf at: sort ].
	"A kind can have multiple maximal sorts. In that case, kindCandidates contains multiple sets
	 that have a non-empty intersection, and which must be merged to obtain the kind."
	kinds := Set new.
	[ kindCandidates isEmpty ] whileFalse: [ 
		kind := kindCandidates first.
		hasCommonSorts := kindCandidates allButFirst groupedBy:
									[ :c | (kind intersection: c) isNotEmpty ].
		#(true false) do: [ :b | hasCommonSorts at: b ifAbsentPut: OrderedCollection new. ].
		kind := ((hasCommonSorts at: true) inject: kind into: [ :k :c | k union: c ]).
		kinds add: (LbKind sortGraph: self
		 								sorts: kind
										maximalSorts: (maximalSorts select: [ :s | kind includes: s ])).
		kindCandidates := hasCommonSorts at: false. ].

	kindsOf := Dictionary new.
	kinds do: [ :k | k asSet do: [ :s | kindsOf at: s name put: k ] ]
]

{ #category : #initializing }
LbSortGraph >> initializeMaximalSorts [
	maximalSorts :=
		(directSubsortsOf values)
			inject: directSubsortsOf keys asSet
			into: [ :ms :ss | ms difference: ss ].
	maximalSorts :=
		(derivedSubsortsOf values)
			inject: maximalSorts
			into: [ :ms :ss | ms difference: ss ].
]

{ #category : #initializing }
LbSortGraph >> initializeSubsortsOf [
	subsortsOf := Dictionary new.
	directSubsortsOf keysDo: [ :sort |
		self initializeSubsortsOfAt: sort ]	
]

{ #category : #initializing }
LbSortGraph >> initializeSubsortsOfAt: aSort [
	| dss ss |
	(subsortsOf includes: aSort) ifTrue: [ ^ self ].
	dss := ((directSubsortsOf at: aSort)
			union: (derivedSubsortsOf at: aSort ifAbsent: [ Set new ])).
	ss := dss copy.
	ss add: aSort.
	dss do: [ :sort |
		self initializeSubsortsOfAt: sort.
		ss := ss union: (subsortsOf at: sort) ].
	subsortsOf at: aSort put: ss
]

{ #category : #initializing }
LbSortGraph >> initializeWithSubsortRelations: subsortRelations andCollectionSorts: collectionSorts origins: anOriginDictionary [
	directSubsortsOf := subsortRelations.
	origins := anOriginDictionary.
	self initializeDerivedSubsortsFrom: collectionSorts.
	self initializeSubsortsOf.
	self initializeMaximalSorts.
	self initializeKinds.
	self beRecursivelyReadOnlyObject
]

{ #category : #comparing }
LbSortGraph >> instVarsExcludedFromEquality [
	"The only instance variable used in comparison is directSubsortsOf,
	 since all others are derived from it"
	^#(#kinds #maximalSorts #subsortsOf #kindsOf)

]

{ #category : #accessing }
LbSortGraph >> isEmpty [
	^ directSubsortsOf isEmpty
]

{ #category : #private }
LbSortGraph >> kindOf: aSymbol [
	^ kindsOf at: aSymbol
]

{ #category : #accessing }
LbSortGraph >> kinds [
	^ kinds
]

{ #category : #accessing }
LbSortGraph >> maximalSorts [
	^  maximalSorts collect: [ :aSymbol | self sortNamed: aSymbol ]
]

{ #category : #printing }
LbSortGraph >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	aStream nextPutAll: (', ' join: (self maximalSorts collect: [ : sort | sort name asString ])).
	aStream nextPut: $).

]

{ #category : #accessing }
LbSortGraph >> size [
	^ self asSet size.

]

{ #category : #accessing }
LbSortGraph >> sortNamed: aSymbol [
	self
		assert: (directSubsortsOf includesKey: aSymbol) 
		description: 'No sort named ', aSymbol.
	^ LbSort
		named: aSymbol
		in: self
		origins: (origins at: aSymbol ifAbsent: [ nil ])
]

{ #category : #accessing }
LbSortGraph >> subsortsOf: aSymbol [
	^ (subsortsOf at: aSymbol) collect: [ : each | self sortNamed: each ]
]

{ #category : #enumerating }
LbSortGraph >> union: aSortGraph [ 
	^ self asSortGraphBuilder
		addSortGraph: aSortGraph;
		sortGraph
]

{ #category : #private }
LbSortGraph >> withAllSubsortRelationsDo: aBlockClosure [
	self withSubsortRelations: directSubsortsOf do: aBlockClosure.
	self withSubsortRelations: derivedSubsortsOf do: aBlockClosure
]

{ #category : #private }
LbSortGraph >> withSubsortRelations: aDictionary do: aBlockClosure [
	aDictionary keysAndValuesDo: [ :superSortName :subSortNames |
		subSortNames do: [ :subSortName |
			aBlockClosure value:
				(LbSubsortRelation new
					subsort: (self sortNamed: subSortName)
					supersort: (self sortNamed: superSortName) 
					origins: (origins
									at: { subSortName. superSortName }
									"ifAbsent: [ LbOrigins forCurrentContext ]")) ] ]
]

{ #category : #private }
LbSortGraph >> withSubsortRelationsDo: aBlockClosure [
	self withSubsortRelations: directSubsortsOf do: aBlockClosure
]
