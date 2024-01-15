Class {
	#name : #LzComputation,
	#superclass : #Object,
	#instVars : [
		'internalVars',
		'steps',
		'resultTerm',
		'context'
	],
	#category : #'Leibniz2-Computations'
}

{ #category : #initializing }
LzComputation >> addStep: aTermString var: aVarString [
	| node varBuilder vars |
	node := LzParser2 parse: aVarString startingAt: LzParser2 startingStateForVar.
	varBuilder := LzVarDeclarationBuilder new.
	varBuilder acceptNode: node.
	vars := context signature parsedVariables: varBuilder vars.
	internalVars addAll: vars.
	steps add: { context term: aTermString . vars associations first }
]

{ #category : #accessing }
LzComputation >> context [
	^ context
]

{ #category : #accessing }
LzComputation >> context: anObject [
	context := anObject
]

{ #category : #inspecting }
LzComputation >> gtStepsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Steps';
		priority: 5;
		items: [ steps ];
		column: 'Variable' text: [ :each |
			| association |
			association := each second.
			association key asLeibnizSyntax,
				':' asRopedText, association value asLeibnizSyntax ];
		column: 'Term' text: [ :each |
			each first asLeibnizSyntax ];
		yourself
]

{ #category : #initializing }
LzComputation >> initialize [
	internalVars := Dictionary new.
	steps := OrderedCollection new.
]

{ #category : #accessing }
LzComputation >> internalVars [
	^ internalVars
]

{ #category : #accessing }
LzComputation >> resultTerm: aTermString [
	| node builder |
	node := LzParser2 parse: aTermString startingAt: LzParser2 startingStateForTerm.
	builder := LzDeclarationBuilder new.
	resultTerm := (builder acceptNode: node)  buildFor: self signature variables: self internalVars
]

{ #category : #accessing }
LzComputation >> signature [
	^ self context signature
]
