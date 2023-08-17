Class {
	#name : #LzSakodaSchellingEmptyCell,
	#superclass : #LzSakodaSchellingCellOccupation,
	#category : #'Leibniz2-SakodaSchellingModel'
}

{ #category : #accessing }
LzSakodaSchellingEmptyCell >> color [
	^ Color gray
]

{ #category : #testing }
LzSakodaSchellingEmptyCell >> isEmpty [
	^ true
]
