Class {
	#name : #LzStepTerm,
	#superclass : #LzTerm,
	#instVars : [
		'steps',
		'sort'
	],
	#category : #'Leibniz2-Terms'
}

{ #category : #converting }
LzStepTerm >> addAsRopedTextTo: aRopedText [
	aRopedText append: '{. ' asRopedText.
	1 to: steps size do: [ :eachIndex |
		| step |
		step := steps at: eachIndex.
		step first addAsRopedTextTo: aRopedText.
		step second ifNotNil: [ :v |
			aRopedText append: ' ⇒ ' asRopedText.
			v addAsRopedTextTo: aRopedText.
			self
				do: [ :t |
					t append: ':' asRopedText.
					self
						do: [ :tt | step third addAsRopedTextTo: tt ]
						to: t
						withAttribute: LzSortAttribute new ]
				to: aRopedText
				withAttribute: LzVarDeclarationAttribute new ].
		eachIndex < steps size ifTrue: [ aRopedText append: ', ' asRopedText ] ].
	aRopedText append: ' .}' asRopedText.
]

{ #category : #accessing }
LzStepTerm >> args [
	^ #()
]

{ #category : #initializing }
LzStepTerm >> checkConsistency [
	| stepSort |
	self assert: self steps isNotEmpty.
	stepSort := self signature sortGraph sort: 'Step'.
	steps do: [ :each |
		self assert: each first sort <= stepSort.
		].
]

{ #category : #initializing }
LzStepTerm >> computeSort [
	sort := self steps last first sort
]

{ #category : #organizing }
LzStepTerm >> fingerprint [
	^ #steps
]

{ #category : #unifying }
LzStepTerm >> match: otherTerm bindings: bindings [
	otherTerm
		matchStepTerm: self
		steps: self steps
		bindings: bindings
]

{ #category : #unifying }
LzStepTerm >> matchArrayTerm: otherTerm elements: aTermList shape: anArray bindings: bindings [
	bindings failWith: self notUnifiableWith: otherTerm
]

{ #category : #unifying }
LzStepTerm >> matchOpTerm: otherTerm op: anOpName args: anArgList bindings: bindings [
	bindings failWith: self notUnifiableWith: otherTerm
]

{ #category : #accessing }
LzStepTerm >> sort [
	^ sort
]

{ #category : #accessing }
LzStepTerm >> sort: aSort [
	sort := aSort
]

{ #category : #accessing }
LzStepTerm >> steps [
	^ steps
]

{ #category : #accessing }
LzStepTerm >> steps: anObject [
	steps := anObject
]

{ #category : #unifying }
LzStepTerm >> substitute: bindings [
	| substitutedElements |
	bindings hasNoBindings ifTrue: [ ^ self ].
	self elements ifEmpty: [ ^ self ].
	substitutedElements := self elements collect: [ :each | each substitute: bindings ].
	^ signature arrayTerm: substitutedElements shape: self shape
]

{ #category : #unifying }
LzStepTerm >> unifyTagged: aSymbol with: otherTerm tagged: otherSymbol bindings: bindings [
	otherTerm
		unifyTagged: otherSymbol
		withStepTerm: self
		tagged: aSymbol
		steps: self steps
		bindings: bindings.
]

{ #category : #unifying }
LzStepTerm >> unifyTagged: aSymbol withArrayTerm: otherTerm tagged: otherSymbol elements: aTermList shape: anArray bindings: bindings [
	bindings failWith: self notUnifiableWith: otherTerm
]

{ #category : #unifying }
LzStepTerm >> unifyTagged: aSymbol withAtomicTerm: otherTerm tagged: otherSymbol bindings: bindings [
	bindings failWith: self notUnifiableWith: otherTerm
]

{ #category : #unifying }
LzStepTerm >> unifyTagged: aSymbol withOpTerm: otherTerm tagged: otherSymbol op: anOpName args: anArgList bindings: bindings [
	bindings failWith: self notUnifiableWith: otherTerm
]

{ #category : #accessing }
LzStepTerm >> valueSlots [
	^ #(steps)
]
