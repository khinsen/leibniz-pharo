"
I am a parser for Leibniz terms.
"
Class {
	#name : #LeibnizTermParser,
	#superclass : #PPCompositeParser,
	#instVars : [
		'context',
		'integer',
		'rationalNumber',
		'atomic',
		'string',
		'fpNumber'
	],
	#category : #'Leibniz-3-Terms'
}

{ #category : #'instance creation' }
LeibnizTermParser class >> context: aContext [
	^self new
			setContext: aContext;
			yourself

]

{ #category : #accessing }
LeibnizTermParser class >> ignoredNames [
	^ super ignoredNames copyWith: #context

]

{ #category : #productions }
LeibnizTermParser >> atomic [
	^ rationalNumber / fpNumber / integer / string
]

{ #category : #productions }
LeibnizTermParser >> fpNumber [
	^ ($- asParser optional , #digit asParser plus ,
			($. asParser , (#digit asParser plus) ,
				($e asParser , $- asParser optional , #digit asParser plus) optional) optional)
		flatten trim 
		==> [ :value | LeibnizFPNumberTerm value: value asNumber inContext: context ]
]

{ #category : #productions }
LeibnizTermParser >> integer [
	^ ($- asParser optional , #digit asParser plus) flatten trim 
		==> [ :value | LeibnizIntegerTerm value: value asNumber inContext: context ]
]

{ #category : #productions }
LeibnizTermParser >> rationalNumber [
	^ ($- asParser optional , #digit asParser plus , $/ asParser , #digit asParser plus) flatten trim 
		==> [ :value | LeibnizRationalNumberTerm value: (Fraction readFromString: value)
															 inContext: context ]
]

{ #category : #initialization }
LeibnizTermParser >> setContext: aContext [
	context := aContext
]

{ #category : #accessing }
LeibnizTermParser >> start [
	^ atomic end
]

{ #category : #productions }
LeibnizTermParser >> string [
	^ ($" asParser , $" asParser negate plus , $" asParser) flatten trim 
		==> [ :value | LeibnizStringTerm value: (value copyFrom: 2 to: value size - 1)
													inContext: context ]
]
