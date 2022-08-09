Class {
	#name : #LzPlotTerm,
	#superclass : #LzTermInContext,
	#instVars : [
		'eGraph'
	],
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
	^ self linePlot create
]

{ #category : #plotting }
LzPlotTerm >> linePlot [
	| data linePlot |
	self assert: self normalForm opName asSymbol = #linePlot.
	data := GtPlotterDataGroup new
		values: (self xyValuesFrom: self normalForm args first).
	linePlot := GtPlotterLineChart new
	valueX: #first;
	labelFormatX: [ :each | each printShowingDecimalPlaces: 1] ;
	scaleX: GtPlotterLinearScale new;
	titleX: 'x';
	ticksX: 10;
	valueY: #second;
	labelFormatY: [ :each | each printShowingDecimalPlaces: 2 ] ;
	scaleY: GtPlotterLinearScale new;
	titleY: 'y';
	ticksY: 10;
	with: data.

	^ linePlot
]

{ #category : #data }
LzPlotTerm >> xyValuesFrom: anArrayTerm [
	^ anArrayTerm elements collect: [ :each |
		{  each args first value. each args second value. } ]
]
