#!/bin/bash

echo "🧹 Nettoyage complet du projet Flutter iOS..."

# Arrêter tous les processus
killall -9 Runner 2>/dev/null
killall -9 Xcode 2>/dev/null

# Nettoyage Flutter
echo "📦 Nettoyage Flutter..."
flutter clean

# Nettoyage iOS
echo "🍎 Nettoyage iOS..."
cd ios

# Supprimer les fichiers générés
rm -rf Pods
rm -rf Podfile.lock
rm -rf .symlinks
rm -rf Flutter/Flutter.framework
rm -rf Flutter/Flutter.podspec
rm -rf .flutter-plugins
rm -rf .flutter-plugins-dependencies
rm -rf DerivedData
rm -rf Runner.xcworkspace

# Nettoyage des caches Xcode
echo "🗑️  Nettoyage des caches Xcode..."
rm -rf ~/Library/Developer/Xcode/DerivedData/*
rm -rf ~/Library/Caches/CocoaPods

# Nettoyage du cache pod
echo "☕ Nettoyage du cache CocoaPods..."
pod cache clean --all

# Deintegrate pods
pod deintegrate

cd ..

# Récupération des dépendances
echo "📥 Récupération des dépendances Flutter..."
flutter pub get

# Installation des pods
echo "☕ Installation des CocoaPods..."
cd ios
pod install --repo-update
cd ..

echo "✅ Nettoyage terminé ! Vous pouvez maintenant lancer 'flutter run'"