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
	node := (LzOpENode new: nArgs)
				graph: anEGraph;
				opName: self opName;
				sort: self sort.
	1 to: nArgs do: [ :index |
		node
			at: index
			put: ((self args at: index)
					asENodeIn: anEGraph) ].
	^ anEGraph add: node
]

{ #category : #organizing }
LzOpTerm >> fingerprint [
	^ opName
]

{ #category : #accessing }
LzOpTerm >> hasInfixOpOtherThan: anOpName [
	^ opName isInfixOpOtherThan: anOpName
]

{ #category : #testing }
LzOpTerm >> hasVars [
	^ args
		detect: #hasVars
		ifFound: [ true ]
		ifNone: [ false ]
]

{ #category : #testing }
LzOpTerm >> isInfix [
	^ opName isInfix
]

{ #category : #unifying }
LzOpTerm >> match: otherTerm bindings: bindings [
	otherTerm matchOpTerm: self op: opName args: args bindings: bindings
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
