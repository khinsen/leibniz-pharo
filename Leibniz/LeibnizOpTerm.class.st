"
I represent a standard Leibniz term defined by a operator and its arguments.
"
Class {
	#name : #LeibnizOpTerm,
	#superclass : #LeibnizTerm,
	#instVars : [
		'opSymbol',
		'argList',
		'sort'
	],
	#category : #'Leibniz-3-Terms'
}

{ #category : #'instance creation' }
LeibnizOpTerm class >> symbol: aSymbol args: anArgList sort: aSort forSignature: aSignature [
	^self basicNew
			initializeWithSymbol: aSymbol args: anArgList sort: aSort forSignature: aSignature;
			yourself.

]

{ #category : #private }
LeibnizOpTerm >> hasOtherOpThan: aSymbol [
	^ aSymbol ~= opSymbol.
]

{ #category : #initialization }
LeibnizOpTerm >> initializeWithSymbol: aSymbol args: anArgList sort: aSort forSignature: aSignature [
	opSymbol := aSymbol.
	argList := anArgList.
	sort := aSort.
	signature := aSignature.
]

{ #category : #testing }
LeibnizOpTerm >> isInfix [
	"Answer true if the term is printed in infix notation."
	| opString |
	opString := opSymbol asString.
	^ opString size > 1 and: [ opString first = $_ ]
]

{ #category : #matching }
LeibnizOpTerm >> match: otherTerm [
	otherTerm matchOp: opSymbol andArgs: argList

]

{ #category : #matching }
LeibnizOpTerm >> matchOp: aSymbol andArgs: anArgList [
	| match |
	opSymbol = aSymbol
		ifFalse: [ ^ nil ].
	argList size = anArgList size
		ifFalse: [ ^ nil ].
	match := LeibnizMatch new.
	anArgList with: argList do:
		[ :patternArg :valueArg |
		  | argMatch |
			argMatch := patternArg match: valueArg.
			argMatch ifNil: [ ^ nil ].
			match := match combineWith: argMatch.
			match ifNil: [ ^ nil ] ].
	^ match
]

{ #category : #printing }
LeibnizOpTerm >> printAsLeibnizSyntaxOn: aStream [
	| opString |
	opString := opSymbol asString.
	argList
		ifEmpty: [ aStream nextPutAll: opString. ^ self ].
	(#(#'[]' #'^' #'_') includes: opSymbol)
		ifTrue: [ self printSpecialAsLeibnizSyntaxOn: aStream. ^ self ].
	opString first = $_
		ifTrue: [ self printInfixAsLeibnizSyntaxOn: aStream. ^ self ].
	self printPrefixAsLeibnizSyntaxOn: aStream.

]

{ #category : #printing }
LeibnizOpTerm >> printInfixAsLeibnizSyntaxOn: aStream [
	self assert: argList size equals: 2.
	argList first printAsLeibnizSyntaxOn: aStream
					  parenthesized: (argList first hasOtherOpThan: opSymbol).
	aStream nextPutAll: ' '.
	aStream nextPutAll: opSymbol asString allButFirst.
	aStream nextPutAll: ' '.
	argList second printAsLeibnizSyntaxOn: aStream
						parenthesized: argList second isInfix.

]

{ #category : #printing }
LeibnizOpTerm >> printPrefixAsLeibnizSyntaxOn: aStream [
	aStream nextPutAll: opSymbol asString.
	aStream nextPut: $(.
	argList first printAsLeibnizSyntaxOn: aStream.
	argList allButFirstDo: [ :each | aStream nextPutAll: ', '. each printAsLeibnizSyntaxOn: aStream ].
	aStream nextPut: $).
	
]

{ #category : #printing }
LeibnizOpTerm >> printSpecialAsLeibnizSyntaxOn: aStream [
	| leftDelimiter rightDelimiter |
	leftDelimiter := Dictionary with: #'[]' -> '[' with: #'^' -> '^{' with: #'_' -> '_{'.
	rightDelimiter := Dictionary with: #'[]' -> ']' with: #'^' -> '}' with: #'_' -> '}'.
	self assert: argList size > 1.
	argList first printAsLeibnizSyntaxOn: aStream
					  parenthesized: (argList first hasOtherOpThan: opSymbol).
	aStream nextPutAll: (leftDelimiter at: opSymbol).
	argList second printAsLeibnizSyntaxOn: aStream.
	(argList allButFirst: 2) do:
		[ :each | aStream nextPutAll: ', '. each printAsLeibnizSyntaxOn: aStream ].
	aStream nextPutAll: (rightDelimiter at: opSymbol).

]

{ #category : #accessing }
LeibnizOpTerm >> sort [
	^sort
]
