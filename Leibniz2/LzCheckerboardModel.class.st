"
A straightforward Pharo implementation of the agent-based model described in {{gtPage:Schelling's segregation model}}.



"
Class {
	#name : #LzCheckerboardModel,
	#superclass : #Object,
	#instVars : [
		'board',
		'randomGenerator'
	],
	#category : #'Leibniz2-CheckerboardModel'
}

{ #category : #operating }
LzCheckerboardModel >> agentHappyAt: aRow at: aColumn [
	| agent |
	agent := board at: aRow at: aColumn.
	^ (self fractionOf: agent inNeighborhoodOfCellAt: aRow at: aColumn) > (1/2)
]

{ #category : #agents }
LzCheckerboardModel >> blackAgent [
	^ #'*'
]

{ #category : #agents }
LzCheckerboardModel >> emptyCell [
	^ #' '
]

{ #category : #operating }
LzCheckerboardModel >> emptyCellPositions [
	| positions |
	positions := OrderedCollection new.
	1 to: board numberOfRows do: [ :aRow |
	 	1 to: board numberOfColumns do: [ :aColumn |
	 		(board at: aRow at: aColumn) = self emptyCell ifTrue: [
	 			positions add: aRow @ aColumn ] ] ].
	 ^ positions
]

{ #category : #operating }
LzCheckerboardModel >> emptyCellPositionsSortedByDistanceFrom: aPosition [
	| distancesAndPositions |
	distancesAndPositions := self emptyCellPositions collect: [ :eachPosition |
		{ eachPosition manhattanDistanceTo: aPosition . eachPosition } ].
	^ (distancesAndPositions
		sorted: [ :a :b | a first <= b first ])
		collect: #second
]

{ #category : #operating }
LzCheckerboardModel >> fractionOf: agentKind inNeighborhoodOfCellAt: aRow at: aColumn [
	| nCells nLikeCells |
	nCells := 0.
	nLikeCells := 0.
	aRow - 1 to: aRow + 1 do: [ :nbRow |
		aColumn - 1 to: aColumn + 1 do: [ :nbColumn |
			((nbRow between: 1 and: board numberOfRows)
				and: [ nbColumn between: 1 and: board numberOfColumns ])
				ifTrue: [
					nCells := nCells + 1.
					(board at: nbRow at: nbColumn) = agentKind
						ifTrue: [ nLikeCells := nLikeCells + 1 ] ] ] ].
	^ nLikeCells / nCells
]

{ #category : #operating }
LzCheckerboardModel >> fullPass [
	1 to: board numberOfRows do: [ :aRow |
	 	1 to: board numberOfColumns do: [ :aColumn |
	 		((board at: aRow at: aColumn) = self emptyCell) ifFalse: [
		 		self moveAgentAt: aRow at: aColumn ] ] ]
]

{ #category : #inspecting }
LzCheckerboardModel >> gtBoardFor: aView [
	<gtView>
	| view |
	view := aView columnedList
		title: 'Board';
		priority: 1;
		items: [ board rowsCollect: [ :row | row ] ].
	1 to: board numberOfColumns do: [ :i |
		view column: i asString text: [ :item | item at: i ] ].
	view 
		actionButtonIcon: BrGlamorousIcons fromhere 
		tooltip: 'Full pass'
		action: [ :aButton :aTab |
			self fullPass.
			aTab viewContentElement phlow update ]
]

{ #category : #initializing }
LzCheckerboardModel >> initialize [
	super initialize.
	board := Array2D rows: 13 columns: 16.
	randomGenerator := Random new.
	self randomInitialOccupationsWithEmptyFraction: 1/3.
]

{ #category : #operating }
LzCheckerboardModel >> moveAgentAt: aRow at: aColumn [
	| agent |
	agent := board at: aRow at: aColumn.
	(self agentHappyAt: aRow at: aColumn)
		ifFalse: [
			| destinations |
			destinations := self emptyCellPositionsSortedByDistanceFrom: aRow @ aColumn.
			destinations ifNotEmpty: [
				| destination |
				destination := destinations first.
				board
					swap: aRow at: aColumn
					with: destination x at: destination y ] ]
]

{ #category : #initializing }
LzCheckerboardModel >> randomInitialOccupationsWithEmptyFraction: aNumber [
	self assert: aNumber > 0.
	self assert: aNumber < 1.
	1 to: board numberOfRows do: [ :aRow |
	 	1 to: board numberOfColumns do: [ :aColumn |
	 		| cell |
	 		cell := self emptyCell.
	 		randomGenerator next > aNumber
	 			ifTrue: [ randomGenerator next > 0.5
	 						ifTrue: [ cell := self blackAgent ]
	 						ifFalse: [ cell := self whiteAgent ] ].
	 		board at: aRow at: aColumn put: cell ] ]
]

{ #category : #agents }
LzCheckerboardModel >> whiteAgent [
	^ #'0'
]
