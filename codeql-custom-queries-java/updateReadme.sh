#!/usr/bin/bash

# Définition du fichier cible
TARGET_FILE="README.md"
START_LINE=26

# Vérification de l'existence du fichier
if [ ! -f "$TARGET_FILE" ]; then
    echo "Erreur : $TARGET_FILE introuvable."
    exit 1
fi

# Création d'un fichier temporaire contenant les 36 premières lignes
head -n $((START_LINE - 1)) "$TARGET_FILE" > "$TARGET_FILE.tmp"

# Ajout de l'arborescence dans un bloc de code Markdown
echo "## Structure du projet" >> "$TARGET_FILE.tmp"
echo "\`\`\`text" >> "$TARGET_FILE.tmp"
tree -I "node_modules|.git|.actual" >> "$TARGET_FILE.tmp"
echo "\`\`\`" >> "$TARGET_FILE.tmp"

# Remplacement du fichier original par le nouveau
mv "$TARGET_FILE.tmp" "$TARGET_FILE"

echo "Mise à jour de $TARGET_FILE effectuée à partir de la ligne $START_LINE."
