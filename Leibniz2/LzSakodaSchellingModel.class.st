"
A straightforward Pharo implementation of the agent-based model described in {{gtPage:Schelling's segregation model}}.

"
Class {
	#name : #LzSakodaSchellingModel,
	#superclass : #Object,
	#instVars : [
		'board',
		'randomGenerator'
	],
	#category : #'Leibniz2-SakodaSchellingModel'
}

{ #category : #'instance creation' }
LzSakodaSchellingModel class >> fromRandomSeed: anInteger [
	^ self new
		randomGenerator: (Random new seed: anInteger);
		yourself
]

{ #category : #operating }
LzSakodaSchellingModel >> agent: aCellOccupation isHappyAt: aPosition [
	self assert: aCellOccupation isEmpty not.
	^ (self fractionOf: aCellOccupation inNeighborhoodOfCell: aPosition) >= (1/2)
]

{ #category : #operating }
LzSakodaSchellingModel >> agentIsHappyAt: aPoint [
	^ self
		agent: (board at: aPoint x at: aPoint y)
		isHappyAt: aPoint
]

{ #category : #operating }
LzSakodaSchellingModel >> allCellsDo: aBlock [
	1 to: board numberOfRows do: [ :aRow |
	 	1 to: board numberOfColumns do: [ :aColumn |
	 		aBlock value: aRow @ aColumn ] ]
]

{ #category : #operating }
LzSakodaSchellingModel >> allCellsSelect: aBlock [
	| positions |
	positions := OrderedCollection new.
	self allCellsDo: [ :aPoint |
		(aBlock value: aPoint)
			ifTrue: [ positions add: aPoint ] ].
	^ positions
]

{ #category : #accessing }
LzSakodaSchellingModel >> cellAt: aPosition [
	^ board at: aPosition x at: aPosition y
]

{ #category : #testing }
LzSakodaSchellingModel >> cellIsEmptyAt: aPoint [
	^ (self cellOccupationAt: aPoint) isEmpty
]

{ #category : #accessing }
LzSakodaSchellingModel >> cellOccupationAt: aPoint [
	^ board at: aPoint x at: aPoint y
]

{ #category : #operating }
LzSakodaSchellingModel >> destinationForAgent: aSymbol at: aPoint [
	self emptyCellPositionsSortedByDistanceFrom: aPoint.
]

{ #category : #operating }
LzSakodaSchellingModel >> emptyCellPositionsSortedByDistanceFrom: aPosition [
	| distancesAndPositions |
	distancesAndPositions := self emptyCells collect: [ :eachPosition |
		{ eachPosition manhattanDistanceTo: aPosition . eachPosition } ].
	^ (distancesAndPositions
		sorted: [ :a :b | a first <= b first ])
		collect: #second
]

{ #category : #operating }
LzSakodaSchellingModel >> emptyCells [
	^ self allCellsSelect: [ :aPosition |
		(self cellIsEmptyAt: aPosition)]
]

{ #category : #operating }
LzSakodaSchellingModel >> emptyCellsSortedByDistanceFrom: aPosition [
	| distancesAndPositions |
	distancesAndPositions := self emptyCells collect: [ :eachPosition |
		{ eachPosition manhattanDistanceTo: aPosition . eachPosition } ].
	^ (distancesAndPositions
		sorted: [ :a :b | a first <= b first ])
		collect: #second
]

{ #category : #operating }
LzSakodaSchellingModel >> fractionOf: agentKind inNeighborhoodOfCell: aPosition [
	| nCells nLikeCells |
	nCells := 0.
	nLikeCells := 0.
	self neighborhoodOf: aPosition do: [ :nbPosition |
		(self cellIsEmptyAt: nbPosition)
			ifFalse: [
				nCells := nCells + 1.
				(agentKind = (self cellOccupationAt: nbPosition))
					ifTrue: [ nLikeCells := nLikeCells + 1 ] ] ].
	^ nCells isZero
		ifTrue: [ 1 ]
		ifFalse: [ nLikeCells / nCells ]
]

{ #category : #operating }
LzSakodaSchellingModel >> fullPass [
	"Do a full pass over the board, attempting to move all unhappy
	 agents. Return true if any agent was moved, false otherwise."
	| moved |
	moved := false.
	self allCellsDo: [ :eachPoint |
		(self cellIsEmptyAt: eachPoint) ifFalse: [
			(self moveAgentAt: eachPoint)
				 ifTrue: [ moved := true ] ] ].
	^ moved
]

{ #category : #inspecting }
LzSakodaSchellingModel >> gtBoardFor: aView [
	<gtView>
	^ aView explicit
		title: 'Board';
		priority: 1;
		stencil: [ LzSakodaSchellingElement new board: self ];
		actionButtonIcon: BrGlamorousIcons fromhere 
			tooltip: 'One pass'
			action: [ :aButton :aTab |
				self fullPass.
				aTab viewContentElement children first update ];
		actionButtonIcon: BrGlamorousVectorIcons play 
			tooltip: 'Animation'
			action: [ :aButton :aTab |
				aTab viewContentElement children first multiplePassAnimation ];
		yourself
]

{ #category : #initializing }
LzSakodaSchellingModel >> initialize [
	super initialize.
	randomGenerator := Random new
]

{ #category : #initializing }
LzSakodaSchellingModel >> initializeBoardWithSize: aPoint fractionEmpty: aNumber [
	self assert: (aNumber between: 0 and: 1).
	board := Array2D rows: aPoint x columns: aPoint y.
	self allCellsDo: [ :eachPoint |
		| cellOccupation |
		cellOccupation :=
			randomGenerator next > aNumber
				ifFalse: [ LzSakodaSchellingEmptyCell new]
				ifTrue: [
					randomGenerator next > 0.5
	 					ifTrue: [ LzSakodaSchellingBlackCell new ]
	 					ifFalse: [ LzSakodaSchellingWhiteCell new ] ].
		board at: eachPoint x at: eachPoint y put: cellOccupation ]
]

{ #category : #testing }
LzSakodaSchellingModel >> isValidPosition: aPoint [
	^ (aPoint x between: 1 and: board numberOfRows)
		and: [ aPoint y between: 1 and: board numberOfColumns ]
]

{ #category : #operating }
LzSakodaSchellingModel >> moveAgentAt: aPoint [
	"Move the agent at aPoint if it is unhappy. Return true if
	 the agent was moved, false otherwise."
	| agent |
	agent := board at: aPoint x at: aPoint y.
	(self agent: agent isHappyAt: aPoint)
		ifTrue: [ ^ false ].
	(self nearestEmptyCellProvidingHappinessTo: agent currentlyAt: aPoint)
		ifNil: [ ^ false ]
		ifNotNil: [ :happinessPoint |
			board
				swap: aPoint x at: aPoint y
				with: happinessPoint x at: happinessPoint y.
			^ true ]
]

{ #category : #operating }
LzSakodaSchellingModel >> multiplePassGenerator [
	^ Generator on: [ :g |
		[
			| moved |
			moved := false.
			self allCellsDo: [ :eachPoint |
				(self cellIsEmptyAt: eachPoint) ifFalse: [
					(self moveAgentAt: eachPoint)
						ifTrue: [
							moved := true.
							g yield: eachPoint ] ] ].
			moved ] whileTrue ]
]

{ #category : #operating }
LzSakodaSchellingModel >> nearestEmptyCellProvidingHappinessTo: agent currentlyAt: aPoint [
	(self emptyCellPositionsSortedByDistanceFrom: aPoint)
		detect: [ :eachPoint |
			self agent: agent isHappyAt: eachPoint ]
		ifFound: [ :happinessPoint | ^ happinessPoint ].
	^ nil
]

{ #category : #operating }
LzSakodaSchellingModel >> neighborHoodOf: aPosition do: anObject [ 
]

{ #category : #operating }
LzSakodaSchellingModel >> neighborhoodOf: aPosition do: aBlock [ 
	aPosition x - 1 to: aPosition x + 1 do: [ :nbRow |
		aPosition y - 1 to: aPosition y + 1 do: [ :nbColumn |
			| nbPosition |
			nbPosition := nbRow @ nbColumn.
			(nbPosition = aPosition)
				ifFalse: [
					(self isValidPosition: nbPosition)
						ifTrue: [ aBlock value:  nbPosition ] ] ] ]
]

{ #category : #accessing }
LzSakodaSchellingModel >> numberOfColumns [
	^ board numberOfColumns
]

{ #category : #accessing }
LzSakodaSchellingModel >> numberOfRows [
	^ board numberOfRows
]

{ #category : #accessing }
LzSakodaSchellingModel >> randomGenerator: anObject [
	randomGenerator := anObject 
]

{ #category : #inspecting }
LzSakodaSchellingModel >> spawnDebuggerForCellAt: aPoint [
	self halt.
	self moveAgentAt: aPoint
]
