"
I represent a rewrite rule in a Leibniz context.
"
Class {
	#name : 'LbRewriteRule',
	#superclass : 'LbRule',
	#traits : 'EqualityThroughVariables',
	#classTraits : 'EqualityThroughVariables classTrait',
	#instVars : [
		'replacement'
	],
	#category : 'Leibniz-4-Rules'
}

{ #category : 'instance creation' }
LbRewriteRule class >> pattern: aPattern condition: aBooleanTerm replacement: aTerm [
	^ self pattern: aPattern localVariables: Dictionary new condition: aBooleanTerm replacement: aTerm

]

{ #category : 'instance creation' }
LbRewriteRule class >> pattern: aPattern localVariables: aDictionary condition: aBooleanTerm replacement: aTerm [
	^ self basicNew
			 initializeWithPattern: aPattern
								localVariables: aDictionary
								condition: aBooleanTerm
								replacement: aTerm;
			 yourself

]

{ #category : 'instance creation' }
LbRewriteRule class >> pattern: aPattern localVariables: aDictionary replacement: aTerm [
	^ self pattern: aPattern localVariables: aDictionary condition: nil replacement: aTerm

]

{ #category : 'instance creation' }
LbRewriteRule class >> pattern: aPattern replacement: aTerm [
	^ self pattern: aPattern condition: nil replacement: aTerm

]

{ #category : 'rewriting' }
LbRewriteRule >> apply: aSubstitution [
	^ replacement substitute: aSubstitution

]

{ #category : 'converting' }
LbRewriteRule >> convertToSignature: aSignature [
	| convertTerm convertedVars |
	convertTerm := [ :term | term convertToSignature: aSignature extraVariables: variables ].
	convertedVars := variables collect: [ :eachSort | aSignature sortNamed: eachSort name ].
	^ self class
		pattern: (convertTerm value: pattern)
		localVariables: convertedVars
		condition: (condition ifNotNil: [ convertTerm value: condition ])
		replacement: (convertTerm value: replacement)
]

{ #category : 'initializing' }
LbRewriteRule >> initializeWithPattern: aPattern localVariables: aDictionary condition: aBooleanTerm replacement: aTerm [
	| patternVariables |
	self initializeWithPattern: aPattern localVariables: aDictionary condition: aBooleanTerm.
	replacement := aTerm.
	self assert: replacement signature equals: signature.
	patternVariables := pattern variables.
	replacement variables associationsDo: [ :each |
		self
			assert: (patternVariables includesAssociation: each)
			description: 'Variable ', each key asSymbol, ' in replacement but not in pattern'  ].
	self beRecursivelyReadOnlyObject.
]

{ #category : 'printing' }
LbRewriteRule >> printBodyAsLeibnizSyntaxOn: aStream [
	pattern printAsLeibnizSyntaxOn: aStream.
	aStream nextPutAll: ' ⇒ '.
	replacement printAsLeibnizSyntaxOn: aStream
]

{ #category : 'accessing' }
LbRewriteRule >> replacement [
	^ replacement
]
