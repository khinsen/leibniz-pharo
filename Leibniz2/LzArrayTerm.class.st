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

{ #category : #converting }
LzArrayTerm >> addAsRopedTextTo: aRopedText [
	aRopedText append: '{' asRopedText.
	self addElementsOf: self elements shape: self shape asRopedTextTo: aRopedText.
	aRopedText append: '}' asRopedText.
]

{ #category : #converting }
LzArrayTerm >> addElementsOf: anArray shape: shapeArray asRopedTextTo: aRopedText [
	| elementShape elementSize index |
	elementShape := shapeArray allButFirst.
	elementSize := elementShape inject: 1 into: [ :product :each | product * each ].
	index := 1.
	aRopedText append: '[' asRopedText.
	1 to: shapeArray first do: [ :each |
		elementShape
			ifEmpty: [ (anArray at: index) addAsRopedTextTo: aRopedText ]
			ifNotEmpty: [
				self
					addElementsOf: (anArray copyFrom: index to: index + elementSize - 1)
					shape: elementShape asRopedTextTo: aRopedText ].
		index := index + elementSize.
		index > anArray size ifFalse: [ aRopedText append: ', ' asRopedText ] ].
	aRopedText append: ']' asRopedText
]

{ #category : #transforming }
LzArrayTerm >> append: anArrayTerm [
	| shapeFirst shapeRest |
	shapeFirst := self shape first + anArrayTerm shape first.
	shapeRest := self shape allButFirst.
	self assert: anArrayTerm shape allButFirst equals: shapeRest.
	^ self signature
		arrayTerm: elements, anArrayTerm elements
		shape: { shapeFirst }, shapeRest
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

{ #category : #private }
LzArrayTerm >> elementsForSlice: slice1 slice: slice2 [
	| first1 last1 step1 first2 last2 step2
	  size1 size2
	  sliceElementSize sliceElements sliceIndex |
	first1 := slice1 first value.
	last1 := slice1 second value.
	step1 := slice1 third value.
	first2 := slice2 first value.
	last2 := slice2 second value.
	step2 := slice2 third value.
	self assert: self shape size == 2.
	self assert: first1 >= 1.
	self assert: last1 <= self shape first.
	self assert: step1 >= 1.
	self assert: first2 >= 1.
	self assert: last2 <= self shape second.
	self assert: step2 >= 1.
	size1 := (last1 - first1) // step1 + 1.
	size2 := (last2 - first2) // step2 + 1.
	sliceElementSize := size1 * size2.
	sliceElements := Array new: sliceElementSize.
	sliceIndex := 1.
	first1 to: last1 by: step1 do: [ :index1 |
		first2 to: last2 by: step2 do: [ :index2 |	
			sliceElements
				at: sliceIndex
				put: (elements at: (index1 - 1) * self shape second + index2).
			sliceIndex := sliceIndex + 1 ] ].
	^ { sliceElements . size1 . size2 }
]

{ #category : #rewriting }
LzArrayTerm >> ensureArrayTerm [
]

{ #category : #organizing }
LzArrayTerm >> fingerprint [
	^ #array
]

{ #category : #transforming }
LzArrayTerm >> index: anInteger [
	self assert: self shape size == 1.
	^ elements
		at: anInteger value
		ifAbsent: [ LzRewriteFailure signal: 'index ', anInteger asString, ' out of range' ]
]

{ #category : #transforming }
LzArrayTerm >> index: index1 index: index2 [
	| i1 i2 |
	self assert: self shape size == 2.
	i1 := index1 value.
	i2 := index2 value.
	(i1 < 0 or: [ i1 > shape first
		or: [ i2 < 0 or: [ i2 > shape second ] ]])
		ifTrue: [ LzRewriteFailure signal:
					'index ', { i1 . i2 } asString, ' out of range' ].
	^ elements at: ((i1-1) * shape second) + i2
]

{ #category : #transforming }
LzArrayTerm >> index: index1 slice: slice2 [
	| data sliceElements size2 |
	data := self elementsForSlice: { index1 . index1 . 1 } slice: slice2.
	sliceElements := data first.
	size2 := data third.
	^ self signature
		arrayTerm: sliceElements
		shape: { size2 }
]

{ #category : #transforming }
LzArrayTerm >> inject: aTerm into: aFnTerm [
	^ elements inject: aTerm into: [ :total :each |
		self signature
			opTerm: LzBracketOpName new
			args: { aFnTerm. total. each }]
]

{ #category : #transforming }
LzArrayTerm >> inject: aTerm into: aFnTerm reducer: aBlock [
	^ elements inject: aTerm into: [ :total :each |
		aBlock value:
			(self signature
				opTerm: LzBracketOpName new
				args: { aFnTerm. total. each })]
]

{ #category : #testing }
LzArrayTerm >> isLeafErrorTerm [
	self sort isKind ifFalse: [ ^ false ].
	self elements
		detect: [ :each | each sort isKind ]
		ifFound: [ ^ false ]
		ifNone: [ ^ true ]
]

{ #category : #accessing }
LzArrayTerm >> lengthAsTerm [
	^ self signature integerTerm: shape first
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

{ #category : #transforming }
LzArrayTerm >> slice: slice1 index: index2 [
	| data sliceElements size1 |
	data := self elementsForSlice: slice1 slice: { index2 . index2 . 1 }.
	sliceElements := data first.
	size1 := data second.
	^ self signature
		arrayTerm: sliceElements
		shape: { size1 }
]

{ #category : #transforming }
LzArrayTerm >> slice: slice1 slice: slice2 [
	| data sliceElements size1 size2 |
	data := self elementsForSlice: slice1 slice: slice2.
	sliceElements := data first.
	size1 := data second.
	size2 := data third.
	^ self signature
		arrayTerm: sliceElements
		shape: { size1 . size2 }
]

{ #category : #transforming }
LzArrayTerm >> slice: first to: last by: step [
	| sliceElementSize sliceElements sliceIndex |
	self assert: self shape size == 1.
	self assert: step value >= 1.
	sliceElementSize := (last value - first value) // step value + 1.
	sliceElements := Array new: sliceElementSize.
	sliceIndex := 1.
	first value to: last value by: step value do: [ :arrayIndex |
		sliceElements at: sliceIndex put: (elements at: arrayIndex).
		sliceIndex := sliceIndex + 1 ].
	^ self signature
		arrayTerm: sliceElements
		shape: { sliceElementSize }
]

{ #category : #transforming }
LzArrayTerm >> sliceToEndFrom: first by: step [
	| last |
	self assert: self shape size == 1.
	last := self shape first.
	^ self slice: first to: last by: step
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
