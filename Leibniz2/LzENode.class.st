Class {
	#name : #LzENode,
	#superclass : #Array,
	#type : #variable,
	#category : #'Leibniz2-EGraphs'
}

{ #category : #accessing }
LzENode >> canonicalizeIn: anEGraph [
	1 to: self size do: [ :index|
		self at: index put:
			(anEGraph findRootFor: (self at: index)) ].
]
