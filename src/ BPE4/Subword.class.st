Class {
	#name : 'Subword',
	#superclass : 'Object',
	#instVars : [
		'subword',
		'occurence'
	],
	#category : ' BPE4',
	#package : ' BPE4'
}

{ #category : 'as yet unclassified' }
Subword class >> subword: aString occurence: anInteger [
	|aSubword|
	aSubword := Subword new.
	aSubword subword: aString.
	aSubword occurence: anInteger.
	^aSubword. 
]

{ #category : 'build' }
Subword >> buildPairFrom: aNode in: aBPE [
"création d'une paire à partir d'un noeud et ajout du paire créée dans l'objet aBPE"
	aNode ifNil: [ ^ self ].
	aNode value buildPairWith: aNode in: aBPE .	
	
]

{ #category : 'build' }
Subword >> buildPairWith: aNode in: aBPE [
"Construit et enregistre dans le BPE la paire formée à partir du nœud donné, ainsi que sa position dans la liste chaînée."
	aBPE collectPairFrom: aNode .
	
]

{ #category : 'initialize' }
Subword >> initialize [ 
	super initialize .
	subword := String new.
	occurence := SmallInteger 
]

{ #category : 'accessing' }
Subword >> occurence [
	^occurence 
]

{ #category : 'accessing' }
Subword >> occurence: anInteger [
	occurence := anInteger 
]

{ #category : 'accessing' }
Subword >> subword [
	^subword 
]

{ #category : 'accessing' }
Subword >> subword: aString [
	subword := aString 
]

{ #category : 'update' }
Subword >> updatePairAt: aNode in: aBPE [
"Met à jour les informations de la paire correspondant au nœud donné dans l'objet aBPE."
	aBPE updatePairFrom: aNode 
]

{ #category : 'update' }
Subword >> updatePairFromNode: aNode in: aBPE [
"Met à jour la paire correspondant au nœud donné dans l'objet aBPE."
	aNode ifNil: [ ^self ].
	aNode value updatePairAt: aNode in: aBPE .
]
