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
coul:			.asciiz	"couleur"
deplace:			.asciiz "deplacement"
quit:					.asciiz "quit"

.text
.globl __start

		__start:

			#initialisation du damier
			jal init_damier
			li $8 7
			li $9 5
			addu $sp $sp -8		#allocation de l'espace nécessaire sur la pile pour les arguments de la fontciton getCase
			sw $8 ($sp)			
			sw $9 4($sp)
			jal couleur			#appel de la fonction couleur
			lw $8 ($sp)
			lw $9 4($sp)
			addu $sp $sp 8		#désallocation espace sur la pile
			li $8 32
			addu $sp $sp -4		#allocation de l'espace nécessaire sur la pile pour les arguments de la fontciton getCase
			sw $8 ($sp)			
			jal ligne			#appel de la fonction ligne
			lw $8 ($sp)
			addu $sp $sp 4		#désallocation espace sur la pile
				
			#Debut boucle saisie
			#on sort de la boucle lorsque l'utilisateur rentre la commande "quit"



			j		Exit	# saut a la fin du programme

			#fonction du jeu------------------------------------------------

			#FONCTION init_damier: initialise un damier en mettant les pions blancs à la valeur 1, 0 quand la case est inoccupée et 2 quand il s'agit d'un pion noir
			init_damier:
					addi $sp $sp -4		#On augment la pile pour contenir l'adresse de retour de la fonction
					sw $31 0($sp)			#On met l'adresse de retour de la fonction dans la pile
					la $10 damier			#On charge l'adresse damier dans $10 
					li $8 20					#Intervalle superieur pour la boucle forInit
					li $9 0						#Intervalle inferieur pour la boucle forInit
					li $11 1					#La valeur que va prendre les element du damier entreintervalle sup et inf 
					jal forInit1				#la boucle qui va mettre les 20 premiere case avec des pionsnoir (1)
			init1:
					li $8 30					#Idem
					li $9 20 
					li $11 0
					jal forInit2				#La boucle qui va mettre les case entre entre les deux joueur a vide (0)
			init2:
					li $8 50					#Idem
					li $9 30 
					li $11 2
					jal forInit3				#La boucle qui va mettre les 20 derniere case avec des pions blanc (2)
			init3:
					lw $31 0($sp)			#On restore le retour de la fonction
					addi $sp $sp 4		#on désalloue l'espace sur la pile
					jr $31							#On retourne dans le main

			forInit1:
					bne $8 $9	suivantInit1	#Tant que $8!=$9 on lance les operations
					j init1
			suivantInit1:
					sb $11 0($10)			#On charge le byte contenant (0,1 ou 2) dans la bonne case du damier
					addi $10 $10 1		#On prend l'adresse du byte suivant dans damier
					addi $9 $9 1					#On incremente l'iterateur
					j forInit1				#on boucle sur le test

			forInit2:
					bne $8 $9	suivantInit2	#Tant que $8!=$9 on lance les operations
					j init2
			suivantInit2:
					sb $11 0($10)			#On charge le byte contenant (0,1 ou 2) dans la bonne case du damier
					addi $10 $10 1		#On prend l'adresse du byte suivant dans damier
					addi $9 $9 1					#On incremente l'iterateur
					j forInit2				#on boucle sur le test

			forInit3:
					bne $8 $9	suivantInit3	#Tant que $8!=$9 on lance les operations
					j init3			
			suivantInit3:
					sb $11 0($10)			#On charge le byte contenant (0,1 ou 2) dans la bonne case du damier
					addi $10 $10 1		#On prend l'adresse du byte suivant dans damier
					addi $9 $9 1					#On incremente l'iterateur
					j forInit3				#on boucle sur le test


			#FONCTION ligne:
			ligne:
					addi $sp $sp -4		#On augment la pile pour contenir l'adresse de retour de la fonction
					sw $31 0($sp)			#On met l'adresse de retour de la fonction dans la pile
					li $10 5					#Valeur du diviseur
					div $4 $10				#division de l'argument $4 avec 5 ($10) //ya quoi dans $4!!!!!!!!!!!!!!!!!!!!!!!
					mflo $2						#On met le resultat de $4/$10 dans la valeur de retour
					mfhi $11					#On met le resultat de $4 mod $10 dans $11
					beq $11 $0 ligne2
					addi $2 $2 1			#On a
					lw $31 0($sp)			#On restore le retour de la fonction
					addi $sp $sp 4		#on désalloue l'espace alloué sur le pile
					jr $31

			ligne2:
					lw $31 0($sp)			#On restore le retour de la fonction
					addi $sp $sp 4		#on désalloue l'espace alloué sur le pile
					jr $31

			colonne:
					addu $sp $sp -4 	#on décrémente la pile pour mettre l'adresse de retour
					sw $31 ($sp)			#on stocke l'adresse de retour
					li $10 5					#Valeur du diviseur
					div $4 $10				#division de l'argument $4 avec 5 ($10)
					mflo $2						#On met le resultat de $4/$10 dans la valeur de retour
					mfhi $11					#On met le resultat de $4 mod $10 dans $11
					li $9 2						#On met 2 dans $9
					div $11 $9					#on divide le reste de la division par 5 ensuite par deux
					mflo $2						#on met le quotient dans $2
					mfhi $12					#on met le reste dans $12
					beq $12 $0 colonne2		#si $12=0 on va fait ce qui suit sinon on se branche sur colonne 2
					mult $11 $9			#on multiplie $11 par 2
					mflo $11			#on met le résultat de la multiplication dans $11
					addu $11 $11 1		#on y ajoute 1
					lw $31 ($sp)			#on met l'adresse de retour dans $31
					addu $sp $sp 4		#on désallout l'espace sur la pile
					jr $31						#on retourne dans le corps du programme
			colonne2:
					mult $11 $9			#on multiplie $11 par 2
					mflo $11			#on met le resultat de la multiplication dans $11
					lw $31 ($sp)			#on met l'adresse de retour dans $31
					addu $sp $sp 4		#on désalloue l'espace sur la pile
					jr $31						#on retourne dans le corps du programme

					#Si la case est blanche on revoie -1, sinon on renvoie la	valeur qui se trouve à l'adresse de la case à l'adresse de la case
					#on retourne le resultat dans $2
					#fonction qui prend en argument un i (ligne) et un j (colonne)
			get_case:
					addu $sp $sp -4 	#on décrémente la pile pour mettre l'adresse de retour
					sw $31 ($sp)			#on stocke l'adresse de retour
					lw $8 4($sp)			#on charge l'adresse du premier agument de la	pile
					lw $9 8($sp)			#on charge l'adresse du deuxième agument de la	pile
					addu $10 $8 $9		#on additionne j ($8) et i($9)
					li $11 2					#on charge 2 dans $11
					div $10 $11				#on divise i+j par 2
					mfhi $11					#on prend le reste
					beq $11 $0 blanc 
					li $10 5					#on met 5 dans $10
					mult $10 $9				#on multiplie i par 5
					mflo $10					#on récupère le résultat dans $10
					addu $10 $8 $10		#on additionne avec j
					la $11 damier			#on charge l'adresse du damier dans le registre $11
					add $11 $11 $10		#on ajoute à l'adresse le décalage pour avoir	l'adresse de la case
					lb $2 ($11)				#on stocke la valeur de retour de la fonction	dans $2
					lw $31 ($sp)			#on met l'adresse de retour dans $31
					addu $sp $sp 4		#on désalloue l'espace sur la pile
					jr $31						#on retourne dans le corps du programme
			blanc:
					li $2 -1
					lw $31 ($sp)			#on met l'adresse de retour dans $31
					addu $sp $sp 4		#on désalloue l'espace sur la pile
					jr $31						#on retourne dans le corps du programme

			move_pion:
			
			#argument $4 $5 (x,y)
			couleur:
					addi $sp $sp -4		#On augment la pile pour contenir l'adresse de retour de la fonction
					sw $31 0($sp)			#On met l'adresse de retour de la fonction dans la pile
					lw $8 4($sp)			#on récupere les arguments sur la pile
					lw $9 8($sp)
					addi $sp $sp -8		#on alloue l'espace necessaire pour placer les arguments sur la pile
					sw $8 0($sp)			#on met les arguments sur la pile
					sw $9 4($sp)
					jal get_case			#Appel à la fonction get_case
					addi $sp $sp 8 		#on libère l'espace sur la pile
					la $8 ($2)			#On met le résultat de la fonction dans $8
					blt $8 $0 couleurBlanc 	#branchement si $2 < 0
					j couleurNoire

			couleurBlanc:	
					li $2 4				#préparation à l'affichage de la réponse 
					la $4 caseBlanche
					syscall 			#appel systeme
					lw $31 0($sp)			#On restore le retour de la fonction
					addi $sp $sp -4		#On désalloue l'espace de l'adresse de retour sur la pile
					jr $31

			couleurNoire:
					li $2 4				#préparation à l'affichage de la réponse 
					la $4 caseNoire
					syscall 			#appel systeme
					lw $31 0($sp)			#On restore le retour de la fonction
					addi $sp $sp -4		#On désalloue l'espace de l'adresse de retour sur la pile
					jr $31

			occuper:

			affichage:
					addi $sp $sp -4		#On augment la pile pour contenir l'adresse de retour de la fonction
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
					addi $sp $sp 4
					jr $31							#On retourne dans le main
			
			forAffi:
					#div $9 $
					bne $8 $9	suivantAffi	#Tant que $8!=$9 on lance les operations
					lw $31 0($sp)			#On restore le retour de la fonction
					addi $sp $sp 4
					jr $31
			
			suivantAffi:
					lb $11 0($10)
					addi $10 $10 1
					beq $11 $12 affiVide 
					beq	$11 $13 affiNoir
					beq	$11 $14 affiBlanc
					j forAffi

			affiVide:
			affiNoir:
			affiBlanc:

			deplacement:
			
			#fonction du module de control-----------------------------------

			user_deplacement:

			user_quit:

			user_couleur:

			user_occuper:

			#fonction d'affichage, et sous-routines--------------------------

			afficher_string:
					addi $sp $sp -8		#On augment la pile pour contenir l'adresse de retour de la fonction
					sw $31 0($sp)			#On met l'adresse de retour de la fonction dans la pile
					lw $4 ($5)				#On prend l'adresse contenu dan $5 passe en argument 
					li $2 4						#on met le bon numero d'appel system 
					syscall						#On affiche la chaine dont l'adress est passe en argument
					lw $31 0($sp)			#On restore le retour de la fonction
					addi $sp $sp 8		#On augment la pile pour contenir l'adresse de retour de la fonction
					jr $31							#On retourne dans le main
			
			afficher_int:

			saisie:
		
			#etc ...

Exit:							# fin du programme
