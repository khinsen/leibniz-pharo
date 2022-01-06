Class {
	#name : #LzArity,
	#superclass : #Array,
	#type : #variable,
	#traits : 'TLzPrintable',
	#classTraits : 'TLzPrintable classTrait',
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

{ #category : #printing }
LzArity >> printAsLeibnizSyntaxOn: aStream [
	"self printVariablesAsLeibnizSyntaxOn: aStream."
	self
		do: [ :each | each printAsLeibnizSyntaxOn: aStream ]
		separatedBy: [ aStream nextPutAll: ', ' ]
]

{ #category : #accessing }
LzArity >> sortGraph [
	^ sortGraph
]

{ #category : #accessing }
LzArity >> sortGraph: aSortGraph [
	self flag: #todo.
	"Not sure this is really needed!"
	"sortGraph := aSortGraph"
]
