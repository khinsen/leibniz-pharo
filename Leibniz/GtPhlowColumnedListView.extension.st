Extension { #name : #GtPhlowColumnedListView }

{ #category : #'*Leibniz' }
GtPhlowColumnedListView >> column: aTitleString lbCode: aBlock [
	"A variant of column:text: that uses
	 an appropriate Unicode font for Leibniz code"
	self column: aTitleString do: [ :aColumn |
		aColumn cellStencil: LbCodeFont brLabelCellStencil;
		dataBinder: [ :eachLabel :eachItem |
			eachLabel text: (aBlock value: eachItem)  ] ]
]
