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
LbSubstitution class >> variable: aName value: aTerm [
	^self basicNew
			initializeWithVariable: aName value: aTerm;
			yourself.
]

{ #category : #accessing }
LbSubstitution >> combineWith: anotherMatch [
	anotherMatch variables keysAndValuesDo:
		[ :name :value |
		  variables at: name
				ifPresent: [ :priorValue | priorValue = value ifFalse: [ ^ nil ]].
		  variables at: name put: value ]
]

{ #category : #inspecting }
LbSubstitution >> gtItemsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Items' translated;
		priority: 1;
		items: [ variables associations sorted: [ :a :b | a key <= b key ]];
		column: 'Name' do: [ :aColumn |
			aColumn cellStencil: LbCodeFont brLabelCellStencil;
			dataBinder: [ :eachLabel :eachItem |
				eachLabel text: eachItem key asSymbol ] ];
		column: 'Value' do: [ :aColumn |
			aColumn cellStencil: LbCodeFont brLabelCellStencil;
			dataBinder: [ :eachLabel :eachItem |
				eachLabel text: eachItem value asLeibnizSyntaxString ] ];
		yourself
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

{ #category : #printing }
LbSubstitution >> printOn: aStream [
	| printOne |
	printOne := [ :association |
		aStream nextPutAll: association key asString.
		aStream nextPutAll: ' -> '.
		association value printAsLeibnizSyntaxOn: aStream ].
	variables associations allButLast do: [ :each |
		printOne value: each.
		aStream nextPutAll: ', ' ].
	printOne value: variables associations last.
]

{ #category : #accessing }
LbSubstitution >> variables [
	^ variables
]
