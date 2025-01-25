# L-importance-des-Sauvegardes
# Sauvegarde et Restauration sous Linux

💡 **Les ordinateurs**, qu'ils soient pour usage personnel ou de type serveur, peuvent être victimes de mauvaises manipulations. Ces erreurs humaines peuvent endommager le système et les données s'y trouvant.  
⚠️ **Et il faut savoir qu'un jour ou l'autre, un accident peut survenir. Donc mieux vaut être préparé.**  
Lorsque l'on utilise des systèmes de type Linux, il peut être intéressant de savoir restaurer son système après un incident ou une mise à jour qui s'est mal passée.  

🙋‍♂️ Pour un administrateur système, savoir sauvegarder et restaurer est essentiel, comme savoir manger et respirer pour les humains. Vous voyez maintenant son importance.  

---

## 🚨 Les causes potentielles d'endommagement du système et des données :
### Causes physiques :
- 🔥 Incendie  
- ⚙️ Problème mécanique  
- 🚨 Dommages causés volontairement aux serveurs  

### Causes non-physiques (niveau logiciel) :
- 🖱️ Erreur de manipulation et/ou de partitionnement  
- 🛡️ Attaques des pirates informatiques (chiffrement de données, etc.)  
- ⚙️ Système instable dû à une erreur de manipulation  

---

## 🛡️ Sauvegarder

La sauvegarde est l'opération qui consiste à mettre en sécurité les données contenues dans un système informatique. C'est une copie de secours.  

💡 **Avant de sauvegarder :**
1. Pourquoi dois-je sauvegarder mes données ?  
2. Quoi sauvegarder ?  
3. Quand le faire et à quelle fréquence ?  
4. Où mettre les sauvegardes ?  
5. Comment le faire ?  
6. Pendant combien de temps ?  
7. Procédé automatique ou manuel ?  

### 📁 Supports possibles :
- Carte SD  
- Clé USB  
- CD, DVD  
- Disques externes  
- Serveur distant (FTP, Samba)  

⚠️ **Privilégier les sauvegardes qui ne sont pas accessibles physiquement** pour éviter les attaques et dommages physiques.

---

## 📊 Types de sauvegardes

### Sauvegarde complète (Full Backup)  
✅ Copie toutes les données sauvegardables.  
🚨 **Note :** À effectuer épisodiquement car cela prend du temps et occupe beaucoup d'espace.  

### Sauvegarde incrémentielle  
🔄 Copie uniquement les modifications récentes depuis la dernière sauvegarde.  
💾 **Avantage :** Gain de temps et d'espace.  

### Sauvegarde différentielle (ou cumulative)  
📂 Copie les fichiers modifiés depuis la dernière sauvegarde complète.  
💡 **Astuce :** Combine la rapidité des sauvegardes incrémentielles et la simplicité des restaurations complètes.

---

## 📜 Quoi sauvegarder ?
- Répertoires importants :  
  - `~` (Dossier utilisateur)  
  - `/var/` (sauf `/var/cache/`, `/var/run/`, `/var/tmp/`)  
  - `/etc/` (Fichiers de configuration)  
  - `/usr/` et `/opt/` (Logiciels locaux)  

---

## ⚙️ Avec quoi sauvegarder ?

Dans cette étude, nous utiliserons des outils CLI (ligne de commande) :  
- `tar` : Archive les données pour une utilisation générale.  
- `cpio` : Archive les systèmes pour une restauration identique.  

---

## 📜 Exemple de script Bash pour une sauvegarde quotidienne

Voici un script pour sauvegarder les fichiers d'un serveur web et sa base de données MySQL :

```bash
#!/bin/bash

# Variables
DATE=$(date +"%Y-%m-%d")
BACKUP_DIR="/backup/$DATE"
MYSQL_USER="root"
MYSQL_PASS="password"
DATABASE="nom_de_la_base"

# Créer le dossier de sauvegarde
mkdir -p $BACKUP_DIR

# Sauvegarder les fichiers du serveur web
tar -czf $BACKUP_DIR/web_files.tar.gz /var/www/html

# Sauvegarder la base de données
mysqldump -u $MYSQL_USER -p$MYSQL_PASS $DATABASE > $BACKUP_DIR/db_backup.sql

# Confirmation
echo "Sauvegarde terminée : $BACKUP_DIR"
