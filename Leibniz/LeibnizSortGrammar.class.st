"
!The grammar for Leibniz sort graph definitions

!!Sorts

Sort names are plain identifiers.

!!Subsorts

Subsort relations are defined by ${method:name=LeibnizSortGrammar>>#subsort|expanded=}$.
"
Class {
	#name : #LeibnizSortGrammar,
	#superclass : #LeibnizGrammar,
	#instVars : [
		'subsortSymbol',
		'subsort',
		'sort'
	],
	#category : #'Leibniz-1-SortGraphs'
}

{ #category : #productions }
LeibnizSortGrammar >> sort [
	^ identifier

]

{ #category : #accessing }
LeibnizSortGrammar >> start [
	^ (subsort / sort) end
]

{ #category : #productions }
LeibnizSortGrammar >> subsort [
	^ identifier trim, subsortSymbol, identifier trim

]

{ #category : #productions }
LeibnizSortGrammar >> subsortSymbol [
	^ $⊆ asPParser

]
