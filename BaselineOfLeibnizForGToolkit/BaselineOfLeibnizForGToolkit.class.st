Class {
	#name : #BaselineOfLeibnizForGToolkit,
	#superclass : #BaselineOf,
	#category : #BaselineOfLeibnizForGToolkit
}

{ #category : #baseline }
BaselineOfLeibnizForGToolkit >> baseline: spec [
	<baseline>
	
	spec for: #common do: [

		spec postLoadDoIt: #'postload:package:'.

		spec
			baseline: 'RecursiveWriteBarrier' 
			with: [ spec repository: 'github://khinsen/RecursiveWriteBarrier:master/src' ].

		spec
			baseline: 'SingletonTrait' 
			with: [ spec repository: 'github://khinsen/SingletonTrait:master' ].

		spec
			package: 'Leibniz2'
			with: [ spec requires:
						#('RecursiveWriteBarrier'
							'SingletonTrait') ].

		spec
			package: 'RecurrenceEquations'
			with: [ spec requires:
						#('Leibniz2') ].
]
]

{ #category : #baseline }
BaselineOfLeibnizForGToolkit >> postload: loader package: packageSpec [
	LzCodeFont chooseDefaultFamily
]
