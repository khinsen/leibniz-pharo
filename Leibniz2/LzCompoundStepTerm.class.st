Class {
	#name : #LzCompoundStepTerm,
	#superclass : #LzTerm,
	#instVars : [
		'steps',
		'sort'
	],
	#category : #'Leibniz2-Terms'
}

{ #category : #converting }
LzCompoundStepTerm >> addAsRopedTextTo: aRopedText [
	aRopedText append: '{. ' asRopedText.
	1 to: steps size do: [ :eachIndex |
		| step |
		step := steps at: eachIndex.
		step first addAsRopedTextTo: aRopedText.
		step second ifNotNil: [ :v |
			aRopedText append: ' ⇒ ' asRopedText.
			v addAsRopedTextTo: aRopedText ].
		eachIndex < steps size
			ifTrue: [ aRopedText append: '; ' asRopedText ] ].
	aRopedText append: ' .}' asRopedText.
]

{ #category : #accessing }
LzCompoundStepTerm >> args [
	^ #()
]

{ #category : #initializing }
LzCompoundStepTerm >> checkConsistency [
	| stepSort |
	self assert: self steps isNotEmpty.
	stepSort := self signature sortGraph sort: 'Step'.
	steps do: [ :each |
		self assert: each first sort <= stepSort.
		].
]

{ #category : #initializing }
LzCompoundStepTerm >> computeSort [
	| lastStepSort sortTerm |
	lastStepSort := self steps last first sort.
	sortTerm := lastStepSort term signature
					opTerm: (LzPrefixOpName for: #CompoundStep)
					args: lastStepSort term args.
	sort := lastStepSort sortGraph sortWithTerm: sortTerm.
]

{ #category : #rewriting }
LzCompoundStepTerm >> ensureCompoundStep [
]

{ #category : #organizing }
LzCompoundStepTerm >> fingerprint [
	^ #steps
]

{ #category : #unifying }
LzCompoundStepTerm >> match: otherTerm bindings: bindings [
	otherTerm
		matchStepTerm: self
		steps: self steps
		bindings: bindings
]

{ #category : #unifying }
LzCompoundStepTerm >> matchArrayTerm: otherTerm elements: aTermList shape: anArray bindings: bindings [
	bindings failWith: self notUnifiableWith: otherTerm
]

{ #category : #unifying }
LzCompoundStepTerm >> matchOpTerm: otherTerm op: anOpName args: anArgList bindings: bindings [
	bindings failWith: self notUnifiableWith: otherTerm
]

{ #category : #accessing }
LzCompoundStepTerm >> runWithReducer: aReducer [
	| variables bindings result |
	variables := Dictionary new.
	bindings := LzBindings new
		sortGraph: self signature sortGraph.
	steps do: [ :eachStep |
		| stepTerm runStepTerm |
		stepTerm := eachStep first substitute: bindings.
		runStepTerm := self signature
						opTerm: (LzPrefixOpName for: #run)
						args: { stepTerm }.
		result := aReducer value: runStepTerm.
		eachStep second ifNotNil: [ :p |
			| stepPattern |
			stepPattern := p substitute: bindings.
			stepPattern match: result bindings: bindings ].
		bindings ifFailure: [ :f |
			LzRewriteFailure signal: f asString ] ].
	^ result
]

{ #category : #accessing }
LzCompoundStepTerm >> sort [
	^ sort
]

{ #category : #accessing }
LzCompoundStepTerm >> sort: aSort [
	sort := aSort
]

{ #category : #accessing }
LzCompoundStepTerm >> steps [
	^ steps
]

{ #category : #accessing }
LzCompoundStepTerm >> steps: anObject [
	steps := anObject
]

{ #category : #unifying }
LzCompoundStepTerm >> substitute: bindings [
	| substitutedElements |
	bindings hasNoBindings ifTrue: [ ^ self ].
	self elements ifEmpty: [ ^ self ].
	substitutedElements := self elements collect: [ :each | each substitute: bindings ].
	^ signature arrayTerm: substitutedElements shape: self shape
]

{ #category : #unifying }
LzCompoundStepTerm >> unifyTagged: aSymbol with: otherTerm tagged: otherSymbol bindings: bindings [
	otherTerm
		unifyTagged: otherSymbol
		withStepTerm: self
		tagged: aSymbol
		steps: self steps
		bindings: bindings.
]

{ #category : #unifying }
LzCompoundStepTerm >> unifyTagged: aSymbol withArrayTerm: otherTerm tagged: otherSymbol elements: aTermList shape: anArray bindings: bindings [
	bindings failWith: self notUnifiableWith: otherTerm
]

{ #category : #unifying }
LzCompoundStepTerm >> unifyTagged: aSymbol withAtomicTerm: otherTerm tagged: otherSymbol bindings: bindings [
	bindings failWith: self notUnifiableWith: otherTerm
]

{ #category : #unifying }
LzCompoundStepTerm >> unifyTagged: aSymbol withOpTerm: otherTerm tagged: otherSymbol op: anOpName args: anArgList bindings: bindings [
	bindings failWith: self notUnifiableWith: otherTerm
]

{ #category : #accessing }
LzCompoundStepTerm >> valueSlots [
	^ #(steps)
]
