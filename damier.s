.data

damier:				.space 50
newline:			.asciiz "\n"										#Le retour a la ligne
deplaceImpO:	.asciiz "Deplacement impossible: case occupe\n"
deplaceImpH:	.asciiz "Deplacement impossible: coordonnees hors jeu\n"
caseNoire: 		.asciiz "La case est noire\n"
caseBlanche:	.asciiz "La case est blanche\n"
caseLibre: 		.asciiz "La case est libre\n"
caseOccupeN:	.asciiz "La case est occupe par un pion noir\n"
caseOccupeB:	.asciiz "La case est occupe par un pion blanc\n"

#Chaine a compare a l'entree de l'utilisateur pour savoir quel commande effectue

occup:				.asciiz "occuper"
couleur:			.asciiz	"couleur"
deplace:			.asciiz "deplacement"
quit:					.asciiz "quit"

.text
.globl __start

		__start:

			#initialisation du damier
			jal init_damier

			#Debut boucle saisie
			#on sort de la boucle lorsque l'utilisateur rentre la commande "quit"



			j		Exit	# saut a la fin du programme

			#fonction du jeu------------------------------------------------

			init_damier:
					addi $sp $sp 4		#On augment la pile pour contenir l'adresse de retour de la fonction
					sw $31 0($sp)			#On met l'adresse de retour de la fonction dans la pile
					la $10 damier			#On charge l'adresse damier dans $10 
					li $8 20					#Intervalle superieur pour la boucle forInit
					li $9 0						#Intervalle inferieur pour la boucle forInit
					li $11 1					#La valeur que va prendre les element du damier entreintervalle sup et inf 
					jal forInit				#la boucle qui va mettre les 20 premiere case avec des pionsnoir (1)
					li $8 31					#Idem
					li $9 20 
					li $11 0
					jal forInit				#La boucle qui va mettre les case entre entre les deux joueur a vide (0)
					li $8 50					#Idem
					li $9 31 
					li $11 2
					jal forInit				#La boucle qui va mettre les 20 derniere case avec des pions blanc (2)
					lw $31 0($sp)			#On restore le retour de la fonction

					j $31							#On retourne dans le main

			forInit:
					bne $8 $9	suivantInit	#Tant que $8!=$9 on lance les operations
					j $31

			suivantInit:
					sb $11 0($10)			#On charge le byte contenant (0,1 ou 2) dans la bonne case du damier
					addi $10 $10 1		#On prend l'adresse du byte suivant dans damier
					addi $9 1					#On incremente l'iterateur
					j forInit					#on boucle sur le test
			
			
			ligne:
					addi $sp $sp 4		#On augment la pile pour contenir l'adresse de retour de la fonction
					sw $31 0($sp)			#On met l'adresse de retour de la fonction dans la pile
					li $10 5					#Valeur du diviseur
					div $4 $10				#division de l'argument $4 avec 5 ($10)
					mflo $2						#On met le resultat de $4/$10 dans la valeur de retour
					mfhi $11					#On met le resultat de $4 mod $10 dans $11
					beq $11 $0 ligne2
					addi $2 $2 1			#On a
					lw $31 0($sp)			#On restore le retour de la fonction
					j $31

			ligne2:
					lw $31 0($sp)			#On restore le retour de la fonction
					j $31

			colonne:
					

			get_case:

			move_pion:
			
			couleur:

			occuper:

			affichage:
					addi $sp $sp 4		#On augment la pile pour contenir l'adresse de retour de la fonction
					sw $31 0($sp)			#On met l'adresse de retour de la fonction dans la pile
					la $10 damier			#On charge l'adresse damier dans $10 
					li $8 50					#Intervalle superieur pour la boucle forAffi
					li $9 0						#Intervalle inferieur pour la boucle forAffi
					li $12 0					#Valeur d'une case vide
					li $13 1					#Valeur d'un pion noir
					li $14 2					#Valeur d'un pion blanc
					li $15 5
					jal forAffi
					lw $31 0($sp)			#On restore le retour de la fonction
					j $31							#On retourne dans le main
			
			forAffi:
					div $9 $
					bne $8 $9	suivantAffi	#Tant que $8!=$9 on lance les operations
					j $31
			
			suivantAffi:
					lb $11 0($10)
					addi $10 $10 1
					beq $11 $12 affiVide 
					beq	$11 $13 affiNoir
					beq	$11 $14 affiBlanc
					j forAffi

			deplacement:
			
			#fonction du module de control-----------------------------------

			user_deplacement:

			user_quit:

			user_couleur:

			user_occuper:

			#fonction d'affichage, et sous-routines--------------------------

			afficher_string:
					addi $sp $sp 8		#On augment la pile pour contenir l'adresse de retour de la fonction
					sw $31 0($sp)			#On met l'adresse de retour de la fonction dans la pile
					lw $4 ($5)				#On prend l'adresse contenu dan $5 passe en argument 
					li $2 4						#on met le bon numero d'appel system 
					syscall						#On affiche la chaine dont l'adress est passe en argument
					lw $31 0($sp)			#On restore le retour de la fonction
					j $31							#On retourne dans le main
			
			afficher_int:

			saisie:
		
			#etc ...

Exit:							# fin du programme
