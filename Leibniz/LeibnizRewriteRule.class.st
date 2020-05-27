"
I represent a rewrite rule in a Leibniz context.
"
Class {
	#name : #LeibnizRewriteRule,
	#superclass : #LeibnizRule,
	#traits : 'EqualityThroughVariables',
	#classTraits : 'EqualityThroughVariables classTrait',
	#instVars : [
		'replacement'
	],
	#category : #'Leibniz-4-Rules'
}

{ #category : #'instance creation' }
LeibnizRewriteRule class >> pattern: aPattern condition: aBooleanTerm replacement: aTerm [
	^ self pattern: aPattern localVariables: Dictionary new condition: aBooleanTerm replacement: aTerm

]

{ #category : #'instance creation' }
LeibnizRewriteRule class >> pattern: aPattern localVariables: aDictionary condition: aBooleanTerm replacement: aTerm [
	^ self basicNew
			 initializeWithPattern: aPattern
								localVariables: aDictionary
								condition: aBooleanTerm
								replacement: aTerm;
			 yourself

]

{ #category : #'instance creation' }
LeibnizRewriteRule class >> pattern: aPattern localVariables: aDictionary replacement: aTerm [
	^ self pattern: aPattern localVariables: aDictionary condition: nil replacement: aTerm

]

{ #category : #'instance creation' }
LeibnizRewriteRule class >> pattern: aPattern replacement: aTerm [
	^ self pattern: aPattern condition: nil replacement: aTerm

]

{ #category : #rewriting }
LeibnizRewriteRule >> apply: aSubstitution [
	^ replacement substitute: aSubstitution

]

{ #category : #converting }
LeibnizRewriteRule >> convertToSignature: aSignature [
	| convertTerm |
	convertTerm := [ :term | term convertToSignature: aSignature extraVariables: variables ].
	^ self class
		pattern: (convertTerm value: pattern)
	 	localVariables: variables
		condition: (condition ifNotNil: [ convertTerm value: condition ])
		replacement: (convertTerm value: replacement)

]

{ #category : #initializing }
LeibnizRewriteRule >> initializeWithPattern: aPattern localVariables: aDictionary condition: aBooleanTerm replacement: aTerm [
	| patternVariables |
	self initializeWithPattern: aPattern localVariables: aDictionary condition: aBooleanTerm.
	replacement := aTerm.
	self assert: replacement signature equals: signature.
	patternVariables := pattern variables.
	replacement variables associationsDo:
		[ :each | self assert: (patternVariables includesAssociation: each)
							description: 'Variable ', each key, ' in replacement but not in pattern'  ].
	self beRecursivelyReadOnlyObject.
]

{ #category : #printing }
LeibnizRewriteRule >> printAsLeibnizSyntaxOn: aStream [
	variables keysAndValuesDo:
		[ :var :sort |
			aStream nextPutAll: '∀ '.
			aStream nextPutAll: var.
			aStream nextPut: $:.
			aStream nextPutAll: sort.
			aStream nextPutAll: ' '].
	pattern printAsLeibnizSyntaxOn: aStream.
	aStream nextPutAll: ' ⇒ '.
	replacement printAsLeibnizSyntaxOn: aStream.
	condition ifNotNil:
		[ aStream nextPutAll: ' | '. condition printAsLeibnizSyntaxOn: aStream ].
]
