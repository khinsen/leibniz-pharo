Class {
	#name : #LzEGraph,
	#superclass : #Object,
	#instVars : [
		'disjointSets',
		'memo',
		'classes',
		'classIdsNeedingRebuild',
		'signature'
	],
	#category : #'Leibniz2-EGraphs'
}

{ #category : #accessing }
LzEGraph >> add: anENode [
	| classId class |
	(self findClassIdFor: anENode)
		ifNotNil: [ :id | ^ id ].
	classId := disjointSets makeSet.
	class := LzEClass new
				addNode: anENode.
	anENode do: [ :child |
		(classes at: child) addParentNode: anENode classId: classId ].
	classes at: classId put: class.
	memo at: anENode put: classId.
	^ classId
]

{ #category : #enumerating }
LzEGraph >> allTerms [
	^ Generator on: [ :generator |
		self classes do: [ :each |
			each allTerms do: [ :eachTerm | generator yield: eachTerm ] ] ]
]

{ #category : #accessing }
LzEGraph >> canonicalize: anENode [
	anENode canonicalizeIn: self
]

{ #category : #accessing }
LzEGraph >> classForId: anInteger [
	^ classes at: anInteger
]

{ #category : #accessing }
LzEGraph >> classes [
	^ classes values
]

{ #category : #accessing }
LzEGraph >> findClassIdFor: anENode [
	self canonicalize: anENode.
	^ memo at: anENode
		ifPresent: [ :id | self findRootFor:  id ]
		ifAbsent: [ nil ]
]

{ #category : #accessing }
LzEGraph >> findRootFor: anEClassId [
	^ disjointSets findRootFor: anEClassId
]

{ #category : #inspecting }
LzEGraph >> gtClassesFor: aView [
	<gtView>
	| eClasses |
	eClasses := classes values.
	eClasses ifEmpty: [ ^ aView empty ].
	^ aView list
		title: 'Classes';
		priority: 0;
		items: eClasses;
		yourself
]

{ #category : #inspecting }
LzEGraph >> gtGraphFor: aView [
	<gtView>
	| eClasses |
	eClasses := self classes.
	eClasses ifEmpty: [ ^ aView empty ].
	^ aView mondrian
		title: 'Graph';
		priority: 1;
		painting: [ :view |
			| edges |
			edges := OrderedCollection new.
			view nodes
				shape: [ :eClass |
					| el |
					el := BlElement new
						border: (BlBorder paint: Color black);
						padding: (BlInsets all: 5);
						constraintsDo: [ :c |
							c horizontal fitContent.
							c vertical fitContent ].
					el addChild: (LzCodeFont brLabelFor: eClass sort asLeibnizSyntaxString).
					el addChild:
						(BlElement new
							border: (BlBorder paint: Color gray);
							constraintsDo: [ :c |
								c horizontal matchParent.
								c vertical exact: 1 ]).
					el ] ;
				with: eClasses;
				forEach: [ :eachEClass |
					view nodes
						shape: [ :eachENode |
							LzCodeFont brLabelFor: eachENode asLeibnizSyntaxString ];
						with: eachEClass nodes.
					edges addAll:
						(eachEClass nodes flatCollect: [ :eachENode |
							eachENode collect: [ :eachClassId |
								eachENode -> (classes at: eachClassId) ] ]).
					view layout vertical ].
			view edges
				connectAssociations: edges;
				shape: [ :x | LzGraphicsElements graphArrow ].
			view layout force
				strength: 0.15;
				charge: -250;
				length: 70 ]
]

{ #category : #inspecting }
LzEGraph >> gtTermsFor: aView [
	<gtView>
	^ aView forward
		title: 'Terms';
		priority: 3;
		object: [ LzTermGeneratorView new generator: self allTerms ];
		view: #gtTermsFor:;
		yourself
]

{ #category : #accessing }
LzEGraph >> initialize [
	disjointSets := LzDisjointIntegerSets new.
	memo := Dictionary new.
	classes := Dictionary new.
	classIdsNeedingRebuild := OrderedCollection new.
]

{ #category : #matching }
LzEGraph >> matchesFor: aPattern [
	^ Generator on: [ :generator |
		classes keysAndValuesDo: [ :classId :class |
			class nodes do: [ :eachNode |
				(eachNode
					matchesFor: aPattern
					bindings: LzBindings new)
					do: [ :bindings |
						generator yield: { bindings. classId } ] ] ] ]
]

{ #category : #matching }
LzEGraph >> matchesForPatterns: patterns withClassIds: classIds bindings: bindings [
	patterns ifEmpty: [ ^ { bindings } ].
	^ Generator on: [ :generator |
		(classes at: classIds first) nodes do: [ :eachNode |
			(eachNode
				matchesFor: patterns first
				bindings: bindings copy)
				do: [ :b1 |
					b1 ifSuccess: [
						(self
							matchesForPatterns: patterns allButFirst
							withClassIds: classIds allButFirst
							bindings: b1)
							do: [ :b2 | b2 ifSuccess: [ generator yield: b2 ] ] ] ] ] ]
]

{ #category : #accessing }
LzEGraph >> merge: anEClassId with: otherEClassId [
	| root1 root2 mergedId staleId mergedClass staleClass |
	root1 := self findRootFor: anEClassId.
	root2 := self findRootFor: otherEClassId.
	root1 = root2 ifTrue: [ ^ self ].
	mergedId := disjointSets merge: root1 with: root2.
	staleId := mergedId = root2
				ifTrue: [ root1 ] ifFalse: [ root2 ].
	"Transfer nodes from staleClass to mergedClass"
	mergedClass := classes at: mergedId.
	staleClass := classes at: staleId.
	mergedClass addNodes: staleClass nodes.
	staleClass nodesDo: [ :each |
		memo removeKey: each.
		self canonicalize: each.
		memo at: each put: mergedId ].
	staleClass parentsDo: [ :node :id | 
		self canonicalize: node.
		mergedClass addParentNode: node classId: id ].
	classes removeKey: staleId.
	"Put the merged class on the todo list for the next rebuild."
	classIdsNeedingRebuild add: mergedId
]

{ #category : #rebuilding }
LzEGraph >> rebuild [
	[ classIdsNeedingRebuild isEmpty ] whileFalse: [
		| todo |
		todo := classIdsNeedingRebuild collect: [ :each |
			self findRootFor:  each ].
		classIdsNeedingRebuild := OrderedCollection new.
		todo do: [ :each | self repair: each ] ]
]

{ #category : #rebuilding }
LzEGraph >> repair: aClassId [
	| class newParents |
	class := classes at: aClassId.
	class parentsDo: [ :node :id |
		memo removeKey: node.
		self canonicalize:  node.
		memo at: node put: (self findRootFor:  id) ].
	newParents := Dictionary new.
	class parentsDo: [ :node :id |
		(newParents includesKey: node)
			ifTrue: [ self merge: id with: (newParents at: node)].
		newParents at: node put: (self findRootFor: id) ].
	class clearParents.
	newParents keysAndValuesDo: [ :node :id |
		class addParentNode: node classId: id ].
	class removeDuplicateNodes
]

{ #category : #accessing }
LzEGraph >> signature [
	^ signature
]

{ #category : #accessing }
LzEGraph >> signature: aSignature [
	signature := aSignature
]
