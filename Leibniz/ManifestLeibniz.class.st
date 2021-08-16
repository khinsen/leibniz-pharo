"
! Leibniz overview

Leibniz is a ''digital scientific notation'', meant for developing, publishing, and using scientific models in machine-readable form. From the computer science point of view of formal languages, it is a ''specification language'' for scientific models. It takes most inspiration from the algebraic specification languages of the *OBJ family>https://en.wikipedia.org/wiki/OBJ_(programming_language)*, and in particular from its latest incarnation, *Maude>http://maude.cs.illinois.edu/w/index.php/The_Maude_System*. However, the intended application domain for Leibniz is very different from what OBJ and Maude have been used for.

The theoretical foundations for Leibniz are *term rewriting systems>https://en.wikipedia.org/wiki/Rewriting#Term_rewriting_systems* and *equational logic>https://en.wikipedia.org/wiki/Equational_logic*. Readers not familiar with these concepts should at least read the Wikipedia entries referenced above for a general idea.

The central object in Leibniz is the  ${class:name=LbContext}$,  which describes a partial or complete scientific model. Like many of its constituent objects, a  ${class:name=LbContext}$ is a read-only object (see ${method:Object>>#beRecursivelyReadOnlyObject}$). Its construction via a sequence of declarations is performed using a  ${class:name=LbContextBuilder}$.

Scientific objects and their relations are described in Leibniz by several layers of declarations:
# A sort defines a specific kind of object or quantity, or equivalently a set of possible values. Examples of sorts are integers, positions, masses, molecules, etc. Relations between sorts are described by a ${class:name=LbSortGraph}$.
# A ${class:name=LbOperator}$ defines concrete values with the sort they belong to. These values can be constants or functions of other values. The collection of all operators used in a context is a ${class:name=LbSignature}$.
# A ${class:name=LbTerm}$ is a specific value, made up from a combination of operators and built-in values such as numbers.
# A ${class:name=LbRule}$ defines how terms are transformed. Rules have two roles in Leibniz: they serve to express algorithms in scientific models, but also to perform simple computations.
# ''Assets'' are used to express scientific objects, quantities, and relations between them. They are built up from terms. A ${class:name=LbTerm}$ can by itself be an asset, as can a ${class:name=LbRule}$. A ${class:name=LbEquation}$ is the third type of asset.
# A ${class:name=LbContext}$ is a package consisting of a ${class:name=LbSortGraph}$, a ${class:name=LbSignature}$, and optionally any number of ${class:name=LbRule}$ and assets.
# A ${class:name=LeibnizDocument}$ combines several related contexts. It is the unit of Leibniz definitions that can be published and references. A special document, ${class:name=LeibnizBuiltins}$, contains contexts that are built into Leibniz because they cannot be defined using standard Leibniz elements, in particular numbers.

For examples, see
[[[
LeibnizExamples new contexts
]]]

"
Class {
	#name : 'ManifestLeibniz',
	#superclass : 'PackageManifest',
	#category : 'Leibniz-Manifest'
}

{ #category : 'code-critics' }
ManifestLeibniz class >> ruleRBCollectionMessagesToExternalObjectRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#LbSortGraph #make:subsortOf: #false)) #'2018-12-06T17:13:39.514023+01:00') )
]

{ #category : 'code-critics' }
ManifestLeibniz class >> ruleRBLiteralArrayContainsSuspiciousTrueFalseOrNilRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#LeibnizBuiltinsTest #testTruth #false)) #'2019-01-09T11:47:27.30381+01:00') )
]

{ #category : 'code-critics' }
ManifestLeibniz class >> ruleRBModifiesCollectionRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#LbSortGraph #make:subsortOf: #false)) #'2018-12-06T17:14:01.072463+01:00') )
]
