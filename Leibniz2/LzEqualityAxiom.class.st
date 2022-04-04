Class {
	#name : #LzEqualityAxiom,
	#superclass : #LzAxiom,
	#instVars : [
		'left',
		'right',
		'condition'
	],
	#category : #'Leibniz2-Axioms'
}

{ #category : #initialization }
LzEqualityAxiom >> buildTermsFrom: aDictionary [
	self left: ((aDictionary at: #left)
					buildFor: self signature
					variables: self variables).
	self right: ((aDictionary at: #right)
					buildFor: self signature
					variables: self variables)
]

{ #category : #accessing }
LzEqualityAxiom >> checkConsistency [
	self assert: left signature == signature.
	self assert: right signature == signature.
	condition ifNotNil: [
		self assert: condition signature == signature ].
	self flag: #todo. "Check variable consistency"
]

{ #category : #accessing }
LzEqualityAxiom >> condition [
	^ condition
]

{ #category : #accessing }
LzEqualityAxiom >> condition: aPattern [
	condition := aPattern
]

{ #category : #accessing }
LzEqualityAxiom >> left [
	^ left
]

{ #category : #accessing }
LzEqualityAxiom >> left: aPattern [
	left := aPattern
]

{ #category : #accessing }
LzEqualityAxiom >> patterns [
	^ Set with: left with: right
]

{ #category : #printing }
LzEqualityAxiom >> printAsLeibnizSyntaxOn: aStream [
	self printVariablesAsLeibnizSyntaxOn: aStream.
	left printAsLeibnizSyntaxOn: aStream.
	aStream nextPutAll: ' = '.
	right printAsLeibnizSyntaxOn: aStream.
	self condition ifNotNil: [ :c |
		aStream nextPutAll: ' | '.
		self printConditionAsLeibnizSyntaxOn: aStream ].
]

{ #category : #printing }
LzEqualityAxiom >> printConditionAsLeibnizSyntaxOn: aStream [
	self condition ifNotNil: [ :c |
		c printAsLeibnizSyntaxOn: aStream ]
]

{ #category : #accessing }
LzEqualityAxiom >> right [
	^ right
]

{ #category : #accessing }
LzEqualityAxiom >> right: aPattern [
	right := aPattern
]

{ #category : #accessing }
LzEqualityAxiom >> valueSlots [
	^ super valueSlots, #(left right condition)
]
