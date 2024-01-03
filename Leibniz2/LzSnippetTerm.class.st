Class {
	#name : #LzSnippetTerm,
	#superclass : #LzTermInContext,
	#category : #'Leibniz2-Lepiter'
}

{ #category : #accessing }
LzSnippetTerm class >> firstSnippetStartingWith: text page: pageName [
	| page snippet |
	[
		page := LzBook pageNamed: pageName value.
		snippet := page allChildrenTextSnippets
			detect: [ :each | each text asString beginsWith: text value ]
	]
	on: Error
	do: [ LzRewriteFailure signal: 'No such snippet' ].
	^ snippet uid uidString.
]

{ #category : #accessing }
LzSnippetTerm class >> snippetWithUID: uidString [
	^ LzBook database
		blockWithUID: (LeUID new uidString: uidString)
]

{ #category : #inspecting }
LzSnippetTerm >> gtLiveFor: aView [
	<gtView>
	| snippet |
	[ snippet :=  self snippet ]
	on: Error
	do: [ ^ aView empty ].
	^ aView forward
		title: 'Snippet';
		priority: 0;
		object: [ snippet ];
		view: #gtLiveFor:
]

{ #category : #inspecting }
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
	^ self snippet page
]

{ #category : #accessing }
LzSnippetTerm >> snippet [
	^ self class snippetWithUID: self uidString
]

{ #category : #accessing }
LzSnippetTerm >> uidString [
	^ self normalForm args first value
]
