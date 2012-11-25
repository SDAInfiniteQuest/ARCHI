.data

damier: 			.space 50
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

			#Debut boucle saisie
			#on sort de la boucle lorsque l'utilisateur rentre la commande "quit"



			j		Exit	# saut a la fin du programme

			#fonction du jeu------------------------------------------------

			init_damier:

			ligne:

			colonne:

			get_case:

			move_pion:
			
			couleur:

			occuper:

			affichage:

			deplacement:
			
			#fonction du module de control-----------------------------------

			user_deplacement:

			user_quit:

			user_couleur:

			user_occuper:

			#fonction d'affichage, et sous-routines--------------------------

			afficher_string:

			afficher_int:
		
			#etc ...

Exit:							# fin du programme
