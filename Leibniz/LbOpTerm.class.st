"
I represent a standard Leibniz term defined by a operator and its arguments.
"
Class {
	#name : #LbOpTerm,
	#superclass : #LbTerm,
	#instVars : [
		'sort',
		'opName',
		'arguments'
	],
	#category : 'Leibniz-3-Terms'
}

{ #category : #'instance creation' }
LbOpTerm class >> name: anOpName args: anArgList sort: aSort signature: aSignature [
	^self basicNew
			initializeWithName: anOpName args: anArgList sort: aSort signature: aSignature;
			yourself
]

{ #category : #accessing }
LbOpTerm >> arguments [
	^ arguments
]

{ #category : #converting }
LbOpTerm >> convertToSignature: aSignature extraVariables: aDictionary [
	| vars |
	vars := aDictionary collect: [ :eachSort | aSignature sortNamed: eachSort name ].
	^ arguments
		ifEmpty: [
			aSignature zeroArgTermNamed: opName extraVariables: vars ]
		ifNotEmpty: [
			aSignature
				nonZeroArgTermNamed: opName
				withArgs: (arguments collect: [ :each |
					each convertToSignature: aSignature  extraVariables: aDictionary ] ) ]
]

{ #category : #testing }
LbOpTerm >> evaluateEqualityTerm [
	opName isEqualityOp ifFalse: [ ^ nil ].
	arguments size == 2 ifFalse: [ ^ nil ].
	sort name = #boolean ifFalse: [ ^ nil ].
	^ arguments first = arguments second
]

{ #category : #private }
LbOpTerm >> hasInfixOpOtherThan: anOpName [
	^ opName isInfixOpOtherThan: anOpName
]

{ #category : #testing }
LbOpTerm >> hasVariables [
	^ arguments
		detect: [ :each | each hasVariables ]
		ifFound: [ true ]
		ifNone: [ false ]
]

{ #category : #classifying }
LbOpTerm >> headOpName [
	^ opName
]

{ #category : #initialization }
LbOpTerm >> initializeWithName: anOpName args: anArgList sort: aSort signature: aSignature [
	opName := anOpName.
	arguments := anArgList.
	sort := aSort.
	signature := aSignature.
]

{ #category : #testing }
LbOpTerm >> isInfix [
	^ opName isInfix
]

{ #category : #testing }
LbOpTerm >> isTrue [
	^ (sort name = #boolean)
		and: [ (opName asSymbol = #true)
		and: [ arguments isEmpty ] ]
]

{ #category : #matching }
LbOpTerm >> match: otherTerm variables: variables [
	otherTerm matchOpTerm: self op: opName args: arguments variables: variables
]

{ #category : #matching }
LbOpTerm >> matchOpTerm: otherTerm op: anOpName args: anArgList variables: variables [
	(opName = anOpName and: [ arguments size = anArgList size ])
		ifTrue: [ anArgList with: arguments do: [ :arg1 :arg2 |
					arg1 match: arg2 variables: variables ] ]
		ifFalse: [ variables failWith: self notUnifiableWith: otherTerm ]
]

{ #category : #accessing }
LbOpTerm >> opName [
	^ opName
]

{ #category : #printing }
LbOpTerm >> printAsLeibnizSyntaxOn: aStream [
	opName printForArgs: arguments on: aStream
]

{ #category : #accessing }
LbOpTerm >> sort [
	^sort
]

{ #category : #substituting }
LbOpTerm >> substitute: aSubstitution [
	| substitutedArgList |
	aSubstitution hasNoBindings ifTrue: [ ^ self ].
	arguments ifEmpty: [ ^ self ].
	substitutedArgList := arguments collect: [ :arg | arg substitute: aSubstitution ].
	^ signature nonZeroArgTermNamed: opName withArgs: substitutedArgList
]

{ #category : #inspecting }
LbOpTerm >> synopsis [
	^ self opName synopsis
]

{ #category : #matching }
LbOpTerm >> unifyTagged: aSymbol with: otherTerm tagged: anotherSymbol variables: variables [
	otherTerm
		unifyTagged: anotherSymbol
		withOpTerm: self
		tagged: aSymbol
		op: opName args: arguments
		variables: variables.
]

{ #category : #matching }
LbOpTerm >> unifyTagged: aSymbol withAtomicTerm: otherTerm tagged: anotherSymbol variables: variables [
	variables failWith: self notUnifiableWith: otherTerm
]

{ #category : #matching }
LbOpTerm >> unifyTagged: aSymbol withOpTerm: otherTerm tagged: anotherSymbol op: anOpName args: anArgList variables: variables [
	(opName = anOpName and: [ arguments size = anArgList size ])
		ifTrue: [ anArgList with: arguments do: [ :arg1 :arg2 |
					arg1
						unifyTagged: anotherSymbol
						with: arg2
						tagged: aSymbol
						variables: variables ] ]
		ifFalse: [ variables failWith: self notUnifiableWith: otherTerm ]
]

{ #category : #accessing }
LbOpTerm >> variables [
	^ arguments inject: Dictionary new into: [ :total :each | total union: each variables ]
]

{ #category : #transforming }
LbOpTerm >> withTransformedArgs: anArgList [
	^ signature nonZeroArgTermNamed: opName withArgs: anArgList
]
