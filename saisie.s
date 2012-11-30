.data
read: .space 15
choix:.asciiz  "Que vous vous faire ?\n"
choix1:.asciiz "Pour quitter,entre quit\n"
choix2:.asciiz "Pour avoir la couleur d'une case, entre couleur\n"
choix3:.asciiz "Pour savoir par quoi est occuper une case,entre occuper\n"
choix4:.asciiz "Pour deplacer un pion, entre deplacement\n"

.text
.globl __start

__start:

	j Exit # saut a la fin du programme

#Pas de parametre 
#retour $2
lectureString:
	la $2, read 				# charge le pointeur read dans $4	
	ori $5, $0, 15 			# charge la longueur maximale dans $5
	ori $2, $0, 8 			# charge 8 (code de l’appel système) dans $2
	syscall 						# Exécute l’appel système

#argument $4 : l'adresse de la cahine a teste 
#retour $2 : le nombre de caractere dans la chaine 
	strlen:
		addi $29 ,$29 ,-4
		sw $31,0($29)	
		li $15,10					#code ascii correspondant au \n
		li $18,0					#nombre d'element de la chaine
		lb $10 0($4)			#on charge les lettres une a une dans $10
		jal rechercheFin
		addi $18 $18 -1		#on enleve le compte du \n de la chaine saisie par 
		move $2 $18				#on renvoie le resultat dans le registre $2
		lw $31,4($29)			
		addi $29,$29,4

	whileStrlen:	
		bne $15 $10 parc	#cas d'arret du while: si le dernier caractere lu est un \n (code ascii 10 dans le registre 15)
		jr $31						

	parc:
		addi $18 $18 1		#on incremente le nombre de caractere lu
		addi $4 $4 1			#on augmente l'adresse du debut de la cahine de 1 pour acceder aucaractere suivant
		lb $10 0($4)			#on charge le caractere courant dans le registre 10
		j whileStrlen

#argument #4 et #5 les deux chaine a tester
#renvoie 1 si vrai ,sinon 0 dans $2
	compareString:
		addi $29 ,$29 ,-4
		sw $31,0($29)
		li $10 0					#on mettre les caractere de la chaine dont l'adresse est dans $4 dans ce registre pour le test			
		li $11 0					#on mettre les caractere de la chaine dont l'adresse est dans $5 dans ce registre pour le test
		li $15 0					#Incrementeur: nombre de tour de boucle (lettre egale une a une )
		addi $29 ,$29 ,-4
		sw $4,4($29)
		jal Strlen						#taille de $4
		lw $4,4($29)
		move $2 $20				#on met le resultat de Strlen dans $20
		jal whileCompareString 
		lw $31,0($29)
		addi $29,$29,4
		jr $31

	whileCompareString:
		beq $10 $11 suivantCompare
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

	user_choix:
		la $5 choix
		jal afficher_string
		la $5 choix1
		jal afficher_string
		la $5 choix2
		jal afficher_string
		la $5 choix3
		jal afficher_string
		la $5 choix4
		
		jal lectureString
		move $2 $4
		user_commande
		
#argument dans $4 , l'entre de l'utilisateur
	user_commande:
		addi $29 ,$29 ,-4
		sw $31,0($29)
		la $13,occup			#adresse de la chaine occup 
		la $14,couleur		#adresse de la chaine couleur
		la $15,deplace		#adresse de la chaine deplace
		la $16,quit				#adresse de la chaine quit 
		li $17,1					#on mettre les caractere de la chaine occup dans ce registre pour le test
						

		addi $29 ,$29 ,-4
		sw $4 4($29)
		move $13 $5
		jal compareString
		lw $4 4($29)
		beq $2 $17 user_occuper

		addi $29 ,$29 ,-4
		sw $4 4($29)
		move $14 $5
		jal compareString
		lw $4 4($29)
		beq $2 $17 user_couleur

		addi $29 ,$29 ,-4
		sw $4 4($29)
		move $15 $5
		jal compareString
		lw $4 4($29)
		beq $2 $17 user_deplacement
		
		addi $29 ,$29 ,-4
		sw $4 4($29)
		move $13 $5
		jal compareString
		lw $4 4($29)
		beq $2 $17 user_quit
		
		jal while
		lw $31,4($29)
		addi $29,$29,4
		jr $31

	user_quit:
		j Exit

		
