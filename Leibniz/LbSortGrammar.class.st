"
!The grammar for Leibniz sort graph definitions

!!Sorts

Sort names are plain identifiers.

!!Subsorts

Subsort relations are defined by ${method:name=LbSortGrammar>>#subsort|expanded=}$.
"
Class {
	#name : 'LbSortGrammar',
	#superclass : 'LbGrammar',
	#instVars : [
		'subsortSymbol',
		'subsort',
		'sort'
	],
	#category : 'Leibniz-1-SortGraphs'
}

{ #category : 'productions' }
LbSortGrammar >> sort [
	^ identifier

]

{ #category : 'accessing' }
LbSortGrammar >> start [
	^ (subsort / sort) end
]

{ #category : 'productions' }
LbSortGrammar >> subsort [
	^ identifier trim, subsortSymbol, identifier trim

]

{ #category : 'productions' }
LbSortGrammar >> subsortSymbol [
	^ $⊆ asPParser

]
