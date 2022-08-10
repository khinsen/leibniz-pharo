Class {
	#name : #LzPlotTerm,
	#superclass : #LzTermInContext,
	#category : #'Leibniz2-Plotting'
}

{ #category : #inspecting }
LzPlotTerm >> gtViewFor: aView [
	<gtView>
	^ aView forward
		title: 'Plot';
		priority: 0;
		object: [ self inlineView ];
		view: #gtLiveFor:.
]

{ #category : #testing }
LzPlotTerm >> hasInlineView [
	^ true
]

{ #category : #viewing }
LzPlotTerm >> inlineView [
	self assert: self normalForm opName asSymbol = #linePlot.
	^ (LzLinePlot new
		points: self xyValues)
		asElement
]

{ #category : #data }
LzPlotTerm >> xValuesFrom: xArray yValuesFrom: yArray [
	| x y |
	x := xArray elements collect: #value.
	y := yArray elements collect: #value.
	^ x with: y collect: [ :xv :yv | { xv. yv } ]
]

{ #category : #data }
LzPlotTerm >> xyValues [
	| args |
	args := self normalForm args.
	args size = 1 ifTrue: [ ^ self xyValuesFrom: args first ].
	args size = 2 ifTrue: [ ^ self xValuesFrom: args first yValuesFrom: args second ].
	self notYetImplemented
]

{ #category : #data }
LzPlotTerm >> xyValuesFrom: anArrayTerm [
	^ anArrayTerm elements collect: [ :each |
		{  each args first value. each args second value. } ]
]
