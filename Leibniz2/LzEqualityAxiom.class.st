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

{ #category : #converting }
LzEqualityAxiom >> addBodyAsRopedTextTo: aRopedText [
	left addAsRopedTextTo: aRopedText.
	aRopedText append:
		(' = ' asRopedText attribute: LzEqualSignAttribute new).
	right addAsRopedTextTo: aRopedText
]

{ #category : #converting }
LzEqualityAxiom >> addConditionAsRopedTextTo: aRopedText [
	self condition ifNotNil: [ :c |
		aRopedText append:
			(' | ' asRopedText attribute: LzConditionAttribute new).
		c addAsRopedTextTo: aRopedText ].
]

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

{ #category : #rewriting }
LzEqualityAxiom >> normalFormIn: aContext [
	^ self class new
		signature: self signature;
		variables: self variables;
		left: (aContext reduce: self left);
		condition: (self condition ifNotNil: [ :c | aContext reduce: c ]);
		right: (aContext reduce: self right);
		label: self label;
		checkConsistency;
		beRecursivelyReadOnlyObject;
		yourself
]

{ #category : #accessing }
LzEqualityAxiom >> patterns [
	^ Set with: left with: right
]

{ #category : #printing }
LzEqualityAxiom >> printBodyAsLeibnizSyntaxOn: aStream [
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
