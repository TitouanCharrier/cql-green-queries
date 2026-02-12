#!/usr/bin/bash

# Activation de la recherche récursive
shopt -s globstar

# 1. Exécution des tests et capture du code de retour
echo "--- Exécution des tests CodeQL ---"
codeql test run **/*.ql
TEST_RESULT=$?

# 2. Nettoyage systématique (exécuté même si TEST_RESULT != 0)
echo "--- Nettoyage des fichiers temporaires ---"
rm -rf **/*.testproj

# 3. Actions conditionnelles
if [ $TEST_RESULT -eq 0 ]; then
    echo "Succès : Tous les tests sont passés."
    if [ -f "./updateReadme.sh" ]; then
        ./updateReadme.sh
    fi
else
    echo "Erreur : Au moins un test a échoué (Code : $TEST_RESULT)."
fi

# 4. Transmission du code d'erreur au système (pour stopper le workflow CI)
exit $TEST_RESULT
