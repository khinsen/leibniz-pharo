Class {
	#name : #LzSubsortAxiom,
	#superclass : #LzAxiom,
	#instVars : [
		'supersort',
		'subsort'
	],
	#category : #'Leibniz2-Leibniz2'
}

{ #category : #printing }
LzSubsortAxiom >> printAsLeibnizSyntaxOn: aStream [
	self printVariablesAsLeibnizSyntaxOn: aStream.
	aStream nextPut: Character space.
	subsort printAsLeibnizSyntaxOn: aStream.
	aStream nextPutAll: ' ⊆ '.
	supersort printAsLeibnizSyntaxOn: aStream
]

{ #category : #accessing }
LzSubsortAxiom >> subsort [
	^ subsort
]

{ #category : #accessing }
LzSubsortAxiom >> subsort: aPattern [
	subsort := aPattern
]

{ #category : #accessing }
LzSubsortAxiom >> supersort [
	^ supersort
]

{ #category : #accessing }
LzSubsortAxiom >> supersort: aPattern [
	supersort := aPattern
]

{ #category : #accessing }
LzSubsortAxiom >> valueSlots [
	^ #(subsort supersort)
]
