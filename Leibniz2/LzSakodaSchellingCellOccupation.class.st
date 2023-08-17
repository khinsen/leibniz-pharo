Class {
	#name : #LzSakodaSchellingCellOccupation,
	#superclass : #Object,
	#category : #'Leibniz2-SakodaSchellingModel'
}

{ #category : #accessing }
LzSakodaSchellingCellOccupation >> = other [
	^ self class = other class
]

{ #category : #accessing }
LzSakodaSchellingCellOccupation >> color [
	self subclassResponsibility
]

{ #category : #comparing }
LzSakodaSchellingCellOccupation >> hash [
	^ self class hash
]

{ #category : #testing }
LzSakodaSchellingCellOccupation >> isEmpty [
	self subclassResponsibility
]
