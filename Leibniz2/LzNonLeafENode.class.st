Class {
	#name : #LzNonLeafENode,
	#superclass : #LzENode,
	#type : #variable,
	#instVars : [
		'sort'
	],
	#category : #'Leibniz2-EGraphs'
}

{ #category : #enumerating }
LzNonLeafENode >> allArgTerms: classIds [
	classIds ifEmpty: [ ^ #(#()) ].
	^ Generator on: [ :generator |
		| gFirst gRest |
		gFirst :=  (graph classForId: classIds first) allTerms.
		gRest := self allArgTerms: classIds allButFirst.
		gFirst do: [ :firstArg |
			gRest do: [ :restArgs |
				generator yield: { firstArg }, restArgs ]   ] ]
]

{ #category : #updating }
LzNonLeafENode >> canonicalizeIn: anEGraph [
	| oldClassId |
	oldClassId := nil.
	1 to: self size do: [ :index |
		| classId rootId |
		classId := self at: index.
		rootId := anEGraph findRootFor: classId.
		(oldClassId isNil and: [ rootId ~= classId ]) ifTrue: [
			oldClassId := anEGraph removeFromMemo: self ].
		self at: index put: rootId  ].
	oldClassId ifNotNil: [ anEGraph addMemoEntry: self classId: oldClassId ]
]

{ #category : #testing }
LzNonLeafENode >> hasLinkToAncestorIn: aSet [
	^ self
		detect: [ :each |
			| class |
			class := graph classForId: each.
			(aSet includes: class) or: [ class hasLinkToAncestorIn: aSet ] ]
		ifFound: [ true ]
		ifNone: [ false ]
]

{ #category : #printing }
LzNonLeafENode >> printAsLeibnizSyntaxOn: aStream [
	self
		printAsLeibnizSyntaxOn: aStream
		parents: IdentitySet new
]

{ #category : #accessing }
LzNonLeafENode >> sort [
	^ sort
]

{ #category : #accessing }
LzNonLeafENode >> sort: aSort [
	sort := aSort
]
