Class {
	#name : #LzParser2,
	#superclass : #SmaCCGLRParser,
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzParser2 class >> ambiguousTransitions [
^#(
#[ 0 6 0 49] 
#[ 0 6 0 105] 
#[ 0 70 1 161] 
#[ 0 74 1 165] 
#[ 0 78 1 177] 
#[ 0 78 1 181] 
#[ 0 78 1 185] 
#[ 0 146 1 177] 
#[ 0 146 1 181] 
#[ 0 146 1 185] 
#[ 0 78 0 146] 
#[ 0 14 2 29] 
#[ 0 178 1 165] 
#[ 0 198 2 53] 
#[ 0 218 0 242] 
#[ 0 198 0 238]
	).
]

{ #category : #'generated-accessing' }
LzParser2 class >> cacheId [
	^'2024-08-08T17:36:33.797621+02:00'
]

{ #category : #generated }
LzParser2 class >> definitionComment [
"%unicode;
%glr;
%root ParseTree;
%prefix Lz;
%suffix Node;
%start TopLevelTerm TopLevelOp TopLevelSort TopLevelAxiom TopLevelRule TopLevelUseContext TopLevelSpecialTerms TopLevelAsset TopLevelState Term;
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
	;
TopLevelState
	:  Var 'var' (Option 'option')* {{}}
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
		at: 'lzState'
		put: [ :parser | parser spawnParser: self startingAt: self startingStateForTopLevelState ].
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
	#(39 0 #reduceActionFor_Var__var_______comma___1: 1195009 false) 
	#(35 1 #liftFirstValue: 1071105 false) 
	#(41 0 #reduceActionFor_Option__option___1: 1254401 false) 
	#(84 1 #liftFirstValue: 5414917 false) 
	#(84 1 #liftFirstValue: 5414915 false) 
	#(84 1 #liftFirstValue: 5414913 false) 
	#(84 1 #liftFirstValue: 5414914 false) 
	#(84 1 #liftFirstValue: 5414918 false) 
	#(84 1 #liftFirstValue: 5414916 false) 
	#(84 1 #liftFirstValue: 5414919 false) 
	#(83 0 #reduceActionFor_Var__var_______comma___1: 5345281 false) 
	#(76 1 #reduceActionForStringLiteralTerm1: 4990977 false) 
	#(77 1 #reduceActionForIntegerLiteralTerm1: 5037057 false) 
	#(78 1 #reduceActionForRationalNumberLiteralTerm1: 5085185 false) 
	#(79 1 #reduceActionForFpNumberLiteralTerm1: 5147649 false) 
	#(67 1 #reduceActionForPrefixOpTerm1: 4231169 false) 
	#(68 1 #reduceActionForVarTerm2: 4360194 false) 
	#(55 1 #liftFirstValue: 3315714 false) 
	#(58 1 #liftFirstValue: 3426305 false) 
	#(61 1 #liftFirstValue: 3825668 false) 
	#(61 1 #liftFirstValue: 3825666 false) 
	#(61 1 #liftFirstValue: 3825670 false) 
	#(61 1 #liftFirstValue: 3825671 false) 
	#(61 1 #liftFirstValue: 3825667 false) 
	#(61 1 #liftFirstValue: 3825669 false) 
	#(61 1 #liftFirstValue: 3825665 false) 
	#(75 1 #liftFirstValue: 4878340 false) 
	#(75 1 #liftFirstValue: 4878337 false) 
	#(75 1 #liftFirstValue: 4878338 false) 
	#(75 1 #liftFirstValue: 4878339 false) 
	#(44 2 #reduceActionForAssetPrefix1: 1670145 false) 
	#(39 2 #reduceActionFor_Var__var_______comma___2: 1195010 false) 
	#(48 2 #reduceActionForPattern1: 2258945 false) 
	#(47 2 #reduceActionForTopLevelTerm1: 2171905 false) 
	#(49 1 #reduceActionForOp1: 2316289 false) 
	#(53 1 #reduceActionForSimpleOpArg2: 3092482 false) 
	#(46 2 #reduceActionForRulePrefix1: 2091009 false) 
	#(85 2 #reduceActionForTopLevelAsset1: 5547009 false) 
	#(86 2 #reduceActionForTopLevelState1: 5645313 false) 
	#(72 0 #reduceActionFor_Var__var_______comma___1: 4635649 false) 
	#(65 1 #reduceActionForStep2: 4075522 false) 
	#(64 0 #reduceActionFor_Var__var_______comma___1: 4013057 false) 
	#(57 1 #reduceActionFor__opIdentifier___opName__NonInfixTerm__arg___1: 3343361 false) 
	#(55 2 #reduceActionForTerm1: 3315713 false) 
	#(38 2 #reduceActionFor_Var__var_______comma__1: 1195009 false) 
	#(47 3 #reduceActionForTopLevelTerm2: 2171906 false) 
	#(40 1 #liftFirstValue: 1254401 false) 
	#(41 2 #reduceActionFor_Option__option___2: 1254402 false) 
	#(52 1 #reduceActionForOpArg2: 2997250 false) 
	#(42 3 #reduceActionForTopLevelSort1: 1282049 false) 
	#(80 3 #reduceActionForTopLevelUseContext2: 5197826 false) 
	#(81 3 #reduceActionForTopLevelSpecialTerms1: 5294081 false) 
	#(83 2 #reduceActionFor_Var__var_______comma___2: 5345282 false) 
	#(54 3 #reduceActionForVar1: 3246081 false) 
	#(66 3 #reduceActionForParenthesizedTerm1: 4155393 false) 
	#(73 1 #liftFirstValue: 4704257 false) 
	#(73 1 #liftFirstValue: 4704258 false) 
	#(69 3 #reduceActionForArrayTerm1: 4481025 false) 
	#(60 0 #reduceActionFor_Var__var_______comma___1: 3510273 false) 
	#(68 3 #reduceActionForVarTerm1: 4360193 false) 
	#(56 2 #reduceActionFor_Var__var_______comma__1: 3343361 false) 
	#(57 2 #reduceActionFor_Var__var_______comma___2: 3343362 false) 
	#(51 0 #reduceActionFor_Var__var_______comma___1: 2381825 false) 
	#(49 3 #reduceActionForOp5: 2316293 false) 
	#(80 4 #reduceActionForTopLevelUseContext1: 5197825 false) 
	#(82 2 #reduceActionFor_Var__var_______comma__1: 5345281 false) 
	#(74 4 #reduceActionForTupleTerm1: 4746241 false) 
	#(70 3 #reduceActionForArrayElements1: 4567041 false) 
	#(72 2 #reduceActionFor_Var__var_______comma___2: 4635650 false) 
	#(65 3 #reduceActionForStep1: 4075521 false) 
	#(62 4 #reduceActionForCompoundStepTerm1: 3951617 false) 
	#(64 2 #reduceActionFor_Var__var_______comma___2: 4013058 false) 
	#(52 3 #reduceActionForOpArg1: 2997249 false) 
	#(49 4 #reduceActionForOp3: 2316291 false) 
	#(37 5 #reduceActionForTopLevelOp1: 1180673 false) 
	#(42 5 #reduceActionForTopLevelSort2: 1282050 false) 
	#(43 5 #reduceActionForTopLevelAxiom1: 1488897 false) 
	#(46 5 #reduceActionForRulePrefix2: 2091010 false) 
	#(45 5 #reduceActionForTopLevelRule1: 1721345 false) 
	#(85 5 #reduceActionForTopLevelAsset2: 5547010 false) 
	#(71 2 #reduceActionFor_Var__var_______comma__1: 4635649 false) 
	#(70 4 #reduceActionForArrayElements2: 4567042 false) 
	#(63 2 #reduceActionFor_Var__var_______comma__1: 4013057 false) 
	#(67 5 #reduceActionForPrefixOpTerm2: 4231170 false) 
	#(60 2 #reduceActionFor_Var__var_______comma___2: 3510274 false) 
	#(58 5 #reduceActionForNonInfixTerm2: 3426306 false) 
	#(58 5 #reduceActionForNonInfixTerm4: 3426308 false) 
	#(58 5 #reduceActionForNonInfixTerm3: 3426307 false) 
	#(36 4 #reduceActionForOption1: 1097729 false) 
	#(53 5 #reduceActionForSimpleOpArg1: 3092481 false) 
	#(49 5 #reduceActionForOp2: 2316290 false) 
	#(51 2 #reduceActionFor_Var__var_______comma___2: 2381826 false) 
	#(49 5 #reduceActionForOp6: 2316294 false) 
	#(49 5 #reduceActionForOp8: 2316296 false) 
	#(49 5 #reduceActionForOp7: 2316295 false) 
	#(43 6 #reduceActionForTopLevelAxiom3: 1488899 false) 
	#(45 6 #reduceActionForTopLevelRule5: 1721349 false) 
	#(45 6 #reduceActionForTopLevelRule3: 1721347 false) 
	#(74 6 #reduceActionForTupleTerm2: 4746242 false) 
	#(59 2 #reduceActionFor_Var__var_______comma__1: 3510273 false) 
	#(49 6 #reduceActionForOp4: 2316292 false) 
	#(50 2 #reduceActionFor_Var__var_______comma__1: 2381825 false) 
	#(43 7 #reduceActionForTopLevelAxiom2: 1488898 false) 
	#(45 7 #reduceActionForTopLevelRule2: 1721346 false) 
	#(45 7 #reduceActionForTopLevelRule7: 1721351 false) 
	#(43 8 #reduceActionForTopLevelAxiom4: 1488900 false) 
	#(45 8 #reduceActionForTopLevelRule6: 1721350 false) 
	#(45 8 #reduceActionForTopLevelRule4: 1721348 false) 
	#(45 9 #reduceActionForTopLevelRule8: 1721352 false)
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
	^ 11
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
LzParser2 class >> startingStateForTopLevelState [
	^ 10
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
	^ #('"("' '")"' '","' '".}"' '":"' '"="' '"Pharo:"' '"["' '"\("' '"]"' '"^("' '"arrays"' '"floatingPointNumbers"' '"integers"' '"name"' '"name="' '"rationalNumbers"' '"steps"' '"strings"' '"termClasses"' '"{"' '"{."' '"|"' '"}"' '"⇒"' '"⊆"' '<whitespace>' '<string>' '<integer>' '<rationalNumber>' '<fpNumber>' '<opIdentifier>' '<varIdentifier>' 'B e g i n' 'Start' 'Option' 'TopLevelOp' '(Var ''var'' "," ''comma'')' '(Var ''var'' "," ''comma'')*' '(Option ''option'')' '(Option ''option'')*' 'TopLevelSort' 'TopLevelAxiom' 'AssetPrefix' 'TopLevelRule' 'RulePrefix' 'TopLevelTerm' 'Pattern' 'Op' '("," ''comma'' OpArg ''arg'')' '("," ''comma'' OpArg ''arg'')*' 'OpArg' 'SimpleOpArg' 'Var' 'Term' '(<opIdentifier> ''opName'' NonInfixTerm ''arg'')' '(<opIdentifier> ''opName'' NonInfixTerm ''arg'')+' 'NonInfixTerm' '("," ''comma'' Term ''arg'')' '("," ''comma'' Term ''arg'')*' 'SimpleTerm' 'CompoundStepTerm' '("," ''comma'' Step ''step'')' '("," ''comma'' Step ''step'')*' 'Step' 'ParenthesizedTerm' 'PrefixOpTerm' 'VarTerm' 'ArrayTerm' 'ArrayElements' '("," ''comma'' ArrayElement ''element'')' '("," ''comma'' ArrayElement ''element'')*' 'ArrayElement' 'TupleTerm' 'LiteralTerm' 'StringLiteralTerm' 'IntegerLiteralTerm' 'RationalNumberLiteralTerm' 'FpNumberLiteralTerm' 'TopLevelUseContext' 'TopLevelSpecialTerms' '("," ''comma'' SpecialTerm ''specialTerm'')' '("," ''comma'' SpecialTerm ''specialTerm'')*' 'SpecialTerm' 'TopLevelAsset' 'TopLevelState' 'E O F' 'error')
]

{ #category : #generated }
LzParser2 class >> symbolTypes [
	^ #(#SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #LzTopLevelTermNode #LzTopLevelTermNode #LzOptionNode #LzTopLevelOpNode #OrderedCollection #OrderedCollection #LzOptionNode #OrderedCollection #LzParseTreeNode #LzTopLevelEqualityAxiomNode #LzAssetPrefixNode #LzTopLevelRuleNode #LzRulePrefixNode #LzTopLevelTermNode #LzPatternNode #LzOpNode #OrderedCollection #OrderedCollection #LzOpArgNode #LzSimpleOpArgNode #LzVarNode #LzParseTreeNode #OrderedCollection #OrderedCollection #LzParseTreeNode #OrderedCollection #OrderedCollection #LzParseTreeNode #LzCompoundStepTermNode #OrderedCollection #OrderedCollection #LzStepNode #LzParenthesizedTermNode #LzPrefixOpTermNode #LzVarTermNode #LzArrayTermNode #LzArrayElementsNode #OrderedCollection #OrderedCollection #LzParseTreeNode #LzTupleTermNode #LzLiteralTermNode #LzStringLiteralTermNode #LzIntegerLiteralTermNode #LzRationalNumberLiteralTermNode #LzFpNumberLiteralTermNode #LzTopLevelUseContextNode #LzTopLevelSpecialTermsNode #OrderedCollection #OrderedCollection #SmaCCToken #LzTopLevelAssetNode #LzTopLevelStateNode #SmaCCToken #SmaCCErrorNode)
]

{ #category : #generated }
LzParser2 class >> transitionTable [
^#(
#[1 0 6 0 1 0 6 0 21 0 6 0 22 0 6 0 28 0 6 0 29 0 6 0 30 0 6 0 31 0 7 0 32 0 6 0 33 0 53 0 35 0 57 0 39 0 61 0 44 0 53 0 47 0 69 0 48] 
#[1 0 6 0 1 0 6 0 21 0 6 0 22 0 6 0 28 0 6 0 29 0 6 0 30 0 6 0 31 0 7 0 32 0 6 0 33 0 57 0 39 0 61 0 44 0 73 0 47 0 69 0 48] 
#[1 0 6 0 1 0 6 0 21 0 6 0 22 0 6 0 28 0 6 0 29 0 6 0 30 0 6 0 31 0 6 0 32 0 6 0 33 0 77 0 37 0 81 0 39] 
#[1 0 6 0 1 0 6 0 21 0 6 0 22 0 6 0 28 0 6 0 29 0 6 0 30 0 6 0 31 0 6 0 32 0 6 0 33 0 85 0 39 0 89 0 42] 
#[1 0 6 0 1 0 6 0 21 0 6 0 22 0 6 0 28 0 6 0 29 0 6 0 30 0 6 0 31 0 7 0 32 0 6 0 33 0 93 0 39 0 97 0 43 0 101 0 44] 
#[1 0 6 0 1 0 6 0 21 0 6 0 22 0 6 0 28 0 6 0 29 0 6 0 30 0 6 0 31 0 11 0 32 0 6 0 33 0 109 0 39 0 113 0 45 0 117 0 46] 
#[1 0 121 0 15 0 125 0 16 0 129 0 80] 
#[1 0 165 0 12 0 165 0 13 0 165 0 14 0 165 0 17 0 165 0 18 0 165 0 19 0 165 0 20 0 161 0 81 0 165 0 84] 
#[1 0 169 0 32 0 173 0 85] 
#[1 0 177 0 33 0 181 0 54 0 185 0 86] 
#[1 0 189 0 1 0 193 0 21 0 197 0 22 0 201 0 28 0 205 0 29 0 209 0 30 0 213 0 31 0 217 0 32 0 221 0 33 0 225 0 55 0 229 0 58 0 233 0 61 0 233 0 62 0 233 0 66 0 233 0 67 0 233 0 68 0 233 0 69 0 233 0 74 0 233 0 75 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79] 
#[0 1 25 0 5] 
#[0 0 0 0 87] 
#[1 0 189 0 1 0 193 0 21 0 197 0 22 0 201 0 28 0 205 0 29 0 209 0 30 0 213 0 31 0 217 0 32 1 29 0 33 1 33 0 38 1 37 0 54 1 41 0 55 0 229 0 58 0 233 0 61 0 233 0 62 0 233 0 66 0 233 0 67 0 233 0 68 0 233 0 69 0 233 0 74 0 233 0 75 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79] 
#[1 0 6 0 1 0 6 0 21 0 6 0 22 0 6 0 28 0 6 0 29 0 6 0 30 0 6 0 31 0 6 0 32 0 6 0 33 0 57 0 39 1 45 0 48] 
#[0 0 10 0 87] 
#[1 0 14 0 3 1 49 0 41 0 14 0 87] 
#[0 0 0 0 87] 
#[0 0 0 0 87] 
#[1 1 53 0 1 0 193 0 21 0 197 0 22 0 201 0 28 0 205 0 29 0 209 0 30 0 213 0 31 1 57 0 32 1 29 0 33 1 33 0 38 1 61 0 49 1 65 0 53 1 37 0 54 1 69 0 61 1 69 0 62 1 69 0 66 1 69 0 67 1 69 0 68 1 69 0 69 1 69 0 74 1 69 0 75 1 69 0 76 1 69 0 77 1 69 0 78 1 69 0 79] 
#[1 1 53 0 1 0 193 0 21 0 197 0 22 0 201 0 28 0 205 0 29 0 209 0 30 0 213 0 31 1 57 0 32 1 29 0 33 1 33 0 38 1 73 0 49 1 65 0 53 1 37 0 54 1 77 0 55 0 229 0 58 1 81 0 61 1 81 0 62 1 81 0 66 1 81 0 67 1 81 0 68 1 81 0 69 1 81 0 74 1 81 0 75 1 81 0 76 1 81 0 77 1 81 0 78 1 81 0 79] 
#[0 0 0 0 87] 
#[1 0 189 0 1 0 193 0 21 0 197 0 22 0 201 0 28 0 205 0 29 0 209 0 30 0 213 0 31 0 217 0 32 1 29 0 33 1 33 0 38 1 37 0 54 1 85 0 55 0 229 0 58 0 233 0 61 0 233 0 62 0 233 0 66 0 233 0 67 0 233 0 68 0 233 0 69 0 233 0 74 0 233 0 75 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79] 
#[0 0 0 0 87] 
#[1 0 6 0 1 0 6 0 21 0 6 0 22 0 6 0 28 0 6 0 29 0 6 0 30 0 6 0 31 0 6 0 32 0 6 0 33 1 89 0 39] 
#[1 1 93 0 5 1 97 0 8] 
#[1 0 189 0 1 0 193 0 21 0 197 0 22 0 201 0 28 0 205 0 29 0 209 0 30 0 213 0 31 0 217 0 32 1 29 0 33 1 33 0 38 1 37 0 54 1 101 0 55 0 229 0 58 0 233 0 61 0 233 0 62 0 233 0 66 0 233 0 67 0 233 0 68 0 233 0 69 0 233 0 74 0 233 0 75 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79] 
#[0 0 0 0 87] 
#[1 0 6 0 1 0 6 0 21 0 6 0 22 0 6 0 28 0 6 0 29 0 6 0 30 0 6 0 31 0 6 0 32 0 6 0 33 1 105 0 39] 
#[0 1 109 0 6] 
#[0 1 113 0 28] 
#[0 0 0 0 87] 
#[0 0 18 0 3 0 87] 
#[0 0 22 0 3 0 87] 
#[0 0 26 0 3 0 87] 
#[0 0 30 0 3 0 87] 
#[0 0 34 0 3 0 87] 
#[0 0 38 0 3 0 87] 
#[0 0 42 0 3 0 87] 
#[0 0 0 0 87] 
#[1 0 46 0 3 1 117 0 83 0 46 0 87] 
#[1 0 14 0 3 1 121 0 8 1 125 0 41 0 14 0 87] 
#[0 0 0 0 87] 
#[0 1 129 0 5] 
#[1 0 14 0 3 1 133 0 41 0 14 0 87] 
#[0 0 0 0 87] 
#[1 0 189 0 1 0 193 0 21 0 197 0 22 0 201 0 28 0 205 0 29 0 209 0 30 0 213 0 31 0 217 0 32 0 221 0 33 1 137 0 55 0 229 0 58 0 233 0 61 0 233 0 62 0 233 0 66 0 233 0 67 0 233 0 68 0 233 0 69 0 233 0 74 0 233 0 75 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79] 
#[1 1 141 0 8 1 145 0 70] 
#[1 0 189 0 1 0 193 0 21 0 197 0 22 0 201 0 28 0 205 0 29 0 209 0 30 0 213 0 31 0 217 0 32 0 221 0 33 1 149 0 55 0 229 0 58 0 233 0 61 0 233 0 62 1 153 0 65 0 233 0 66 0 233 0 67 0 233 0 68 0 233 0 69 0 233 0 74 0 233 0 75 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79] 
#[0 0 50 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 87] 
#[0 0 54 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 87] 
#[0 0 58 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 87] 
#[0 0 62 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 87] 
#[1 1 157 0 1 0 66 0 2 0 66 0 3 0 66 0 4 0 66 0 5 0 66 0 6 0 66 0 8 0 66 0 9 0 66 0 10 0 66 0 11 0 66 0 23 0 66 0 25 0 66 0 26 0 66 0 32 0 66 0 87] 
#[1 0 70 0 2 0 70 0 3 0 70 0 4 0 15 0 5 0 70 0 6 0 70 0 8 0 70 0 9 0 70 0 10 0 70 0 11 0 70 0 23 0 70 0 25 0 70 0 26 0 70 0 32 0 70 0 87] 
#[0 0 0 0 87] 
#[1 0 74 0 2 0 74 0 3 0 74 0 4 0 74 0 5 0 74 0 6 0 74 0 8 0 74 0 9 0 74 0 10 0 74 0 11 0 74 0 23 0 74 0 25 0 74 0 26 0 19 0 32 1 169 0 56 1 173 0 57 0 74 0 87] 
#[1 0 78 0 2 0 78 0 3 0 78 0 4 0 78 0 5 0 78 0 6 0 23 0 8 0 27 0 9 0 78 0 10 0 31 0 11 0 78 0 23 0 78 0 25 0 78 0 26 0 78 0 32 0 78 0 87] 
#[0 0 82 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 87] 
#[0 0 86 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 87] 
#[0 0 90 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 87] 
#[0 0 94 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 87] 
#[0 0 98 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 87] 
#[0 0 102 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 87] 
#[0 0 106 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 87] 
#[0 0 110 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 87] 
#[0 0 114 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 87] 
#[0 0 118 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 87] 
#[0 0 122 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 87] 
#[0 0 126 0 1 0 21 0 22 0 28 0 29 0 30 0 31 0 32 0 33] 
#[1 0 70 0 3 0 70 0 4 1 189 0 5 0 70 0 6 0 70 0 8 0 70 0 9 0 70 0 11 0 70 0 25 0 70 0 26 0 70 0 32 0 70 0 87] 
#[0 0 130 0 1 0 21 0 22 0 28 0 29 0 30 0 31 0 32 0 33] 
#[0 1 193 0 3] 
#[0 0 134 0 3 0 4 0 87] 
#[1 0 14 0 3 1 197 0 41 0 14 0 87] 
#[1 1 201 0 3 1 209 0 36 1 209 0 40 0 138 0 87] 
#[1 0 189 0 1 0 193 0 21 0 197 0 22 0 201 0 28 0 205 0 29 0 209 0 30 0 213 0 31 1 213 0 32 0 221 0 33 1 217 0 52 1 221 0 55 0 229 0 58 0 233 0 61 0 233 0 62 0 233 0 66 0 233 0 67 0 233 0 68 0 233 0 69 0 233 0 74 0 233 0 75 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79] 
#[1 1 225 0 1 0 142 0 3 0 142 0 5 0 66 0 8 0 66 0 9 0 66 0 11 0 66 0 26 0 66 0 32 0 142 0 87] 
#[0 1 229 0 5] 
#[1 1 233 0 8 1 237 0 9 1 241 0 11 1 245 0 32] 
#[0 0 146 0 3 0 5 0 8 0 9 0 11 0 32 0 87] 
#[1 0 14 0 3 1 249 0 41 0 14 0 87] 
#[0 1 253 0 26] 
#[1 0 35 0 8 0 39 0 9 0 43 0 11 0 78 0 26 0 47 0 32] 
#[0 2 1 0 6] 
#[1 0 189 0 1 0 193 0 21 0 197 0 22 0 201 0 28 0 205 0 29 0 209 0 30 0 213 0 31 0 217 0 32 1 29 0 33 1 33 0 38 1 37 0 54 2 5 0 55 0 229 0 58 0 233 0 61 0 233 0 62 0 233 0 66 0 233 0 67 0 233 0 68 0 233 0 69 0 233 0 74 0 233 0 75 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79] 
#[0 0 150 0 1 0 21 0 22 0 28 0 29 0 30 0 31 0 32 0 33] 
#[0 2 9 0 29] 
#[0 2 13 0 25] 
#[1 0 189 0 1 0 193 0 21 0 197 0 22 0 201 0 28 0 205 0 29 0 209 0 30 0 213 0 31 0 217 0 32 1 29 0 33 1 33 0 38 1 37 0 54 2 17 0 55 0 229 0 58 0 233 0 61 0 233 0 62 0 233 0 66 0 233 0 67 0 233 0 68 0 233 0 69 0 233 0 74 0 233 0 75 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79] 
#[0 2 21 0 28] 
#[1 0 14 0 3 2 25 0 41 0 14 0 87] 
#[1 0 51 0 3 2 33 0 41 2 37 0 82 0 14 0 87] 
#[0 2 41 0 29] 
#[1 1 201 0 3 1 209 0 36 1 209 0 40 0 154 0 87] 
#[1 0 189 0 1 0 193 0 21 0 197 0 22 0 201 0 28 0 205 0 29 0 209 0 30 0 213 0 31 0 217 0 32 0 221 0 33 2 45 0 55 0 229 0 58 0 233 0 61 0 233 0 62 0 233 0 66 0 233 0 67 0 233 0 68 0 233 0 69 0 233 0 74 0 233 0 75 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79] 
#[1 1 201 0 3 1 209 0 36 1 209 0 40 0 158 0 87] 
#[1 2 49 0 2 2 53 0 3] 
#[1 0 189 0 1 0 162 0 3 1 141 0 8 0 162 0 10 0 193 0 21 0 197 0 22 0 201 0 28 0 205 0 29 0 209 0 30 0 213 0 31 0 217 0 32 0 221 0 33 2 69 0 55 0 229 0 58 0 233 0 61 0 233 0 62 0 233 0 66 0 233 0 67 0 233 0 68 0 233 0 69 2 69 0 70 2 65 0 72 2 69 0 73 0 233 0 74 0 233 0 75 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79] 
#[0 2 73 0 24] 
#[1 0 166 0 3 0 166 0 4 2 77 0 25] 
#[1 0 170 0 3 0 170 0 4 2 81 0 64] 
#[1 0 189 0 1 0 193 0 21 0 197 0 22 0 201 0 28 0 205 0 29 0 209 0 30 0 213 0 31 0 217 0 32 0 221 0 33 2 85 0 55 0 229 0 58 0 233 0 61 0 233 0 62 0 233 0 66 0 233 0 67 0 233 0 68 0 233 0 69 0 233 0 74 0 233 0 75 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79] 
#[1 0 189 0 1 0 193 0 21 0 197 0 22 0 201 0 28 0 205 0 29 0 209 0 30 0 213 0 31 0 217 0 32 0 221 0 33 2 89 0 55 0 229 0 58 0 233 0 61 0 233 0 62 0 233 0 66 0 233 0 67 0 233 0 68 0 233 0 69 0 233 0 74 0 233 0 75 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79] 
#[1 0 189 0 1 0 193 0 21 0 197 0 22 0 201 0 28 0 205 0 29 0 209 0 30 0 213 0 31 0 217 0 32 0 221 0 33 2 93 0 58 0 233 0 61 0 233 0 62 0 233 0 66 0 233 0 67 0 233 0 68 0 233 0 69 0 233 0 74 0 233 0 75 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79] 
#[0 0 174 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 87] 
#[1 0 178 0 2 0 178 0 3 0 178 0 4 0 178 0 5 0 178 0 6 0 178 0 8 0 178 0 9 0 178 0 10 0 178 0 11 0 178 0 23 0 178 0 25 0 178 0 26 0 55 0 32 2 97 0 56 0 178 0 87] 
#[1 0 189 0 1 0 193 0 21 0 197 0 22 0 201 0 28 0 205 0 29 0 209 0 30 0 213 0 31 0 217 0 32 0 221 0 33 2 101 0 55 0 229 0 58 0 233 0 61 0 233 0 62 0 233 0 66 0 233 0 67 0 233 0 68 0 233 0 69 0 233 0 74 0 233 0 75 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79] 
#[1 0 189 0 1 0 193 0 21 0 197 0 22 0 201 0 28 0 205 0 29 0 209 0 30 0 213 0 31 0 217 0 32 0 221 0 33 2 105 0 55 0 229 0 58 0 233 0 61 0 233 0 62 0 233 0 66 0 233 0 67 0 233 0 68 0 233 0 69 0 233 0 74 0 233 0 75 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79] 
#[1 0 189 0 1 0 193 0 21 0 197 0 22 0 201 0 28 0 205 0 29 0 209 0 30 0 213 0 31 0 217 0 32 0 221 0 33 2 109 0 55 0 229 0 58 0 233 0 61 0 233 0 62 0 233 0 66 0 233 0 67 0 233 0 68 0 233 0 69 0 233 0 74 0 233 0 75 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79] 
#[1 0 189 0 1 0 193 0 21 0 197 0 22 0 201 0 28 0 205 0 29 0 209 0 30 0 213 0 31 0 217 0 32 0 221 0 33 2 113 0 55 0 229 0 58 0 233 0 61 0 233 0 62 0 233 0 66 0 233 0 67 0 233 0 68 0 233 0 69 0 233 0 74 0 233 0 75 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79] 
#[0 0 182 0 1 0 21 0 22 0 28 0 29 0 30 0 31 0 32 0 33] 
#[1 1 201 0 3 1 209 0 36 1 209 0 40 0 186 0 87] 
#[0 2 117 0 32] 
#[0 0 190 0 3 0 87] 
#[0 0 194 0 3 0 87] 
#[1 1 157 0 1 0 66 0 2 0 66 0 3 2 121 0 5 0 66 0 8 0 66 0 9 0 66 0 11 0 66 0 32] 
#[0 2 125 0 3] 
#[1 2 49 0 2 0 59 0 3] 
#[1 0 189 0 1 0 193 0 21 0 197 0 22 0 201 0 28 0 205 0 29 0 209 0 30 0 213 0 31 2 129 0 32 0 221 0 33 2 133 0 52 2 137 0 55 0 229 0 58 0 233 0 61 0 233 0 62 0 233 0 66 0 233 0 67 0 233 0 68 0 233 0 69 0 233 0 74 0 233 0 75 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79] 
#[1 0 189 0 1 0 193 0 21 0 197 0 22 0 201 0 28 0 205 0 29 0 209 0 30 0 213 0 31 0 217 0 32 0 221 0 33 2 141 0 55 0 229 0 58 0 233 0 61 0 233 0 62 0 233 0 66 0 233 0 67 0 233 0 68 0 233 0 69 0 233 0 74 0 233 0 75 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79] 
#[1 0 189 0 1 0 193 0 21 0 197 0 22 0 201 0 28 0 205 0 29 0 209 0 30 0 213 0 31 2 129 0 32 0 221 0 33 2 145 0 52 2 149 0 55 0 229 0 58 0 233 0 61 0 233 0 62 0 233 0 66 0 233 0 67 0 233 0 68 0 233 0 69 0 233 0 74 0 233 0 75 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79] 
#[1 0 189 0 1 0 193 0 21 0 197 0 22 0 201 0 28 0 205 0 29 0 209 0 30 0 213 0 31 2 129 0 32 0 221 0 33 2 153 0 52 2 149 0 55 0 229 0 58 0 233 0 61 0 233 0 62 0 233 0 66 0 233 0 67 0 233 0 68 0 233 0 69 0 233 0 74 0 233 0 75 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79] 
#[1 0 189 0 1 0 193 0 21 0 197 0 22 0 201 0 28 0 205 0 29 0 209 0 30 0 213 0 31 2 129 0 32 0 221 0 33 2 157 0 52 2 149 0 55 0 229 0 58 0 233 0 61 0 233 0 62 0 233 0 66 0 233 0 67 0 233 0 68 0 233 0 69 0 233 0 74 0 233 0 75 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79] 
#[1 2 161 0 1 0 193 0 21 0 197 0 22 0 201 0 28 0 205 0 29 0 209 0 30 0 213 0 31 0 217 0 32 0 221 0 33 2 165 0 53 1 69 0 61 1 69 0 62 1 69 0 66 1 69 0 67 1 69 0 68 1 69 0 69 1 69 0 74 1 69 0 75 1 69 0 76 1 69 0 77 1 69 0 78 1 69 0 79] 
#[1 1 201 0 3 1 209 0 36 1 209 0 40 0 202 0 87] 
#[1 0 189 0 1 0 193 0 21 0 197 0 22 0 201 0 28 0 205 0 29 0 209 0 30 0 213 0 31 0 217 0 32 0 221 0 33 2 169 0 55 0 229 0 58 0 233 0 61 0 233 0 62 0 233 0 66 0 233 0 67 0 233 0 68 0 233 0 69 0 233 0 74 0 233 0 75 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79] 
#[1 0 189 0 1 0 193 0 21 0 197 0 22 0 201 0 28 0 205 0 29 0 209 0 30 0 213 0 31 0 217 0 32 0 221 0 33 2 173 0 55 0 229 0 58 0 233 0 61 0 233 0 62 0 233 0 66 0 233 0 67 0 233 0 68 0 233 0 69 0 233 0 74 0 233 0 75 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79] 
#[0 2 177 0 6] 
#[0 2 181 0 10] 
#[1 0 189 0 1 2 185 0 7 0 193 0 21 0 197 0 22 0 201 0 28 0 205 0 29 0 209 0 30 0 213 0 31 0 217 0 32 0 221 0 33 2 189 0 55 0 229 0 58 0 233 0 61 0 233 0 62 0 233 0 66 0 233 0 67 0 233 0 68 0 233 0 69 0 233 0 74 0 233 0 75 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79] 
#[0 2 193 0 25] 
#[1 0 14 0 3 2 197 0 41 0 14 0 87] 
#[1 1 201 0 3 1 209 0 36 1 209 0 40 0 206 0 87] 
#[0 2 201 0 12 0 13 0 14 0 17 0 18 0 19 0 20 0 84] 
#[1 1 201 0 3 1 209 0 36 1 209 0 40 0 210 0 87] 
#[0 0 214 0 3 0 87] 
#[0 2 205 0 10] 
#[0 0 218 0 3 0 87] 
#[0 0 222 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 87] 
#[1 0 189 0 1 2 209 0 2 0 193 0 21 0 197 0 22 0 201 0 28 0 205 0 29 0 209 0 30 0 213 0 31 0 217 0 32 0 221 0 33 2 213 0 55 0 229 0 58 0 233 0 61 0 233 0 62 0 233 0 66 0 233 0 67 0 233 0 68 0 233 0 69 0 233 0 74 0 233 0 75 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79] 
#[0 0 226 0 3 0 10] 
#[0 0 230 0 3 0 10] 
#[1 2 217 0 3 2 221 0 10 2 225 0 71] 
#[1 0 162 0 3 0 162 0 10 2 229 0 72] 
#[0 0 234 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 87] 
#[1 0 6 0 1 0 6 0 21 0 6 0 22 0 6 0 28 0 6 0 29 0 6 0 30 0 6 0 31 0 6 0 32 0 6 0 33 0 57 0 39 2 233 0 48] 
#[1 2 237 0 3 2 241 0 4 2 245 0 63] 
#[1 0 238 0 2 0 238 0 3 2 249 0 60] 
#[0 0 242 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 87] 
#[0 0 246 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 87] 
#[0 0 250 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 87] 
#[1 0 238 0 3 0 238 0 10 2 253 0 60] 
#[1 0 238 0 2 0 238 0 3 3 1 0 60] 
#[1 0 238 0 2 0 238 0 3 3 5 0 60] 
#[1 0 63 0 3 0 242 0 4 0 242 0 6 0 242 0 8 0 242 0 9 0 242 0 11 0 242 0 25 0 242 0 26 0 242 0 32 0 242 0 87] 
#[0 3 9 0 6] 
#[1 0 189 0 1 0 193 0 21 0 197 0 22 0 201 0 28 0 205 0 29 0 209 0 30 0 213 0 31 0 217 0 32 0 221 0 33 3 13 0 55 0 229 0 58 0 233 0 61 0 233 0 62 0 233 0 66 0 233 0 67 0 233 0 68 0 233 0 69 0 233 0 74 0 233 0 75 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79] 
#[1 0 189 0 1 3 17 0 2 0 193 0 21 0 197 0 22 0 201 0 28 0 205 0 29 0 209 0 30 0 213 0 31 2 129 0 32 0 221 0 33 3 21 0 52 2 149 0 55 0 229 0 58 0 233 0 61 0 233 0 62 0 233 0 66 0 233 0 67 0 233 0 68 0 233 0 69 0 233 0 74 0 233 0 75 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79] 
#[1 1 157 0 1 0 66 0 2 0 66 0 3 3 25 0 5 0 66 0 8 0 66 0 9 0 66 0 10 0 66 0 11 0 66 0 32] 
#[1 0 254 0 2 0 254 0 3 3 29 0 51] 
#[1 0 67 0 2 0 67 0 3 2 249 0 60] 
#[1 0 14 0 3 3 33 0 41 0 14 0 87] 
#[1 0 254 0 3 0 254 0 10 3 37 0 51] 
#[0 0 198 0 2 0 3 0 10] 
#[1 0 254 0 2 0 254 0 3 3 41 0 51] 
#[1 0 254 0 2 0 254 0 3 3 45 0 51] 
#[1 0 189 0 1 0 193 0 21 0 197 0 22 0 201 0 28 0 205 0 29 0 209 0 30 0 213 0 31 3 49 0 32 0 221 0 33 1 137 0 55 0 229 0 58 0 233 0 61 0 233 0 62 0 233 0 66 0 233 0 67 0 233 0 68 0 233 0 69 0 233 0 74 0 233 0 75 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79] 
#[0 1 2 0 3 0 5 0 87] 
#[1 0 14 0 3 3 53 0 41 0 14 0 87] 
#[1 0 14 0 3 3 57 0 23 3 61 0 41 0 14 0 87] 
#[1 0 189 0 1 0 193 0 21 0 197 0 22 0 201 0 28 0 205 0 29 0 209 0 30 0 213 0 31 0 217 0 32 0 221 0 33 3 65 0 55 0 229 0 58 0 233 0 61 0 233 0 62 0 233 0 66 0 233 0 67 0 233 0 68 0 233 0 69 0 233 0 74 0 233 0 75 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79] 
#[0 3 69 0 5] 
#[0 3 73 0 28] 
#[1 0 14 0 3 3 77 0 23 3 81 0 41 0 14 0 87] 
#[1 0 189 0 1 3 85 0 7 0 193 0 21 0 197 0 22 0 201 0 28 0 205 0 29 0 209 0 30 0 213 0 31 0 217 0 32 0 221 0 33 3 89 0 55 0 229 0 58 0 233 0 61 0 233 0 62 0 233 0 66 0 233 0 67 0 233 0 68 0 233 0 69 0 233 0 74 0 233 0 75 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79] 
#[1 1 201 0 3 1 209 0 36 1 209 0 40 1 6 0 87] 
#[0 1 10 0 3 0 87] 
#[1 0 14 0 3 3 93 0 41 0 14 0 87] 
#[0 1 14 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 87] 
#[1 0 238 0 2 0 238 0 3 3 97 0 60] 
#[1 0 189 0 1 1 141 0 8 0 193 0 21 0 197 0 22 0 201 0 28 0 205 0 29 0 209 0 30 0 213 0 31 0 217 0 32 0 221 0 33 3 101 0 55 0 229 0 58 0 233 0 61 0 233 0 62 0 233 0 66 0 233 0 67 0 233 0 68 0 233 0 69 3 101 0 70 3 101 0 73 0 233 0 74 0 233 0 75 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79] 
#[0 1 18 0 3 0 10 0 24] 
#[0 1 22 0 3 0 10] 
#[1 2 217 0 3 3 105 0 10 2 225 0 71] 
#[0 1 26 0 3 0 4] 
#[1 0 189 0 1 0 193 0 21 0 197 0 22 0 201 0 28 0 205 0 29 0 209 0 30 0 213 0 31 0 217 0 32 0 221 0 33 1 149 0 55 0 229 0 58 0 233 0 61 0 233 0 62 3 109 0 65 0 233 0 66 0 233 0 67 0 233 0 68 0 233 0 69 0 233 0 74 0 233 0 75 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79] 
#[0 1 30 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 87] 
#[0 1 34 0 3 0 4] 
#[1 3 113 0 2 3 117 0 3 3 121 0 59] 
#[1 3 117 0 3 3 125 0 10 3 121 0 59] 
#[1 3 129 0 2 3 117 0 3 3 121 0 59] 
#[1 3 133 0 2 3 117 0 3 3 121 0 59] 
#[1 0 201 0 28 0 205 0 29 0 209 0 30 0 213 0 31 3 137 0 75 3 137 0 76 3 137 0 77 3 137 0 78 3 137 0 79] 
#[1 3 141 0 2 1 38 0 3] 
#[0 1 42 0 3 0 5 0 87] 
#[1 0 254 0 2 0 254 0 3 3 145 0 51] 
#[1 0 189 0 1 0 193 0 21 0 197 0 22 0 201 0 28 0 205 0 29 0 209 0 30 0 213 0 31 0 217 0 32 0 221 0 33 3 149 0 55 0 229 0 58 0 233 0 61 0 233 0 62 0 233 0 66 0 233 0 67 0 233 0 68 0 233 0 69 0 233 0 74 0 233 0 75 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79] 
#[1 3 153 0 2 3 157 0 3 3 161 0 50] 
#[1 1 201 0 3 1 209 0 36 1 209 0 40 1 46 0 87] 
#[1 3 157 0 3 3 165 0 10 3 161 0 50] 
#[1 3 169 0 2 3 157 0 3 3 161 0 50] 
#[1 3 173 0 2 3 157 0 3 3 161 0 50] 
#[1 1 157 0 1 0 66 0 2 0 66 0 3 3 177 0 5 0 66 0 8 0 66 0 9 0 66 0 11 0 66 0 32] 
#[1 1 201 0 3 1 209 0 36 1 209 0 40 1 50 0 87] 
#[1 0 189 0 1 0 193 0 21 0 197 0 22 0 201 0 28 0 205 0 29 0 209 0 30 0 213 0 31 0 217 0 32 0 221 0 33 3 181 0 55 0 229 0 58 0 233 0 61 0 233 0 62 0 233 0 66 0 233 0 67 0 233 0 68 0 233 0 69 0 233 0 74 0 233 0 75 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79] 
#[1 1 201 0 3 1 209 0 36 1 209 0 40 1 54 0 87] 
#[1 0 14 0 3 3 185 0 23 3 189 0 41 0 14 0 87] 
#[0 1 58 0 1 0 21 0 22 0 28 0 29 0 30 0 31 0 32 0 33] 
#[1 0 14 0 3 3 193 0 23 3 197 0 41 0 14 0 87] 
#[1 0 189 0 1 0 193 0 21 0 197 0 22 0 201 0 28 0 205 0 29 0 209 0 30 0 213 0 31 0 217 0 32 0 221 0 33 3 201 0 55 0 229 0 58 0 233 0 61 0 233 0 62 0 233 0 66 0 233 0 67 0 233 0 68 0 233 0 69 0 233 0 74 0 233 0 75 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79] 
#[1 1 201 0 3 1 209 0 36 1 209 0 40 1 62 0 87] 
#[0 3 205 0 28] 
#[1 0 14 0 3 3 209 0 23 3 213 0 41 0 14 0 87] 
#[1 1 201 0 3 1 209 0 36 1 209 0 40 1 66 0 87] 
#[1 3 217 0 2 3 117 0 3 3 121 0 59] 
#[0 1 70 0 3 0 10] 
#[0 1 74 0 3 0 10 0 24] 
#[0 1 78 0 3 0 4] 
#[0 1 82 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 87] 
#[1 0 189 0 1 0 193 0 21 0 197 0 22 0 201 0 28 0 205 0 29 0 209 0 30 0 213 0 31 0 217 0 32 0 221 0 33 3 221 0 55 0 229 0 58 0 233 0 61 0 233 0 62 0 233 0 66 0 233 0 67 0 233 0 68 0 233 0 69 0 233 0 74 0 233 0 75 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79] 
#[0 1 86 0 2 0 3 0 10] 
#[0 1 90 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 87] 
#[0 1 94 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 87] 
#[0 1 98 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 87] 
#[0 1 102 0 3 0 87] 
#[0 1 106 0 3 0 5 0 8 0 9 0 11 0 32 0 87] 
#[1 3 225 0 2 3 157 0 3 3 161 0 50] 
#[0 1 38 0 2 0 3 0 10] 
#[0 1 110 0 3 0 5 0 87] 
#[1 0 189 0 1 0 193 0 21 0 197 0 22 0 201 0 28 0 205 0 29 0 209 0 30 0 213 0 31 2 129 0 32 0 221 0 33 3 229 0 52 2 149 0 55 0 229 0 58 0 233 0 61 0 233 0 62 0 233 0 66 0 233 0 67 0 233 0 68 0 233 0 69 0 233 0 74 0 233 0 75 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79] 
#[0 1 114 0 2 0 3 0 10] 
#[0 1 118 0 3 0 5 0 87] 
#[0 1 122 0 3 0 5 0 87] 
#[0 1 126 0 3 0 5 0 87] 
#[1 0 189 0 1 0 193 0 21 0 197 0 22 0 201 0 28 0 205 0 29 0 209 0 30 0 213 0 31 0 217 0 32 0 221 0 33 3 233 0 55 0 229 0 58 0 233 0 61 0 233 0 62 0 233 0 66 0 233 0 67 0 233 0 68 0 233 0 69 0 233 0 74 0 233 0 75 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79] 
#[1 0 14 0 3 3 237 0 41 0 14 0 87] 
#[1 0 189 0 1 0 193 0 21 0 197 0 22 0 201 0 28 0 205 0 29 0 209 0 30 0 213 0 31 0 217 0 32 0 221 0 33 3 241 0 55 0 229 0 58 0 233 0 61 0 233 0 62 0 233 0 66 0 233 0 67 0 233 0 68 0 233 0 69 0 233 0 74 0 233 0 75 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79] 
#[1 1 201 0 3 1 209 0 36 1 209 0 40 1 130 0 87] 
#[1 0 189 0 1 0 193 0 21 0 197 0 22 0 201 0 28 0 205 0 29 0 209 0 30 0 213 0 31 0 217 0 32 0 221 0 33 3 245 0 55 0 229 0 58 0 233 0 61 0 233 0 62 0 233 0 66 0 233 0 67 0 233 0 68 0 233 0 69 0 233 0 74 0 233 0 75 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79] 
#[1 1 201 0 3 1 209 0 36 1 209 0 40 1 134 0 87] 
#[1 0 14 0 3 3 249 0 41 0 14 0 87] 
#[1 0 14 0 3 3 253 0 23 4 1 0 41 0 14 0 87] 
#[1 0 189 0 1 0 193 0 21 0 197 0 22 0 201 0 28 0 205 0 29 0 209 0 30 0 213 0 31 0 217 0 32 0 221 0 33 4 5 0 55 0 229 0 58 0 233 0 61 0 233 0 62 0 233 0 66 0 233 0 67 0 233 0 68 0 233 0 69 0 233 0 74 0 233 0 75 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79] 
#[1 1 201 0 3 1 209 0 36 1 209 0 40 1 138 0 87] 
#[0 1 142 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 87] 
#[0 1 146 0 2 0 3 0 10] 
#[0 1 150 0 3 0 5 0 87] 
#[0 1 154 0 2 0 3 0 10] 
#[0 3 141 0 2] 
#[1 1 201 0 3 1 209 0 36 1 209 0 40 1 158 0 87] 
#[1 0 14 0 3 4 9 0 41 0 14 0 87] 
#[1 0 14 0 3 4 13 0 41 0 14 0 87] 
#[1 1 201 0 3 1 209 0 36 1 209 0 40 1 162 0 87] 
#[1 0 189 0 1 0 193 0 21 0 197 0 22 0 201 0 28 0 205 0 29 0 209 0 30 0 213 0 31 0 217 0 32 0 221 0 33 4 17 0 55 0 229 0 58 0 233 0 61 0 233 0 62 0 233 0 66 0 233 0 67 0 233 0 68 0 233 0 69 0 233 0 74 0 233 0 75 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79] 
#[1 1 201 0 3 1 209 0 36 1 209 0 40 1 166 0 87] 
#[1 0 14 0 3 4 21 0 41 0 14 0 87] 
#[1 1 201 0 3 1 209 0 36 1 209 0 40 1 170 0 87] 
#[1 1 201 0 3 1 209 0 36 1 209 0 40 1 174 0 87] 
#[1 0 14 0 3 4 25 0 41 0 14 0 87] 
#[1 1 201 0 3 1 209 0 36 1 209 0 40 1 178 0 87] 
#[1 1 201 0 3 1 209 0 36 1 209 0 40 1 182 0 87]
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
LzParser2 >> reduceActionForTopLevelState1: nodes [
	| result |
	result := LzTopLevelStateNode new.
	result var: (nodes at: 1).
	result addNodes: (nodes at: 2) to: result options.
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
