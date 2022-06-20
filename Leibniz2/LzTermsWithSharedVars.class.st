Class {
	#name : #LzTermsWithSharedVars,
	#superclass : #Object,
	#traits : 'TLzEquality + TLzPrintable',
	#classTraits : 'TLzEquality classTrait + TLzPrintable classTrait',
	#instVars : [
		'signature',
		'variables',
		'sortVariables'
	],
	#category : #'Leibniz2-Infrastructure'
}

{ #category : #converting }
LzTermsWithSharedVars >> addAsRopedTextTo: aRopedText [
	self addVariablesAsRopedTextTo: aRopedText.
	self addBodyAsRopedTextTo: aRopedText.
	self addConditionAsRopedTextTo: aRopedText
]

{ #category : #converting }
LzTermsWithSharedVars >> addBodyAsRopedTextTo: aRopedText [
	self subclassResponsibility
]

{ #category : #converting }
LzTermsWithSharedVars >> addConditionAsRopedTextTo: aRopedText [
	self subclassResponsibility
]

{ #category : #converting }
LzTermsWithSharedVars >> addVariablesAsRopedTextTo: aRopedText [
	| addVars |
	addVars := [ :var :sort |
		| size |
		size := aRopedText size.
		var addAsRopedTextTo: aRopedText.
		aRopedText append:
			(':' asRopedText attribute: LzColonAttribute new).
		sort addAsRopedTextTo:  aRopedText.
		aRopedText append: ', ' asRopedText.
		aRopedText
			attribute: (LzVarDeclarationAttribute new)
			from: size + 1 to: aRopedText size + 1 ].
	self sortVariables keysAndValuesDo: addVars.
	self variables keysAndValuesDo: addVars
]

{ #category : #printing }
LzTermsWithSharedVars >> printVariablesAsLeibnizSyntaxOn: aStream [
	| printVars |
	printVars := [ :var :sort |
			aStream nextPutAll: var asSymbol.
			aStream nextPut: $:.
			sort printAsLeibnizSyntaxOn:  aStream.
			aStream nextPutAll: ', ' ].
	self sortVariables keysAndValuesDo: printVars.
	self variables keysAndValuesDo: printVars
]

{ #category : #accessing }
LzTermsWithSharedVars >> referenceSlots [
	^ #(signature)
]

{ #category : #accessing }
LzTermsWithSharedVars >> signature [
	^ signature
]

{ #category : #accessing }
LzTermsWithSharedVars >> signature: aSignature [
	signature := aSignature
]

{ #category : #accessing }
LzTermsWithSharedVars >> sortVariables [
	^ sortVariables
]

{ #category : #accessing }
LzTermsWithSharedVars >> valueSlots [
	"No need to test sortVariables, which is derived from variables."
	^ #(variables)
]

{ #category : #accessing }
LzTermsWithSharedVars >> variables [
	^ variables
]

{ #category : #accessing }
LzTermsWithSharedVars >> variables: aDictionary [
	variables := aDictionary.
	sortVariables := (self variables values collect: [ :each | each term vars ])
							inject: Dictionary new
							into: [ :total :each | total union: each ]
]
