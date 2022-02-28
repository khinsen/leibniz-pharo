Class {
	#name : #LzEGraphMatchStreamContents,
	#superclass : #LzStreamContents,
	#category : #'Leibniz2-EGraphs'
}

{ #category : #inspecting }
LzEGraphMatchStreamContents >> gtMatchesFor: aView [
	<gtView>
	| view |
	view := aView columnedList
		title: 'Matches';
		priority: 0;
		items: [ retrievedItems ];
		column: 'EClass' lzCode: #eClass;
		column: 'Substitution' lzCode: [ :each |
			each substitution gtDisplayString ];
		updateWhen: LzStreamContentsMoreItemsEvent in: [ self announcer ]
		yourself.
	self isComplete ifFalse: [
		view
			actionButtonIcon: BrGlamorousVectorIcons add
			tooltip: 'More'
			action: [ self moreItems ] ].
	^ view
]
