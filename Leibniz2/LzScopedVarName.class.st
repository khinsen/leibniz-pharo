Class {
	#name : #LzScopedVarName,
	#superclass : #LzVarName,
	#instVars : [
		'scope'
	],
	#category : #'Leibniz2-Declarations'
}

{ #category : #'instance creation' }
LzScopedVarName class >> for: internalSymbol scope: aSymbol [
	^ (super for: internalSymbol)
		scope: aSymbol;
		yourself
]

{ #category : #converting }
LzScopedVarName >> addAsRopedTextTo: aRopedText [
	| text |
	text := scope asRopedText
		attribute: LzVarNameAttribute new;
		attribute: LzVarNameScopeAttribute new;
		fontSize: 8.
	aRopedText append: text.
	super addAsRopedTextTo: aRopedText
]

{ #category : #'instance creation' }
LzScopedVarName >> for: aSymbol [
	self shouldNotImplement
]

{ #category : #printing }
LzScopedVarName >> printAsLeibnizSyntaxOn: aStream [
	aStream nextPutAll: scope.
	super printAsLeibnizSyntaxOn: aStream
]

{ #category : #accessing }
LzScopedVarName >> scope [
	^ scope
]

{ #category : #accessing }
LzScopedVarName >> scope: anObject [
	scope := anObject
]

{ #category : #accessing }
LzScopedVarName >> valueSlots [
	^ super valueSlots, #(scope)
]
