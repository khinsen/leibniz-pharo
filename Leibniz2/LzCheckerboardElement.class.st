Class {
	#name : #LzCheckerboardElement,
	#superclass : #BlElement,
	#instVars : [
		'board'
	],
	#category : #'Leibniz2-CheckerboardModel'
}

{ #category : #accessing }
LzCheckerboardElement >> board [
	^ board
]

{ #category : #accessing }
LzCheckerboardElement >> board: anLzCheckerboardModel [
	board := anLzCheckerboardModel.
	self update.
]

{ #category : #initializing }
LzCheckerboardElement >> initialize [
	super initialize.
	self layout: BlGridLayout horizontal.
	self layout cellSpacing: 7.
	self background: Color gray.
	self constraintsDo: [ :c |
		c horizontal fitContent.
		c vertical fitContent ].
]

{ #category : #updating }
LzCheckerboardElement >> update [
	self board ifNil: [ ^ self ].
	self removeChildren.
	self layout columnCount: self board numberOfColumns.
	1 to: board numberOfRows do: [ :aRow |
	 	1 to: board numberOfColumns do: [ :aColumn |
			| aCellElement |
			aCellElement := LzCheckerboardCellElement new.
			aCellElement
				board: board;
				cellPosition: aRow @ aColumn.
		 	self addChild: aCellElement ] ].
]
