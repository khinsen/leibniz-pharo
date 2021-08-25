Extension { #name : 'GtPhlowColumnedTreeView' }

{ #category : '*Leibniz' }
GtPhlowColumnedTreeView >> column: aTitleString lbCode: aBlock [
	"A variant of column:text: that uses
	 an appropriate Unicode font for Leibniz code"
	self column: aTitleString do: [ :aColumn |
		aColumn cellStencil: LbCodeFont brLabelCellStencil;
		dataBinder: [ :eachLabel :eachItem |
			eachLabel text: (aBlock value: eachItem)  ] ]
]

{ #category : '*Leibniz' }
GtPhlowColumnedTreeView >> column: aTitleString lbCode: aBlock weight: aNumber [
	"A variant of column:text: that uses
	 an appropriate Unicode font for Leibniz code"
	self column: aTitleString do: [ :aColumn |
		aColumn cellStencil: LbCodeFont brLabelCellStencil;
		dataBinder: [ :eachLabel :eachItem |
			eachLabel text: (aBlock value: eachItem)  ];
		weight: aNumber ]
]
