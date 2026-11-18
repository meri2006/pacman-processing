# Pacman – Processing (Java)

Reproduction du jeu classique **Pacman**, réalisée dans le cadre de ma formation en informatique, avec **Processing** (langage basé sur Java) et en **programmation orientée objet**.

Pacman doit manger toutes les gommes du labyrinthe en évitant les quatre fantômes. Une super gomme rend les fantômes vulnérables pendant quelques secondes : Pacman peut alors les manger.

<!-- Ajoute ici une capture d'écran du jeu : glisse l'image "capture.png" dans le dépôt, puis garde la ligne ci-dessous -->
![Capture du jeu](capture.png)

## Fonctionnalités

- **Labyrinthe chargé depuis un fichier texte** (`levels/level1.txt`)
- **4 fantômes** avec leur propre couleur, qui sortent de leur maison les uns après les autres
- **Mode peur** : après une super gomme, les fantômes deviennent bleus et ralentissent
- **Score** : 10 points par gomme, 50 par super gomme, et 200, 400, 800 puis 1 600 points par fantôme mangé
- **Tunnels** pour passer d'un côté à l'autre de l'écran
- **3 vies**, et une vie bonus à 10 000 points
- **Menu pause** : reprendre, recommencer, sauvegarder, charger une partie, meilleurs scores, quitter
- **Top 5 des meilleurs scores**, enregistré avec le nom du joueur
- Animation de la bouche de Pacman et murs aux coins arrondis

## Commandes

| Action | Touche |
|---|---|
| Se déplacer | Flèches ou Z Q S D |
| Ouvrir le menu pause | P ou Échap (ou le bouton MENU) |
| Naviguer dans le menu | Z / S ou flèches haut / bas |
| Valider | Entrée |

## Lancer le jeu

1. Installer [Processing](https://processing.org/download) (version 4).
2. Télécharger ce dépôt (bouton **Code → Download ZIP**) et le décompresser.
3. Ouvrir le fichier `pacman/pacman.pde` avec Processing.
4. Cliquer sur **Run** (▶).

## Organisation du code

- `Game` : déroulement de la partie (score, vies, mode peur, collisions, menu, sauvegarde, meilleurs scores)
- `Board` : chargement et affichage du labyrinthe et des gommes
- `Hero` : déplacement et animation de Pacman
- `Fantome` : sortie de la maison, déplacement et mode peur des fantômes
- `Menu` : menu pause
- `constants` : constantes du jeu (types de cases, taille des cases, points)

## Crédits

Projet réalisé par **Mariem El Babidi** dans le cadre de ma formation. Le niveau `level1.txt` a été fourni par l'enseignant.
