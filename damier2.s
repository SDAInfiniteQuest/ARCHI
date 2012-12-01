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

PionBlanc:		.asciiz	"[0]"
PionNoir:			.asciiz	"[1]"
Noir:					.asciiz	"[X]"
Blanc:				.asciiz	"[ ]"
#Chaine a compare a l'entree de l'utilisateur pour savoir quel commande effectue

occup:				.asciiz "occuper"
coul:					.asciiz	"couleur"
deplace:			.asciiz "deplacement"
quit:					.asciiz "quit"

read: .space 15
choix:.asciiz  "Que vous vous faire ?\n"
choix1:.asciiz "Pour quitter,entre quit\n"
choix2:.asciiz "Pour avoir la couleur d'une case, entre couleur\n"
choix3:.asciiz "Pour savoir par quoi est occuper une case,entre occuper\n"
choix4:.asciiz "Pour deplacer un pion, entre deplacement\n"

.text
.globl __start

		__start:

					#initialisation du damier
			jal init_damier
			
			li $8 0
			li $9 1
			addi $sp $sp -12 		#allocation de l'espace sur la pile pour les arguments
			sw $31 0($sp)
			sw $9 4($sp)
			sw $8 8($sp)
			jal couleur			#appel de la fonction couleur
			lw $31 0($sp)
			lw $9 4($sp)
			lw $8 8($sp)
			addi $sp $sp 12
			
			li $8 8
			addu $sp $sp -8
			sw $31 ($sp)
			sw $8 4($sp)
			jal ligne 		#appel de la fonction ligne
			sw $31 ($sp)			
			lw $8 4($sp)
			addu $sp $sp 8

			li $8 22
			addu $sp $sp -4
			sw $8 ($sp) 
			jal colonne
			lw $8 ($sp)
			addu $sp $sp 4

			la $4 ($2)
			li $2 1
			syscall

			move $4 $2
			li $2 1
			syscall
			
			jal affichage
			
			#Debut boucle saisie
			#on sort de la boucle lorsque l'utilisateur rentre la commande "quit"



			j		Exit	# saut a la fin du programme

			#fonction du jeu------------------------------------------------

			#FONCTION init_damier: initialise un damier en mettant les pions blancs à la valeur 1, 0 quand la case est inoccupée et 2 quand il s'agit d'un pion noir

			init_damier:
					addi $sp $sp 4		#On augment la pile pour contenir l'adresse de retour de la fonction
					sw $31 0($sp)			#On met l'adresse de retour de la fonction dans la pile
					la $10 damier			#On charge l'adresse damier dans $10 
					li $8 20					#Intervalle superieur pour la boucle forInit
					li $9 0						#Intervalle inferieur pour la boucle forInit
					li $11 1					#La valeur que va prendre les element du damier entreintervalle sup et inf 
					jal forInit				#la boucle qui va mettre les 20 premiere case avec des pionsnoir (1)
					li $8 30					#Idem
					li $9 20
					li $11 0
					jal forInit				#La boucle qui va mettre les case entre entre les deux joueur a vide (0)
					li $8 50					#Idem
					li $9 30 
					li $11 2
					jal forInit				#La boucle qui va mettre les 20 derniere case avec des pions blanc (2)
					lw $31 0($sp)			#On restore le retour de la fonction
					addi $sp $sp 4		#on désalloue l'espace sur la pile
					jr $31							#On retourne dans le main

			forInit:
					bne $8 $9	suivantInit	#Tant que $8!=$9 on lance les operations
					jr $31

			suivantInit:
					sb $11 0($10)			#On charge le byte contenant (0,1 ou 2) dans la bonne case du damier
					addi $10 $10 1		#On prend l'adresse du byte suivant dans damier
					addi $9 $9 1					#On incremente l'iterateur
					j forInit					#on boucle sur le test
			

			#FONCTION ligne:
			ligne:
					lw $4 4($sp)			#On charge les argument depuis la pile


					addi $sp $sp -12		#On augment la pile pour contenir l'adresse de retour de la fonction
					sw $31 0($sp)			#On met l'adresse de retour de la fonction dans la pile
					sw $10 4($sp)
					sw $11 8($sp)
					li $10 5					#Valeur du diviseur
					div $4 $10				#division de l'argument $4 avec 5 ($10)
					mflo $2						#On met le resultat de $4/$10 dans la valeur de retour
					mfhi $11					#On met le resultat de $4 mod $10 dans $11
					beq $11 $0 ligne2
					lw $31 0($sp)			#On restore le retour de la fonction
					lw $10 4($sp)
					lw $11 8($sp)
					addi $sp $sp 12		#on désalloue l'espace alloué sur le pile
					addi $2 $2 1
					jr $31

			ligne2:
					lw $31 0($sp)			#On restore le retour de la fonction
					addi $sp $sp 4		#on désalloue l'espace alloué sur le pile
					jr $31

			#FONCTION colonne: prend une case et renvoie une colonne
			colonne:
					addu $sp $sp -4 	#on décrémente la pile pour mettre l'adresse de retour
					sw $31 ($sp)			#on stocke l'adresse de retour
					lw $10 4($sp)			#on met l'argument dans $10
					li $8 5				# $8←5
					li $9 10			# $9←10
					div $10 $9			
					mfhi $12			# $12←arg%10
					li $11 2			# $11←2
					ble $8 $12 colonne2		# si 5<arg%10 on branche sur colonne2
					mul $2 $12 $11		
					addi $2 $2 1					
					addu $sp $sp 4		#on désalloue l'espace sur la pile
					jr $31						#on retourne dans le corps du programme
			colonne2:
					addu $12 $12 -5		# $12←arg%10-5
					mul $2 $12 $11
					lw $31 ($sp)			#on met l'adresse de retour dans $31
					addu $sp $sp 4		#on désalloue l'espace sur la pile
					jr $31						#on retourne dans le corps du programme

					#Si la case est blanche on revoie -1, sinon on renvoie la	valeur qui se trouve à l'adresse de la case à l'adresse de la case
					#on retourne le resultat dans $2
					#fonction qui prend en argument un i (ligne) et un j (colonne)
			get_case:	
					lw $9 4($sp)			#on charge l'adresse du premier agument de la	pile
					lw $8 8($sp)			#on charge l'adresse du deuxième agument de la	pile
					addu $sp $sp -20 	#on décrémente la pile pour mettre l'adresse de retour,et le contexte de la fonction appellante
					sw $31 ($sp)			#on stocke l'adresse de retour
					sw $9 4($sp)
					sw $8 8($sp)
					sw $10 12($sp)		#On sauvegarde les registre que l'on va utiliser
					sw $11 16($sp)		#idem
					addu $10 $8 $9		#on additionne j ($8) et i($9)
					li $11 2					#on charge 2 dans $11
					div $10 $11				#on divise i+j par 2
					mfhi $11					#on prend le reste
					beq $11 $0 blanc 
					li $10 5					#on met 5 dans $10
					mul $10 $10 $9				#on multiplie i par 5
					addu $10 $8 $10		#on additionne avec j
					la $11 damier			#on charge l'adresse du damier dans le registre $11
					add $11 $11 $10		#on ajoute à l'adresse le décalage pour avoir	l'adresse de la case
					move $2 $11				#on stocke la valeur de retour de la fonction	dans $2
					lw $31 ($sp)			#on met l'adresse de retour dans $31
					lw $9 4($sp)			# On restaure les registre utiliser
					lw $8 8($sp)			#idem
					lw $10 12($sp)		#idem
					lw $11 16($sp)		#idem
					addu $sp $sp 20		#on désalloue l'espace sur la pile
					jr $31						#on retourne dans le corps du programme
			blanc:
					li $2 -1
					lw $31 ($sp)			#on met l'adresse de retour dans $31
					lw $8 4($sp)
					lw $9 8($sp)
					lw $10 12($sp)
					lw $11 16($sp)
					addu $sp $sp 20		#on désalloue l'espace sur la pile
					jr $31						#on retourne dans le corps du programme
			

			#FONCTION: prend deux couples a=(x,y) et b=(z,t), a=adresse de la case de départ (doit contenir un pion), b=adresse de la case d'arrivée
			move_pion_possible:
					addi $sp $sp -4		#On augment la pile pour contenir l'adresse de retour de la fonction
					sw $31 0($sp)		#On met l'adresse de retour de la fonction dans la pile

					lw $8 4($sp)			# $8 ← i
					lw $9 8($sp)			# $9 ← j
					lw $10 12($sp)		# $10 ← x
					lw $12 16($sp)		# $11 ← y

					addu $sp $sp -8		#appel get_case avec i j
					sw $8 0($sp)
					sw $9 4($sp)
					jal get_case
					lw $8 0($sp)
					lw $9 4($sp)
					addu $sp $sp 8
					la $13 ($2)			# $13 ← get_case(i,j)

					addu $sp $sp -8		#appel get_case avec x y
					sw $10 0($sp)
					sw $11 4($sp)
					jal get_case
					lw $10 0($sp)
					lw $11 4($sp)
					addu $sp $sp 8
					la $14 ($2)			# $14 ← get_case(x,y)

					lb $15 ($13)			#on charge la valeur contenue dans la case départ
					lb $16 ($14)			#on charge la valeur contenue dans la case arrivée

					#CONDITION DE POURSUITE
					blt $13 $0 fin			#on saute à la fin de la fonction si la case est blanche
					blt $14 $0 fin			#on saute à la fin de la fonction si la case est blanche	
					beq $15 $0 fin		#on saute à la finh de la fonction si la case est inoccupée				

					li $21 1			#on charge 1 dans  $21
					li $22 2			#on charge 2 dans  $22

					beq $15 $21 cas_pion_blanc # on détermine la couleur du pion
					j cas_pion_noir

			cas_pion_blanc:
					j cas_gauche_blanc
			
			cas_gauche_blanc:
					addi $17 $8 1			# $17 ← i+1
					addi $18 $9 -1		# $17 ← j-1

					addu $sp $sp -8		# appel get_case avec i+1 j-1
					sw $17 0($sp)
					sw $18 4($sp)
					jal get_case
					lw $17 0($sp)
					lw $18 4($sp)
					addu $sp $sp 8
					lb $17 ($2)			# on charge la valeur à l'adresse get_case(i+1,j-1)

					beq $17 $21 cas_droite_blanc
					beq $17 $22 prendre_gauche_blanc

					lw $31 0($sp)			#On restore le retour de la fonction
					addi $sp $sp -4		#On désalloue l'espace de l'adresse de retour sur la pile
					jr $31

			prendre_gauche_blanc:

			cas_droite_blanc:
					addi $17 $8 1			# $17 ← i+1
					addi $18 $9 1			# $17 ← j+1

					addu $sp $sp -8		# appel get_case avec i+1 j+1
					sw $17 0($sp)
					sw $18 4($sp)
					jal get_case
					lw $17 0($sp)
					lw $18 4($sp)
					addu $sp $sp 8
					lb $17 ($2)			# on charge la valeur à l'adresse get_case(i+1,j+1)

					beq $17 $21 fin		# le pion est bloqué aucun mouvement n'est possible
					beq $17 $22 prendre_droite_blanc

					lw $31 0($sp)			#On restore le retour de la fonction
					addi $sp $sp -4		#On désalloue l'espace de l'adresse de retour sur la pile
					jr $31

			prendre_droite_blanc:

			cas_pion_noir:
					j cas_gauche_noir

			cas_gauche_noir:
					addi $17 $8 -1		# $17 ← i-1
					addi $18 $9 -1		# $17 ← j-1

					addu $sp $sp -8		# appel get_case avec i+1 j-1
					sw $17 0($sp)
					sw $18 4($sp)
					jal get_case
					lw $17 0($sp)
					lw $18 4($sp)
					addu $sp $sp 8
					lb $17 ($2)			# on charge la valeur à l'adresse get_case(i+1,j-1)

					beq $17 $22 cas_droite_noir

					lw $31 0($sp)			#On restore le retour de la fonction
					addi $sp $sp -4		#On désalloue l'espace de l'adresse de retour sur la pile
					jr $31

			cas_droite_noir:
					addi $17 $8 1			# $17 ← i-1
					addi $18 $9 1			# $17 ← j+1

					addu $sp $sp -8		# appel get_case avec i-1 j+1
					sw $17 0($sp)
					sw $18 4($sp)
					jal get_case
					lw $17 0($sp)
					lw $18 4($sp)
					addu $sp $sp 8
					lb $17 ($2)			# on charge la valeur à l'adresse get_case(i-1,j+1)

					beq $17 $22 fin		# le pion est bloqué aucun mouvement n'est possible

					lw $31 0($sp)			#On restore le retour de la fonction
					addi $sp $sp -4		#On désalloue l'espace de l'adresse de retour sur la pile
					jr $31
			fin:
					lw $31 0($sp)			#On restore le retour de la fonction
					addi $sp $sp -4		#On désalloue l'espace de l'adresse de retour sur la pile
					jr $31

			move_pion:
			
			#argument $4 $5 (x,y)
			couleur:
					addi $sp $sp -4		#On augment la pile pour contenir l'adresse de retour de la fonction
					sw $31 0($sp)			#On met l'adresse de retour de la fonction dans la pile
					lw $8 8($sp)
					lw $9 12($sp)
					addi $sp $sp -8
					sw $8 4($sp)
					sw $9 0($sp)
					jal get_case			#Appel à la fonction get_case
					lw $8 4($sp)
					lw $9 0($sp)
					addi $sp $sp 8
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
#Pas d'argument 
#pas de retour

			affichage:
					addi $sp $sp -32	#On augment la pile pour contenir l'adresse de retour de la fonction et le contexte de la fonction appellante
					sw $31 0($sp)			#On met l'adresse de retour de la fonction dans la pile
					sw $8 4($sp)			#On sauvegarde les registre que l'on va utiliser
					sw $9 8($sp)			#idem
					sw $10 12($sp)		#idem
					sw $11 16($sp)		#idem
					sw $12 20($sp)		#idem
					sw $13 24($sp)		#idem
					sw $14 28($sp)		#idem
					
					la $10 damier			#On charge l'adresse damier dans $10 
					li $8 0						#Iterateur pour les ligne
					li $9 0						#Iterateur pour les colonne
					li $15 10					#Nombre de case par ligne et colonne
					li $12 -1					#Valeur d'une case vide
					li $13 1					#Valeur d'un pion blanc
					li $14 2					#Valeur d'un pion noir
					
					addi $sp $sp -4   #on sauvegarde l'adresse de retour
					sw $31 0($sp)
					jal forAffi				#On appelle la fonction d'affichage
					sw $31 0($sp)
					addi $sp $sp 4

					lw $31 0($sp)			#On restore le retour de la fonction
					lw $8 4($sp)			#On restaure les registre qu'on a utiliser
					lw $9 8($sp)			#idem
					lw $10 12($sp)		#idem
					lw $11 16($sp)		#idem
					lw $12 20($sp)		#idem
					lw $13 24($sp)		#idem
					lw $14 28($sp)		#idem
					addi $sp $sp 32		#On decremente la pile 
					jr $31							#On retourne dans le main
			
			forAffi:
					bne $8 $15 parcColonne	#for numero de ligne != numero ligne max -> afficher colonne par colonne
					jr $31
			
			parcColonne:
					bne $9 $15 suivantAffi	#for numero de colonne  != numero colonne max -> afficher l'element
					li $9 0								#Si on arrive a la dernier colonne on remet le compteur a 0 pour la (possible ) ligne  suivante
					addi $8 $8 1					#incremente l'indice d ligne ,on veut passer a la suivante
					
					addiu $sp $sp -8
					sw $31 0($sp)
					la $5 newline
					sw $5 4($sp)
					jal afficher_string 	#on veut afficher un retour a la ligne,apelle de la fonction d'affichage d'un string
					lw $31 0($sp)
					lw $5 4($sp)
					addiu $sp $sp 8

					j forAffi							#On repart au teste sur les lignes

			suivantAffi:
					addiu $sp $sp -12
					sw $31 0($sp)					
					sw $8 4($sp)
					sw $9 8($sp)
					jal get_case				#Appelle a get_case avec comme argument les iterateurs sur les ligne et colonne ($8 $9) 
					lw $31 0($sp)					
					lw $8 4($sp)
					lw $9 8($sp)
					addiu $sp $sp 12
					
					addi $9 $9 1 					#incremente le compteur sur les colonne,onveut la colonne suivante
					beq $2 $12 affiBlanc 	#Si la valeur de la case obtenu est -1 on affiche une case blanche
					lb $11 0($2)					#Sinon on charge la valeur contenu dans l'adresse renvoyer par get_case
					beq $11 $13 affiPionBlanc #si valeur = pion blanc on affiche un pion blanc
					beq $11 $14 affiPionNoir	#ect ...
					beq $11 $0 affiNoir				#ect ...
					

			affiBlanc:
				addiu $sp $sp -8
				sw $31 0($sp)
				la $5 Blanc
				sw $5 4($sp)
				jal afficher_string  	#appelle a la fonction afficher_string pour afficher une case blanche
				lw $31 0($sp)
				lw $5 4($sp)
				addiu $sp $sp 8

				j parcColonne

			affiNoir:
				addiu $sp $sp -8
				sw $31 0($sp)
				la $5 Noir
				sw $5 4($sp)
				jal afficher_string		#appelle a la fonction afficher_string pour afficher une case noir
				lw $31 0($sp)
				lw $5 4($sp)
				addiu $sp $sp 8
				j parcColonne

			affiPionNoir:
				addiu $sp $sp -8
				sw $31 0($sp)
				la $5 PionNoir
				sw $5 4($sp)
				jal afficher_string		#appelle a la fonction afficher_string pour afficher un pion noir
				lw $31 0($sp)
				lw $5 4($sp)
				addiu $sp $sp 8
				j parcColonne

			affiPionBlanc:
				addiu $sp $sp -8
				sw $31 0($sp)
				la $5	PionBlanc
				sw $5 4($sp)
				jal afficher_string		#appelle a la fonction afficher_string pour afficher un pion blanc	
				lw $31 0($sp)
				lw $5 4($sp)
				addiu $sp $sp 8
				j parcColonne

			
			#fonction du module de control-----------------------------------

			user_deplacement:

			user_quit:
					j Exit

			user_couleur:

			user_occuper:

			#fonction d'affichage, et sous-routines--------------------------

			afficher_string:
					lw $4 4($sp)			#on charge l'argument depuis la pile		

					addi $sp $sp -8		#On augment la pile pour contenir l'adresse de retour de la fonction
					sw $31 0($sp)			#On met l'adresse de retour de la fonction dans la pile
					sw $4 4($sp) 
					li $2 4						#on met le bon numero d'appel system 
					syscall						#On affiche la chaine dont l'adress est passe en argument
					lw $31 0($sp)			#On restore le retour de la fonction
					lw $4 4($sp)			# on restaure l'argument
					addi $sp $sp 8		#On decremente la pile 
					jr $31						#On retourne dans la fonction appellante
			
#Pas de parametre 
#retour $2
			lectureString:
					addiu $sp $sp 8
					sw $31 0($sp)
					la $2, read 				# charge le pointeur read dans $4	
					ori $5, $0, 15 			# charge la longueur maximale dans $5
					ori $2, $0, 8 			# charge 8 (code de l’appel système) dans $2
					syscall 						# Exécute l’appel système
					lw $31 0($sp)
					jr $31

#argument $4 : l'adresse de la chaine a teste 
#retour $2 : le nombre de caractere dans la chaine 
			strlen:	
					lw $4 4($sp)

					addi $29 ,$29 ,-16#on augmente la taille de la pile 
					sw $31,0($29)			#On met l'adresse de retour de la fonction dans la pile	
					sw $15,4($29)			#sauvegarde des registre que la fonction va utiliser
					sw $18,8($29)			#idem
					sw $10,12($29)		#idem
					li $15,10					#code ascii correspondant au \n
					li $18,0					#nombre d'element de la chaine
					lb $10 0($4)			#on charge les lettres une a une dans $10
		
					addiu $sp $sp -4
					sw $31 0($sp)		
					jal whileStrlen
					lw $31 0($sp)
					addiu $sp $sp 4
		
					addi $18 $18 -1		#on enleve le compte du \n de la chaine saisie par 
					move $2 $18				#on renvoie le resultat dans le registre $2
		
					lw $31,0($29)			
					lw $15,4($29)			#on restaure les registre du contexte de al fonction appellante	
					lw $18,8($29)			#idem	
					lw $10,12($29)		#idem	
					addi $29,$29,16

					jr $31

			whileStrlen:	
					bne $15 $10 parc	#cas d'arret du while: si le dernier caractere lu est un \n (code ascii 10 dans le registre 15)
					jr $31						

			parc:
					addi $18 $18 1		#on incremente le nombre de caractere lu
					addi $4 $4 1			#on augmente l'adresse du debut de la cahine de 1 pour acceder aucaractere suivant
					lb $10 0($4)			#on charge le caractere courant dans le registre 10
					j whileStrlen
				
			compareString:
					lw $4 4($sp)
					lw $5 8($sp)		

					addi $29 ,$29 ,-20#on augmente la taille de la pile 
					sw $31,0($29)			#On met l'adresse de retour de la fonction dans la pile	
					sw $10,4($29)			#sauvegarde des registre que la fonction va utiliser
					sw $11,8($29)			#idem
					sw $15,12($29)		#idem
					sw $20,12($29)		#idem
					li $10 0					#on mettre les caractere de la chaine dont l'adresse est dans $4 dans ce registre pour le test			
					li $11 0					#on mettre les caractere de la chaine dont l'adresse est dans $5 dans ce registre pour le test
					li $15 0					#Incrementeur: nombre de tour de boucle (lettre egale une a une ) 		

					addi $29 ,$29 ,-8
					sw $31 0($sp)		
					sw $4,4($29)
					jal strlen				#taille de $4
					lw $4,4($29)
					lw $31 0($sp)
					addi $29 ,$29 ,8

					move $2 $20				#on met le resultat de Strlen dans $20

					addi $29 ,$29 ,-4
					sw $31 0($sp)
					jal whileCompareString 
					sw $31 0($sp)
					addi $29 ,$29 ,4

					lw $31,0($29)			#on restaure la valeur de retour de la fonction	
					lw $15,4($29)			#on restaure les registre du contexte de al fonction appellante
					lw $18,8($29)			#idem	
					lw $10,12($29)		#idem				
					addi $29,$29,20
		
					jr $31

		whileCompareString:
					beq $10 $11 suivantCompareString
					j stringPasEgale

		suivantCompareString:
					beq $20 $15 stringEgale	#si l'incrementeur est egale au nombre de lettre de la chaine $4 alors $4 et $5 sont egale
					lb $10 0($4)			#on charge une lettre de $4
					lb $11 0($5)			#on charge une lettre de $5
					addi $4 $4 1			#on prend l'adresse du byte suivant de $4
					addi $5 $5 1			#on prend l'adresse du byte suivant de $5
					addi $15 $15 1 		#incrementeur
					j whileCompareString
		
		stringEgale:
					li $2 1
					jr $31

		stringPasEgale:
					li $2 0
					jr $31

		user_affichage_choix:
				addiu $sp $sp -4 
				sw $31 0($sp)
	
				la $5 choix
		
				addiu $sp $sp -8
				sw $31 0($sp)		
				sw $5  4($sp) 
				jal afficher_string
				sw $31 0($sp)		
				sw $5  4($sp)
				addiu $sp $sp 8
		
				la $5 choix1

				addiu $sp $sp -8
				sw $31 0($sp)		
				sw $5  4($sp)
				jal afficher_string
				lw $31 0($sp)		
				lw $5  4($sp)
				addiu $sp $sp 8

				la $5 choix2

				addiu $sp $sp -8
				sw $31 0($sp)		
				sw $5  4($sp)
				jal afficher_string
				lw $31 0($sp)		
				lw $5  4($sp)
				addiu $sp $sp 8
		
				la $5 choix3

				addiu $sp $sp -8
				sw $31 0($sp)		
				sw $5  4($sp)
				jal afficher_string
				lw $31 0($sp)		
				lw $5  4($sp)
				addiu $sp $sp 8

				la $5 choix4

				addiu $sp $sp -8
				sw $31 0($sp)		
				sw $5  4($sp)
				jal afficher_string
				lw $31 0($sp)		
				lw $5  4($sp)
				addiu $sp $sp 8

				addiu $sp $sp -4
				sw $31 0($sp)		
				jal lectureString
				lw $31 0($sp)	
				addiu $sp $sp 4
				move $2 $4
		
				addiu $sp $sp -8
				sw $31 0($sp)		
				sw $4  4($sp)
				jal user_commande
				lw $31 0($sp)		
				lw $5  4($sp)
				addiu $sp $sp 8

				lw $31 0($sp)
				addiu $sp $sp 4 

#argument dans $4 , l'entre de l'utilisateur
		user_commande:
				lw $4 4($sp)
 			
				addi $29 ,$29 ,-24#on augmente la taille de la pile 
				sw $31,0($29)			#sauvegarde des registre que la fonction va utiliser
				sw $13,4($29)			#idem
				sw $14,8($29)			#idem
				sw $15,12($29)		#idem
				sw $16,16($29)		#idem
				sw $17,20($29)		#idem
				la $13,occup			#adresse de la chaine occup 
				la $14,couleur		#adresse de la chaine couleur
				la $15,deplace		#adresse de la chaine deplace
				la $16,quit				#adresse de la chaine quit 
				li $17,1					#on mettre les caractere de la chaine occup dans ce registre pour le test
								

				addi $29 ,$29 ,-12	#on augmente la taille de la pile 
				sw $31 0($29)			#on sauvegarde l'argument passe a la fonction compareString
					sw $4 4($sp)
				sw $13 8($sp)
				jal compareString	#la comparaison est appeller avec $4 la chaine passer en argument a user_commande
				lw $31 0($29)			#on restaure le $4 initiale
				lw $4 4($29)			#on restaure le $4 initiale
				lw $13 8($29)			#on restaure le $4 initiale
				addi $29 ,$29 ,12
				beq $2 $17 user_occuper	#Si la comparaison est vrai alors on executer la fonction user_occuper
		
				addi $29 ,$29 ,-12	#on augmente la taille de la pile 
				sw $31 0($29)			#on sauvegarde l'argument passe a la fonction compareString
				sw $4 4($sp)
				sw $14 8($sp)
				jal compareString	#la comparaison est appeller avec $4 la chaine passer en argument a user_commande
				lw $31 0($29)			#on restaure le $4 initiale
				lw $4 4($29)			#on restaure le $4 initiale
				lw $14 8($29)			#on restaure le $4 initiale
				addi $29 ,$29 ,12
				beq $2 $17 user_couleur	#Si la comparaison est vrai alors on executer la fonction user_occuper
	
				addi $29 ,$29 ,-12	#on augmente la taille de la pile 
				sw $31 0($29)			#on sauvegarde l'argument passe a la fonction compareString
				sw $4 4($sp)
				sw $15 8($sp)
				jal compareString	#la comparaison est appeller avec $4 la chaine passer en argument a user_commande
				lw $31 0($29)			#on restaure le $4 initiale
				lw $4 4($29)			#on restaure le $4 initiale
				lw $15 8($29)			#on restaure le $4 initiale
				addi $29 ,$29 ,12
				beq $2 $17 user_deplacement	#Si la comparaison est vrai alors on executer la fonction user_occuper
				
				addi $29 ,$29 ,-12	#on augmente la taille de la pile 
				sw $31 0($29)			#on sauvegarde l'argument passe a la fonction compareString
				sw $4 4($sp)
				sw $16 8($sp)
				jal compareString	#la comparaison est appeller avec $4 la chaine passer en argument a user_commande
				lw $31 0($29)			#on restaure le $4 initiale
				lw $4 4($29)			#on restaure le $4 initiale
				lw $16 8($29)			#on restaure le $4 initiale
				addi $29 ,$29 ,12
				beq $2 $17 user_quit	#Si la comparaison est vrai alors on executer la fonction user_occuper
		
		
				lw $31,0($29)			#on restaure les registre du contexte de al fonction appellante
				sw $13,4($29)			#idem	
				sw $14,8($29)			#idem	
				sw $15,12($29)		#idem	
				sw $16,16($29)		#idem	
				sw $17,20($29)		#idem	
				addi $29,$29,20
				jr $31
saisie:
		
			#etc ...

Exit:							# fin du programme
