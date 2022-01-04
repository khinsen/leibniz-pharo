Class {
	#name : #LzBuiltinContexts,
	#superclass : #Object,
	#category : #'Leibniz2-Leibniz2'
}

{ #category : #accessing }
LzBuiltinContexts class >> sortContext [
	^ LzSortHierarchyRoot uniqueInstance sortContext
]
