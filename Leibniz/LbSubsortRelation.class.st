Class {
	#name : #LbSubsortRelation,
	#superclass : #Object,
	#traits : 'EqualityThroughVariables',
	#classTraits : 'EqualityThroughVariables classTrait',
	#instVars : [
		'subsort',
		'supersort',
		'sortGraph',
		'origins'
	],
	#category : #'Leibniz-1-SortGraphs'
}

{ #category : #inspecting }
LbSubsortRelation >> gtDeclarationFor: aView [
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
LbSubsortRelation >> gtOriginsFor: aView [
	<gtView>
	origins ifNil: [ ^ aView empty ].
	^ aView forward
		title: 'Origins';
		priority: 2;
		object: [ origins collect: [ :each | each ifNil: 'current context' ] ];
		view: #gtItemsFor:
]

{ #category : #accessing }
LbSubsortRelation >> origins [
	^ origins
]

{ #category : #accessing }
LbSubsortRelation >> printOn: aStream [
	aStream nextPutAll: subsort name asString.
	aStream nextPutAll: ' ⊆ '.
	aStream nextPutAll: supersort name asString
]

{ #category : #accessing }
LbSubsortRelation >> subsort [
	^ subsort
]

{ #category : #initialization }
LbSubsortRelation >> subsort: sort1 supersort: sort2 in: aSortGraph origins: aSet [
	subsort := sort1.
	supersort := sort2.
	sortGraph := aSortGraph.
	origins := aSet
]

{ #category : #initialization }
LbSubsortRelation >> subsort: sort1 supersort: sort2 origins: aSet [
	subsort := sort1.
	supersort := sort2.
	origins := aSet
]

{ #category : #accessing }
LbSubsortRelation >> supersort [
	^ supersort
]
