"
!A sort graph grammar subclass that generates symbols or pairs of symbols

This is a subclass of ${class:name=LeibnizSortGrammar}$ that adds conversion of the parsed data to symbols.

"
Class {
	#name : #LeibnizSortParser,
	#superclass : #LeibnizSortGrammar,
	#category : #'Leibniz-1-SortGraphs'
}

{ #category : #productions }
LeibnizSortParser >> sort [
	^ super sort
		==> [ :id | { id } ]
]

{ #category : #productions }
LeibnizSortParser >> subsort [
	^ super subsort
		==> [ :nodes | { nodes first. nodes third } ]
]
