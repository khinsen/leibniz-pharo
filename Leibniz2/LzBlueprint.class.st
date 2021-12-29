Class {
	#name : #LzBlueprint,
	#superclass : #Object,
	#category : #'Leibniz2-Parser'
}

{ #category : #converting }
LzBlueprint >> associations [
	^ self fieldNames collect: [ :each |
		each -> (self instVarNamed:  each) ]
]

{ #category : #accessing }
LzBlueprint >> fieldNames [
	^ self class allInstVarNames
]

{ #category : #inspecting }
LzBlueprint >> gtTreeFor: aView [
	<gtView>
	^ aView columnedTree
		title: 'Tree';
		priority: 1;
		items: [ self associations ];
		children: [ :each | 
			each value isLzBlueprint
				ifTrue: [ each value associations ]
				ifFalse: [ (each value isArray and: [ each value allSatisfy: #isDictionary ])
						ifTrue: [ each value collectWithIndex: [ :x :i | i -> x ] ]
						ifFalse: [ #() ] ] ];
		column: 'Field' text: [ :assoc | assoc key ];
		column: 'Value' text: [ :assoc | assoc value ];
		send: [ :assoc | assoc value ]
]

{ #category : #testing }
LzBlueprint >> isLzBlueprint [
	^ true
]

{ #category : #printing }
LzBlueprint >> printOn: aStream [
	super printOn: aStream.
	self associations printElementsOn: aStream.
]
