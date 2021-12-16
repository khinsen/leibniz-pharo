Class {
	#name : #LzSortGraphBuilder,
	#superclass : #Object,
	#instVars : [
		'subsortAxioms',
		'sortDeclarations',
		'includeDeclarations'
	],
	#category : #'Leibniz2-Leibniz2'
}

{ #category : #accessing }
LzSortGraphBuilder >> initialize [
	includeDeclarations :=
		OrderedCollection with: LzBuiltinContexts sortContext.
	sortDeclarations := OrderedCollection new.
	subsortAxioms := OrderedCollection new.
]

{ #category : #defining }
LzSortGraphBuilder >> sort: aString [
	self notYetImplemented
]
