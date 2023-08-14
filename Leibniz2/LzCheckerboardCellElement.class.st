Class {
	#name : #LzCheckerboardCellElement,
	#superclass : #BlElement,
	#instVars : [
		'cellPosition',
		'board',
		'position'
	],
	#category : #'Leibniz2-CheckerboardModel'
}

{ #category : #accessing }
LzCheckerboardCellElement >> board [
	^ board
]

{ #category : #accessing }
LzCheckerboardCellElement >> board: anObject [
	board := anObject
]

{ #category : #accessing }
LzCheckerboardCellElement >> cellPosition [
	^ cellPosition
]

{ #category : #accessing }
LzCheckerboardCellElement >> cellPosition: aPoint [
	| cell |
	cellPosition := aPoint.
	cell := board cellAt: aPoint.
	cell = #' '
		ifTrue: [ self background: Color gray ]
		ifFalse: [
			self background:  (cell = #'*'
									ifTrue: [Color black ]
									ifFalse: [Color white ]).
			(board agentHappyAt: aPoint)
				ifFalse: [ self border: (BlBorder paint: Color red) ] ]
]

{ #category : #initializing }
LzCheckerboardCellElement >> initialize [
	super initialize.
	self layout: BlFrameLayout new.
	self size: 20 @ 20.
	self geometry: (BlRoundedRectangleGeometry cornerRadius: 5).
]
