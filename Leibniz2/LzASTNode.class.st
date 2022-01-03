Class {
	#name : #LzASTNode,
	#superclass : #Object,
	#traits : 'TLzEquality',
	#classTraits : 'TLzEquality classTrait',
	#category : #'Leibniz2-Parser'
}

{ #category : #converting }
LzASTNode >> associations [
	^ self valueSlots collect: [ :each |
		each -> (self instVarNamed:  each) ]
]

{ #category : #inspecting }
LzASTNode >> gtTreeFor: aView [
	<gtView>
	^ aView columnedTree
		title: 'Tree';
		priority: 1;
		items: [ self associations ];
		children: [ :each | 
			each value isLzASTNode
				ifTrue: [ each value associations ]
				ifFalse: [ (each value isArray and: [ each value allSatisfy: #isDictionary ])
						ifTrue: [ each value collectWithIndex: [ :x :i | i -> x ] ]
						ifFalse: [ #() ] ] ];
		column: 'Field' text: [ :assoc | assoc key ];
		column: 'Value' text: [ :assoc | assoc value ];
		send: [ :assoc | assoc value ]
]

{ #category : #testing }
LzASTNode >> isLzASTNode [
	^ true
]

{ #category : #printing }
LzASTNode >> printOn: aStream [
	super printOn: aStream.
	self associations printElementsOn: aStream.
]

{ #category : #accessing }
LzASTNode >> valueSlots [
	^ self class allInstVarNames
]
