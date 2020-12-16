"
!Origins of items in a context

Contexts tend to be composed by recursively including other contexts, making it important to keep track of where everything was initially defined. This class represents the set of origins of a declaration (sort, subsort, ...) as it evolved during the construction of a context.
"
Class {
	#name : #LbOrigins,
	#superclass : #Object,
	#traits : 'EqualityThroughVariables',
	#classTraits : 'EqualityThroughVariables classTrait',
	#instVars : [
		'origins'
	],
	#category : #'Leibniz-0-Infrastructure'
}

{ #category : #'instance creation' }
LbOrigins class >> forCurrentContext [
	^ self new origins: (Set with: nil)
]

{ #category : #testing }
LbOrigins >> containsIncludes [
	origins detect: #isNotNil
		ifFound: [ ^ true] ifNone: [ ^ false ]
]

{ #category : #'instance creation' }
LbOrigins >> from: aContext [
	^ LbOrigins new
		origins: (origins collect: [ :each | each ifNil: [ aContext ] ])
]

{ #category : #accessing }
LbOrigins >> gtItemsFor: aView [
	<gtView>
	^ aView forward
		title: 'Items';
		priority: 0;
		object: [ self items ];
		view: #gtItemsFor:;
		yourself
]

{ #category : #accessing }
LbOrigins >> items [
	^ origins collect: [ :each | each ifNil: [ 'current context' ] ]
]

{ #category : #adding }
LbOrigins >> merge: anLbOrigins [
	origins := origins union: anLbOrigins origins
]

{ #category : #testing }
LbOrigins >> onlyIncludes [
	origins detect: #isNil
		ifFound: [ ^ false] ifNone: [ ^ true ]
]

{ #category : #'private - accessing' }
LbOrigins >> origins [
	^ origins
]

{ #category : #'private - accessing' }
LbOrigins >> origins: aSet [
	origins := aSet
]
