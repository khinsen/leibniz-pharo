Class {
	#name : #LzExecutionState,
	#superclass : #Object,
	#instVars : [
		'values'
	],
	#category : #'Leibniz2-Terms'
}

{ #category : #updating }
LzExecutionState >> addStateVar: anLzVarName [
	(values includesKey: anLzVarName)
		ifFalse: [ values at: anLzVarName put: nil ]
]

{ #category : #accessing }
LzExecutionState >> bindingFor: aName [
	^ values at: aName ifAbsent: [ nil ]
]

{ #category : #inspecting }
LzExecutionState >> gtDisplayOn: aStream [
	values keysAndValuesDo: [ :name :value |
		aStream
			<< name asLeibnizSyntaxString;
			<< '=';
			<< (value ifNil: 'nil' ifNotNil: [ :v | v asLeibnizSyntaxString ]);
			<< ' ' ]
]

{ #category : #accessing }
LzExecutionState >> gtValuesFor: aView [
	<gtView>
	^ aView forward
		title: 'Values';
		priority: 1;
		object: [ values ];
		view: #gtItemsFor:;
		yourself
]

{ #category : #accessing }
LzExecutionState >> hasNoBindings [
	^ values values
		detect: #isNotNil
		ifFound: [ false ]
		ifNone: [ true]
]

{ #category : #initializing }
LzExecutionState >> initialize [
	values := Dictionary new
]

{ #category : #printing }
LzExecutionState >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	self gtDisplayOn: aStream.
	aStream nextPut: $)
]

{ #category : #initializing }
LzExecutionState >> stateVars: aSet [
	aSet do: [ :each | self addStateVar: each ]
]

{ #category : #updating }
LzExecutionState >> updateFromBindings: bindings [
	bindings bindings keysAndValuesDo: [ :eachName :eachValue |
		(values includesKey: eachName) ifTrue: [
			values at: eachName put: eachValue ] ]
]
