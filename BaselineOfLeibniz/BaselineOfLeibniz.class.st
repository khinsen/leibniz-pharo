Class {
	#name : #BaselineOfLeibniz,
	#superclass : #BaselineOf,
	#category : #BaselineOfLeibniz
}

{ #category : #baseline }
BaselineOfLeibniz >> baseline: spec [
	<baseline>
	
	spec for: #common do: [

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
			with: [ spec requires: #(
					'RecursiveWriteBarrier'
					'EqualityThroughVariablesTrait')];
			package: 'BaselineOfLeibniz'.

]
]
