Class {
	#name : #LzTermBuilder,
	#superclass : #LzParseTreeNodeVisitor,
	#instVars : [
		'signature',
		'variables'
	],
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #private }
LzTermBuilder >> arrayElementsFor: anArray [
	^ anArray collect: [ :each |
		(each isKindOf: LzArrayElementsNode)
			ifTrue: [ self arrayElementsFor: each elements ]
			ifFalse: [ each ] ]
]

{ #category : #private }
LzTermBuilder >> arrayShapeFor: anArray [
	| subshapes |
	anArray ifEmpty: [ ^ #(0) ].
	subshapes := anArray collect: [ :each |
		each isCollection
			ifTrue: [ self arrayShapeFor: each ]
			ifFalse: [ #() ] ].
	self flag: #todo. "Try to move the check into the parser."
	subshapes asSet size = 1 ifFalse: [ self error: 'Subarray shapes do not match' ].
	^ { anArray size }, subshapes first
]

{ #category : #constructing }
LzTermBuilder >> build: aTermNode [
	^ self acceptNode: aTermNode
]

{ #category : #accessing }
LzTermBuilder >> signature [
	^ signature
]

{ #category : #accessing }
LzTermBuilder >> signature: aSignature [
	signature := aSignature
]

{ #category : #accessing }
LzTermBuilder >> variables [
	^ variables
]

{ #category : #accessing }
LzTermBuilder >> variables: aDictionary [
	variables := aDictionary
]

{ #category : #visiting }
LzTermBuilder >> visitArrayTerm: anArrayTerm [
	| shape elements |
	elements := self arrayElementsFor: anArrayTerm arrayElements elements.
	shape := self arrayShapeFor: elements.
	^ signature
		arrayTerm: (elements flattened collect: [ :each |
						self build: each ])
		shape: shape
]

{ #category : #visiting }
LzTermBuilder >> visitBracketOpTerm: aBracketOpTerm [
	^ signature
		opTerm: LzBracketOpName new
		args: (aBracketOpTerm args collect: [ :each | self build: each ])
]

{ #category : #visiting }
LzTermBuilder >> visitFpNumberLiteralTerm: aFpNumberLiteralTerm [
	| value |
	"Pharo doesn't allow a dot followed by an exponent without any fractional part.
	Workaround: replace '.e' by '.0e'"
	value := (aFpNumberLiteralTerm text value
				copyReplaceAll: '.e' with: '.0e')
				asNumber asFloat.
	^ self signature
		literalTerm: value
		class: LzFloatingPointNumberTerm
		builtin: #floatingPointNumbers
]

{ #category : #visiting }
LzTermBuilder >> visitInfixOpTerm: anInfixOpTerm [
	| opNames opName args |
	opNames := anInfixOpTerm opNames collect: #value.
	self assert: opNames asSet size equals: 1.
	args := anInfixOpTerm args collect: [ :each | self build: each ].
	opName := LzInfixOpName for: opNames anyOne asSymbol.
	^ args allButFirst inject: args first into: [ :total :each |
		signature opTerm: opName args: { total. each } ]
]

{ #category : #visiting }
LzTermBuilder >> visitIntegerLiteralTerm: anIntegerLiteralTerm [
	| value |
	value := anIntegerLiteralTerm text value asNumber.
	^ self signature
		literalTerm: value
		class: LzIntegerTerm
		builtin: #integers
]

{ #category : #visiting }
LzTermBuilder >> visitParseTree: aParseTree [
	self error: 'Not a term: ', aParseTree value
]

{ #category : #visiting }
LzTermBuilder >> visitPrefixOpTerm: aPrefixOpTerm [
	^ signature
		opTerm: (LzPrefixOpName for: aPrefixOpTerm opName value asSymbol)
		args: (aPrefixOpTerm args collect: [ :each | self build: each ])
]

{ #category : #visiting }
LzTermBuilder >> visitRationalNumberLiteralTerm: aRationalNumberLiteralTerm [
	| value |
	value := Fraction readFromString: aRationalNumberLiteralTerm text value.
	^ self signature
		literalTerm: value
		class: LzRationalNumberTerm
		builtin: #rationalNumbers
]

{ #category : #visiting }
LzTermBuilder >> visitStringLiteralTerm: aStringLiteralTerm [
	| value |
	value := aStringLiteralTerm text value allButFirst allButLast.
	^ self signature
		literalTerm: value
		class: LzStringTerm
		builtin: #strings
]

{ #category : #visiting }
LzTermBuilder >> visitSubscriptOpTerm: aBracketOpTerm [
	^ signature
		opTerm: LzSubscriptOpName new
		args: (aBracketOpTerm args collect: [ :each | self build: each ])
]

{ #category : #visiting }
LzTermBuilder >> visitSuperscriptOpTerm: aBracketOpTerm [
	^ signature
		opTerm: LzSuperscriptOpName new
		args: (aBracketOpTerm args collect: [ :each | self build: each ])
]

{ #category : #visiting }
LzTermBuilder >> visitVarTerm: aVarTerm [
	^ signature
		varTerm: (LzVarName for: aVarTerm opName value)
		variables: self variables
]
