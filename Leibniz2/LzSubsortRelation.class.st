Class {
	#name : #LzSubsortRelation,
	#superclass : #Object,
	#traits : 'TLzPrintable',
	#classTraits : 'TLzPrintable classTrait',
	#instVars : [
		'sortGraph',
		'axiom'
	],
	#category : #'Leibniz2-Sorts'
}

{ #category : #converting }
LzSubsortRelation >> addAsRopedTextTo: aRopedText [
	self axiom addAsRopedTextTo: aRopedText
]

{ #category : #accessing }
LzSubsortRelation >> axiom [
	^ axiom
]

{ #category : #accessing }
LzSubsortRelation >> axiom: aSubsortAxiom [
	axiom := aSubsortAxiom
]

{ #category : #inspecting }
LzSubsortRelation >> gtSortGraphFor: aView [
	<gtView>
	^ aView forward
		title: 'Sort graph';
		priority: 0;
		object: [ LzSortPair
					sort1: (self sortGraph sortWithTerm: self axiom subsort)
					sort2: (self sortGraph sortWithTerm: self axiom supersort) ];
		view: #gtSortGraphFor:;
		yourself
]

{ #category : #printing }
LzSubsortRelation >> printAsLeibnizSyntaxOn: aStream [
	self axiom printAsLeibnizSyntaxOn: aStream
]

{ #category : #accessing }
LzSubsortRelation >> sortGraph [
	^ sortGraph
]

{ #category : #accessing }
LzSubsortRelation >> sortGraph: aSortGraph [
	sortGraph := aSortGraph
]
