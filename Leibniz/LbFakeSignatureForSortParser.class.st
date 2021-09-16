Class {
	#name : 'LbFakeSignatureForSortParser',
	#superclass : 'Object',
	#category : 'Leibniz-1-SortGraphs'
}

{ #category : 'accessing' }
LbFakeSignatureForSortParser >> zeroArgTermNamed: anOpName extraVariables: aDictionary [
	self assert: aDictionary isEmpty.
	^ anOpName asSymbol
]
