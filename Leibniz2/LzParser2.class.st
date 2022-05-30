Class {
	#name : #LzParser2,
	#superclass : #SmaCCGLRParser,
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzParser2 class >> ambiguousTransitions [
^#(
#[ 0 74 1 37] 
#[ 0 78 1 49] 
#[ 0 78 1 53] 
#[ 0 78 1 57] 
#[ 0 46 1 105] 
#[ 0 142 1 37]
	).
]

{ #category : #'generated-accessing' }
LzParser2 class >> cacheId [
	^'2022-05-30T11:47:27.420644+02:00'
]

{ #category : #generated }
LzParser2 class >> definitionComment [
"%unicode;
%glr;
%root ParseTree;
%prefix Lz;
%suffix Node;
%start TopLevelTerm TopLevelOp TopLevelSort TopLevelAxiom TopLevelRule TopLevelUseContext TopLevelSpecialTerms;
%hierarchy LiteralTerm (IntegerLiteralTerm RationalNumberLiteralTerm FpNumberLiteralTerm StringLiteralTerm);
%hierarchy VarTerm (VarTermWithSort);
%hierarchy Term (PrefixOpTerm BracketOpTerm SuperscriptOpTerm SubscriptOpTerm ParenthesizedTerm VarTerm ArrayTerm LiteralTerm);
%hierarchy Op (PrefixOp InfixOp);
%hierarchy TopLevelRule (TopLevelRewriteRule TopLevelFunctionRule);
<whitespace>
	: \s+
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
Start 
	: TopLevelSpecialTerms
	;
TopLevelOp
	: (Var 'var' "","" 'comma')* Op 'op'  "":"" 'colon' Term 'sort' {{}}
	;
TopLevelSort
	: (Var 'var' "","" 'comma')* Op 'op' {{TopLevelSort}}
	| (Var 'var' "","" 'comma')* Term 'subsort' ""⊆"" 'subsetOf' Term 'supersort' {{TopLevelSubsort}}
	;
TopLevelAxiom
	: (Var 'var' "","" 'comma')* Term 'left' ""="" 'equals' Term 'right' (""|"" Term 'condition')? {{TopLevelEqualityAxiom}}
	;
TopLevelRule
	: (Var 'var' "","" 'comma')* Term 'pattern' ""⇒"" 'arrow' Term 'replacement' (""|"" Term 'condition')? {{TopLevelRewriteRule}}
	| (Var 'var' "","" 'comma')* Term 'pattern' ""→"" 'arrow' <string> 'code' ("":"" <opIdentifier> 'class')? (""|"" Term 'condition')? {{TopLevelFunctionRule}}
	;
TopLevelTerm
	: (Var 'var' "","" 'comma')* Term 'term' {{}}
	;
Op
	: <opIdentifier> 'opName'
		(""("" 'leftParen' Term 'arg'
			("","" 'comma' Term 'arg')* "")"" 'rightParen')? {{PrefixOp}}
	| NonInfixTerm 'arg' <opIdentifier> 'opName' NonInfixTerm 'arg' {{InfixOp}}
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
	| PrefixOpTerm
	| VarTerm
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
	: ""["" 'leftBracket' ArrayElement 'element'
		("","" 'comma' ArrayElement 'element')* ""]"" 'rightBracket' {{}}
	;
ArrayElement
	: Term
	| ArrayElements
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
	: (""name"" ""="" | ""name="") <string> 'pageName'
		(""|"" ""forSorts"" ""="" YesNoFlag 'sortFlag')? {{}}
	;
YesNoFlag
	: ""yes""
	| ""no""
	;
TopLevelSpecialTerms
	: SpecialTerm 'specialTerm' ("","" 'comma' SpecialTerm 'specialTerm')* {{}}
	;
SpecialTerm
	: ""integers""
	| ""rationalNumbers""
	| ""floatingPointNumbers""
	| ""strings""
	| ""arrays""
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
]

{ #category : #accessing }
LzParser2 class >> obsolete [
	{ 'lzSort'. 'lzOp'. 'lzAxiom'.  'lzRule'. 'lzTerm'.
		'lzUseContext'. 'lzSpecialTerms' }
		do: [ :each |
			LeParser annotationParsers removeKey: each  ifAbsent: [  ] ].
	^ super obsolete
]

{ #category : #generated }
LzParser2 class >> reduceTable [
^#(
	#(37 0 #reduceActionFor_Var__var_______comma___1: 989185 false) 
	#(69 1 #liftFirstValue: 3750917 false) 
	#(69 1 #liftFirstValue: 3750915 false) 
	#(69 1 #liftFirstValue: 3750913 false) 
	#(69 1 #liftFirstValue: 3750914 false) 
	#(69 1 #liftFirstValue: 3750916 false) 
	#(34 1 #liftFirstValue: 940033 false) 
	#(68 0 #reduceActionFor_Var__var_______comma___1: 3700737 false) 
	#(66 2 #reduceActionForTopLevelSpecialTerms1: 3649537 false) 
	#(52 1 #reduceActionForPrefixOpTerm1: 2671617 false) 
	#(53 1 #reduceActionForVarTerm2: 2800642 false) 
	#(60 1 #reduceActionForStringLiteralTerm1: 3290113 false) 
	#(61 1 #reduceActionForIntegerLiteralTerm1: 3336193 false) 
	#(62 1 #reduceActionForRationalNumberLiteralTerm1: 3384321 false) 
	#(63 1 #reduceActionForFpNumberLiteralTerm1: 3446785 false) 
	#(37 2 #reduceActionFor_Var__var_______comma___2: 989186 false) 
	#(41 2 #reduceActionForTopLevelTerm1: 1655809 false) 
	#(46 1 #liftFirstValue: 1993730 false) 
	#(49 1 #liftFirstValue: 2104321 false) 
	#(50 1 #liftFirstValue: 2503682 false) 
	#(50 1 #liftFirstValue: 2503684 false) 
	#(50 1 #liftFirstValue: 2503685 false) 
	#(50 1 #liftFirstValue: 2503683 false) 
	#(50 1 #liftFirstValue: 2503681 false) 
	#(59 1 #liftFirstValue: 3177476 false) 
	#(59 1 #liftFirstValue: 3177473 false) 
	#(59 1 #liftFirstValue: 3177474 false) 
	#(59 1 #liftFirstValue: 3177475 false) 
	#(42 1 #reduceActionForOp1: 1718273 false) 
	#(38 2 #reduceActionForTopLevelSort1: 1056769 false) 
	#(64 2 #reduceActionForTopLevelUseContext3: 3496963 false) 
	#(68 2 #reduceActionFor_Var__var_______comma___2: 3700738 false) 
	#(36 2 #reduceActionFor_Var__var_______comma__1: 989185 false) 
	#(48 1 #reduceActionFor__opIdentifier___opName__NonInfixTerm__arg___1: 2021377 false) 
	#(46 2 #reduceActionForTerm1: 1993729 false) 
	#(64 3 #reduceActionForTopLevelUseContext1: 3496961 false) 
	#(67 2 #reduceActionFor_Var__var_______comma__1: 3700737 false) 
	#(51 3 #reduceActionForParenthesizedTerm1: 2595841 false) 
	#(58 1 #liftFirstValue: 3135489 false) 
	#(58 1 #liftFirstValue: 3135490 false) 
	#(57 0 #reduceActionFor_Var__var_______comma___1: 3068929 false) 
	#(54 3 #reduceActionForArrayTerm1: 2921473 false) 
	#(44 0 #reduceActionFor_Var__var_______comma___1: 1782785 false) 
	#(45 3 #reduceActionForVar1: 1924097 false) 
	#(53 3 #reduceActionForVarTerm1: 2800641 false) 
	#(47 2 #reduceActionFor_Var__var_______comma__1: 2021377 false) 
	#(48 2 #reduceActionFor_Var__var_______comma___2: 2021378 false) 
	#(35 4 #reduceActionForTopLevelOp1: 974849 false) 
	#(42 3 #reduceActionForOp3: 1718275 false) 
	#(38 4 #reduceActionForTopLevelSort2: 1056770 false) 
	#(39 4 #reduceActionForTopLevelAxiom1: 1224705 false) 
	#(40 4 #reduceActionForTopLevelRule3: 1360899 false) 
	#(40 4 #reduceActionForTopLevelRule1: 1360897 false) 
	#(55 4 #reduceActionForArrayElements1: 3007489 false) 
	#(57 2 #reduceActionFor_Var__var_______comma___2: 3068930 false) 
	#(52 5 #reduceActionForPrefixOpTerm2: 2671618 false) 
	#(44 2 #reduceActionFor_Var__var_______comma___2: 1782786 false) 
	#(49 5 #reduceActionForNonInfixTerm2: 2104322 false) 
	#(49 5 #reduceActionForNonInfixTerm4: 2104324 false) 
	#(49 5 #reduceActionForNonInfixTerm3: 2104323 false) 
	#(42 5 #reduceActionForOp2: 1718274 false) 
	#(39 6 #reduceActionForTopLevelAxiom2: 1224706 false) 
	#(40 6 #reduceActionForTopLevelRule5: 1360901 false) 
	#(40 6 #reduceActionForTopLevelRule4: 1360900 false) 
	#(40 6 #reduceActionForTopLevelRule2: 1360898 false) 
	#(65 1 #liftFirstValue: 3618818 false) 
	#(65 1 #liftFirstValue: 3618817 false) 
	#(64 6 #reduceActionForTopLevelUseContext4: 3496964 false) 
	#(56 2 #reduceActionFor_Var__var_______comma__1: 3068929 false) 
	#(43 2 #reduceActionFor_Var__var_______comma__1: 1782785 false) 
	#(64 7 #reduceActionForTopLevelUseContext2: 3496962 false) 
	#(40 8 #reduceActionForTopLevelRule6: 1360902 false)
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
	^ #('"("' '")"' '","' '":"' '"="' '"["' '"\("' '"]"' '"^("' '"arrays"' '"floatingPointNumbers"' '"forSorts"' '"integers"' '"name"' '"name="' '"no"' '"rationalNumbers"' '"strings"' '"yes"' '"{"' '"|"' '"}"' '"→"' '"⇒"' '"⊆"' '<whitespace>' '<opIdentifier>' '<varIdentifier>' '<string>' '<integer>' '<rationalNumber>' '<fpNumber>' 'B e g i n' 'Start' 'TopLevelOp' '(Var ''var'' "," ''comma'')' '(Var ''var'' "," ''comma'')*' 'TopLevelSort' 'TopLevelAxiom' 'TopLevelRule' 'TopLevelTerm' 'Op' '("," ''comma'' Term ''arg'')' '("," ''comma'' Term ''arg'')*' 'Var' 'Term' '(<opIdentifier> ''opName'' NonInfixTerm ''arg'')' '(<opIdentifier> ''opName'' NonInfixTerm ''arg'')+' 'NonInfixTerm' 'SimpleTerm' 'ParenthesizedTerm' 'PrefixOpTerm' 'VarTerm' 'ArrayTerm' 'ArrayElements' '("," ''comma'' ArrayElement ''element'')' '("," ''comma'' ArrayElement ''element'')*' 'ArrayElement' 'LiteralTerm' 'StringLiteralTerm' 'IntegerLiteralTerm' 'RationalNumberLiteralTerm' 'FpNumberLiteralTerm' 'TopLevelUseContext' 'YesNoFlag' 'TopLevelSpecialTerms' '("," ''comma'' SpecialTerm ''specialTerm'')' '("," ''comma'' SpecialTerm ''specialTerm'')*' 'SpecialTerm' 'E O F' 'error')
]

{ #category : #generated }
LzParser2 class >> symbolTypes [
	^ #(#SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #LzTopLevelSpecialTermsNode #LzTopLevelSpecialTermsNode #LzTopLevelOpNode #OrderedCollection #OrderedCollection #LzParseTreeNode #LzTopLevelEqualityAxiomNode #LzTopLevelRuleNode #LzTopLevelTermNode #LzOpNode #OrderedCollection #OrderedCollection #LzVarNode #LzParseTreeNode #OrderedCollection #OrderedCollection #LzTermNode #LzTermNode #LzParenthesizedTermNode #LzPrefixOpTermNode #LzVarTermNode #LzArrayTermNode #LzArrayElementsNode #OrderedCollection #OrderedCollection #LzParseTreeNode #LzLiteralTermNode #LzStringLiteralTermNode #LzIntegerLiteralTermNode #LzRationalNumberLiteralTermNode #LzFpNumberLiteralTermNode #LzTopLevelUseContextNode #SmaCCToken #LzTopLevelSpecialTermsNode #OrderedCollection #OrderedCollection #SmaCCToken #SmaCCToken #SmaCCErrorNode)
]

{ #category : #generated }
LzParser2 class >> transitionTable [
^#(
#[1 0 65 0 10 0 65 0 11 0 65 0 13 0 65 0 17 0 65 0 18 0 57 0 34 0 57 0 66 0 65 0 69] 
#[1 0 6 0 1 0 6 0 20 0 6 0 27 0 6 0 28 0 6 0 29 0 6 0 30 0 6 0 31 0 6 0 32 0 69 0 37 0 73 0 41] 
#[1 0 6 0 1 0 6 0 20 0 6 0 27 0 6 0 28 0 6 0 29 0 6 0 30 0 6 0 31 0 6 0 32 0 77 0 35 0 81 0 37] 
#[1 0 6 0 1 0 6 0 20 0 6 0 27 0 6 0 28 0 6 0 29 0 6 0 30 0 6 0 31 0 6 0 32 0 85 0 37 0 89 0 38] 
#[1 0 6 0 1 0 6 0 20 0 6 0 27 0 6 0 28 0 6 0 29 0 6 0 30 0 6 0 31 0 6 0 32 0 93 0 37 0 97 0 39] 
#[1 0 6 0 1 0 6 0 20 0 6 0 27 0 6 0 28 0 6 0 29 0 6 0 30 0 6 0 31 0 6 0 32 0 101 0 37 0 105 0 40] 
#[1 0 109 0 14 0 113 0 15 0 117 0 64] 
#[1 0 65 0 10 0 65 0 11 0 65 0 13 0 65 0 17 0 65 0 18 0 121 0 66 0 65 0 69] 
#[0 0 10 0 3 0 70] 
#[0 0 14 0 3 0 70] 
#[0 0 18 0 3 0 70] 
#[0 0 22 0 3 0 70] 
#[0 0 26 0 3 0 70] 
#[0 0 0 0 70] 
#[0 0 30 0 70] 
#[1 0 34 0 3 0 125 0 68 0 34 0 70] 
#[1 0 129 0 1 0 133 0 20 0 137 0 27 0 141 0 28 0 145 0 29 0 149 0 30 0 153 0 31 0 157 0 32 0 161 0 36 0 165 0 45 0 169 0 46 0 173 0 49 0 177 0 50 0 177 0 51 0 177 0 52 0 177 0 53 0 177 0 54 0 177 0 59 0 177 0 60 0 177 0 61 0 177 0 62 0 177 0 63] 
#[0 0 0 0 70] 
#[0 0 0 0 70] 
#[1 0 129 0 1 0 133 0 20 0 217 0 27 0 141 0 28 0 145 0 29 0 149 0 30 0 153 0 31 0 157 0 32 0 161 0 36 0 221 0 42 0 165 0 45 0 225 0 49 0 177 0 50 0 177 0 51 0 177 0 52 0 177 0 53 0 177 0 54 0 177 0 59 0 177 0 60 0 177 0 61 0 177 0 62 0 177 0 63] 
#[1 0 129 0 1 0 133 0 20 0 217 0 27 0 141 0 28 0 145 0 29 0 149 0 30 0 153 0 31 0 157 0 32 0 161 0 36 0 229 0 42 0 165 0 45 0 233 0 46 0 237 0 49 0 177 0 50 0 177 0 51 0 177 0 52 0 177 0 53 0 177 0 54 0 177 0 59 0 177 0 60 0 177 0 61 0 177 0 62 0 177 0 63] 
#[0 0 0 0 70] 
#[1 0 129 0 1 0 133 0 20 0 137 0 27 0 141 0 28 0 145 0 29 0 149 0 30 0 153 0 31 0 157 0 32 0 161 0 36 0 165 0 45 0 241 0 46 0 173 0 49 0 177 0 50 0 177 0 51 0 177 0 52 0 177 0 53 0 177 0 54 0 177 0 59 0 177 0 60 0 177 0 61 0 177 0 62 0 177 0 63] 
#[0 0 0 0 70] 
#[1 0 129 0 1 0 133 0 20 0 137 0 27 0 141 0 28 0 145 0 29 0 149 0 30 0 153 0 31 0 157 0 32 0 161 0 36 0 165 0 45 0 245 0 46 0 173 0 49 0 177 0 50 0 177 0 51 0 177 0 52 0 177 0 53 0 177 0 54 0 177 0 59 0 177 0 60 0 177 0 61 0 177 0 62 0 177 0 63] 
#[0 0 0 0 70] 
#[0 0 249 0 5] 
#[0 0 253 0 29] 
#[0 0 0 0 70] 
#[0 0 0 0 70] 
#[1 1 1 0 3 1 5 0 67 0 38 0 70] 
#[1 0 129 0 1 0 133 0 20 0 137 0 27 1 9 0 28 0 145 0 29 0 149 0 30 0 153 0 31 0 157 0 32 1 13 0 46 0 173 0 49 0 177 0 50 0 177 0 51 0 177 0 52 0 177 0 53 0 177 0 54 0 177 0 59 0 177 0 60 0 177 0 61 0 177 0 62 0 177 0 63] 
#[1 1 17 0 6 1 21 0 55] 
#[1 1 25 0 1 0 42 0 2 0 42 0 3 0 42 0 4 0 42 0 5 0 42 0 6 0 42 0 7 0 42 0 8 0 42 0 9 0 42 0 21 0 42 0 23 0 42 0 24 0 42 0 25 0 42 0 27 0 42 0 70] 
#[1 1 29 0 4 0 46 0 5 0 46 0 6 0 46 0 7 0 46 0 9 0 46 0 23 0 46 0 24 0 46 0 25 0 46 0 27 0 46 0 70] 
#[0 0 50 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 21 0 23 0 24 0 25 0 27 0 70] 
#[0 0 54 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 21 0 23 0 24 0 25 0 27 0 70] 
#[0 0 58 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 21 0 23 0 24 0 25 0 27 0 70] 
#[0 0 62 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 21 0 23 0 24 0 25 0 27 0 70] 
#[0 0 66 0 1 0 20 0 27 0 28 0 29 0 30 0 31 0 32] 
#[0 1 33 0 3] 
#[0 0 70 0 70] 
#[1 0 74 0 2 0 74 0 3 0 74 0 4 0 74 0 5 0 74 0 6 0 74 0 7 0 74 0 8 0 74 0 9 0 74 0 21 0 74 0 23 0 74 0 24 0 74 0 25 0 7 0 27 1 41 0 47 1 45 0 48 0 74 0 70] 
#[1 0 78 0 2 0 78 0 3 0 78 0 4 0 78 0 5 0 11 0 6 0 15 0 7 0 78 0 8 0 19 0 9 0 78 0 21 0 78 0 23 0 78 0 24 0 78 0 25 0 78 0 27 0 78 0 70] 
#[0 0 82 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 21 0 23 0 24 0 25 0 27 0 70] 
#[0 0 86 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 21 0 23 0 24 0 25 0 27 0 70] 
#[0 0 90 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 21 0 23 0 24 0 25 0 27 0 70] 
#[0 0 94 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 21 0 23 0 24 0 25 0 27 0 70] 
#[0 0 98 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 21 0 23 0 24 0 25 0 27 0 70] 
#[0 0 102 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 21 0 23 0 24 0 25 0 27 0 70] 
#[0 0 106 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 21 0 23 0 24 0 25 0 27 0 70] 
#[0 0 110 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 21 0 23 0 24 0 25 0 27 0 70] 
#[0 0 114 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 21 0 23 0 24 0 25 0 27 0 70] 
#[1 1 61 0 1 0 118 0 4 0 42 0 6 0 42 0 7 0 42 0 9 0 42 0 25 0 42 0 27 0 118 0 70] 
#[0 1 65 0 4] 
#[0 1 69 0 27] 
#[0 0 122 0 70] 
#[0 1 73 0 25] 
#[1 0 74 0 25 1 77 0 27 1 41 0 47 1 45 0 48] 
#[0 1 81 0 5] 
#[1 1 85 0 23 1 89 0 24] 
#[0 1 93 0 29] 
#[1 1 97 0 21 0 126 0 70] 
#[0 1 101 0 10 0 11 0 13 0 17 0 18 0 69] 
#[0 0 130 0 3 0 70] 
#[1 0 46 0 2 0 46 0 3 0 23 0 4 0 46 0 5 0 46 0 6 0 46 0 7 0 46 0 8 0 46 0 9 0 46 0 21 0 46 0 23 0 46 0 24 0 46 0 25 0 46 0 27 0 46 0 70] 
#[0 1 109 0 2] 
#[1 0 129 0 1 1 17 0 6 0 133 0 20 0 137 0 27 1 9 0 28 0 145 0 29 0 149 0 30 0 153 0 31 0 157 0 32 1 121 0 46 0 173 0 49 0 177 0 50 0 177 0 51 0 177 0 52 0 177 0 53 0 177 0 54 1 121 0 55 1 121 0 58 0 177 0 59 0 177 0 60 0 177 0 61 0 177 0 62 0 177 0 63] 
#[0 1 125 0 22] 
#[1 0 129 0 1 0 133 0 20 0 137 0 27 1 9 0 28 0 145 0 29 0 149 0 30 0 153 0 31 0 157 0 32 1 129 0 46 0 173 0 49 0 177 0 50 0 177 0 51 0 177 0 52 0 177 0 53 0 177 0 54 0 177 0 59 0 177 0 60 0 177 0 61 0 177 0 62 0 177 0 63] 
#[1 0 129 0 1 0 133 0 20 0 137 0 27 1 9 0 28 0 145 0 29 0 149 0 30 0 153 0 31 0 157 0 32 1 133 0 46 0 173 0 49 0 177 0 50 0 177 0 51 0 177 0 52 0 177 0 53 0 177 0 54 0 177 0 59 0 177 0 60 0 177 0 61 0 177 0 62 0 177 0 63] 
#[0 0 134 0 1 0 20 0 27 0 28 0 29 0 30 0 31 0 32] 
#[1 0 129 0 1 0 133 0 20 0 137 0 27 1 9 0 28 0 145 0 29 0 149 0 30 0 153 0 31 0 157 0 32 1 137 0 49 0 177 0 50 0 177 0 51 0 177 0 52 0 177 0 53 0 177 0 54 0 177 0 59 0 177 0 60 0 177 0 61 0 177 0 62 0 177 0 63] 
#[0 0 138 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 21 0 23 0 24 0 25 0 27 0 70] 
#[1 0 142 0 2 0 142 0 3 0 142 0 4 0 142 0 5 0 142 0 6 0 142 0 7 0 142 0 8 0 142 0 9 0 142 0 21 0 142 0 23 0 142 0 24 0 142 0 25 0 27 0 27 1 141 0 47 0 142 0 70] 
#[1 0 129 0 1 0 133 0 20 0 137 0 27 1 9 0 28 0 145 0 29 0 149 0 30 0 153 0 31 0 157 0 32 1 145 0 46 0 173 0 49 0 177 0 50 0 177 0 51 0 177 0 52 0 177 0 53 0 177 0 54 0 177 0 59 0 177 0 60 0 177 0 61 0 177 0 62 0 177 0 63] 
#[1 0 129 0 1 0 133 0 20 0 137 0 27 1 9 0 28 0 145 0 29 0 149 0 30 0 153 0 31 0 157 0 32 1 149 0 46 0 173 0 49 0 177 0 50 0 177 0 51 0 177 0 52 0 177 0 53 0 177 0 54 0 177 0 59 0 177 0 60 0 177 0 61 0 177 0 62 0 177 0 63] 
#[1 0 129 0 1 0 133 0 20 0 137 0 27 1 9 0 28 0 145 0 29 0 149 0 30 0 153 0 31 0 157 0 32 1 153 0 46 0 173 0 49 0 177 0 50 0 177 0 51 0 177 0 52 0 177 0 53 0 177 0 54 0 177 0 59 0 177 0 60 0 177 0 61 0 177 0 62 0 177 0 63] 
#[1 0 129 0 1 0 133 0 20 0 137 0 27 1 9 0 28 0 145 0 29 0 149 0 30 0 153 0 31 0 157 0 32 1 157 0 46 0 173 0 49 0 177 0 50 0 177 0 51 0 177 0 52 0 177 0 53 0 177 0 54 0 177 0 59 0 177 0 60 0 177 0 61 0 177 0 62 0 177 0 63] 
#[1 0 129 0 1 0 133 0 20 0 137 0 27 1 9 0 28 0 145 0 29 0 149 0 30 0 153 0 31 0 157 0 32 1 161 0 46 0 173 0 49 0 177 0 50 0 177 0 51 0 177 0 52 0 177 0 53 0 177 0 54 0 177 0 59 0 177 0 60 0 177 0 61 0 177 0 62 0 177 0 63] 
#[1 0 129 0 1 0 133 0 20 0 137 0 27 1 9 0 28 0 145 0 29 0 149 0 30 0 153 0 31 0 157 0 32 1 165 0 49 0 177 0 50 0 177 0 51 0 177 0 52 0 177 0 53 0 177 0 54 0 177 0 59 0 177 0 60 0 177 0 61 0 177 0 62 0 177 0 63] 
#[1 0 129 0 1 0 133 0 20 0 137 0 27 1 9 0 28 0 145 0 29 0 149 0 30 0 153 0 31 0 157 0 32 1 169 0 46 0 173 0 49 0 177 0 50 0 177 0 51 0 177 0 52 0 177 0 53 0 177 0 54 0 177 0 59 0 177 0 60 0 177 0 61 0 177 0 62 0 177 0 63] 
#[1 0 129 0 1 0 133 0 20 0 137 0 27 1 9 0 28 0 145 0 29 0 149 0 30 0 153 0 31 0 157 0 32 1 173 0 49 0 177 0 50 0 177 0 51 0 177 0 52 0 177 0 53 0 177 0 54 0 177 0 59 0 177 0 60 0 177 0 61 0 177 0 62 0 177 0 63] 
#[1 0 129 0 1 0 133 0 20 0 137 0 27 1 9 0 28 0 145 0 29 0 149 0 30 0 153 0 31 0 157 0 32 1 177 0 46 0 173 0 49 0 177 0 50 0 177 0 51 0 177 0 52 0 177 0 53 0 177 0 54 0 177 0 59 0 177 0 60 0 177 0 61 0 177 0 62 0 177 0 63] 
#[0 1 181 0 29] 
#[1 0 129 0 1 0 133 0 20 0 137 0 27 1 9 0 28 0 145 0 29 0 149 0 30 0 153 0 31 0 157 0 32 1 185 0 46 0 173 0 49 0 177 0 50 0 177 0 51 0 177 0 52 0 177 0 53 0 177 0 54 0 177 0 59 0 177 0 60 0 177 0 61 0 177 0 62 0 177 0 63] 
#[1 1 189 0 21 0 146 0 70] 
#[0 1 193 0 12] 
#[0 0 150 0 3 0 70] 
#[1 0 129 0 1 0 133 0 20 0 137 0 27 1 9 0 28 0 145 0 29 0 149 0 30 0 153 0 31 0 157 0 32 1 197 0 46 0 173 0 49 0 177 0 50 0 177 0 51 0 177 0 52 0 177 0 53 0 177 0 54 0 177 0 59 0 177 0 60 0 177 0 61 0 177 0 62 0 177 0 63] 
#[0 0 154 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 21 0 23 0 24 0 25 0 27 0 70] 
#[0 0 158 0 3 0 8] 
#[0 0 162 0 3 0 8] 
#[1 0 166 0 3 0 166 0 8 1 201 0 57] 
#[0 0 170 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 21 0 23 0 24 0 25 0 27 0 70] 
#[1 0 174 0 2 0 174 0 3 1 205 0 44] 
#[1 0 178 0 3 0 182 0 5 0 182 0 6 0 182 0 7 0 182 0 9 0 182 0 23 0 182 0 24 0 182 0 25 0 182 0 27 0 182 0 70] 
#[0 0 186 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 21 0 23 0 24 0 25 0 27 0 70] 
#[0 0 190 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 21 0 23 0 24 0 25 0 27 0 70] 
#[1 0 174 0 3 0 174 0 8 1 209 0 44] 
#[1 0 174 0 2 0 174 0 3 1 213 0 44] 
#[1 0 174 0 2 0 174 0 3 1 217 0 44] 
#[1 0 174 0 2 0 174 0 3 1 221 0 44] 
#[0 0 194 0 70] 
#[0 0 198 0 4] 
#[0 0 202 0 70] 
#[1 0 186 0 25 0 186 0 27 0 198 0 70] 
#[1 1 225 0 21 0 206 0 70] 
#[1 1 229 0 4 1 233 0 21 0 210 0 70] 
#[1 1 237 0 21 0 214 0 70] 
#[0 1 241 0 12] 
#[0 1 245 0 5] 
#[0 0 182 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 21 0 23 0 24 0 25 0 27 0 70] 
#[1 1 249 0 3 1 253 0 8 2 1 0 56] 
#[1 2 5 0 2 2 9 0 3 2 13 0 43] 
#[1 2 9 0 3 2 17 0 8 2 13 0 43] 
#[1 2 21 0 2 2 9 0 3 2 13 0 43] 
#[1 2 25 0 2 2 9 0 3 2 13 0 43] 
#[1 2 29 0 2 2 9 0 3 2 13 0 43] 
#[1 0 129 0 1 0 133 0 20 0 137 0 27 1 9 0 28 0 145 0 29 0 149 0 30 0 153 0 31 0 157 0 32 2 33 0 46 0 173 0 49 0 177 0 50 0 177 0 51 0 177 0 52 0 177 0 53 0 177 0 54 0 177 0 59 0 177 0 60 0 177 0 61 0 177 0 62 0 177 0 63] 
#[0 2 37 0 27] 
#[1 0 129 0 1 0 133 0 20 0 137 0 27 1 9 0 28 0 145 0 29 0 149 0 30 0 153 0 31 0 157 0 32 2 41 0 46 0 173 0 49 0 177 0 50 0 177 0 51 0 177 0 52 0 177 0 53 0 177 0 54 0 177 0 59 0 177 0 60 0 177 0 61 0 177 0 62 0 177 0 63] 
#[1 0 129 0 1 0 133 0 20 0 137 0 27 1 9 0 28 0 145 0 29 0 149 0 30 0 153 0 31 0 157 0 32 2 45 0 46 0 173 0 49 0 177 0 50 0 177 0 51 0 177 0 52 0 177 0 53 0 177 0 54 0 177 0 59 0 177 0 60 0 177 0 61 0 177 0 62 0 177 0 63] 
#[0 2 49 0 5] 
#[0 2 61 0 16 0 19 0 65] 
#[1 0 129 0 1 1 17 0 6 0 133 0 20 0 137 0 27 1 9 0 28 0 145 0 29 0 149 0 30 0 153 0 31 0 157 0 32 2 65 0 46 0 173 0 49 0 177 0 50 0 177 0 51 0 177 0 52 0 177 0 53 0 177 0 54 2 65 0 55 2 65 0 58 0 177 0 59 0 177 0 60 0 177 0 61 0 177 0 62 0 177 0 63] 
#[0 0 218 0 3 0 8 0 22] 
#[0 0 222 0 3 0 8] 
#[0 0 226 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 21 0 23 0 24 0 25 0 27 0 70] 
#[1 0 129 0 1 0 133 0 20 0 137 0 27 1 9 0 28 0 145 0 29 0 149 0 30 0 153 0 31 0 157 0 32 2 69 0 46 0 173 0 49 0 177 0 50 0 177 0 51 0 177 0 52 0 177 0 53 0 177 0 54 0 177 0 59 0 177 0 60 0 177 0 61 0 177 0 62 0 177 0 63] 
#[0 0 230 0 2 0 3 0 8] 
#[0 0 234 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 21 0 23 0 24 0 25 0 27 0 70] 
#[0 0 238 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 21 0 23 0 24 0 25 0 27 0 70] 
#[0 0 242 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 21 0 23 0 24 0 25 0 27 0 70] 
#[1 0 246 0 4 0 226 0 6 0 226 0 7 0 226 0 9 0 226 0 25 0 226 0 27 0 246 0 70] 
#[0 0 250 0 70] 
#[1 2 73 0 21 0 254 0 70] 
#[0 1 2 0 70] 
#[0 1 6 0 70] 
#[0 2 77 0 16 0 19 0 65] 
#[0 1 10 0 70] 
#[0 1 14 0 70] 
#[0 1 18 0 70] 
#[0 1 22 0 3 0 8] 
#[0 1 26 0 2 0 3 0 8] 
#[1 0 129 0 1 0 133 0 20 0 137 0 27 1 9 0 28 0 145 0 29 0 149 0 30 0 153 0 31 0 157 0 32 2 81 0 46 0 173 0 49 0 177 0 50 0 177 0 51 0 177 0 52 0 177 0 53 0 177 0 54 0 177 0 59 0 177 0 60 0 177 0 61 0 177 0 62 0 177 0 63] 
#[0 1 30 0 70] 
#[0 1 34 0 70]
	).
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForArrayElements1: nodes [
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
	result := LzInfixOpNode new.
	result addNode: (nodes at: 1) to: result args.
	result opName: (nodes at: 2).
	result addNode: (nodes at: 3) to: result args.
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
LzParser2 >> reduceActionForTopLevelAxiom1: nodes [
	| result |
	result := LzTopLevelEqualityAxiomNode new.
	result addNodes: ((nodes at: 1) at: 1) to: result vars.
	result addTokens: ((nodes at: 1) at: 2) to: result commas.
	result left: (nodes at: 2).
	result equals: (nodes at: 3).
	result right: (nodes at: 4).
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
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelRule3: nodes [
	| result |
	result := LzTopLevelFunctionRuleNode new.
	result addNodes: ((nodes at: 1) at: 1) to: result vars.
	result addTokens: ((nodes at: 1) at: 2) to: result commas.
	result pattern: (nodes at: 2).
	result arrow: (nodes at: 3).
	result code: (nodes at: 4).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelRule4: nodes [
	| result |
	result := LzTopLevelFunctionRuleNode new.
	result addNodes: ((nodes at: 1) at: 1) to: result vars.
	result addTokens: ((nodes at: 1) at: 2) to: result commas.
	result pattern: (nodes at: 2).
	result arrow: (nodes at: 3).
	result code: (nodes at: 4).
	result condition: (nodes at: 6).
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
	result code: (nodes at: 4).
	result _class: (nodes at: 6).
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
	result code: (nodes at: 4).
	result _class: (nodes at: 6).
	result condition: (nodes at: 8).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelSort1: nodes [
	| result |
	result := LzTopLevelSortNode new.
	result addNodes: ((nodes at: 1) at: 1) to: result vars.
	result addTokens: ((nodes at: 1) at: 2) to: result commas.
	result op: (nodes at: 2).
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
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelSpecialTerms1: nodes [
	| result |
	result := LzTopLevelSpecialTermsNode new.
	result addToken: (nodes at: 1) to: result specialTerms.
	result addTokens: ((nodes at: 2) at: 1) to: result commas.
	result addTokens: ((nodes at: 2) at: 2) to: result specialTerms.
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelTerm1: nodes [
	| result |
	result := LzTopLevelTermNode new.
	result addNodes: ((nodes at: 1) at: 1) to: result vars.
	result addTokens: ((nodes at: 1) at: 2) to: result commas.
	result term: (nodes at: 2).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelUseContext1: nodes [
	| result |
	result := LzTopLevelUseContextNode new.
	result pageName: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelUseContext2: nodes [
	| result |
	result := LzTopLevelUseContextNode new.
	result pageName: (nodes at: 3).
	result sortFlag: (nodes at: 7).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelUseContext3: nodes [
	| result |
	result := LzTopLevelUseContextNode new.
	result pageName: (nodes at: 2).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelUseContext4: nodes [
	| result |
	result := LzTopLevelUseContextNode new.
	result pageName: (nodes at: 2).
	result sortFlag: (nodes at: 6).
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
