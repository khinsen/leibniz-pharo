"
!A sort graph grammar subclass that generates symbols or pairs of symbols

This is a subclass of ${class:name=LbSortGrammar}$ that adds conversion of the parsed data to symbols.

"
Class {
	#name : 'LbSortParser',
	#superclass : 'LbSortGrammar',
	#category : 'Leibniz-1-SortGraphs'
}

{ #category : 'productions' }
LbSortParser >> sort [
	^ super sort
		==> [ :id | { id } ]
]

{ #category : 'productions' }
LbSortParser >> subsort [
	^ super subsort
		==> [ :nodes | { nodes first. nodes third } ]
]
