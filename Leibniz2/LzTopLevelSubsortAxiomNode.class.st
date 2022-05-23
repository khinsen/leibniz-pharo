Class {
	#name : #LzTopLevelSubsortAxiomNode,
	#superclass : #LzTopLevelAxiomNode,
	#instVars : [
		'subsort',
		'subsetOf',
		'supersort'
	],
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzTopLevelSubsortAxiomNode >> acceptVisitor: aParseTreeVisitor [
	^ aParseTreeVisitor visitTopLevelSubsortAxiom: self
]

{ #category : #generated }
LzTopLevelSubsortAxiomNode >> nodeVariables [
	^ #(#subsort #supersort)
]

{ #category : #generated }
LzTopLevelSubsortAxiomNode >> subsetOf [
	^ subsetOf
]

{ #category : #generated }
LzTopLevelSubsortAxiomNode >> subsetOf: aSmaCCToken [
	subsetOf := aSmaCCToken
]

{ #category : #generated }
LzTopLevelSubsortAxiomNode >> subsort [
	^ subsort
]

{ #category : #generated }
LzTopLevelSubsortAxiomNode >> subsort: aLzParseTreeNode [
	self subsort notNil ifTrue: [ self subsort parent: nil ].
	subsort := aLzParseTreeNode.
	self subsort notNil ifTrue: [ self subsort parent: self ]
]

{ #category : #generated }
LzTopLevelSubsortAxiomNode >> supersort [
	^ supersort
]

{ #category : #generated }
LzTopLevelSubsortAxiomNode >> supersort: aLzParseTreeNode [
	self supersort notNil ifTrue: [ self supersort parent: nil ].
	supersort := aLzParseTreeNode.
	self supersort notNil ifTrue: [ self supersort parent: self ]
]

{ #category : #generated }
LzTopLevelSubsortAxiomNode >> tokenVariables [
	^ #(#subsetOf)
]
