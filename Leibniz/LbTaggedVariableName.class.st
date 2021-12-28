Class {
	#name : #LbTaggedVariableName,
	#superclass : #Object,
	#instVars : [
		'tag',
		'name'
	],
	#category : 'Leibniz-3-Terms'
}

{ #category : #'instance creation' }
LbTaggedVariableName class >> tag: aSymbolOrNil name: anLbOperatorName [
	^ aSymbolOrNil
		ifNil: [ anLbOperatorName ]
		ifNotNil: [ self new
						tag: aSymbolOrNil;
						name: anLbOperatorName;
						yourself ]
]

{ #category : #comparing }
LbTaggedVariableName >> <= other [
	^ self asString <= other asString
]

{ #category : #comparing }
LbTaggedVariableName >> = other [
	^ (self class = other class)
		and: [ (self tag = other tag)
				and: self name = other name ]
]

{ #category : #converting }
LbTaggedVariableName >> asString [
	^ tag asString, '.', name asString
]

{ #category : #converting }
LbTaggedVariableName >> asSymbol [
	^ self asString asSymbol
]

{ #category : #comparing }
LbTaggedVariableName >> hash [
	^ tag hash bitXor: name hash
]

{ #category : #accessing }
LbTaggedVariableName >> name [
	^ name
]

{ #category : #accessing }
LbTaggedVariableName >> name: anLbOperatorName [
	name := anLbOperatorName
]

{ #category : #printing }
LbTaggedVariableName >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	tag printOn: aStream.
	aStream nextPut: $..
	name printOn: aStream.
	aStream nextPut: $).
]

{ #category : #accessing }
LbTaggedVariableName >> tag [
	^ tag
]

{ #category : #accessing }
LbTaggedVariableName >> tag: aSymbol [
	tag := aSymbol
]
