Class {
	#name : #BaselineOfLeibniz,
	#superclass : #BaselineOf,
	#category : #BaselineOfLeibniz
}

{ #category : #baseline }
BaselineOfLeibniz >> baseline: spec [
	<baseline>
	
	spec for: #common do: [

		spec postLoadDoIt: #'postload:package:'.

		spec
			baseline: 'Roassal2' 
			with: [ spec repository: 'github://ObjectProfile/Roassal2:master/src' ].

		spec
			baseline: 'PetitParser2' 
			with: [ spec repository: 'github://kursjan/petitparser2:master/src' ].

		spec
			baseline: 'XMLParser'
			with: [ spec repository: 'github://pharo-contributions/XML-XMLParser/src' ].

		spec
			baseline: 'RecursiveWriteBarrier' 
			with: [ spec repository: 'github://khinsen/RecursiveWriteBarrier:master/src' ].

		spec
			baseline: 'EqualityThroughVariablesTrait' 
			with: [ spec repository: 'github://khinsen/EqualityThroughVariablesTrait:master/src' ].

		spec
			package: 'Leibniz'
			with: [ spec requires: #('Roassal2'
											'RecursiveWriteBarrier'
											'EqualityThroughVariablesTrait')];
			package: 'BaselineOfLeibniz'.

].

]

{ #category : #baseline }
BaselineOfLeibniz >> postload: loader package: packageSpec [
	LeibnizLibrary reset.

]

{ #category : #baseline }
BaselineOfLeibniz >> preload: loader package: packageSpec [
	(Smalltalk globals includesKey: #LeibnizLibrary)
		ifFalse: [ ^ self ].
	LeibnizLibrary reset.
	Smalltalk garbageCollect.

]

{ #category : #baseline }
BaselineOfLeibniz >> projectClass [
	Smalltalk at: #'MetacelloCypressBaselineProject' ifPresent: [ :cl | ^ cl ].
	^ super projectClass

]
