Class {
	#name : #LzScanner,
	#superclass : #SmaCCScanner,
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #'generated-initialization' }
LzScanner class >> initializeKeywordMap [
	keywordMap := Dictionary new.
	#(#(29 'arrays' 11) #(29 'classTerms' 12) #(29 'floatingPointNumbers' 13) #(29 'integers' 14) #(29 'name' 15) #(29 'name=' 16) #(29 'rationalNumbers' 17) #(29 'strings' 18))
		do: [ :each | 
			(keywordMap at: each first ifAbsentPut: [ Dictionary new ])
				at: (each at: 2)
				put: each last ].
	^ keywordMap
]

{ #category : #generated }
LzScanner >> emptySymbolTokenId [
	^ 76
]

{ #category : #generated }
LzScanner >> errorTokenId [
	^ 77
]

{ #category : #generated }
LzScanner >> scan1 [
	[ self recordMatch: #(29).
	self step.
	currentCharacter == $_
		ifTrue: [ [ self recordMatch: #(30).
			self step.
			currentCharacter == $_ ] whileTrue.
			^ self reportLastMatch ].
	currentCharacter isLzIdentifierCharacter
		or: [ currentCharacter == $. or: [ currentCharacter between: $0 and: $9 ] ] ]
		whileTrue.
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> scan10 [
	self step.
	currentCharacter == $- ifTrue: [ self step ].
	(currentCharacter between: $0 and: $9)
		ifTrue: [ [ self recordMatch: #(28).
			self step.
			currentCharacter between: $0 and: $9 ] whileTrue ].
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> scan11 [
	self recordMatch: #(5 29).
	self step.
	currentCharacter == $_
		ifTrue: [ [ self recordMatch: #(30).
			self step.
			currentCharacter == $_ ] whileTrue.
			^ self reportLastMatch ].
	(currentCharacter isLzIdentifierCharacter
		or: [ currentCharacter == $. or: [ currentCharacter between: $0 and: $9 ] ])
		ifTrue: [ ^ self scan1 ].
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> scan12 [
	self recordMatch: #(29).
	self step.
	currentCharacter == $_
		ifTrue: [ [ self recordMatch: #(30).
			self step.
			currentCharacter == $_ ] whileTrue.
			^ self reportLastMatch ].
	currentCharacter == $h ifTrue: [ ^ self scan13 ].
	(currentCharacter isLzIdentifierCharacter
		or: [ currentCharacter == $. or: [ currentCharacter between: $0 and: $9 ] ])
		ifTrue: [ ^ self scan1 ].
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> scan13 [
	self recordMatch: #(29).
	self step.
	currentCharacter == $_
		ifTrue: [ [ self recordMatch: #(30).
			self step.
			currentCharacter == $_ ] whileTrue.
			^ self reportLastMatch ].
	currentCharacter == $a ifTrue: [ ^ self scan14 ].
	(currentCharacter isLzIdentifierCharacter
		or: [ currentCharacter == $. or: [ currentCharacter between: $0 and: $9 ] ])
		ifTrue: [ ^ self scan1 ].
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> scan14 [
	self recordMatch: #(29).
	self step.
	currentCharacter == $_
		ifTrue: [ [ self recordMatch: #(30).
			self step.
			currentCharacter == $_ ] whileTrue.
			^ self reportLastMatch ].
	currentCharacter == $r ifTrue: [ ^ self scan15 ].
	(currentCharacter isLzIdentifierCharacter
		or: [ currentCharacter == $. or: [ currentCharacter between: $0 and: $9 ] ])
		ifTrue: [ ^ self scan1 ].
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> scan15 [
	self recordMatch: #(29).
	self step.
	currentCharacter == $_
		ifTrue: [ [ self recordMatch: #(30).
			self step.
			currentCharacter == $_ ] whileTrue.
			^ self reportLastMatch ].
	currentCharacter == $o ifTrue: [ ^ self scan16 ].
	(currentCharacter isLzIdentifierCharacter
		or: [ currentCharacter == $. or: [ currentCharacter between: $0 and: $9 ] ])
		ifTrue: [ ^ self scan1 ].
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> scan16 [
	self recordMatch: #(29).
	self step.
	currentCharacter == $: ifTrue: [ ^ self recordAndReportMatch: #(6) ].
	currentCharacter == $_
		ifTrue: [ [ self recordMatch: #(30).
			self step.
			currentCharacter == $_ ] whileTrue.
			^ self reportLastMatch ].
	(currentCharacter isLzIdentifierCharacter
		or: [ currentCharacter == $. or: [ currentCharacter between: $0 and: $9 ] ])
		ifTrue: [ ^ self scan1 ].
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> scan17 [
	self recordMatch: #(20 29).
	self step.
	currentCharacter == $_
		ifTrue: [ [ self recordMatch: #(30).
			self step.
			currentCharacter == $_ ] whileTrue.
			^ self reportLastMatch ].
	(currentCharacter isLzIdentifierCharacter
		or: [ currentCharacter == $. or: [ currentCharacter between: $0 and: $9 ] ])
		ifTrue: [ ^ self scan1 ].
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> scan18 [
	self recordMatch: #(22 29).
	self step.
	currentCharacter == $_
		ifTrue: [ [ self recordMatch: #(30).
			self step.
			currentCharacter == $_ ] whileTrue.
			^ self reportLastMatch ].
	(currentCharacter isLzIdentifierCharacter
		or: [ currentCharacter == $. or: [ currentCharacter between: $0 and: $9 ] ])
		ifTrue: [ ^ self scan1 ].
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> scan19 [
	self recordMatch: #(23 29).
	self step.
	currentCharacter == $_
		ifTrue: [ [ self recordMatch: #(30).
			self step.
			currentCharacter == $_ ] whileTrue.
			^ self reportLastMatch ].
	(currentCharacter isLzIdentifierCharacter
		or: [ currentCharacter == $. or: [ currentCharacter between: $0 and: $9 ] ])
		ifTrue: [ ^ self scan1 ].
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> scan2 [
	self recordMatch: #(29).
	self step.
	currentCharacter == $_
		ifTrue: [ [ self recordMatch: #(30).
			self step.
			currentCharacter == $_ ] whileTrue.
			^ self reportLastMatch ].
	(currentCharacter between: $0 and: $9) ifTrue: [ ^ self scan3 ].
	(currentCharacter isLzIdentifierCharacter or: [ currentCharacter == $. ])
		ifTrue: [ ^ self scan1 ].
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> scan3 [
	[ self recordMatch: #(26 29).
	self step.
	currentCharacter == $. ifTrue: [ ^ self scan4 ].
	currentCharacter == $/ ifTrue: [ ^ self scan8 ].
	currentCharacter == $_
		ifTrue: [ [ self recordMatch: #(30).
			self step.
			currentCharacter == $_ ] whileTrue.
			^ self reportLastMatch ].
	currentCharacter == $e ifTrue: [ ^ self scan5 ].
	currentCharacter between: $0 and: $9 ] whileTrue.
	currentCharacter isLzIdentifierCharacter ifTrue: [ ^ self scan1 ].
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> scan4 [
	[ self recordMatch: #(28 29).
	self step.
	currentCharacter == $_
		ifTrue: [ [ self recordMatch: #(30).
			self step.
			currentCharacter == $_ ] whileTrue.
			^ self reportLastMatch ].
	currentCharacter == $e ifTrue: [ ^ self scan5 ].
	currentCharacter between: $0 and: $9 ] whileTrue.
	(currentCharacter isLzIdentifierCharacter or: [ currentCharacter == $. ])
		ifTrue: [ ^ self scan1 ].
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> scan5 [
	self recordMatch: #(29).
	self step.
	currentCharacter == $- ifTrue: [ ^ self scan6 ].
	currentCharacter == $_
		ifTrue: [ [ self recordMatch: #(30).
			self step.
			currentCharacter == $_ ] whileTrue.
			^ self reportLastMatch ].
	(currentCharacter between: $0 and: $9) ifTrue: [ ^ self scan7 ].
	(currentCharacter isLzIdentifierCharacter or: [ currentCharacter == $. ])
		ifTrue: [ ^ self scan1 ].
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> scan6 [
	self recordMatch: #(29).
	self step.
	currentCharacter == $_
		ifTrue: [ [ self recordMatch: #(30).
			self step.
			currentCharacter == $_ ] whileTrue.
			^ self reportLastMatch ].
	(currentCharacter between: $0 and: $9) ifTrue: [ ^ self scan7 ].
	(currentCharacter isLzIdentifierCharacter or: [ currentCharacter == $. ])
		ifTrue: [ ^ self scan1 ].
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> scan7 [
	[ self recordMatch: #(28 29).
	self step.
	currentCharacter == $_
		ifTrue: [ [ self recordMatch: #(30).
			self step.
			currentCharacter == $_ ] whileTrue.
			^ self reportLastMatch ].
	currentCharacter between: $0 and: $9 ] whileTrue.
	(currentCharacter isLzIdentifierCharacter or: [ currentCharacter == $. ])
		ifTrue: [ ^ self scan1 ].
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> scan8 [
	self recordMatch: #(29).
	self step.
	currentCharacter == $_
		ifTrue: [ [ self recordMatch: #(30).
			self step.
			currentCharacter == $_ ] whileTrue.
			^ self reportLastMatch ].
	(currentCharacter between: $1 and: $9) ifTrue: [ ^ self scan9 ].
	(currentCharacter isLzIdentifierCharacter
		or: [ '.0' includes: currentCharacter ]) ifTrue: [ ^ self scan1 ].
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> scan9 [
	[ self recordMatch: #(27 29).
	self step.
	currentCharacter == $_
		ifTrue: [ [ self recordMatch: #(30).
			self step.
			currentCharacter == $_ ] whileTrue.
			^ self reportLastMatch ].
	currentCharacter between: $0 and: $9 ] whileTrue.
	(currentCharacter isLzIdentifierCharacter or: [ currentCharacter == $. ])
		ifTrue: [ ^ self scan1 ].
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> scanForToken [
	self step.
	currentCharacter == $"
		ifTrue: [ [ self step.
			currentCharacter == $" ifTrue: [ ^ self recordAndReportMatch: #(25) ].
			true ] whileTrue ].
	currentCharacter == $( ifTrue: [ ^ self recordAndReportMatch: #(1) ].
	currentCharacter == $) ifTrue: [ ^ self recordAndReportMatch: #(2) ].
	currentCharacter == $, ifTrue: [ ^ self recordAndReportMatch: #(3) ].
	currentCharacter == $- ifTrue: [ ^ self scan2 ].
	currentCharacter == $: ifTrue: [ ^ self recordAndReportMatch: #(4) ].
	currentCharacter == $= ifTrue: [ ^ self scan11 ].
	currentCharacter == $P ifTrue: [ ^ self scan12 ].
	currentCharacter == $[ ifTrue: [ ^ self recordAndReportMatch: #(7) ].
	currentCharacter == $\ ifTrue: [ ^ self scanForTokenX4 ].
	currentCharacter == $] ifTrue: [ ^ self recordAndReportMatch: #(9) ].
	^ self scanForTokenX5
]

{ #category : #generated }
LzScanner >> scanForTokenX1 [
	[ self recordMatch: #(26).
	self step.
	currentCharacter == $.
		ifTrue: [ [ self recordMatch: #(28).
			self step.
			currentCharacter == $e ifTrue: [ ^ self scan10 ].
			currentCharacter between: $0 and: $9 ] whileTrue.
			^ self reportLastMatch ].
	currentCharacter == $/
		ifTrue: [ self step.
			(currentCharacter between: $1 and: $9)
				ifTrue: [ [ self recordMatch: #(27).
					self step.
					currentCharacter between: $0 and: $9 ] whileTrue ].
			^ self reportLastMatch ].
	currentCharacter == $e ifTrue: [ ^ self scan10 ].
	currentCharacter between: $0 and: $9 ] whileTrue.
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> scanForTokenX2 [
	[ self recordMatch: #(24).
	self step.
	currentCharacter isSeparator or: [ currentCharacter == Character pageUp ] ]
		whileTrue.
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> scanForTokenX3 [
	self step.
	currentCharacter == $( ifTrue: [ ^ self recordAndReportMatch: #(10) ].
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> scanForTokenX4 [
	self step.
	currentCharacter == $( ifTrue: [ ^ self recordAndReportMatch: #(8) ].
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> scanForTokenX5 [
	currentCharacter == $^ ifTrue: [ ^ self scanForTokenX3 ].
	currentCharacter == ${ ifTrue: [ ^ self recordAndReportMatch: #(19) ].
	currentCharacter == $| ifTrue: [ ^ self scan17 ].
	currentCharacter == $} ifTrue: [ ^ self recordAndReportMatch: #(21) ].
	currentCharacter = (Character value: 8658) ifTrue: [ ^ self scan18 ].
	currentCharacter = (Character value: 8838) ifTrue: [ ^ self scan19 ].
	(currentCharacter between: $0 and: $9) ifTrue: [ ^ self scanForTokenX1 ].
	(currentCharacter isSeparator or: [ currentCharacter == Character pageUp ])
		ifTrue: [ ^ self scanForTokenX2 ].
	currentCharacter isLzIdentifierCharacter ifTrue: [ ^ self scan1 ].
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> tokenActions [
	^ #(nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil #whitespace)
]
