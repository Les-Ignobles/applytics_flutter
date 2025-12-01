#!/bin/bash

# 🚀 Script de test et validation du package Applytics Flutter

echo "==================================="
echo "📦 Applytics Flutter - Test Local"
echo "==================================="
echo ""

# Couleurs pour les messages
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Dossier du package
PACKAGE_DIR="/Users/sowakillian/Desktop/work/les_ignobles/customer_products/applytics_flutter"

cd "$PACKAGE_DIR"

echo "${YELLOW}Étape 1 : Installation des dépendances...${NC}"
flutter pub get
if [ $? -eq 0 ]; then
    echo "${GREEN}✅ Dépendances installées${NC}"
else
    echo "${RED}❌ Erreur lors de l'installation des dépendances${NC}"
    exit 1
fi
echo ""

echo "${YELLOW}Étape 2 : Analyse du code...${NC}"
flutter analyze
if [ $? -eq 0 ]; then
    echo "${GREEN}✅ Aucune erreur d'analyse${NC}"
else
    echo "${RED}❌ Erreurs d'analyse détectées${NC}"
    exit 1
fi
echo ""

echo "${YELLOW}Étape 3 : Formatage du code...${NC}"
dart format lib/ test/
echo "${GREEN}✅ Code formaté${NC}"
echo ""

echo "${YELLOW}Étape 4 : Exécution des tests...${NC}"
flutter test
if [ $? -eq 0 ]; then
    echo "${GREEN}✅ Tous les tests passent${NC}"
else
    echo "${RED}❌ Certains tests ont échoué${NC}"
    exit 1
fi
echo ""

echo "${YELLOW}Étape 5 : Validation du package...${NC}"
dart pub publish --dry-run
if [ $? -eq 0 ]; then
    echo "${GREEN}✅ Package prêt à être publié${NC}"
else
    echo "${RED}❌ Le package a des problèmes${NC}"
    exit 1
fi
echo ""

echo "${YELLOW}Étape 6 : Test de l'application exemple...${NC}"
cd example
flutter pub get
if [ $? -eq 0 ]; then
    echo "${GREEN}✅ Exemple prêt${NC}"
else
    echo "${RED}❌ Problème avec l'exemple${NC}"
    exit 1
fi
cd ..
echo ""

echo "==================================="
echo "${GREEN}🎉 Tous les tests sont passés !${NC}"
echo "==================================="
echo ""
echo "Vous pouvez maintenant :"
echo "  1. Tester l'app exemple : ${YELLOW}cd example && flutter run${NC}"
echo "  2. Publier sur pub.dev : ${YELLOW}dart pub publish${NC}"
echo "  3. Créer un repo Git : ${YELLOW}git init && git add . && git commit -m 'Initial commit'${NC}"
echo ""

