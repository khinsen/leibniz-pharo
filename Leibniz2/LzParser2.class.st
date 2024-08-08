Class {
	#name : #LzParser2,
	#superclass : #SmaCCGLRParser,
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzParser2 class >> ambiguousTransitions [
^#(
#[ 0 6 0 45] 
#[ 0 6 0 101] 
#[ 0 70 1 137] 
#[ 0 74 1 141] 
#[ 0 78 1 153] 
#[ 0 78 1 157] 
#[ 0 78 1 161] 
#[ 0 146 1 153] 
#[ 0 146 1 157] 
#[ 0 146 1 161] 
#[ 0 78 0 146] 
#[ 0 14 2 5] 
#[ 0 174 1 141] 
#[ 0 194 2 25] 
#[ 0 234 0 246] 
#[ 0 194 0 230]
	).
]

{ #category : #'generated-accessing' }
LzParser2 class >> cacheId [
	^'2024-08-08T11:42:14.421862+02:00'
]

{ #category : #generated }
LzParser2 class >> definitionComment [
"%unicode;
%glr;
%root ParseTree;
%prefix Lz;
%suffix Node;
%start TopLevelTerm TopLevelOp TopLevelSort TopLevelAxiom TopLevelRule TopLevelUseContext TopLevelSpecialTerms TopLevelAsset Term;
%hierarchy LiteralTerm (IntegerLiteralTerm RationalNumberLiteralTerm FpNumberLiteralTerm StringLiteralTerm);
%hierarchy VarTerm (VarTermWithSort);
%hierarchy Term (PrefixOpTerm BracketOpTerm SuperscriptOpTerm SubscriptOpTerm ParenthesizedTerm VarTerm ArrayTerm StepTerm TupleTerm LiteralTerm);
%hierarchy Op (PrefixOp TupleOp InfixOp BracketOp SuperscriptOp SubscriptOp);
%hierarchy OpArg (SimpleOpArg);
%hierarchy TopLevelRule (TopLevelRewriteRule TopLevelFunctionRule);
<whitespace>
	: \s+
	;
<string>
	: \"" [^""]* \""
	;
<integer>
	: \-? \d+
	;
<rationalNumber>
	: \-?  \d+ \/ [1-9] \d*
	;
<fpNumber>
	: (<integer> \. \d* (e <integer>)?) | (<integer> e <integer>)
	;
<identifierCharacter>
	: <isLzIdentifierCharacter>
	;
<opIdentifier>
	: <identifierCharacter> (\d | \. | <identifierCharacter>)*
	;
<varIdentifier>
	: <opIdentifier> \_+
	;
Start 
	: TopLevelTerm
	;
Option
	: "","" 'comma' <opIdentifier> 'key' ""="" LiteralTerm 'value' {{Option}}
	;
TopLevelOp
	: (Var 'var' "","" 'comma')* Op 'op'  "":"" 'colon' Term 'sort' (Option 'option')* {{}}
	;
TopLevelSort
	: (Var 'var' "","" 'comma')* Op 'op' (Option 'option')* {{TopLevelSort}}
	| (Var 'var' "","" 'comma')* Term 'subsort' ""⊆"" 'subsetOf' Term 'supersort' (Option 'option')* {{TopLevelSubsort}}
	;
TopLevelAxiom
	: (AssetPrefix 'prefix')? (Var 'var' "","" 'comma')* Term 'left' ""="" 'equals' Term 'right' (""|"" Term 'condition')? (Option 'option')*  {{TopLevelEqualityAxiom}}
	;
AssetPrefix
	: <opIdentifier> 'label' "":"" {{}}
	;
TopLevelRule
	: (RulePrefix 'prefix')?  (Var 'var' "","" 'comma')* Term 'pattern' ""⇒"" 'arrow' Term 'replacement' (""|"" Term 'condition')? (Option 'option')* {{TopLevelRewriteRule}}
	| (RulePrefix 'prefix')?  (Var 'var' "","" 'comma')* Term 'pattern' ""⇒"" 'arrow' ""Pharo:"" 'pharo' <string> 'code' (""|"" Term 'condition')? (Option 'option')* {{TopLevelFunctionRule}}
	;
RulePrefix
	: <opIdentifier> 'label' (""["" <integer> 'order' ""]"")? "":""  {{}}
	;
TopLevelTerm
	: (AssetPrefix 'prefix')? Pattern 'pattern' (Option 'option')* {{}}
	;
Pattern
	: (Var 'var' "","" 'comma')* Term 'term' {{}}
	;
Op
	: <opIdentifier> 'opName'
		(""("" 'leftParen' OpArg 'arg'
			("","" 'comma' OpArg 'arg')* "")"" 'rightParen')? {{PrefixOp}}
	| ""("" 'leftParen' OpArg 'arg' "","" 'comma'
			(OpArg 'arg' ("","" 'comma' OpArg 'arg')* )? "")"" 'rightParen' {{TupleOp}}
	| SimpleOpArg 'arg' <opIdentifier> 'opName' SimpleOpArg 'arg' {{InfixOp}}
	| SimpleOpArg 'arg'
		""["" 'opName'  OpArg 'arg'
			("","" 'comma' OpArg 'arg')*
		""]"" 'rightBracket' {{BracketOp}}
	| SimpleOpArg 'arg'
		""^("" 'opName'  OpArg 'arg'
			("","" 'comma' OpArg 'arg')*
		"")"" 'rightParen' {{SuperscriptOp}}
	| SimpleOpArg 'arg'
		""\("" 'opName'  OpArg 'arg'
			("","" 'comma' OpArg 'arg')*
		"")"" 'rightParen' {{SubscriptOp}}
	;
OpArg
	: <opIdentifier> 'name' "":"" 'colon' Term 'sort' {{OpArg}}
	| Term 'sort' {{OpArg}}
	;
SimpleOpArg
	: ""("" 'leftParen' <opIdentifier> 'name' "":"" 'colon' Term 'sort' "")"" 'rightParen' {{SimpleOpArg}}
	| SimpleTerm 'sort' {{SimpleOpArg}}
	;
Var
	: <varIdentifier> 'varName' "":"" 'colon' Term 'sort' {{Var}}
	;
Term
	: NonInfixTerm 'arg' (<opIdentifier> 'opName' NonInfixTerm 'arg')+ {{InfixOpTerm}}
	| NonInfixTerm
	;
NonInfixTerm
	: SimpleTerm
	| SimpleTerm 'arg'
		""["" 'leftBracket'  Term 'arg'
			("","" 'comma' Term 'arg')*
		""]"" 'rightBracket' {{BracketOpTerm}}
	| SimpleTerm 'arg'
		""^("" 'leftParen'  Term 'arg'
			("","" 'comma' Term 'arg')*
		"")"" 'rightParen' {{SuperscriptOpTerm}}
	| SimpleTerm 'arg'
		""\("" 'leftParen'  Term 'arg'
			("","" 'comma' Term 'arg')*
		"")"" 'rightParen' {{SubscriptOpTerm}}
	;
SimpleTerm
	: LiteralTerm
	| ParenthesizedTerm
	| ArrayTerm
	| CompoundStepTerm
	| TupleTerm
	| PrefixOpTerm
	| VarTerm
	;
CompoundStepTerm
	: ""{."" 'leftDelimiter'
			Step 'step' 
			("","" 'comma' Step 'step')*
		"".}"" 'rightDelimiter'
		{{}}
	;
Step
	: Term 'term' ""⇒"" 'arrow' Pattern 'pattern' {{}}
	| Term 'term' {{}}
	;
ParenthesizedTerm
	: ""("" 'leftParen' Term 'term' "")"" 'rightParen' {{}}
	;
PrefixOpTerm
	: <opIdentifier> 'opName'
		(""("" 'leftParen' Term 'arg'
			("","" 'comma' Term 'arg')* "")"" 'rightParen')? {{}}
	;
VarTerm
	: <varIdentifier> 'varName' "":"" 'colon' Term 'sort' {{VarTermWithSort}}
	| <varIdentifier> 'varName' {{}}
	;
ArrayTerm
	: ""{"" 'leftBrace' ArrayElements 'arrayElements' ""}"" 'rightBrace' {{}}
	;
ArrayElements
	: ""["" 'leftBracket'
			(ArrayElement 'element')?
			("","" 'comma' ArrayElement 'element')* ""]""
		'rightBracket' {{}}
	;
ArrayElement
	: Term
	| ArrayElements
	;
TupleTerm
	: ""("" 'leftParen'
			Term 'arg' "","" 'comma'
				(Term 'arg' ("","" 'comma' Term 'arg')* )?
		"")"" 'rightParen'
		{{}}
	;
LiteralTerm
	: IntegerLiteralTerm
	| RationalNumberLiteralTerm
	| FpNumberLiteralTerm
	| StringLiteralTerm
	;
StringLiteralTerm
	: <string> 'text' {{}}
	;
IntegerLiteralTerm
	: <integer> 'text' {{}}
	;
RationalNumberLiteralTerm
	: <rationalNumber> 'text' {{}}
	;
FpNumberLiteralTerm
	: <fpNumber> 'text' {{}}
	;
TopLevelUseContext 
	: (""name"" ""="" | ""name="") <string> 'pageName' (Option 'option')*  {{}}
	;
TopLevelSpecialTerms
	: SpecialTerm 'specialTerm' ("","" 'comma' SpecialTerm 'specialTerm')* (Option 'option')* {{}}
	;
SpecialTerm
	: ""integers""
	| ""rationalNumbers""
	| ""floatingPointNumbers""
	| ""strings""
	| ""arrays""
	| ""steps""
	| ""termClasses""
	;
TopLevelAsset
	: <opIdentifier> 'label' (""["" <integer> 'order' ""]"")? (Option 'option')* {{}}
	;"
]

{ #category : #initializing }
LzParser2 class >> initialize [
	LeParser annotationParsers
		at: 'lzSort'
		put: [ :parser | parser spawnParser: self startingAt: self startingStateForTopLevelSort ].
	LeParser annotationParsers
		at: 'lzOp'
		put: [ :parser | parser spawnParser: self startingAt: self startingStateForTopLevelOp ].
	LeParser annotationParsers
		at: 'lzAxiom'
		put: [ :parser | parser spawnParser: self startingAt: self startingStateForTopLevelAxiom ].
	LeParser annotationParsers
		at: 'lzRule'
		put: [ :parser | parser spawnParser: self startingAt: self startingStateForTopLevelRule ].
	LeParser annotationParsers
		at: 'lzTerm'
		put: [ :parser | parser spawnParser: self startingAt: self startingStateForTopLevelTerm ].
	LeParser annotationParsers
		at: 'lzUseContext'
		put: [ :parser | parser spawnParser: self startingAt: self startingStateForTopLevelUseContext ].
	LeParser annotationParsers
		at: 'lzSpecialTerms'
		put: [ :parser | parser spawnParser: self startingAt: self startingStateForTopLevelSpecialTerms ].
	LeParser annotationParsers
		at: 'lzAsset'
		put: [ :parser | parser spawnParser: self startingAt: self startingStateForTopLevelAsset ].
]

{ #category : #initializing }
LzParser2 class >> obsolete [
	{ 'lzSort'. 'lzOp'. 'lzAxiom'.  'lzRule'. 'lzTerm'.
		'lzUseContext'. 'lzSpecialTerms'. 'lzAsset' }
		do: [ :each |
			LeParser annotationParsers removeKey: each  ifAbsent: [  ] ].
	^ super obsolete
]

{ #category : #generated }
LzParser2 class >> reduceTable [
^#(
	#(39 0 #reduceActionFor_Var__var_______comma___1: 1180673 false) 
	#(35 1 #liftFirstValue: 1056769 false) 
	#(41 0 #reduceActionFor_Option__option___1: 1240065 false) 
	#(84 1 #liftFirstValue: 5400581 false) 
	#(84 1 #liftFirstValue: 5400579 false) 
	#(84 1 #liftFirstValue: 5400577 false) 
	#(84 1 #liftFirstValue: 5400578 false) 
	#(84 1 #liftFirstValue: 5400582 false) 
	#(84 1 #liftFirstValue: 5400580 false) 
	#(84 1 #liftFirstValue: 5400583 false) 
	#(83 0 #reduceActionFor_Var__var_______comma___1: 5330945 false) 
	#(76 1 #reduceActionForStringLiteralTerm1: 4976641 false) 
	#(77 1 #reduceActionForIntegerLiteralTerm1: 5022721 false) 
	#(78 1 #reduceActionForRationalNumberLiteralTerm1: 5070849 false) 
	#(79 1 #reduceActionForFpNumberLiteralTerm1: 5133313 false) 
	#(67 1 #reduceActionForPrefixOpTerm1: 4216833 false) 
	#(68 1 #reduceActionForVarTerm2: 4345858 false) 
	#(55 1 #liftFirstValue: 3301378 false) 
	#(58 1 #liftFirstValue: 3411969 false) 
	#(61 1 #liftFirstValue: 3811332 false) 
	#(61 1 #liftFirstValue: 3811330 false) 
	#(61 1 #liftFirstValue: 3811334 false) 
	#(61 1 #liftFirstValue: 3811335 false) 
	#(61 1 #liftFirstValue: 3811331 false) 
	#(61 1 #liftFirstValue: 3811333 false) 
	#(61 1 #liftFirstValue: 3811329 false) 
	#(75 1 #liftFirstValue: 4864004 false) 
	#(75 1 #liftFirstValue: 4864001 false) 
	#(75 1 #liftFirstValue: 4864002 false) 
	#(75 1 #liftFirstValue: 4864003 false) 
	#(44 2 #reduceActionForAssetPrefix1: 1655809 false) 
	#(39 2 #reduceActionFor_Var__var_______comma___2: 1180674 false) 
	#(48 2 #reduceActionForPattern1: 2244609 false) 
	#(47 2 #reduceActionForTopLevelTerm1: 2157569 false) 
	#(49 1 #reduceActionForOp1: 2301953 false) 
	#(53 1 #reduceActionForSimpleOpArg2: 3078146 false) 
	#(46 2 #reduceActionForRulePrefix1: 2076673 false) 
	#(85 2 #reduceActionForTopLevelAsset1: 5532673 false) 
	#(72 0 #reduceActionFor_Var__var_______comma___1: 4621313 false) 
	#(65 1 #reduceActionForStep2: 4061186 false) 
	#(64 0 #reduceActionFor_Var__var_______comma___1: 3998721 false) 
	#(57 1 #reduceActionFor__opIdentifier___opName__NonInfixTerm__arg___1: 3329025 false) 
	#(55 2 #reduceActionForTerm1: 3301377 false) 
	#(38 2 #reduceActionFor_Var__var_______comma__1: 1180673 false) 
	#(47 3 #reduceActionForTopLevelTerm2: 2157570 false) 
	#(40 1 #liftFirstValue: 1240065 false) 
	#(41 2 #reduceActionFor_Option__option___2: 1240066 false) 
	#(52 1 #reduceActionForOpArg2: 2982914 false) 
	#(42 3 #reduceActionForTopLevelSort1: 1267713 false) 
	#(80 3 #reduceActionForTopLevelUseContext2: 5183490 false) 
	#(81 3 #reduceActionForTopLevelSpecialTerms1: 5279745 false) 
	#(83 2 #reduceActionFor_Var__var_______comma___2: 5330946 false) 
	#(66 3 #reduceActionForParenthesizedTerm1: 4141057 false) 
	#(73 1 #liftFirstValue: 4689921 false) 
	#(73 1 #liftFirstValue: 4689922 false) 
	#(69 3 #reduceActionForArrayTerm1: 4466689 false) 
	#(60 0 #reduceActionFor_Var__var_______comma___1: 3495937 false) 
	#(68 3 #reduceActionForVarTerm1: 4345857 false) 
	#(56 2 #reduceActionFor_Var__var_______comma__1: 3329025 false) 
	#(57 2 #reduceActionFor_Var__var_______comma___2: 3329026 false) 
	#(54 3 #reduceActionForVar1: 3231745 false) 
	#(51 0 #reduceActionFor_Var__var_______comma___1: 2367489 false) 
	#(49 3 #reduceActionForOp5: 2301957 false) 
	#(80 4 #reduceActionForTopLevelUseContext1: 5183489 false) 
	#(82 2 #reduceActionFor_Var__var_______comma__1: 5330945 false) 
	#(74 4 #reduceActionForTupleTerm1: 4731905 false) 
	#(70 3 #reduceActionForArrayElements1: 4552705 false) 
	#(72 2 #reduceActionFor_Var__var_______comma___2: 4621314 false) 
	#(65 3 #reduceActionForStep1: 4061185 false) 
	#(62 4 #reduceActionForCompoundStepTerm1: 3937281 false) 
	#(64 2 #reduceActionFor_Var__var_______comma___2: 3998722 false) 
	#(52 3 #reduceActionForOpArg1: 2982913 false) 
	#(49 4 #reduceActionForOp3: 2301955 false) 
	#(37 5 #reduceActionForTopLevelOp1: 1166337 false) 
	#(42 5 #reduceActionForTopLevelSort2: 1267714 false) 
	#(43 5 #reduceActionForTopLevelAxiom1: 1474561 false) 
	#(46 5 #reduceActionForRulePrefix2: 2076674 false) 
	#(45 5 #reduceActionForTopLevelRule1: 1707009 false) 
	#(85 5 #reduceActionForTopLevelAsset2: 5532674 false) 
	#(71 2 #reduceActionFor_Var__var_______comma__1: 4621313 false) 
	#(70 4 #reduceActionForArrayElements2: 4552706 false) 
	#(63 2 #reduceActionFor_Var__var_______comma__1: 3998721 false) 
	#(67 5 #reduceActionForPrefixOpTerm2: 4216834 false) 
	#(60 2 #reduceActionFor_Var__var_______comma___2: 3495938 false) 
	#(58 5 #reduceActionForNonInfixTerm2: 3411970 false) 
	#(58 5 #reduceActionForNonInfixTerm4: 3411972 false) 
	#(58 5 #reduceActionForNonInfixTerm3: 3411971 false) 
	#(36 4 #reduceActionForOption1: 1083393 false) 
	#(53 5 #reduceActionForSimpleOpArg1: 3078145 false) 
	#(49 5 #reduceActionForOp2: 2301954 false) 
	#(51 2 #reduceActionFor_Var__var_______comma___2: 2367490 false) 
	#(49 5 #reduceActionForOp6: 2301958 false) 
	#(49 5 #reduceActionForOp8: 2301960 false) 
	#(49 5 #reduceActionForOp7: 2301959 false) 
	#(43 6 #reduceActionForTopLevelAxiom3: 1474563 false) 
	#(45 6 #reduceActionForTopLevelRule5: 1707013 false) 
	#(45 6 #reduceActionForTopLevelRule3: 1707011 false) 
	#(74 6 #reduceActionForTupleTerm2: 4731906 false) 
	#(59 2 #reduceActionFor_Var__var_______comma__1: 3495937 false) 
	#(49 6 #reduceActionForOp4: 2301956 false) 
	#(50 2 #reduceActionFor_Var__var_______comma__1: 2367489 false) 
	#(43 7 #reduceActionForTopLevelAxiom2: 1474562 false) 
	#(45 7 #reduceActionForTopLevelRule2: 1707010 false) 
	#(45 7 #reduceActionForTopLevelRule7: 1707015 false) 
	#(43 8 #reduceActionForTopLevelAxiom4: 1474564 false) 
	#(45 8 #reduceActionForTopLevelRule6: 1707014 false) 
	#(45 8 #reduceActionForTopLevelRule4: 1707012 false) 
	#(45 9 #reduceActionForTopLevelRule8: 1707016 false)
	).
]

{ #category : #generated }
LzParser2 class >> scannerClass [
	^LzScanner
]

{ #category : #generated }
LzParser2 class >> startingStateForStart [
	^ 1
]

{ #category : #generated }
LzParser2 class >> startingStateForTerm [
	^ 10
]

{ #category : #generated }
LzParser2 class >> startingStateForTopLevelAsset [
	^ 9
]

{ #category : #generated }
LzParser2 class >> startingStateForTopLevelAxiom [
	^ 5
]

{ #category : #generated }
LzParser2 class >> startingStateForTopLevelOp [
	^ 3
]

{ #category : #generated }
LzParser2 class >> startingStateForTopLevelRule [
	^ 6
]

{ #category : #generated }
LzParser2 class >> startingStateForTopLevelSort [
	^ 4
]

{ #category : #generated }
LzParser2 class >> startingStateForTopLevelSpecialTerms [
	^ 8
]

{ #category : #generated }
LzParser2 class >> startingStateForTopLevelTerm [
	^ 2
]

{ #category : #generated }
LzParser2 class >> startingStateForTopLevelUseContext [
	^ 7
]

{ #category : #generated }
LzParser2 class >> symbolNames [
	^ #('"("' '")"' '","' '".}"' '":"' '"="' '"Pharo:"' '"["' '"\("' '"]"' '"^("' '"arrays"' '"floatingPointNumbers"' '"integers"' '"name"' '"name="' '"rationalNumbers"' '"steps"' '"strings"' '"termClasses"' '"{"' '"{."' '"|"' '"}"' '"⇒"' '"⊆"' '<whitespace>' '<string>' '<integer>' '<rationalNumber>' '<fpNumber>' '<opIdentifier>' '<varIdentifier>' 'B e g i n' 'Start' 'Option' 'TopLevelOp' '(Var ''var'' "," ''comma'')' '(Var ''var'' "," ''comma'')*' '(Option ''option'')' '(Option ''option'')*' 'TopLevelSort' 'TopLevelAxiom' 'AssetPrefix' 'TopLevelRule' 'RulePrefix' 'TopLevelTerm' 'Pattern' 'Op' '("," ''comma'' OpArg ''arg'')' '("," ''comma'' OpArg ''arg'')*' 'OpArg' 'SimpleOpArg' 'Var' 'Term' '(<opIdentifier> ''opName'' NonInfixTerm ''arg'')' '(<opIdentifier> ''opName'' NonInfixTerm ''arg'')+' 'NonInfixTerm' '("," ''comma'' Term ''arg'')' '("," ''comma'' Term ''arg'')*' 'SimpleTerm' 'CompoundStepTerm' '("," ''comma'' Step ''step'')' '("," ''comma'' Step ''step'')*' 'Step' 'ParenthesizedTerm' 'PrefixOpTerm' 'VarTerm' 'ArrayTerm' 'ArrayElements' '("," ''comma'' ArrayElement ''element'')' '("," ''comma'' ArrayElement ''element'')*' 'ArrayElement' 'TupleTerm' 'LiteralTerm' 'StringLiteralTerm' 'IntegerLiteralTerm' 'RationalNumberLiteralTerm' 'FpNumberLiteralTerm' 'TopLevelUseContext' 'TopLevelSpecialTerms' '("," ''comma'' SpecialTerm ''specialTerm'')' '("," ''comma'' SpecialTerm ''specialTerm'')*' 'SpecialTerm' 'TopLevelAsset' 'E O F' 'error')
]

{ #category : #generated }
LzParser2 class >> symbolTypes [
	^ #(#SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #LzTopLevelTermNode #LzTopLevelTermNode #LzOptionNode #LzTopLevelOpNode #OrderedCollection #OrderedCollection #LzOptionNode #OrderedCollection #LzParseTreeNode #LzTopLevelEqualityAxiomNode #LzAssetPrefixNode #LzTopLevelRuleNode #LzRulePrefixNode #LzTopLevelTermNode #LzPatternNode #LzOpNode #OrderedCollection #OrderedCollection #LzOpArgNode #LzSimpleOpArgNode #LzVarNode #LzParseTreeNode #OrderedCollection #OrderedCollection #LzParseTreeNode #OrderedCollection #OrderedCollection #LzParseTreeNode #LzCompoundStepTermNode #OrderedCollection #OrderedCollection #LzStepNode #LzParenthesizedTermNode #LzPrefixOpTermNode #LzVarTermNode #LzArrayTermNode #LzArrayElementsNode #OrderedCollection #OrderedCollection #LzParseTreeNode #LzTupleTermNode #LzLiteralTermNode #LzStringLiteralTermNode #LzIntegerLiteralTermNode #LzRationalNumberLiteralTermNode #LzFpNumberLiteralTermNode #LzTopLevelUseContextNode #LzTopLevelSpecialTermsNode #OrderedCollection #OrderedCollection #SmaCCToken #LzTopLevelAssetNode #SmaCCToken #SmaCCErrorNode)
]

{ #category : #generated }
LzParser2 class >> transitionTable [
^#(
#[1 0 6 0 1 0 6 0 21 0 6 0 22 0 6 0 28 0 6 0 29 0 6 0 30 0 6 0 31 0 7 0 32 0 6 0 33 0 49 0 35 0 53 0 39 0 57 0 44 0 49 0 47 0 65 0 48] 
#[1 0 6 0 1 0 6 0 21 0 6 0 22 0 6 0 28 0 6 0 29 0 6 0 30 0 6 0 31 0 7 0 32 0 6 0 33 0 53 0 39 0 57 0 44 0 69 0 47 0 65 0 48] 
#[1 0 6 0 1 0 6 0 21 0 6 0 22 0 6 0 28 0 6 0 29 0 6 0 30 0 6 0 31 0 6 0 32 0 6 0 33 0 73 0 37 0 77 0 39] 
#[1 0 6 0 1 0 6 0 21 0 6 0 22 0 6 0 28 0 6 0 29 0 6 0 30 0 6 0 31 0 6 0 32 0 6 0 33 0 81 0 39 0 85 0 42] 
#[1 0 6 0 1 0 6 0 21 0 6 0 22 0 6 0 28 0 6 0 29 0 6 0 30 0 6 0 31 0 7 0 32 0 6 0 33 0 89 0 39 0 93 0 43 0 97 0 44] 
#[1 0 6 0 1 0 6 0 21 0 6 0 22 0 6 0 28 0 6 0 29 0 6 0 30 0 6 0 31 0 11 0 32 0 6 0 33 0 105 0 39 0 109 0 45 0 113 0 46] 
#[1 0 117 0 15 0 121 0 16 0 125 0 80] 
#[1 0 161 0 12 0 161 0 13 0 161 0 14 0 161 0 17 0 161 0 18 0 161 0 19 0 161 0 20 0 157 0 81 0 161 0 84] 
#[1 0 165 0 32 0 169 0 85] 
#[1 0 173 0 1 0 177 0 21 0 181 0 22 0 185 0 28 0 189 0 29 0 193 0 30 0 197 0 31 0 201 0 32 0 205 0 33 0 209 0 55 0 213 0 58 0 217 0 61 0 217 0 62 0 217 0 66 0 217 0 67 0 217 0 68 0 217 0 69 0 217 0 74 0 217 0 75 0 217 0 76 0 217 0 77 0 217 0 78 0 217 0 79] 
#[0 1 9 0 5] 
#[0 0 0 0 86] 
#[1 0 173 0 1 0 177 0 21 0 181 0 22 0 185 0 28 0 189 0 29 0 193 0 30 0 197 0 31 0 201 0 32 1 13 0 33 1 17 0 38 1 21 0 54 1 25 0 55 0 213 0 58 0 217 0 61 0 217 0 62 0 217 0 66 0 217 0 67 0 217 0 68 0 217 0 69 0 217 0 74 0 217 0 75 0 217 0 76 0 217 0 77 0 217 0 78 0 217 0 79] 
#[1 0 6 0 1 0 6 0 21 0 6 0 22 0 6 0 28 0 6 0 29 0 6 0 30 0 6 0 31 0 6 0 32 0 6 0 33 0 53 0 39 1 29 0 48] 
#[0 0 10 0 86] 
#[1 0 14 0 3 1 33 0 41 0 14 0 86] 
#[0 0 0 0 86] 
#[0 0 0 0 86] 
#[1 1 37 0 1 0 177 0 21 0 181 0 22 0 185 0 28 0 189 0 29 0 193 0 30 0 197 0 31 1 41 0 32 1 13 0 33 1 17 0 38 1 45 0 49 1 49 0 53 1 21 0 54 1 53 0 61 1 53 0 62 1 53 0 66 1 53 0 67 1 53 0 68 1 53 0 69 1 53 0 74 1 53 0 75 1 53 0 76 1 53 0 77 1 53 0 78 1 53 0 79] 
#[1 1 37 0 1 0 177 0 21 0 181 0 22 0 185 0 28 0 189 0 29 0 193 0 30 0 197 0 31 1 41 0 32 1 13 0 33 1 17 0 38 1 57 0 49 1 49 0 53 1 21 0 54 1 61 0 55 0 213 0 58 1 65 0 61 1 65 0 62 1 65 0 66 1 65 0 67 1 65 0 68 1 65 0 69 1 65 0 74 1 65 0 75 1 65 0 76 1 65 0 77 1 65 0 78 1 65 0 79] 
#[0 0 0 0 86] 
#[1 0 173 0 1 0 177 0 21 0 181 0 22 0 185 0 28 0 189 0 29 0 193 0 30 0 197 0 31 0 201 0 32 1 13 0 33 1 17 0 38 1 21 0 54 1 69 0 55 0 213 0 58 0 217 0 61 0 217 0 62 0 217 0 66 0 217 0 67 0 217 0 68 0 217 0 69 0 217 0 74 0 217 0 75 0 217 0 76 0 217 0 77 0 217 0 78 0 217 0 79] 
#[0 0 0 0 86] 
#[1 0 6 0 1 0 6 0 21 0 6 0 22 0 6 0 28 0 6 0 29 0 6 0 30 0 6 0 31 0 6 0 32 0 6 0 33 1 73 0 39] 
#[1 1 77 0 5 1 81 0 8] 
#[1 0 173 0 1 0 177 0 21 0 181 0 22 0 185 0 28 0 189 0 29 0 193 0 30 0 197 0 31 0 201 0 32 1 13 0 33 1 17 0 38 1 21 0 54 1 85 0 55 0 213 0 58 0 217 0 61 0 217 0 62 0 217 0 66 0 217 0 67 0 217 0 68 0 217 0 69 0 217 0 74 0 217 0 75 0 217 0 76 0 217 0 77 0 217 0 78 0 217 0 79] 
#[0 0 0 0 86] 
#[1 0 6 0 1 0 6 0 21 0 6 0 22 0 6 0 28 0 6 0 29 0 6 0 30 0 6 0 31 0 6 0 32 0 6 0 33 1 89 0 39] 
#[0 1 93 0 6] 
#[0 1 97 0 28] 
#[0 0 0 0 86] 
#[0 0 18 0 3 0 86] 
#[0 0 22 0 3 0 86] 
#[0 0 26 0 3 0 86] 
#[0 0 30 0 3 0 86] 
#[0 0 34 0 3 0 86] 
#[0 0 38 0 3 0 86] 
#[0 0 42 0 3 0 86] 
#[0 0 0 0 86] 
#[1 0 46 0 3 1 101 0 83 0 46 0 86] 
#[1 0 14 0 3 1 105 0 8 1 109 0 41 0 14 0 86] 
#[0 0 0 0 86] 
#[1 0 173 0 1 0 177 0 21 0 181 0 22 0 185 0 28 0 189 0 29 0 193 0 30 0 197 0 31 0 201 0 32 0 205 0 33 1 113 0 55 0 213 0 58 0 217 0 61 0 217 0 62 0 217 0 66 0 217 0 67 0 217 0 68 0 217 0 69 0 217 0 74 0 217 0 75 0 217 0 76 0 217 0 77 0 217 0 78 0 217 0 79] 
#[1 1 117 0 8 1 121 0 70] 
#[1 0 173 0 1 0 177 0 21 0 181 0 22 0 185 0 28 0 189 0 29 0 193 0 30 0 197 0 31 0 201 0 32 0 205 0 33 1 125 0 55 0 213 0 58 0 217 0 61 0 217 0 62 1 129 0 65 0 217 0 66 0 217 0 67 0 217 0 68 0 217 0 69 0 217 0 74 0 217 0 75 0 217 0 76 0 217 0 77 0 217 0 78 0 217 0 79] 
#[0 0 50 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 86] 
#[0 0 54 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 86] 
#[0 0 58 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 86] 
#[0 0 62 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 86] 
#[1 1 133 0 1 0 66 0 2 0 66 0 3 0 66 0 4 0 66 0 5 0 66 0 6 0 66 0 8 0 66 0 9 0 66 0 10 0 66 0 11 0 66 0 23 0 66 0 25 0 66 0 26 0 66 0 32 0 66 0 86] 
#[1 0 70 0 2 0 70 0 3 0 70 0 4 0 15 0 5 0 70 0 6 0 70 0 8 0 70 0 9 0 70 0 10 0 70 0 11 0 70 0 23 0 70 0 25 0 70 0 26 0 70 0 32 0 70 0 86] 
#[0 0 0 0 86] 
#[1 0 74 0 2 0 74 0 3 0 74 0 4 0 74 0 5 0 74 0 6 0 74 0 8 0 74 0 9 0 74 0 10 0 74 0 11 0 74 0 23 0 74 0 25 0 74 0 26 0 19 0 32 1 145 0 56 1 149 0 57 0 74 0 86] 
#[1 0 78 0 2 0 78 0 3 0 78 0 4 0 78 0 5 0 78 0 6 0 23 0 8 0 27 0 9 0 78 0 10 0 31 0 11 0 78 0 23 0 78 0 25 0 78 0 26 0 78 0 32 0 78 0 86] 
#[0 0 82 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 86] 
#[0 0 86 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 86] 
#[0 0 90 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 86] 
#[0 0 94 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 86] 
#[0 0 98 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 86] 
#[0 0 102 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 86] 
#[0 0 106 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 86] 
#[0 0 110 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 86] 
#[0 0 114 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 86] 
#[0 0 118 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 86] 
#[0 0 122 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 86] 
#[0 0 126 0 1 0 21 0 22 0 28 0 29 0 30 0 31 0 32 0 33] 
#[1 0 70 0 3 0 70 0 4 1 165 0 5 0 70 0 6 0 70 0 8 0 70 0 9 0 70 0 11 0 70 0 25 0 70 0 26 0 70 0 32 0 70 0 86] 
#[0 0 130 0 1 0 21 0 22 0 28 0 29 0 30 0 31 0 32 0 33] 
#[0 1 169 0 3] 
#[0 0 134 0 3 0 4 0 86] 
#[1 0 14 0 3 1 173 0 41 0 14 0 86] 
#[1 1 177 0 3 1 185 0 36 1 185 0 40 0 138 0 86] 
#[1 0 173 0 1 0 177 0 21 0 181 0 22 0 185 0 28 0 189 0 29 0 193 0 30 0 197 0 31 1 189 0 32 0 205 0 33 1 193 0 52 1 197 0 55 0 213 0 58 0 217 0 61 0 217 0 62 0 217 0 66 0 217 0 67 0 217 0 68 0 217 0 69 0 217 0 74 0 217 0 75 0 217 0 76 0 217 0 77 0 217 0 78 0 217 0 79] 
#[1 1 201 0 1 0 142 0 3 0 142 0 5 0 66 0 8 0 66 0 9 0 66 0 11 0 66 0 26 0 66 0 32 0 142 0 86] 
#[0 1 205 0 5] 
#[1 1 209 0 8 1 213 0 9 1 217 0 11 1 221 0 32] 
#[0 0 146 0 3 0 5 0 8 0 9 0 11 0 32 0 86] 
#[1 0 14 0 3 1 225 0 41 0 14 0 86] 
#[0 1 229 0 26] 
#[1 0 35 0 8 0 39 0 9 0 43 0 11 0 78 0 26 0 47 0 32] 
#[0 1 233 0 6] 
#[1 0 173 0 1 0 177 0 21 0 181 0 22 0 185 0 28 0 189 0 29 0 193 0 30 0 197 0 31 0 201 0 32 1 13 0 33 1 17 0 38 1 21 0 54 1 237 0 55 0 213 0 58 0 217 0 61 0 217 0 62 0 217 0 66 0 217 0 67 0 217 0 68 0 217 0 69 0 217 0 74 0 217 0 75 0 217 0 76 0 217 0 77 0 217 0 78 0 217 0 79] 
#[0 0 150 0 1 0 21 0 22 0 28 0 29 0 30 0 31 0 32 0 33] 
#[0 1 241 0 29] 
#[0 1 245 0 25] 
#[1 0 173 0 1 0 177 0 21 0 181 0 22 0 185 0 28 0 189 0 29 0 193 0 30 0 197 0 31 0 201 0 32 1 13 0 33 1 17 0 38 1 21 0 54 1 249 0 55 0 213 0 58 0 217 0 61 0 217 0 62 0 217 0 66 0 217 0 67 0 217 0 68 0 217 0 69 0 217 0 74 0 217 0 75 0 217 0 76 0 217 0 77 0 217 0 78 0 217 0 79] 
#[0 1 253 0 28] 
#[1 0 14 0 3 2 1 0 41 0 14 0 86] 
#[1 0 51 0 3 2 9 0 41 2 13 0 82 0 14 0 86] 
#[0 2 17 0 29] 
#[1 1 177 0 3 1 185 0 36 1 185 0 40 0 154 0 86] 
#[1 2 21 0 2 2 25 0 3] 
#[1 0 173 0 1 0 158 0 3 1 117 0 8 0 158 0 10 0 177 0 21 0 181 0 22 0 185 0 28 0 189 0 29 0 193 0 30 0 197 0 31 0 201 0 32 0 205 0 33 2 41 0 55 0 213 0 58 0 217 0 61 0 217 0 62 0 217 0 66 0 217 0 67 0 217 0 68 0 217 0 69 2 41 0 70 2 37 0 72 2 41 0 73 0 217 0 74 0 217 0 75 0 217 0 76 0 217 0 77 0 217 0 78 0 217 0 79] 
#[0 2 45 0 24] 
#[1 0 162 0 3 0 162 0 4 2 49 0 25] 
#[1 0 166 0 3 0 166 0 4 2 53 0 64] 
#[1 0 173 0 1 0 177 0 21 0 181 0 22 0 185 0 28 0 189 0 29 0 193 0 30 0 197 0 31 0 201 0 32 0 205 0 33 2 57 0 55 0 213 0 58 0 217 0 61 0 217 0 62 0 217 0 66 0 217 0 67 0 217 0 68 0 217 0 69 0 217 0 74 0 217 0 75 0 217 0 76 0 217 0 77 0 217 0 78 0 217 0 79] 
#[1 0 173 0 1 0 177 0 21 0 181 0 22 0 185 0 28 0 189 0 29 0 193 0 30 0 197 0 31 0 201 0 32 0 205 0 33 2 61 0 55 0 213 0 58 0 217 0 61 0 217 0 62 0 217 0 66 0 217 0 67 0 217 0 68 0 217 0 69 0 217 0 74 0 217 0 75 0 217 0 76 0 217 0 77 0 217 0 78 0 217 0 79] 
#[1 0 173 0 1 0 177 0 21 0 181 0 22 0 185 0 28 0 189 0 29 0 193 0 30 0 197 0 31 0 201 0 32 0 205 0 33 2 65 0 58 0 217 0 61 0 217 0 62 0 217 0 66 0 217 0 67 0 217 0 68 0 217 0 69 0 217 0 74 0 217 0 75 0 217 0 76 0 217 0 77 0 217 0 78 0 217 0 79] 
#[0 0 170 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 86] 
#[1 0 174 0 2 0 174 0 3 0 174 0 4 0 174 0 5 0 174 0 6 0 174 0 8 0 174 0 9 0 174 0 10 0 174 0 11 0 174 0 23 0 174 0 25 0 174 0 26 0 55 0 32 2 69 0 56 0 174 0 86] 
#[1 0 173 0 1 0 177 0 21 0 181 0 22 0 185 0 28 0 189 0 29 0 193 0 30 0 197 0 31 0 201 0 32 0 205 0 33 2 73 0 55 0 213 0 58 0 217 0 61 0 217 0 62 0 217 0 66 0 217 0 67 0 217 0 68 0 217 0 69 0 217 0 74 0 217 0 75 0 217 0 76 0 217 0 77 0 217 0 78 0 217 0 79] 
#[1 0 173 0 1 0 177 0 21 0 181 0 22 0 185 0 28 0 189 0 29 0 193 0 30 0 197 0 31 0 201 0 32 0 205 0 33 2 77 0 55 0 213 0 58 0 217 0 61 0 217 0 62 0 217 0 66 0 217 0 67 0 217 0 68 0 217 0 69 0 217 0 74 0 217 0 75 0 217 0 76 0 217 0 77 0 217 0 78 0 217 0 79] 
#[1 0 173 0 1 0 177 0 21 0 181 0 22 0 185 0 28 0 189 0 29 0 193 0 30 0 197 0 31 0 201 0 32 0 205 0 33 2 81 0 55 0 213 0 58 0 217 0 61 0 217 0 62 0 217 0 66 0 217 0 67 0 217 0 68 0 217 0 69 0 217 0 74 0 217 0 75 0 217 0 76 0 217 0 77 0 217 0 78 0 217 0 79] 
#[1 0 173 0 1 0 177 0 21 0 181 0 22 0 185 0 28 0 189 0 29 0 193 0 30 0 197 0 31 0 201 0 32 0 205 0 33 2 85 0 55 0 213 0 58 0 217 0 61 0 217 0 62 0 217 0 66 0 217 0 67 0 217 0 68 0 217 0 69 0 217 0 74 0 217 0 75 0 217 0 76 0 217 0 77 0 217 0 78 0 217 0 79] 
#[0 0 178 0 1 0 21 0 22 0 28 0 29 0 30 0 31 0 32 0 33] 
#[1 1 177 0 3 1 185 0 36 1 185 0 40 0 182 0 86] 
#[0 2 89 0 32] 
#[0 0 186 0 3 0 86] 
#[0 0 190 0 3 0 86] 
#[1 1 133 0 1 0 66 0 2 0 66 0 3 2 93 0 5 0 66 0 8 0 66 0 9 0 66 0 11 0 66 0 32] 
#[0 2 97 0 3] 
#[1 2 21 0 2 0 59 0 3] 
#[1 0 173 0 1 0 177 0 21 0 181 0 22 0 185 0 28 0 189 0 29 0 193 0 30 0 197 0 31 2 101 0 32 0 205 0 33 2 105 0 52 2 109 0 55 0 213 0 58 0 217 0 61 0 217 0 62 0 217 0 66 0 217 0 67 0 217 0 68 0 217 0 69 0 217 0 74 0 217 0 75 0 217 0 76 0 217 0 77 0 217 0 78 0 217 0 79] 
#[1 0 173 0 1 0 177 0 21 0 181 0 22 0 185 0 28 0 189 0 29 0 193 0 30 0 197 0 31 0 201 0 32 0 205 0 33 2 113 0 55 0 213 0 58 0 217 0 61 0 217 0 62 0 217 0 66 0 217 0 67 0 217 0 68 0 217 0 69 0 217 0 74 0 217 0 75 0 217 0 76 0 217 0 77 0 217 0 78 0 217 0 79] 
#[1 0 173 0 1 0 177 0 21 0 181 0 22 0 185 0 28 0 189 0 29 0 193 0 30 0 197 0 31 2 101 0 32 0 205 0 33 2 117 0 52 2 121 0 55 0 213 0 58 0 217 0 61 0 217 0 62 0 217 0 66 0 217 0 67 0 217 0 68 0 217 0 69 0 217 0 74 0 217 0 75 0 217 0 76 0 217 0 77 0 217 0 78 0 217 0 79] 
#[1 0 173 0 1 0 177 0 21 0 181 0 22 0 185 0 28 0 189 0 29 0 193 0 30 0 197 0 31 2 101 0 32 0 205 0 33 2 125 0 52 2 121 0 55 0 213 0 58 0 217 0 61 0 217 0 62 0 217 0 66 0 217 0 67 0 217 0 68 0 217 0 69 0 217 0 74 0 217 0 75 0 217 0 76 0 217 0 77 0 217 0 78 0 217 0 79] 
#[1 0 173 0 1 0 177 0 21 0 181 0 22 0 185 0 28 0 189 0 29 0 193 0 30 0 197 0 31 2 101 0 32 0 205 0 33 2 129 0 52 2 121 0 55 0 213 0 58 0 217 0 61 0 217 0 62 0 217 0 66 0 217 0 67 0 217 0 68 0 217 0 69 0 217 0 74 0 217 0 75 0 217 0 76 0 217 0 77 0 217 0 78 0 217 0 79] 
#[1 2 133 0 1 0 177 0 21 0 181 0 22 0 185 0 28 0 189 0 29 0 193 0 30 0 197 0 31 0 201 0 32 0 205 0 33 2 137 0 53 1 53 0 61 1 53 0 62 1 53 0 66 1 53 0 67 1 53 0 68 1 53 0 69 1 53 0 74 1 53 0 75 1 53 0 76 1 53 0 77 1 53 0 78 1 53 0 79] 
#[1 1 177 0 3 1 185 0 36 1 185 0 40 0 198 0 86] 
#[1 0 173 0 1 0 177 0 21 0 181 0 22 0 185 0 28 0 189 0 29 0 193 0 30 0 197 0 31 0 201 0 32 0 205 0 33 2 141 0 55 0 213 0 58 0 217 0 61 0 217 0 62 0 217 0 66 0 217 0 67 0 217 0 68 0 217 0 69 0 217 0 74 0 217 0 75 0 217 0 76 0 217 0 77 0 217 0 78 0 217 0 79] 
#[1 0 173 0 1 0 177 0 21 0 181 0 22 0 185 0 28 0 189 0 29 0 193 0 30 0 197 0 31 0 201 0 32 0 205 0 33 2 145 0 55 0 213 0 58 0 217 0 61 0 217 0 62 0 217 0 66 0 217 0 67 0 217 0 68 0 217 0 69 0 217 0 74 0 217 0 75 0 217 0 76 0 217 0 77 0 217 0 78 0 217 0 79] 
#[0 2 149 0 6] 
#[0 2 153 0 10] 
#[1 0 173 0 1 2 157 0 7 0 177 0 21 0 181 0 22 0 185 0 28 0 189 0 29 0 193 0 30 0 197 0 31 0 201 0 32 0 205 0 33 2 161 0 55 0 213 0 58 0 217 0 61 0 217 0 62 0 217 0 66 0 217 0 67 0 217 0 68 0 217 0 69 0 217 0 74 0 217 0 75 0 217 0 76 0 217 0 77 0 217 0 78 0 217 0 79] 
#[0 2 165 0 25] 
#[1 0 14 0 3 2 169 0 41 0 14 0 86] 
#[1 1 177 0 3 1 185 0 36 1 185 0 40 0 202 0 86] 
#[0 2 173 0 12 0 13 0 14 0 17 0 18 0 19 0 20 0 84] 
#[1 1 177 0 3 1 185 0 36 1 185 0 40 0 206 0 86] 
#[0 0 210 0 3 0 86] 
#[0 2 177 0 10] 
#[0 0 214 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 86] 
#[1 0 173 0 1 2 181 0 2 0 177 0 21 0 181 0 22 0 185 0 28 0 189 0 29 0 193 0 30 0 197 0 31 0 201 0 32 0 205 0 33 2 185 0 55 0 213 0 58 0 217 0 61 0 217 0 62 0 217 0 66 0 217 0 67 0 217 0 68 0 217 0 69 0 217 0 74 0 217 0 75 0 217 0 76 0 217 0 77 0 217 0 78 0 217 0 79] 
#[0 0 218 0 3 0 10] 
#[0 0 222 0 3 0 10] 
#[1 2 189 0 3 2 193 0 10 2 197 0 71] 
#[1 0 158 0 3 0 158 0 10 2 201 0 72] 
#[0 0 226 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 86] 
#[1 0 6 0 1 0 6 0 21 0 6 0 22 0 6 0 28 0 6 0 29 0 6 0 30 0 6 0 31 0 6 0 32 0 6 0 33 0 53 0 39 2 205 0 48] 
#[1 2 209 0 3 2 213 0 4 2 217 0 63] 
#[1 0 230 0 2 0 230 0 3 2 221 0 60] 
#[0 0 234 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 86] 
#[0 0 238 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 86] 
#[0 0 242 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 86] 
#[1 0 230 0 3 0 230 0 10 2 225 0 60] 
#[1 0 230 0 2 0 230 0 3 2 229 0 60] 
#[1 0 230 0 2 0 230 0 3 2 233 0 60] 
#[1 0 63 0 3 0 234 0 4 0 234 0 6 0 234 0 8 0 234 0 9 0 234 0 11 0 234 0 25 0 234 0 26 0 234 0 32 0 234 0 86] 
#[0 2 237 0 6] 
#[1 0 173 0 1 0 177 0 21 0 181 0 22 0 185 0 28 0 189 0 29 0 193 0 30 0 197 0 31 0 201 0 32 0 205 0 33 2 241 0 55 0 213 0 58 0 217 0 61 0 217 0 62 0 217 0 66 0 217 0 67 0 217 0 68 0 217 0 69 0 217 0 74 0 217 0 75 0 217 0 76 0 217 0 77 0 217 0 78 0 217 0 79] 
#[1 0 173 0 1 2 245 0 2 0 177 0 21 0 181 0 22 0 185 0 28 0 189 0 29 0 193 0 30 0 197 0 31 2 101 0 32 0 205 0 33 2 249 0 52 2 121 0 55 0 213 0 58 0 217 0 61 0 217 0 62 0 217 0 66 0 217 0 67 0 217 0 68 0 217 0 69 0 217 0 74 0 217 0 75 0 217 0 76 0 217 0 77 0 217 0 78 0 217 0 79] 
#[1 1 133 0 1 0 66 0 2 0 66 0 3 2 253 0 5 0 66 0 8 0 66 0 9 0 66 0 10 0 66 0 11 0 66 0 32] 
#[1 0 250 0 2 0 250 0 3 3 1 0 51] 
#[1 0 67 0 2 0 67 0 3 2 221 0 60] 
#[1 0 14 0 3 3 5 0 41 0 14 0 86] 
#[1 0 250 0 3 0 250 0 10 3 9 0 51] 
#[0 0 194 0 2 0 3 0 10] 
#[1 0 250 0 2 0 250 0 3 3 13 0 51] 
#[1 0 250 0 2 0 250 0 3 3 17 0 51] 
#[1 0 173 0 1 0 177 0 21 0 181 0 22 0 185 0 28 0 189 0 29 0 193 0 30 0 197 0 31 3 21 0 32 0 205 0 33 1 113 0 55 0 213 0 58 0 217 0 61 0 217 0 62 0 217 0 66 0 217 0 67 0 217 0 68 0 217 0 69 0 217 0 74 0 217 0 75 0 217 0 76 0 217 0 77 0 217 0 78 0 217 0 79] 
#[0 0 254 0 3 0 5 0 86] 
#[1 0 14 0 3 3 25 0 41 0 14 0 86] 
#[1 0 14 0 3 3 29 0 23 3 33 0 41 0 14 0 86] 
#[1 0 173 0 1 0 177 0 21 0 181 0 22 0 185 0 28 0 189 0 29 0 193 0 30 0 197 0 31 0 201 0 32 0 205 0 33 3 37 0 55 0 213 0 58 0 217 0 61 0 217 0 62 0 217 0 66 0 217 0 67 0 217 0 68 0 217 0 69 0 217 0 74 0 217 0 75 0 217 0 76 0 217 0 77 0 217 0 78 0 217 0 79] 
#[0 3 41 0 5] 
#[0 3 45 0 28] 
#[1 0 14 0 3 3 49 0 23 3 53 0 41 0 14 0 86] 
#[1 0 173 0 1 3 57 0 7 0 177 0 21 0 181 0 22 0 185 0 28 0 189 0 29 0 193 0 30 0 197 0 31 0 201 0 32 0 205 0 33 3 61 0 55 0 213 0 58 0 217 0 61 0 217 0 62 0 217 0 66 0 217 0 67 0 217 0 68 0 217 0 69 0 217 0 74 0 217 0 75 0 217 0 76 0 217 0 77 0 217 0 78 0 217 0 79] 
#[1 1 177 0 3 1 185 0 36 1 185 0 40 1 2 0 86] 
#[0 1 6 0 3 0 86] 
#[1 0 14 0 3 3 65 0 41 0 14 0 86] 
#[0 1 10 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 86] 
#[1 0 230 0 2 0 230 0 3 3 69 0 60] 
#[1 0 173 0 1 1 117 0 8 0 177 0 21 0 181 0 22 0 185 0 28 0 189 0 29 0 193 0 30 0 197 0 31 0 201 0 32 0 205 0 33 3 73 0 55 0 213 0 58 0 217 0 61 0 217 0 62 0 217 0 66 0 217 0 67 0 217 0 68 0 217 0 69 3 73 0 70 3 73 0 73 0 217 0 74 0 217 0 75 0 217 0 76 0 217 0 77 0 217 0 78 0 217 0 79] 
#[0 1 14 0 3 0 10 0 24] 
#[0 1 18 0 3 0 10] 
#[1 2 189 0 3 3 77 0 10 2 197 0 71] 
#[0 1 22 0 3 0 4] 
#[1 0 173 0 1 0 177 0 21 0 181 0 22 0 185 0 28 0 189 0 29 0 193 0 30 0 197 0 31 0 201 0 32 0 205 0 33 1 125 0 55 0 213 0 58 0 217 0 61 0 217 0 62 3 81 0 65 0 217 0 66 0 217 0 67 0 217 0 68 0 217 0 69 0 217 0 74 0 217 0 75 0 217 0 76 0 217 0 77 0 217 0 78 0 217 0 79] 
#[0 1 26 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 86] 
#[0 1 30 0 3 0 4] 
#[1 3 85 0 2 3 89 0 3 3 93 0 59] 
#[1 3 89 0 3 3 97 0 10 3 93 0 59] 
#[1 3 101 0 2 3 89 0 3 3 93 0 59] 
#[1 3 105 0 2 3 89 0 3 3 93 0 59] 
#[1 0 185 0 28 0 189 0 29 0 193 0 30 0 197 0 31 3 109 0 75 3 109 0 76 3 109 0 77 3 109 0 78 3 109 0 79] 
#[1 3 113 0 2 1 34 0 3] 
#[0 1 38 0 3 0 5 0 86] 
#[1 0 250 0 2 0 250 0 3 3 117 0 51] 
#[1 0 173 0 1 0 177 0 21 0 181 0 22 0 185 0 28 0 189 0 29 0 193 0 30 0 197 0 31 0 201 0 32 0 205 0 33 3 121 0 55 0 213 0 58 0 217 0 61 0 217 0 62 0 217 0 66 0 217 0 67 0 217 0 68 0 217 0 69 0 217 0 74 0 217 0 75 0 217 0 76 0 217 0 77 0 217 0 78 0 217 0 79] 
#[1 3 125 0 2 3 129 0 3 3 133 0 50] 
#[1 1 177 0 3 1 185 0 36 1 185 0 40 1 42 0 86] 
#[1 3 129 0 3 3 137 0 10 3 133 0 50] 
#[1 3 141 0 2 3 129 0 3 3 133 0 50] 
#[1 3 145 0 2 3 129 0 3 3 133 0 50] 
#[1 1 133 0 1 0 66 0 2 0 66 0 3 3 149 0 5 0 66 0 8 0 66 0 9 0 66 0 11 0 66 0 32] 
#[1 1 177 0 3 1 185 0 36 1 185 0 40 1 46 0 86] 
#[1 0 173 0 1 0 177 0 21 0 181 0 22 0 185 0 28 0 189 0 29 0 193 0 30 0 197 0 31 0 201 0 32 0 205 0 33 3 153 0 55 0 213 0 58 0 217 0 61 0 217 0 62 0 217 0 66 0 217 0 67 0 217 0 68 0 217 0 69 0 217 0 74 0 217 0 75 0 217 0 76 0 217 0 77 0 217 0 78 0 217 0 79] 
#[1 1 177 0 3 1 185 0 36 1 185 0 40 1 50 0 86] 
#[1 0 14 0 3 3 157 0 23 3 161 0 41 0 14 0 86] 
#[0 1 54 0 1 0 21 0 22 0 28 0 29 0 30 0 31 0 32 0 33] 
#[1 0 14 0 3 3 165 0 23 3 169 0 41 0 14 0 86] 
#[1 0 173 0 1 0 177 0 21 0 181 0 22 0 185 0 28 0 189 0 29 0 193 0 30 0 197 0 31 0 201 0 32 0 205 0 33 3 173 0 55 0 213 0 58 0 217 0 61 0 217 0 62 0 217 0 66 0 217 0 67 0 217 0 68 0 217 0 69 0 217 0 74 0 217 0 75 0 217 0 76 0 217 0 77 0 217 0 78 0 217 0 79] 
#[1 1 177 0 3 1 185 0 36 1 185 0 40 1 58 0 86] 
#[0 3 177 0 28] 
#[1 0 14 0 3 3 181 0 23 3 185 0 41 0 14 0 86] 
#[1 1 177 0 3 1 185 0 36 1 185 0 40 1 62 0 86] 
#[1 3 189 0 2 3 89 0 3 3 93 0 59] 
#[0 1 66 0 3 0 10] 
#[0 1 70 0 3 0 10 0 24] 
#[0 1 74 0 3 0 4] 
#[0 1 78 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 86] 
#[1 0 173 0 1 0 177 0 21 0 181 0 22 0 185 0 28 0 189 0 29 0 193 0 30 0 197 0 31 0 201 0 32 0 205 0 33 3 193 0 55 0 213 0 58 0 217 0 61 0 217 0 62 0 217 0 66 0 217 0 67 0 217 0 68 0 217 0 69 0 217 0 74 0 217 0 75 0 217 0 76 0 217 0 77 0 217 0 78 0 217 0 79] 
#[0 1 82 0 2 0 3 0 10] 
#[0 1 86 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 86] 
#[0 1 90 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 86] 
#[0 1 94 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 86] 
#[0 1 98 0 3 0 86] 
#[0 1 102 0 3 0 5 0 8 0 9 0 11 0 32 0 86] 
#[1 3 197 0 2 3 129 0 3 3 133 0 50] 
#[0 1 34 0 2 0 3 0 10] 
#[0 1 106 0 3 0 5 0 86] 
#[1 0 173 0 1 0 177 0 21 0 181 0 22 0 185 0 28 0 189 0 29 0 193 0 30 0 197 0 31 2 101 0 32 0 205 0 33 3 201 0 52 2 121 0 55 0 213 0 58 0 217 0 61 0 217 0 62 0 217 0 66 0 217 0 67 0 217 0 68 0 217 0 69 0 217 0 74 0 217 0 75 0 217 0 76 0 217 0 77 0 217 0 78 0 217 0 79] 
#[0 1 110 0 2 0 3 0 10] 
#[0 1 114 0 3 0 5 0 86] 
#[0 1 118 0 3 0 5 0 86] 
#[0 1 122 0 3 0 5 0 86] 
#[1 0 173 0 1 0 177 0 21 0 181 0 22 0 185 0 28 0 189 0 29 0 193 0 30 0 197 0 31 0 201 0 32 0 205 0 33 3 205 0 55 0 213 0 58 0 217 0 61 0 217 0 62 0 217 0 66 0 217 0 67 0 217 0 68 0 217 0 69 0 217 0 74 0 217 0 75 0 217 0 76 0 217 0 77 0 217 0 78 0 217 0 79] 
#[1 0 14 0 3 3 209 0 41 0 14 0 86] 
#[1 0 173 0 1 0 177 0 21 0 181 0 22 0 185 0 28 0 189 0 29 0 193 0 30 0 197 0 31 0 201 0 32 0 205 0 33 3 213 0 55 0 213 0 58 0 217 0 61 0 217 0 62 0 217 0 66 0 217 0 67 0 217 0 68 0 217 0 69 0 217 0 74 0 217 0 75 0 217 0 76 0 217 0 77 0 217 0 78 0 217 0 79] 
#[1 1 177 0 3 1 185 0 36 1 185 0 40 1 126 0 86] 
#[1 0 173 0 1 0 177 0 21 0 181 0 22 0 185 0 28 0 189 0 29 0 193 0 30 0 197 0 31 0 201 0 32 0 205 0 33 3 217 0 55 0 213 0 58 0 217 0 61 0 217 0 62 0 217 0 66 0 217 0 67 0 217 0 68 0 217 0 69 0 217 0 74 0 217 0 75 0 217 0 76 0 217 0 77 0 217 0 78 0 217 0 79] 
#[1 1 177 0 3 1 185 0 36 1 185 0 40 1 130 0 86] 
#[1 0 14 0 3 3 221 0 41 0 14 0 86] 
#[1 0 14 0 3 3 225 0 23 3 229 0 41 0 14 0 86] 
#[1 0 173 0 1 0 177 0 21 0 181 0 22 0 185 0 28 0 189 0 29 0 193 0 30 0 197 0 31 0 201 0 32 0 205 0 33 3 233 0 55 0 213 0 58 0 217 0 61 0 217 0 62 0 217 0 66 0 217 0 67 0 217 0 68 0 217 0 69 0 217 0 74 0 217 0 75 0 217 0 76 0 217 0 77 0 217 0 78 0 217 0 79] 
#[1 1 177 0 3 1 185 0 36 1 185 0 40 1 134 0 86] 
#[0 1 138 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 86] 
#[0 1 142 0 2 0 3 0 10] 
#[0 1 146 0 3 0 5 0 86] 
#[0 1 150 0 2 0 3 0 10] 
#[0 3 113 0 2] 
#[1 1 177 0 3 1 185 0 36 1 185 0 40 1 154 0 86] 
#[1 0 14 0 3 3 237 0 41 0 14 0 86] 
#[1 0 14 0 3 3 241 0 41 0 14 0 86] 
#[1 1 177 0 3 1 185 0 36 1 185 0 40 1 158 0 86] 
#[1 0 173 0 1 0 177 0 21 0 181 0 22 0 185 0 28 0 189 0 29 0 193 0 30 0 197 0 31 0 201 0 32 0 205 0 33 3 245 0 55 0 213 0 58 0 217 0 61 0 217 0 62 0 217 0 66 0 217 0 67 0 217 0 68 0 217 0 69 0 217 0 74 0 217 0 75 0 217 0 76 0 217 0 77 0 217 0 78 0 217 0 79] 
#[1 1 177 0 3 1 185 0 36 1 185 0 40 1 162 0 86] 
#[1 0 14 0 3 3 249 0 41 0 14 0 86] 
#[1 1 177 0 3 1 185 0 36 1 185 0 40 1 166 0 86] 
#[1 1 177 0 3 1 185 0 36 1 185 0 40 1 170 0 86] 
#[1 0 14 0 3 3 253 0 41 0 14 0 86] 
#[1 1 177 0 3 1 185 0 36 1 185 0 40 1 174 0 86] 
#[1 1 177 0 3 1 185 0 36 1 185 0 40 1 178 0 86]
	).
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForArrayElements1: nodes [
	| result |
	result := LzArrayElementsNode new.
	result leftBracket: (nodes at: 1).
	result addTokens: ((nodes at: 2) at: 1) to: result commas.
	result addNodes: ((nodes at: 2) at: 2) to: result elements.
	result rightBracket: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForArrayElements2: nodes [
	| result |
	result := LzArrayElementsNode new.
	result leftBracket: (nodes at: 1).
	result addNode: (nodes at: 2) to: result elements.
	result addTokens: ((nodes at: 3) at: 1) to: result commas.
	result addNodes: ((nodes at: 3) at: 2) to: result elements.
	result rightBracket: (nodes at: 4).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForArrayTerm1: nodes [
	| result |
	result := LzArrayTermNode new.
	result leftBrace: (nodes at: 1).
	result arrayElements: (nodes at: 2).
	result rightBrace: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForAssetPrefix1: nodes [
	| result |
	result := LzAssetPrefixNode new.
	result label: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForCompoundStepTerm1: nodes [
	| result |
	result := LzCompoundStepTermNode new.
	result leftDelimiter: (nodes at: 1).
	result addNode: (nodes at: 2) to: result steps.
	result addTokens: ((nodes at: 3) at: 1) to: result commas.
	result addNodes: ((nodes at: 3) at: 2) to: result steps.
	result rightDelimiter: (nodes at: 4).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForFpNumberLiteralTerm1: nodes [
	| result |
	result := LzFpNumberLiteralTermNode new.
	result text: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForIntegerLiteralTerm1: nodes [
	| result |
	result := LzIntegerLiteralTermNode new.
	result text: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForNonInfixTerm2: nodes [
	| result |
	result := LzBracketOpTermNode new.
	result addNode: (nodes at: 1) to: result args.
	result leftBracket: (nodes at: 2).
	result addNode: (nodes at: 3) to: result args.
	result addTokens: ((nodes at: 4) at: 1) to: result commas.
	result addNodes: ((nodes at: 4) at: 2) to: result args.
	result rightBracket: (nodes at: 5).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForNonInfixTerm3: nodes [
	| result |
	result := LzSuperscriptOpTermNode new.
	result addNode: (nodes at: 1) to: result args.
	result leftParen: (nodes at: 2).
	result addNode: (nodes at: 3) to: result args.
	result addTokens: ((nodes at: 4) at: 1) to: result commas.
	result addNodes: ((nodes at: 4) at: 2) to: result args.
	result rightParen: (nodes at: 5).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForNonInfixTerm4: nodes [
	| result |
	result := LzSubscriptOpTermNode new.
	result addNode: (nodes at: 1) to: result args.
	result leftParen: (nodes at: 2).
	result addNode: (nodes at: 3) to: result args.
	result addTokens: ((nodes at: 4) at: 1) to: result commas.
	result addNodes: ((nodes at: 4) at: 2) to: result args.
	result rightParen: (nodes at: 5).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForOp1: nodes [
	| result |
	result := LzPrefixOpNode new.
	result opName: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForOp2: nodes [
	| result |
	result := LzPrefixOpNode new.
	result opName: (nodes at: 1).
	result leftParen: (nodes at: 2).
	result addNode: (nodes at: 3) to: result args.
	result addTokens: ((nodes at: 4) at: 1) to: result commas.
	result addNodes: ((nodes at: 4) at: 2) to: result args.
	result rightParen: (nodes at: 5).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForOp3: nodes [
	| result |
	result := LzTupleOpNode new.
	result leftParen: (nodes at: 1).
	result addNode: (nodes at: 2) to: result args.
	result addToken: (nodes at: 3) to: result commas.
	result rightParen: (nodes at: 4).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForOp4: nodes [
	| result |
	result := LzTupleOpNode new.
	result leftParen: (nodes at: 1).
	result addNode: (nodes at: 2) to: result args.
	result addToken: (nodes at: 3) to: result commas.
	result addNode: (nodes at: 4) to: result args.
	result addTokens: ((nodes at: 5) at: 1) to: result commas.
	result addNodes: ((nodes at: 5) at: 2) to: result args.
	result rightParen: (nodes at: 6).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForOp5: nodes [
	| result |
	result := LzInfixOpNode new.
	result addNode: (nodes at: 1) to: result args.
	result opName: (nodes at: 2).
	result addNode: (nodes at: 3) to: result args.
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForOp6: nodes [
	| result |
	result := LzBracketOpNode new.
	result addNode: (nodes at: 1) to: result args.
	result opName: (nodes at: 2).
	result addNode: (nodes at: 3) to: result args.
	result addTokens: ((nodes at: 4) at: 1) to: result commas.
	result addNodes: ((nodes at: 4) at: 2) to: result args.
	result rightBracket: (nodes at: 5).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForOp7: nodes [
	| result |
	result := LzSuperscriptOpNode new.
	result addNode: (nodes at: 1) to: result args.
	result opName: (nodes at: 2).
	result addNode: (nodes at: 3) to: result args.
	result addTokens: ((nodes at: 4) at: 1) to: result commas.
	result addNodes: ((nodes at: 4) at: 2) to: result args.
	result rightParen: (nodes at: 5).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForOp8: nodes [
	| result |
	result := LzSubscriptOpNode new.
	result addNode: (nodes at: 1) to: result args.
	result opName: (nodes at: 2).
	result addNode: (nodes at: 3) to: result args.
	result addTokens: ((nodes at: 4) at: 1) to: result commas.
	result addNodes: ((nodes at: 4) at: 2) to: result args.
	result rightParen: (nodes at: 5).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForOpArg1: nodes [
	| result |
	result := LzOpArgNode new.
	result name: (nodes at: 1).
	result colon: (nodes at: 2).
	result sort: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForOpArg2: nodes [
	| result |
	result := LzOpArgNode new.
	result sort: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForOption1: nodes [
	| result |
	result := LzOptionNode new.
	result comma: (nodes at: 1).
	result key: (nodes at: 2).
	result value: (nodes at: 4).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForParenthesizedTerm1: nodes [
	| result |
	result := LzParenthesizedTermNode new.
	result leftParen: (nodes at: 1).
	result term: (nodes at: 2).
	result rightParen: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForPattern1: nodes [
	| result |
	result := LzPatternNode new.
	result addNodes: ((nodes at: 1) at: 1) to: result vars.
	result addTokens: ((nodes at: 1) at: 2) to: result commas.
	result term: (nodes at: 2).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForPrefixOpTerm1: nodes [
	| result |
	result := LzPrefixOpTermNode new.
	result opName: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForPrefixOpTerm2: nodes [
	| result |
	result := LzPrefixOpTermNode new.
	result opName: (nodes at: 1).
	result leftParen: (nodes at: 2).
	result addNode: (nodes at: 3) to: result args.
	result addTokens: ((nodes at: 4) at: 1) to: result commas.
	result addNodes: ((nodes at: 4) at: 2) to: result args.
	result rightParen: (nodes at: 5).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForRationalNumberLiteralTerm1: nodes [
	| result |
	result := LzRationalNumberLiteralTermNode new.
	result text: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForRulePrefix1: nodes [
	| result |
	result := LzRulePrefixNode new.
	result label: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForRulePrefix2: nodes [
	| result |
	result := LzRulePrefixNode new.
	result label: (nodes at: 1).
	result order: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForSimpleOpArg1: nodes [
	| result |
	result := LzSimpleOpArgNode new.
	result leftParen: (nodes at: 1).
	result name: (nodes at: 2).
	result colon: (nodes at: 3).
	result sort: (nodes at: 4).
	result rightParen: (nodes at: 5).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForSimpleOpArg2: nodes [
	| result |
	result := LzSimpleOpArgNode new.
	result sort: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForStep1: nodes [
	| result |
	result := LzStepNode new.
	result term: (nodes at: 1).
	result arrow: (nodes at: 2).
	result pattern: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForStep2: nodes [
	| result |
	result := LzStepNode new.
	result term: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForStringLiteralTerm1: nodes [
	| result |
	result := LzStringLiteralTermNode new.
	result text: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTerm1: nodes [
	| result |
	result := LzInfixOpTermNode new.
	result addNode: (nodes at: 1) to: result args.
	result addTokens: ((nodes at: 2) at: 1) to: result opNames.
	result addNodes: ((nodes at: 2) at: 2) to: result args.
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelAsset1: nodes [
	| result |
	result := LzTopLevelAssetNode new.
	result label: (nodes at: 1).
	result addNodes: (nodes at: 2) to: result options.
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelAsset2: nodes [
	| result |
	result := LzTopLevelAssetNode new.
	result label: (nodes at: 1).
	result order: (nodes at: 3).
	result addNodes: (nodes at: 5) to: result options.
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelAxiom1: nodes [
	| result |
	result := LzTopLevelEqualityAxiomNode new.
	result addNodes: ((nodes at: 1) at: 1) to: result vars.
	result addTokens: ((nodes at: 1) at: 2) to: result commas.
	result left: (nodes at: 2).
	result equals: (nodes at: 3).
	result right: (nodes at: 4).
	result addNodes: (nodes at: 5) to: result options.
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelAxiom2: nodes [
	| result |
	result := LzTopLevelEqualityAxiomNode new.
	result addNodes: ((nodes at: 1) at: 1) to: result vars.
	result addTokens: ((nodes at: 1) at: 2) to: result commas.
	result left: (nodes at: 2).
	result equals: (nodes at: 3).
	result right: (nodes at: 4).
	result condition: (nodes at: 6).
	result addNodes: (nodes at: 7) to: result options.
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelAxiom3: nodes [
	| result |
	result := LzTopLevelEqualityAxiomNode new.
	result prefix: (nodes at: 1).
	result addNodes: ((nodes at: 2) at: 1) to: result vars.
	result addTokens: ((nodes at: 2) at: 2) to: result commas.
	result left: (nodes at: 3).
	result equals: (nodes at: 4).
	result right: (nodes at: 5).
	result addNodes: (nodes at: 6) to: result options.
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelAxiom4: nodes [
	| result |
	result := LzTopLevelEqualityAxiomNode new.
	result prefix: (nodes at: 1).
	result addNodes: ((nodes at: 2) at: 1) to: result vars.
	result addTokens: ((nodes at: 2) at: 2) to: result commas.
	result left: (nodes at: 3).
	result equals: (nodes at: 4).
	result right: (nodes at: 5).
	result condition: (nodes at: 7).
	result addNodes: (nodes at: 8) to: result options.
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelOp1: nodes [
	| result |
	result := LzTopLevelOpNode new.
	result addNodes: ((nodes at: 1) at: 1) to: result vars.
	result addTokens: ((nodes at: 1) at: 2) to: result commas.
	result op: (nodes at: 2).
	result colon: (nodes at: 3).
	result sort: (nodes at: 4).
	result addNodes: (nodes at: 5) to: result options.
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelRule1: nodes [
	| result |
	result := LzTopLevelRewriteRuleNode new.
	result addNodes: ((nodes at: 1) at: 1) to: result vars.
	result addTokens: ((nodes at: 1) at: 2) to: result commas.
	result pattern: (nodes at: 2).
	result arrow: (nodes at: 3).
	result replacement: (nodes at: 4).
	result addNodes: (nodes at: 5) to: result options.
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelRule2: nodes [
	| result |
	result := LzTopLevelRewriteRuleNode new.
	result addNodes: ((nodes at: 1) at: 1) to: result vars.
	result addTokens: ((nodes at: 1) at: 2) to: result commas.
	result pattern: (nodes at: 2).
	result arrow: (nodes at: 3).
	result replacement: (nodes at: 4).
	result condition: (nodes at: 6).
	result addNodes: (nodes at: 7) to: result options.
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelRule3: nodes [
	| result |
	result := LzTopLevelRewriteRuleNode new.
	result prefix: (nodes at: 1).
	result addNodes: ((nodes at: 2) at: 1) to: result vars.
	result addTokens: ((nodes at: 2) at: 2) to: result commas.
	result pattern: (nodes at: 3).
	result arrow: (nodes at: 4).
	result replacement: (nodes at: 5).
	result addNodes: (nodes at: 6) to: result options.
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelRule4: nodes [
	| result |
	result := LzTopLevelRewriteRuleNode new.
	result prefix: (nodes at: 1).
	result addNodes: ((nodes at: 2) at: 1) to: result vars.
	result addTokens: ((nodes at: 2) at: 2) to: result commas.
	result pattern: (nodes at: 3).
	result arrow: (nodes at: 4).
	result replacement: (nodes at: 5).
	result condition: (nodes at: 7).
	result addNodes: (nodes at: 8) to: result options.
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelRule5: nodes [
	| result |
	result := LzTopLevelFunctionRuleNode new.
	result addNodes: ((nodes at: 1) at: 1) to: result vars.
	result addTokens: ((nodes at: 1) at: 2) to: result commas.
	result pattern: (nodes at: 2).
	result arrow: (nodes at: 3).
	result pharo: (nodes at: 4).
	result code: (nodes at: 5).
	result addNodes: (nodes at: 6) to: result options.
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelRule6: nodes [
	| result |
	result := LzTopLevelFunctionRuleNode new.
	result addNodes: ((nodes at: 1) at: 1) to: result vars.
	result addTokens: ((nodes at: 1) at: 2) to: result commas.
	result pattern: (nodes at: 2).
	result arrow: (nodes at: 3).
	result pharo: (nodes at: 4).
	result code: (nodes at: 5).
	result condition: (nodes at: 7).
	result addNodes: (nodes at: 8) to: result options.
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelRule7: nodes [
	| result |
	result := LzTopLevelFunctionRuleNode new.
	result prefix: (nodes at: 1).
	result addNodes: ((nodes at: 2) at: 1) to: result vars.
	result addTokens: ((nodes at: 2) at: 2) to: result commas.
	result pattern: (nodes at: 3).
	result arrow: (nodes at: 4).
	result pharo: (nodes at: 5).
	result code: (nodes at: 6).
	result addNodes: (nodes at: 7) to: result options.
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelRule8: nodes [
	| result |
	result := LzTopLevelFunctionRuleNode new.
	result prefix: (nodes at: 1).
	result addNodes: ((nodes at: 2) at: 1) to: result vars.
	result addTokens: ((nodes at: 2) at: 2) to: result commas.
	result pattern: (nodes at: 3).
	result arrow: (nodes at: 4).
	result pharo: (nodes at: 5).
	result code: (nodes at: 6).
	result condition: (nodes at: 8).
	result addNodes: (nodes at: 9) to: result options.
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelSort1: nodes [
	| result |
	result := LzTopLevelSortNode new.
	result addNodes: ((nodes at: 1) at: 1) to: result vars.
	result addTokens: ((nodes at: 1) at: 2) to: result commas.
	result op: (nodes at: 2).
	result addNodes: (nodes at: 3) to: result options.
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelSort2: nodes [
	| result |
	result := LzTopLevelSubsortNode new.
	result addNodes: ((nodes at: 1) at: 1) to: result vars.
	result addTokens: ((nodes at: 1) at: 2) to: result commas.
	result subsort: (nodes at: 2).
	result subsetOf: (nodes at: 3).
	result supersort: (nodes at: 4).
	result addNodes: (nodes at: 5) to: result options.
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelSpecialTerms1: nodes [
	| result |
	result := LzTopLevelSpecialTermsNode new.
	result addToken: (nodes at: 1) to: result specialTerms.
	result addTokens: ((nodes at: 2) at: 1) to: result commas.
	result addTokens: ((nodes at: 2) at: 2) to: result specialTerms.
	result addNodes: (nodes at: 3) to: result options.
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelTerm1: nodes [
	| result |
	result := LzTopLevelTermNode new.
	result pattern: (nodes at: 1).
	result addNodes: (nodes at: 2) to: result options.
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelTerm2: nodes [
	| result |
	result := LzTopLevelTermNode new.
	result prefix: (nodes at: 1).
	result pattern: (nodes at: 2).
	result addNodes: (nodes at: 3) to: result options.
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelUseContext1: nodes [
	| result |
	result := LzTopLevelUseContextNode new.
	result pageName: (nodes at: 3).
	result addNodes: (nodes at: 4) to: result options.
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelUseContext2: nodes [
	| result |
	result := LzTopLevelUseContextNode new.
	result pageName: (nodes at: 2).
	result addNodes: (nodes at: 3) to: result options.
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTupleTerm1: nodes [
	| result |
	result := LzTupleTermNode new.
	result leftParen: (nodes at: 1).
	result addNode: (nodes at: 2) to: result args.
	result addToken: (nodes at: 3) to: result commas.
	result rightParen: (nodes at: 4).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTupleTerm2: nodes [
	| result |
	result := LzTupleTermNode new.
	result leftParen: (nodes at: 1).
	result addNode: (nodes at: 2) to: result args.
	result addToken: (nodes at: 3) to: result commas.
	result addNode: (nodes at: 4) to: result args.
	result addTokens: ((nodes at: 5) at: 1) to: result commas.
	result addNodes: ((nodes at: 5) at: 2) to: result args.
	result rightParen: (nodes at: 6).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForVar1: nodes [
	| result |
	result := LzVarNode new.
	result varName: (nodes at: 1).
	result colon: (nodes at: 2).
	result sort: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForVarTerm1: nodes [
	| result |
	result := LzVarTermWithSortNode new.
	result varName: (nodes at: 1).
	result colon: (nodes at: 2).
	result sort: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForVarTerm2: nodes [
	| result |
	result := LzVarTermNode new.
	result varName: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionFor_Option__option___1: nodes [
	| result |
	result := OrderedCollection new: 2.
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionFor_Option__option___2: nodes [
	| result |
	result := nodes at: 1.
	self add: (nodes at: 2) to: result.
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionFor_Var__var_______comma__1: nodes [
	| result |
	result := Array new: 2.
	result at: 1 put: (nodes at: 1).
	result at: 2 put: (nodes at: 2).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionFor_Var__var_______comma___1: nodes [
	| result |
	result := Array new: 2.
	result at: 1 put: (OrderedCollection new: 2).
	result at: 2 put: (OrderedCollection new: 2).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionFor_Var__var_______comma___2: nodes [
	| result |
	result := nodes at: 1.
	self add: ((nodes at: 2) at: 1) to: (result at: 1).
	self add: ((nodes at: 2) at: 2) to: (result at: 2).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionFor__opIdentifier___opName__NonInfixTerm__arg___1: nodes [
	| result |
	result := Array new: 2.
	result at: 1 put: (OrderedCollection new: 2).
	result at: 2 put: (OrderedCollection new: 2).
	self add: ((nodes at: 1) at: 1) to: (result at: 1).
	self add: ((nodes at: 1) at: 2) to: (result at: 2).
	^ result
]
