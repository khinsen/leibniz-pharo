Class {
	#name : #LzOpTerm,
	#superclass : #LzTerm,
	#instVars : [
		'opName',
		'sort',
		'args'
	],
	#category : #'Leibniz2-Terms'
}

{ #category : #converting }
LzOpTerm >> addAsRopedTextTo: aRopedText [
	self isLeafErrorTerm
		ifFalse: [
			opName addForArgs: args asRopedTextTo: aRopedText.
			^ self ].
	self
		do: [ :t | opName addForArgs: args asRopedTextTo: t ]
		to: aRopedText
		withAttribute: LzLeafErrorAttribute new
]

{ #category : #accessing }
LzOpTerm >> args [
	^ args
]

{ #category : #accessing }
LzOpTerm >> args: anArray [
	args := anArray
]

{ #category : #egraphs }
LzOpTerm >> asENodeIn: anEGraph [
	| nArgs node |
	nArgs := self args size.
	nArgs = 0
		ifTrue: [ node := LzLeafENode new
							graph: anEGraph;
							leafTerm: self]
		ifFalse: [
			node := (LzOpENode new: nArgs)
						graph: anEGraph;
						opName: self opName;
						sort: self sort.
			1 to: nArgs do: [ :index |
				node
					at: index
					put: ((self args at: index)
							asENodeIn: anEGraph) ] ].
	^ anEGraph add: node
]

{ #category : #organizing }
LzOpTerm >> fingerprint [
	^ opName
]

{ #category : #inspecting }
LzOpTerm >> gtOperatorRanksFor: aView [
	<gtView>
	^ aView forward
		title: 'Operator ranks';
		priority: 7;
		object: [ self signature operators opForTerm: self ];
		view: #gtGraphFor:;
		yourself
]

{ #category : #accessing }
LzOpTerm >> hasInfixOpOtherThan: anOpName [
	^ opName isInfixOpOtherThan: anOpName
]

{ #category : #testing }
LzOpTerm >> hasSort [
	^ sort isKindOf: LzSort
]

{ #category : #testing }
LzOpTerm >> hasVars [
	^ args
		detect: #hasVars
		ifFound: [ true ]
		ifNone: [ false ]
]

{ #category : #testing }
LzOpTerm >> isBooleanTrue [
	^ self sort isBooleanSort
		and: [ self args isEmpty
			and: [ self opName asSymbol = LzConstants opNameTrue ] ]
]

{ #category : #testing }
LzOpTerm >> isInfix [
	^ opName isInfix
]

{ #category : #testing }
LzOpTerm >> isLeafErrorTerm [
	self sort isKind ifFalse: [ ^ false ].
	self args
		detect: [ :each | each sort isKind ]
		ifFound: [ ^ false ]
		ifNone: [ ^ true ]
]

{ #category : #unifying }
LzOpTerm >> match: otherTerm bindings: bindings [
	otherTerm matchOpTerm: self op: opName args: args bindings: bindings
]

{ #category : #egraphs }
LzOpTerm >> matchArrayENode: anOpENode  bindings: bindings [
	^ #()
]

{ #category : #unifying }
LzOpTerm >> matchArrayTerm: otherTerm elements: aTermList shape: anArray bindings: bindings [
	bindings failWith: self notUnifiableWith: otherTerm
]

{ #category : #egraphs }
LzOpTerm >> matchOpENode: anOpENode  bindings: bindings [
	^ (opName = anOpENode opName
		and: [ args size = anOpENode size])
		ifTrue: [ anOpENode graph
					matchesForPatterns: args
					withClassIds: anOpENode
					bindings: bindings ]
		ifFalse: [ #() ]
]

{ #category : #unifying }
LzOpTerm >> matchOpTerm: otherTerm op: anOpName args: anArgList bindings: bindings [
	(opName = anOpName and: [ args size = anArgList size ])
		ifTrue: [ anArgList with: args do: [ :arg1 :arg2 |
					arg1 match: arg2 bindings: bindings ] ]
		ifFalse: [ bindings failWith: self notUnifiableWith: otherTerm ]
]

{ #category : #accessing }
LzOpTerm >> opName [
	^ opName
]

{ #category : #accessing }
LzOpTerm >> opName: anOpName [
	opName := anOpName
]

{ #category : #printing }
LzOpTerm >> printAsLeibnizSyntaxOn: aStream [
	opName printForArgs: args on: aStream
]

{ #category : #accessing }
LzOpTerm >> sort [
	^ sort
]

{ #category : #accessing }
LzOpTerm >> sort: aSort [
	sort := aSort
]

{ #category : #unifying }
LzOpTerm >> substitute: bindings [
	| substitutedArgList |
	bindings hasNoBindings ifTrue: [ ^ self ].
	args ifEmpty: [ ^ self ].
	substitutedArgList := args collect: [ :arg | arg substitute: bindings ].
	^ signature opTerm: opName args: substitutedArgList
]

{ #category : #accessing }
LzOpTerm >> synopsis [
	^ self opName synopsis
]

{ #category : #unifying }
LzOpTerm >> unifyTagged: aSymbol with: otherTerm tagged: otherSymbol bindings: bindings [
	otherTerm
		unifyTagged: otherSymbol
		withOpTerm: self
		tagged: aSymbol
		op: opName args: args
		bindings: bindings.
]

{ #category : #unifying }
LzOpTerm >> unifyTagged: aSymbol withArrayTerm: otherTerm tagged: otherSymbol elements: aTermList shape: anArray bindings: bindings [
	bindings failWith: self notUnifiableWith: otherTerm
]

{ #category : #unifying }
LzOpTerm >> unifyTagged: aSymbol withAtomicTerm: otherTerm tagged: otherSymbol bindings: bindings [
	bindings failWith: self notUnifiableWith: otherTerm
]

{ #category : #unifying }
LzOpTerm >> unifyTagged: aSymbol withOpTerm: otherTerm tagged: otherSymbol op: anOpName args: anArgList bindings: bindings [
	(opName = anOpName and: [ args size = anArgList size ])
		ifTrue: [ anArgList with: args do: [ :arg1 :arg2 |
					arg1
						unifyTagged: otherSymbol
						with: arg2
						tagged: aSymbol
						bindings: bindings ] ]
		ifFalse: [ bindings failWith: self notUnifiableWith: otherTerm ]
]

{ #category : #accessing }
LzOpTerm >> valueSlots [
	^ #(opName args)
]

{ #category : #accessing }
LzOpTerm >> vars [
	^ args
		inject: Dictionary new
		into: [ :total :each | total union: each vars ]
]

{ #category : #transforming }
LzOpTerm >> withTransformedArgs: anArgList [
	anArgList ifEmpty: [ ^ self ].
	^ signature opTerm: opName args: anArgList
]
