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
		'kindOf',
		'anySortKind'
	],
	#category : #'Leibniz2-Sorts'
}

{ #category : #accessing }
LzSortGraph >> anySortKind [
	^ anySortKind
]

{ #category : #constructing }
LzSortGraph >> arraySortFor: elementSort shape: shape [
	| signature term shapeTerms |
	signature := self sortContext signature.
	shapeTerms := (shape collect: [ :each |
					LzRationalNumberTerm signature: signature value: each ]).
	term := elementSort
		ifNil:  [
			signature
				opTerm: (LzPrefixOpName for: #EmptyArray)
				args: shapeTerms ]
		ifNotNil: [
			signature
				opTerm: (LzPrefixOpName for: #Array)
				args: { elementSort term }, shapeTerms ].
	^ self sortWithTerm: term
]

{ #category : #accessing }
LzSortGraph >> axiomsConnecting: aFamily to: anotherFamily [
	^ connectingAxioms
		at: { aFamily. anotherFamily }
		ifAbsent: [ #() ]
]

{ #category : #accessing }
LzSortGraph >> breadthFirstTraversalFrom: aSort childNodes: childNodeBlock nodesDo: nodeActionBlock edgesDo: edgeActionBlock [
	| visitedNodes currentNodes distance nodesToVisit |
	visitedNodes := Set new.
	currentNodes := Set with: aSort.
	distance := 1.
	[ currentNodes isNotEmpty ] whileTrue: [
		nodesToVisit := Set new.
		currentNodes do: [ :eachNode |
			(childNodeBlock value: eachNode) do: [ :each |
				edgeActionBlock cull: eachNode cull: each cull: distance.
				(visitedNodes includes: each) ifFalse: [
					nodesToVisit add: each.
					nodeActionBlock cull: each cull: distance.
					visitedNodes add: each ] ] ].
		currentNodes := nodesToVisit.
		distance := distance + 1 ]
]

{ #category : #copying }
LzSortGraph >> copy [
	^ self
]

{ #category : #copying }
LzSortGraph >> deepCopy [
	^ self
]

{ #category : #accessing }
LzSortGraph >> directSubFamiliesOf: aSortFamily [
	^ directSubFamilies at: aSortFamily.
]

{ #category : #accessing }
LzSortGraph >> directSubsortsOf: aSortTerm [
	| subsorts family sortArgs argDirectSubsorts |
	subsorts := Set new.
	family := self familyForSortTerm: aSortTerm.
	family = anySortFamily ifTrue: [ ^ subsorts ].
	"First step: subsorts via the sort family graph."
	(directSubFamilies at: family) do: [ :eachSubFamily |
		(connectingAxioms at: { eachSubFamily. family }) do: [ :eachAxiom |
			(eachAxiom subsortOf: aSortTerm inSortGraph: self)
				ifNotNil: [ :term | subsorts add: (self sortWithTerm: term) ]] ].
	"Second step: subsorts via argument subsorts."
	self flag: #contravariant.
	sortArgs := aSortTerm args.
	argDirectSubsorts :=
		sortArgs with: family contravarianceFlags collect: [ :eachSort :eachFlag |
			eachSort sort isSortSort
				ifTrue: [ (eachFlag = $1
							ifTrue: (self directSupersortsOf: eachSort)
							ifFalse: (self directSubsortsOf: eachSort))
								collect: #term ]
				ifFalse: [ Set new ] ].
	1 to: sortArgs size do: [ :index |
		(argDirectSubsorts at: index) do: [ :eachArgSs |
			| ssArgs term |
			ssArgs := sortArgs copy.
			ssArgs at: index put: eachArgSs.
			term := self sortContext signature
						opTerm: aSortTerm opName args: ssArgs.
			subsorts add: (self sortWithTerm: term) ] ].
	^ subsorts
]

{ #category : #accessing }
LzSortGraph >> directSuperFamiliesOf: aSortFamily [
	^ directSuperFamilies at: aSortFamily.
]

{ #category : #accessing }
LzSortGraph >> directSupersortsOf: aSortTerm [
	| supersorts family sortArgs argDirectSupersorts |
	supersorts := Set new.
	family := self familyForSortTerm: aSortTerm.
	family = anySortFamily ifTrue: [ ^ supersorts ].
	"First step: supersorts via the sort family graph."
	(directSuperFamilies at: family) do: [ :eachSuperFamily |
		(connectingAxioms at: { family. eachSuperFamily }) do: [ :eachAxiom |
			(eachAxiom supersortOf: aSortTerm inSortGraph: self)
				ifNotNil: [ :term | supersorts add: (self sortWithTerm: term) ]] ].
	"Second step: supersorts via argument supersorts."
	self flag: #contravariant.
	sortArgs := aSortTerm args.
	argDirectSupersorts :=
		sortArgs with: family contravarianceFlags collect: [ :eachSort :eachFlag |
			eachSort sort isSortSort
				ifTrue: [ (eachFlag = $1
							ifTrue: (self directSubsortsOf: eachSort)
							ifFalse: (self directSupersortsOf: eachSort))
								collect: #term ]
				ifFalse: [ Set new ] ].
	1 to: sortArgs size do: [ :index |
		(argDirectSupersorts at: index) do: [ :eachArgSs |
			| ssArgs term |
			ssArgs := sortArgs copy.
			ssArgs at: index put: eachArgSs.
			term := self sortContext signature
						opTerm: aSortTerm opName args: ssArgs.
			supersorts add: (self sortWithTerm: term) ] ].
	^ supersorts
]

{ #category : #initializing }
LzSortGraph >> familyForParsedOp: anOpDeclaration [
	^ sortFamilies at: (sortContext signature operators findOp: anOpDeclaration)
]

{ #category : #initializing }
LzSortGraph >> familyForSortTerm: aTerm [
	^ aTerm isVarTerm
		ifTrue: [ anySortFamily ]
		ifFalse: [ sortFamilies at: (sortContext signature operators opForTerm: aTerm) ]
]

{ #category : #inspecting }
LzSortGraph >> graphFor: aView highlight: aBlock [
	^ aView mondrian
		title: 'Graph';
		priority: 0;
		initialize: (self mondrianForFamilies: sortFamilies highlight: aBlock)
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
	^ aView explicit
		title: 'Graph';
		priority: 0;
		stencil: [
			| pane |
			pane := BrVerticalPane new
				vFitContent;
				hMatchParent.
			self kinds do: [ :each |
				pane addChild:
					((LzSyntaxLabel for: each) asElement
						padding: (BlInsets all: 10);
						when: BlClickEvent do: [ :event |
							event target phlow spawnObject: each ]).
				pane addChild:
					((self
						mondrianForFamilies: each sortFamilies
						highlight: [ false ]) asElement
							constraintsDo: [ :c |
								c horizontal matchParent.
								c vertical fitContent ]) ].
			pane asScrollableElement ].
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
			subsort = supersort ifFalse: [
				(directSubFamilies at: supersort) add: subsort.
				(directSuperFamilies at: subsort) add: supersort.
				(connectingAxioms at: { subsort. supersort }
					ifAbsentPut: [ Set new ])
					add: each.
				connectingPaths at: { subsort. supersort }
					put: (Set with: (OrderedCollection with: { subsort. supersort }))] ] ].
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
	anySortKind :=
		LzKind new
			sortGraph: self;
			sortFamilies: (Set with: anySortFamily);
			maximalFamilies: (Set with: anySortFamily).
	kinds := Set with: anySortKind.
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

{ #category : #lookup }
LzSortGraph >> kindOf: aSortOrFamily [
	^ kindOf at: aSortOrFamily family
]

{ #category : #accessing }
LzSortGraph >> kinds [
	^ kinds reject: [ :each |
		each = self anySortKind and: [ each size = 1 ] ]
]

{ #category : #inspecting }
LzSortGraph >> mondrianForFamilies: families highlight: aBlock [
	| displayedFamilies aMondrian |
	displayedFamilies := families copyWithout: anySortFamily.
	aMondrian := GtMondrian new.
	aMondrian nodes
		shape: [ :x | self graphNodeForSort: x highlight: (aBlock cull: x) ];
		with: displayedFamilies.
	aMondrian edges
		shape: [ :x | LzGraphicsElements graphArrow ];
		fromCenterTop;
		toCenterBottom;
		connect: connectingAxioms values
			from: [ :each | self familyForSortTerm: each anyOne subsort ]
			to: [ :each | self familyForSortTerm: each anyOne supersort ].
	aMondrian layout
		custom: (GtGradVerticalDominanceTreeLayout new reverse: true).
	^ aMondrian
]

{ #category : #constructing }
LzSortGraph >> normalizedSortWithTerm: aTerm [
	^ LzSort new
		sortGraph: self;
		term: (sortContext reduce: aTerm);
		beRecursivelyReadOnlyObject;
		yourself
]

{ #category : #constructing }
LzSortGraph >> parsedSort: anASTPatternNode [
	^ self sortWithTerm:
		(anASTPatternNode buildFor: self sortContext signature)
]

{ #category : #constructing }
LzSortGraph >> parsedSort: anASTTermNode variables: aDictionary [
	^ self sortWithTerm:
		(anASTTermNode
			buildFor: self sortContext signature
			variables: aDictionary)
]

{ #category : #accessing }
LzSortGraph >> pathsConnecting: aFamily to: anotherFamily [
	^ connectingPaths
		at: { aFamily. anotherFamily }
		ifAbsent: (Set new)
]

{ #category : #constructing }
LzSortGraph >> simpleSort: aSymbol [
	| opName term |
	opName := LzPrefixOpName for: aSymbol.
	term := self sortContext signature opTerm: opName args: #().
	^ self sortWithTerm: term
]

{ #category : #constructing }
LzSortGraph >> sort: aString [
	^ self parsedSort:
		(LzDeclarationBuilder new acceptNode:
			(LzParser2
				parse: aString
				startingAt: LzParser2 startingStateForTopLevelTerm))
				declaration
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
	^ #(sortContext sortDeclarations subsortDeclarations)
]
