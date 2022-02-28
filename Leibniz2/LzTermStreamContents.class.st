Class {
	#name : #LzTermStreamContents,
	#superclass : #LzStreamContents,
	#category : #'Leibniz2-EGraphs'
}

{ #category : #inspecting }
LzTermStreamContents >> gtTermsFor: aView [
	<gtView>
	| view |
	view := aView list
		title: 'Terms';
		priority: 0;
		items: [ retrievedItems ];
		itemLzCode: #asLeibnizSyntaxString;
		updateWhen: LzStreamContentsMoreItemsEvent in: [ self announcer ]
		yourself.
	self isComplete ifFalse: [
		view
			actionButtonIcon: BrGlamorousVectorIcons add
			tooltip: 'More'
			action: [ self moreItems ] ].
	^ view
]
