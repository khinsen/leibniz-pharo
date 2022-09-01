Class {
	#name : #LzSnippetTerm,
	#superclass : #LzTermInContext,
	#category : #'Leibniz2-Lepiter'
}

{ #category : #accessing }
LzSnippetTerm >> ensureSnippetExists [
	[ self snippet ]
	on: Error
	do: [ LzRewriteFailure signal: 'No such snippet' ]
]

{ #category : #accessing }
LzSnippetTerm >> gtLiveFor: aView [
	<gtView>
	self class isAbstract
		ifTrue: [ ^ aView empty ].
	^ aView forward
		title: 'Snippet';
		priority: 0;
		object: [ self snippet ];
		view: #gtLiveFor:
]

{ #category : #accessing }
LzSnippetTerm >> gtSpawnSnippetFor: anAction [
	<gtAction>
	| snippet |
	[ snippet :=  self snippet ]
	on: Error
	do: [ ^ anAction noAction ].
	^ anAction button
		tooltip: 'Inspect the snippet';
		priority: 1;
		icon: BrGlamorousIcons fromhere;
		action: [ :aButton |
			aButton phlow spawnObject: snippet ]
]

{ #category : #accessing }
LzSnippetTerm >> page [
	| name |
	name := self term args second value.
	^ LzBook pageNamed: name
]

{ #category : #accessing }
LzSnippetTerm >> snippet [
	| string |
	string := self term args first value.
	^ self page allChildrenTextSnippets
		detect: [ :each | each text asString beginsWith: string ]
]
