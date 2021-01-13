"
I represent the mapping from variables to values that results from matching a term to a pattern.
"
Class {
	#name : #LbSubstitution,
	#superclass : #Object,
	#instVars : [
		'variables'
	],
	#category : #'Leibniz-3-Terms'
}

{ #category : #'instance creation' }
LbSubstitution class >> null [
	^ self basicNew
		initialize;
		makeNull;
		yourself
]

{ #category : #'instance creation' }
LbSubstitution class >> variable: aName value: aTerm [
	^self basicNew
			initializeWithVariable: aName value: aTerm;
			yourself.
]

{ #category : #accessing }
LbSubstitution >> combineWith: anotherMatch [
	variables ifNil: [ ^ self ].
	anotherMatch isNull ifTrue: [ self makeNull. ^ self ].
	anotherMatch variables keysAndValuesDo: [ :name :value |
		variables at: name ifAbsentPut:  [ value ].
		(variables at: name) = value
			ifFalse: [ self makeNull ] ]
]

{ #category : #inspecting }
LbSubstitution >> gtItemsFor: aView [
	<gtView>
	variables ifNil: [ ^ aView empty ].
	^ aView columnedList
		title: 'Items' translated;
		priority: 1;
		items: [ variables associations
					sorted: [ :a :b | a key <= b key ] ];
		column: 'Name' lbCode: [ :each | each key asSymbol ];
		column: 'Value' lbCode: [ :each | each value asLeibnizSyntaxString];
		yourself
]

{ #category : #testing }
LbSubstitution >> ifNotNull: aBlock [
	self isNull ifFalse: [ ^ aBlock value: self ]
]

{ #category : #testing }
LbSubstitution >> ifNull: aNullBlock ifNotNull: aBlock [
	self isNull
		ifTrue: [ ^ aNullBlock value ]
		ifFalse: [ ^ aBlock value: self ]
]

{ #category : #initialization }
LbSubstitution >> initialize [
	variables := Dictionary new
]

{ #category : #initialization }
LbSubstitution >> initializeWithVariable: aSymbol value: aTerm [
	self initialize.
	variables at: aSymbol put: aTerm.
]

{ #category : #testing }
LbSubstitution >> isNull [
	^ variables isNil
]

{ #category : #accessing }
LbSubstitution >> makeNull [
	variables := nil
]

{ #category : #printing }
LbSubstitution >> printOn: aStream [
	| printOne |
	super printOn: aStream.
	variables ifNil: [ aStream nextPutAll: '(null)'. ^ self ].
	printOne := [ :association |
		aStream nextPutAll: association key asString.
		aStream nextPutAll: ' -> '.
		association value printAsLeibnizSyntaxOn: aStream ].
	aStream nextPut: $(.
	variables associations allButLast do: [ :each |
		printOne value: each.
		aStream nextPutAll: ', ' ].
	printOne value: variables associations last.
	aStream nextPut: $).
]

{ #category : #accessing }
LbSubstitution >> variables [
	^ variables
]
