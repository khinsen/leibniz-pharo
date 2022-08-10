Class {
	#name : #LzLinePlot,
	#superclass : #Object,
	#instVars : [
		'points'
	],
	#category : #'Leibniz2-Plotting'
}

{ #category : #accessing }
LzLinePlot >> asElement [
	| data linePlot |
	data := GtPlotterDataGroup new
		values: points.
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

	^ linePlot create
]

{ #category : #accessing }
LzLinePlot >> points [

	^ points
]

{ #category : #accessing }
LzLinePlot >> points: anObject [

	points := anObject
]
