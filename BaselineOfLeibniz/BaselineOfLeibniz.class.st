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
			project: 'XMLParser'
			with: [ spec
						className: #ConfigurationOfXMLParser;
						repository: 'http://smalltalkhub.com/mc/PharoExtras/XMLParser/main' ].

		spec
			package: 'Leibniz' with: [ spec requires: #('Roassal2')];
			package: 'BaselineOfLeibniz'.

].

]

{ #category : #baseline }
BaselineOfLeibniz >> postload: loader package: packageSpec [
	LeibnizBuiltins reset

]
