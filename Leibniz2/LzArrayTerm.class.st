Class {
	#name : #LzArrayTerm,
	#superclass : #LzTerm,
	#instVars : [
		'elements',
		'shape',
		'sort'
	],
	#category : #'Leibniz2-Terms'
}

{ #category : #'instance creation' }
LzArrayTerm class >> signature: aSignature value: anArray [
]

{ #category : #transforming }
LzArrayTerm >> applyFn: aTerm reducer: aBlock [
	| transformedElements |
	transformedElements := elements collect: [ :each |
		aBlock value:
			(self signature
				opTerm: LzBracketOpName new
				args: { aTerm. each }) ].
	^ self signature
		arrayTerm: transformedElements
		shape: self shape
]

{ #category : #accessing }
LzArrayTerm >> args [
	^ elements
]

{ #category : #egraphs }
LzArrayTerm >> asENodeIn: anEGraph [
	| node |
	node := (LzArrayENode new: self elements size)
				graph: anEGraph;
				shape: self shape;
				sort: self sort.
	1 to: node size do: [ :index |
		node
			at: index
			put: ((self elements at: index)
					asENodeIn: anEGraph) ].
	^ anEGraph add: node
]

{ #category : #accessing }
LzArrayTerm >> elements [
	^ elements
]

{ #category : #accessing }
LzArrayTerm >> elements: anArray [
	elements := anArray
]

{ #category : #testing }
LzArrayTerm >> ensureArrayTerm [
]

{ #category : #organizing }
LzArrayTerm >> fingerprint [
	^ #array
]

{ #category : #transforming }
LzArrayTerm >> inject: aTerm into: aFnTerm [
	| transformedElements |
	^ elements inject: aTerm into: [ :total :each |
		self signature
			opTerm: LzBracketOpName new
			args: { aFnTerm. total. each }]
]

{ #category : #transforming }
LzArrayTerm >> inject: aTerm into: aFnTerm reducer: aBlock [
	| transformedElements |
	^ elements inject: aTerm into: [ :total :each |
		aBlock value:
			(self signature
				opTerm: LzBracketOpName new
				args: { aFnTerm. total. each })]
]

{ #category : #unifying }
LzArrayTerm >> match: otherTerm bindings: bindings [
	otherTerm matchArrayTerm: self elements: elements shape: shape bindings: bindings
]

{ #category : #egraphs }
LzArrayTerm >> matchArrayENode: anArrayENode  bindings: bindings [
	^ (shape = anArrayENode shape
		and: [ self elements size = anArrayENode size])
		ifTrue: [ anArrayENode graph
					matchesForPatterns: self elements
					withClassIds: anArrayENode
					bindings: bindings ]
		ifFalse: [ #() ]
]

{ #category : #unifying }
LzArrayTerm >> matchArrayTerm: otherTerm elements: aTermList shape: anArray bindings: bindings [
	(shape = anArray and: [ elements size = aTermList size ])
		ifTrue: [ aTermList with: elements do: [ :arg1 :arg2 |
					arg1 match: arg2 bindings: bindings ] ]
		ifFalse: [ bindings failWith: self notUnifiableWith: otherTerm ]
]

{ #category : #egraphs }
LzArrayTerm >> matchOpENode: anOpENode  bindings: bindings [
	^ #()
]

{ #category : #unifying }
LzArrayTerm >> matchOpTerm: otherTerm op: anOpName args: anArgList bindings: bindings [
	bindings failWith: self notUnifiableWith: otherTerm
]

{ #category : #printing }
LzArrayTerm >> printAsLeibnizSyntaxOn: aStream [
	aStream nextPut: ${.
	self printElements: self elements shape: self shape on: aStream.
	aStream nextPut: $}
]

{ #category : #printing }
LzArrayTerm >> printElements: anArray shape: shapeArray on: aStream [
	| elementShape elementSize index |
	elementShape := shapeArray allButFirst.
	elementSize := elementShape inject: 1 into: [ :product :each | product * each ].
	index := 1.
	aStream << $[.
	1 to: shapeArray first do: [ :each |
		elementShape
			ifEmpty: [ (anArray at: index) printAsLeibnizSyntaxOn: aStream ]
			ifNotEmpty: [
				self
					printElements: (anArray copyFrom: index to: index + elementSize - 1)
					shape: elementShape on: aStream ].
		index := index + elementSize.
		index > anArray size ifFalse: [ aStream << ', ' ] ].
	aStream << $]
]

{ #category : #accessing }
LzArrayTerm >> shape [
	^ shape
]

{ #category : #accessing }
LzArrayTerm >> shape: anArray [
	self assert: anArray isNotEmpty.
	shape := anArray
]

{ #category : #accessing }
LzArrayTerm >> shapeAsArrayTerm [
	^ self signature
		arrayTerm: (self shape collect: [ :each |
						LzIntegerTerm signature: self signature value: each])
		shape: { self shape size }
]

{ #category : #accessing }
LzArrayTerm >> sort [
	^ sort
]

{ #category : #accessing }
LzArrayTerm >> sort: aSort [
	sort := aSort
]

{ #category : #unifying }
LzArrayTerm >> substitute: bindings [
	| substitutedElements |
	bindings hasNoBindings ifTrue: [ ^ self ].
	self elements ifEmpty: [ ^ self ].
	substitutedElements := self elements collect: [ :each | each substitute: bindings ].
	^ signature arrayTerm: substitutedElements shape: self shape
]

{ #category : #unifying }
LzArrayTerm >> unifyTagged: aSymbol with: otherTerm tagged: otherSymbol bindings: bindings [
	otherTerm
		unifyTagged: otherSymbol
		withArrayTerm: self
		tagged: aSymbol
		elements: self elements
		shape: self shape
		bindings: bindings.
]

{ #category : #unifying }
LzArrayTerm >> unifyTagged: aSymbol withArrayTerm: otherTerm tagged: otherSymbol elements: aTermList shape: anArray bindings: bindings [
	(shape = anArray and: [ self elements size = aTermList size ])
		ifTrue: [ aTermList with: self elements do: [ :arg1 :arg2 |
					arg1
						unifyTagged: otherSymbol
						with: arg2
						tagged: aSymbol
						bindings: bindings ] ]
		ifFalse: [ bindings failWith: self notUnifiableWith: otherTerm ]
]

{ #category : #unifying }
LzArrayTerm >> unifyTagged: aSymbol withAtomicTerm: otherTerm tagged: otherSymbol bindings: bindings [
	bindings failWith: self notUnifiableWith: otherTerm
]

{ #category : #unifying }
LzArrayTerm >> unifyTagged: aSymbol withOpTerm: otherTerm tagged: otherSymbol op: anOpName args: anArgList bindings: bindings [
	bindings failWith: self notUnifiableWith: otherTerm
]

{ #category : #accessing }
LzArrayTerm >> valueSlots [
	^ #(elements shape)
]

{ #category : #transforming }
LzArrayTerm >> with: otherArrayTerm applyFn: aTerm [
	| transformedElements |
	self assert: self shape equals: otherArrayTerm shape.
	transformedElements := elements with: otherArrayTerm elements collect: [ :arg1 :arg2 |
		self signature
			opTerm: LzBracketOpName new
			args: { aTerm. arg1. arg2 } ].
	^ self signature
		arrayTerm: transformedElements
		shape: self shape
]

{ #category : #transforming }
LzArrayTerm >> with: otherArrayTerm applyFn: aTerm reducer: aBlock [
	| transformedElements |
	self assert: self shape equals: otherArrayTerm shape.
	transformedElements := elements with: otherArrayTerm elements collect: [ :arg1 :arg2 |
		aBlock value:
			(self signature
				opTerm: LzBracketOpName new
				args: { aTerm. arg1. arg2 }) ].
	^ self signature
		arrayTerm: transformedElements
		shape: self shape
]

{ #category : #accessing }
LzArrayTerm >> withTransformedArgs: transformedElements [
	^ signature arrayTerm: transformedElements shape: self shape
]
