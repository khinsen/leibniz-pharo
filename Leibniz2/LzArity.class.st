Class {
	#name : #LzArity,
	#superclass : #Array,
	#type : #variable,
	#instVars : [
		'sortGraph'
	],
	#category : #'Leibniz2-Leibniz2'
}

{ #category : #constructing }
LzArity class >> forArgs: anArrayOfTerms [
	| arity |
	arity := self new: anArrayOfTerms size.
	anArrayOfTerms collect: #sort into: arity.
	^ arity
]

{ #category : #constructing }
LzArity >> kindArity [
	| kindArity |
	kindArity := (LzArity new: self size)
					sortGraph: self sortGraph.
	self collect: #kind into: kindArity.
	^ kindArity
]

{ #category : #accessing }
LzArity >> sortGraph [
	^ sortGraph
]

{ #category : #accessing }
LzArity >> sortGraph: aSortGraph [
	sortGraph := aSortGraph
]
