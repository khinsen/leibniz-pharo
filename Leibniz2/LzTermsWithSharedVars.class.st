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

{ #category : #printing }
LzTermsWithSharedVars >> printVariablesAsLeibnizSyntaxOn: aStream [
	| printVars |
	printVars := [ :var :sort |
			aStream nextPutAll: '∀ '.
			aStream nextPutAll: var asSymbol.
			aStream nextPut: $:.
			sort printAsLeibnizSyntaxOn:  aStream.
			aStream nextPut: Character space].
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
