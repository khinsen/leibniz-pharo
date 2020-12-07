Class {
	#name : #LbVariable,
	#superclass : #Object,
	#traits : 'EqualityThroughVariables',
	#classTraits : 'EqualityThroughVariables classTrait',
	#instVars : [
		'signature',
		'name',
		'origins',
		'sort'
	],
	#category : #'Leibniz-2-Signatures'
}

{ #category : #'instance creation' }
LbVariable class >> named: aSymbol sort: aSort in: aSignature origins: anLbOrigins [
	^self basicNew
			initializeWithName: aSymbol sort: aSort signature: aSignature origins: anLbOrigins;
			yourself
]

{ #category : #accessing }
LbVariable >> gtDeclarationFor: aView [
	<gtView>
	^ aView explicit
		title: 'Declaration' translated;
		priority: 0;
		stencil: [
			LbCodeFont brLabelCellStencil value
				text: self printString;
				padding: (BlInsets all: 5) ]
]

{ #category : #inspecting }
LbVariable >> gtOriginsFor: aView [
	<gtView>
	origins ifNil: [ ^ aView empty ].
	^ aView forward
		title: 'Origins';
		priority: 2;
		object: [ origins ];
		view: #gtItemsFor:;
		yourself
]

{ #category : #initializing }
LbVariable >> initializeWithName: aNameSymbol sort: aSort signature: aSignature origins: anLbOrigins [
	signature := aSignature.
	name := aNameSymbol.
	sort := aSort.
	origins := anLbOrigins
]

{ #category : #accessing }
LbVariable >> name [
	^ name
]

{ #category : #accessing }
LbVariable >> origins [
	^ origins
]

{ #category : #printing }
LbVariable >> printOn: aStream [
	aStream nextPutAll: name asSymbol asString.
	aStream nextPutAll: ':'.
	aStream nextPutAll: sort name asString
]

{ #category : #accessing }
LbVariable >> sort [
	^ sort
]
