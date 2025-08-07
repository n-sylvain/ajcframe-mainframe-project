cmd to open TSO:
open -a XQuartz
export DISPLAY=:0
x3270 54.38.29.76:3276



https://sourceforge.net/projects/x3270/

Compilation de x3270 avec interface graphique X11 sur macOS

✅ Prérequis
	0.	Installer Homebrew (si ce n’est pas déjà fait) :https://brew.sh
	0.	Installer les dépendances nécessaires :

brew install xquartz
brew install autoconf automake libtool
brew install openssl
brew install xterm

XQuartz est l’équivalent du serveur X11 sous macOS. Il est indispensable pour afficher les interfaces graphiques comme x3270.


1. Installer les prérequis
Ouvre ton terminal macOS habituel et installe ces outils :

a) XQuartz (interface X11)
Si tu ne l’as pas déjà :
brew install --cask xquartz
Lance-le ensuite avec :
open -a XQuartz

b) Outils de compilation (Xcode command line tools)
xcode-select --install

c) Installer les dépendances nécessaires via Homebrew
brew install pkg-config libtool automake autoconf openssl
brew install libidn
brew install libressl
brew install libpng
brew install wget

2. Télécharger les sources de x3270
Va dans un dossier temporaire, par exemple ~/Downloads :
cd ~/Downloads
Télécharge la dernière version stable (exemple avec la version 4.5) : https://sourceforge.net/projects/x3270/

3. Décompresse l’archive
tar -xzf [nom du fichier téléchargé] suite3270-4.5
cd suite3270-4.5 

4. Configurer la compilation avec X11
Tu dois préciser à configure où est XQuartz, openssl, etc.
./configure --with-x --with-ssl --prefix=/usr/local

5. Compiler et installer
Compile :
make
Puis installe :
sudo make install

6. Vérifie que le binaire x3270 est disponible
which x3270
Si ça affiche /usr/local/bin/x3270 (ou autre chemin), c’est bon.

7. Lancer x3270
Assure-toi que XQuartz est lancé :
open -a XQuartz
Puis dans un terminal classique :
x3270

🚀 Exécution de x3270 avec XQuartz
Lancer XQuartz (si pas déjà ouvert)
open -a XQuartz

Dans un terminal macOS (pas dans XQuartz), définir DISPLAY :
export DISPLAY=:0
Pour rendre cela permanent, ajoute dans ~/.zshrc :
export DISPLAY=:0

(Optionnel) Corriger les avertissements de locale :
Dans ~/.zshrc :
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
Puis :
source ~/.zshrc

Lancer x3270 :
x3270
Une interface graphique IBM 3270 devrait s’ouvrir via XQuartz.

🧩 Tester XQuartz si x3270 ne s’ouvre pas

Vérifie si le serveur X11 fonctionne :
brew install xeyes
xeyes
Si xeyes s’ouvre → XQuartz fonctionne.

🛠️ Dépannage si la fenêtre ne s’ouvre pas
Vérifie que XQuartz tourne :
ps aux | grep Xquartz

Vérifie $DISPLAY :
echo $DISPLAY
Si vide, fais :
export DISPLAY=:0

Lancer x3270 en mode trace :
x3270 -trace trace.log
cat trace.log

✅ Connexion à un hôte 
Une fois la fenêtre x3270 ouverte, tu peux te connecter à ton hôte :
x3270 54.38.29.76:327X
