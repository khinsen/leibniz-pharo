Class {
	#name : #LzExecutionState,
	#superclass : #Object,
	#instVars : [
		'values'
	],
	#category : #'Leibniz2-Terms'
}

{ #category : #accessing }
LzExecutionState >> bindingFor: aName [
	^ values at: aName ifAbsent: [ nil ]
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

{ #category : #initializing }
LzExecutionState >> stateVars: aSet [
	aSet do: [ :each |
		values at: each put: nil ]
]

{ #category : #updating }
LzExecutionState >> updateFromBindings: bindings [
	bindings bindings keysAndValuesDo: [ :eachName :eachValue |
		(values includesKey: eachName) ifTrue: [
			values at: eachName put: eachValue ] ]
]
