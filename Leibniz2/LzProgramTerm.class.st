Class {
	#name : #LzProgramTerm,
	#superclass : #LzTerm,
	#instVars : [
		'steps',
		'sort'
	],
	#classVars : [
		'Counter'
	],
	#category : #'Leibniz2-Terms'
}

{ #category : #constructing }
LzProgramTerm class >> newTempPrefix [
	Counter := 1 + (Counter ifNil: 0).
	^ LzConstants tempVarPrefix, Counter asString, '.'
]

{ #category : #converting }
LzProgramTerm >> addAsRopedTextTo: aRopedText [
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
LzProgramTerm >> args [
	^ #()
]

{ #category : #initializing }
LzProgramTerm >> checkConsistency [
	| stepSort |
	self assert: self steps isNotEmpty.
	stepSort := self signature sortGraph sort: 'Step'.
	steps do: [ :each |
		self assert: each first sort <= stepSort.
		].
]

{ #category : #initializing }
LzProgramTerm >> computeSort [
	| lastStepSort sortTerm |
	lastStepSort := self steps last first sort.
	sortTerm := lastStepSort term signature
					opTerm: (LzPrefixOpName for: #Program)
					args: lastStepSort term args.
	sort := lastStepSort sortGraph sortWithTerm: sortTerm.
]

{ #category : #rewriting }
LzProgramTerm >> ensureProgram [
]

{ #category : #organizing }
LzProgramTerm >> fingerprint [
	^ #program
]

{ #category : #unifying }
LzProgramTerm >> match: otherTerm bindings: bindings [
	otherTerm
		matchStepTerm: self
		steps: self steps
		bindings: bindings
]

{ #category : #unifying }
LzProgramTerm >> matchArrayTerm: otherTerm elements: aTermList shape: anArray bindings: bindings [
	bindings failWith: self notUnifiableWith: otherTerm
]

{ #category : #unifying }
LzProgramTerm >> matchOpTerm: otherTerm op: anOpName args: anArgList bindings: bindings [
	bindings failWith: self notUnifiableWith: otherTerm
]

{ #category : #running }
LzProgramTerm >> runWithReducer: aReducer state: state [
	| tempVarState result |
	tempVarState := LzExecutionState new.
	steps do: [ :eachStep |
		| stepTerm |
		stepTerm := (eachStep first substitute: state)
						substitute: tempVarState.
		result := stepTerm runWithReducer: aReducer state: state.
		eachStep second ifNotNil: [ :p |
			| bindings |
			bindings := self signature emptyBindings.
			p match: result bindings: bindings.
			bindings ifFailure: [ :f |
				LzRewriteFailure signal: f asString ].
			state updateFromBindings: bindings.
			bindings bindings keysDo: [ :each |
				(each asSymbol beginsWith: LzConstants tempVarPrefix)
					ifTrue: [ tempVarState addStateVar: each ] ].
			tempVarState updateFromBindings: bindings ] ].
	^ result
]

{ #category : #accessing }
LzProgramTerm >> sort [
	^ sort
]

{ #category : #accessing }
LzProgramTerm >> sort: aSort [
	sort := aSort
]

{ #category : #accessing }
LzProgramTerm >> steps [
	^ steps
]

{ #category : #accessing }
LzProgramTerm >> steps: anObject [
	steps := anObject
]

{ #category : #unifying }
LzProgramTerm >> substitute: bindings [
	| substitutedSteps shadowedBindings |
	bindings hasNoBindings ifTrue: [ ^ self ].
	self steps ifEmpty: [ ^ self ].
	shadowedBindings := LzShadowedBindings new
							bindings: bindings;
							shadowedVars: self signature stateVars keys.
	substitutedSteps := self steps collect: [ :each |
		{ each first substitute: bindings
		. each second substitute: shadowedBindings } ].
	^ signature programTerm: substitutedSteps
]

{ #category : #unifying }
LzProgramTerm >> unifyTagged: aSymbol with: otherTerm tagged: otherSymbol bindings: bindings [
	otherTerm
		unifyTagged: otherSymbol
		withStepTerm: self
		tagged: aSymbol
		steps: self steps
		bindings: bindings.
]

{ #category : #unifying }
LzProgramTerm >> unifyTagged: aSymbol withArrayTerm: otherTerm tagged: otherSymbol elements: aTermList shape: anArray bindings: bindings [
	bindings failWith: self notUnifiableWith: otherTerm
]

{ #category : #unifying }
LzProgramTerm >> unifyTagged: aSymbol withAtomicTerm: otherTerm tagged: otherSymbol bindings: bindings [
	bindings failWith: self notUnifiableWith: otherTerm
]

{ #category : #unifying }
LzProgramTerm >> unifyTagged: aSymbol withOpTerm: otherTerm tagged: otherSymbol op: anOpName args: anArgList bindings: bindings [
	bindings failWith: self notUnifiableWith: otherTerm
]

{ #category : #accessing }
LzProgramTerm >> valueSlots [
	^ #(steps)
]
