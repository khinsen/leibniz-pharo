Class {
	#name : #LzTaggedVarName,
	#superclass : #Object,
	#traits : 'TLzEquality',
	#classTraits : 'TLzEquality classTrait',
	#instVars : [
		'tag',
		'name'
	],
	#category : #'Leibniz2-Terms'
}

{ #category : #'instance creation' }
LzTaggedVarName class >> tag: aSymbolOrNil name: anOpName [
	^ aSymbolOrNil
		ifNil: [ anOpName ]
		ifNotNil: [
			self new
				tag: aSymbolOrNil;
				name: anOpName ]
]

{ #category : #comparing }
LzTaggedVarName >> <= other [
	^ self asString <= other asString
]

{ #category : #converting }
LzTaggedVarName >> asString [
	^ tag asString, '.', name asString
]

{ #category : #converting }
LzTaggedVarName >> asSymbol [
	^ self asString asSymbol
]

{ #category : #accessing }
LzTaggedVarName >> name [
	^ name
]

{ #category : #accessing }
LzTaggedVarName >> name: anLbOperatorName [
	name := anLbOperatorName
]

{ #category : #printing }
LzTaggedVarName >> printAsLeibnizSyntaxOn: aStream [
	tag printOn: aStream.
	aStream nextPut: $..
	name printAsLeibnizSyntaxOn: aStream.
]

{ #category : #accessing }
LzTaggedVarName >> tag [
	^ tag
]

{ #category : #accessing }
LzTaggedVarName >> tag: aSymbol [
	tag := aSymbol
]

{ #category : #accessing }
LzTaggedVarName >> valueSlots [
	^ #(tag name)
]
