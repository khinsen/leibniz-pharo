Class {
	#name : #LzSortPatternMatcher,
	#superclass : #Object,
	#instVars : [
		'pattern',
		'term',
		'bindings',
		'report'
	],
	#category : #'Leibniz2-Sorts'
}

{ #category : #accessing }
LzSortPatternMatcher >> bindings [
	^ bindings
]

{ #category : #inspecting }
LzSortPatternMatcher >> gtBindingsFor: aView [
	<gtView>
	self bindings bindings ifEmpty: [ ^ aView empty ].
	^ aView forward
		title: 'Bindings';
		priority: 3;
		object: [ self bindings ];
		view: #gtBindingsFor:;
		yourself
]

{ #category : #inspecting }
LzSortPatternMatcher >> gtFailureFor: aView [
	<gtView>
	self bindings ifSuccess: [ ^ aView empty ].
	^ aView forward
		title: 'Failure';
		priority: 5;
		object: [ self bindings ];
		view: #gtFailureFor:;
		yourself
]

{ #category : #accessing }
LzSortPatternMatcher >> gtReportFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Report';
		priority: 0;
		items: [ report ];
		column: 'Item' text: [ :each | each key ];
		column: 'Pattern' text: [ :each | each value first gtDisplayText ];
		column: 'Term' text: [ :each | each value second gtDisplayText ];
		column: 'Success' text: [ :each |
			each value third ];
		send: [ :each | each value fourth ];
		yourself.
]

{ #category : #inspecting }
LzSortPatternMatcher >> gtUnboundFor: aView [
	<gtView>
	self bindings unboundVarSets ifEmpty: [ ^ aView empty ].
	^ aView forward
		title: 'Unbound';
		priority: 4;
		object: [ self bindings ];
		view: #gtUnboundFor:;
		yourself
]

{ #category : #accessing }
LzSortPatternMatcher >> match [
	bindings := self pattern matchWithSupersortsOf: self term.
	report := OrderedCollection
				with: #term ->
					{ pattern . term . bindings isSuccess .
						[ self pattern matchWithSupersortsOf: self term ] }
]

{ #category : #accessing }
LzSortPatternMatcher >> pattern [
	^ pattern
]

{ #category : #accessing }
LzSortPatternMatcher >> pattern: anLzSort [
	pattern := anLzSort.
	term ifNotNil: [ self match ].
]

{ #category : #accessing }
LzSortPatternMatcher >> term [
	^ term
]

{ #category : #accessing }
LzSortPatternMatcher >> term: anLzSort [
	 term := anLzSort.
	 pattern ifNotNil: [ self match ].
]
