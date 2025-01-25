# Backup and Restoration on Linux
English 🇬🇧
💡 **Computers**, whether for personal use or servers, can fall victim to mishandling. These human errors can damage the system and the data stored within.  
⚠️ **It is important to understand that accidents can occur at any time, so it is better to be prepared.**  
When using Linux-based systems, it is helpful to know how to restore your system after an incident or a failed update.  

🙋‍♂️ For a system administrator, knowing how to back up and restore is as essential as eating and breathing for humans. Now you see its importance.  

---

## 🚨 Potential Causes of System and Data Damage:
### Physical Causes:
- 🔥 Fire  
- ⚙️ Mechanical issues  
- 🚨 Deliberate damage to servers  

### Non-Physical Causes (Software Level):
- 🖱️ User error or partition mishandling  
- 🛡️ Hacker attacks (data encryption, etc.)  
- ⚙️ System instability due to user errors  

---

## 🛡️ Backing Up

Backup is the process of securing the data stored in a computer system. It acts as a contingency copy.  

💡 **Before Backing Up:**
1. Why should I back up my data?  
2. What should I back up?  
3. When should I do it, and how often?  
4. Where should the backups be stored?  
5. How should I do it?  
6. For how long should I keep the backups?  
7. Should the process be automated or manual?  

### 📁 Possible Backup Media:
- SD Card  
- USB Drive  
- CD, DVD  
- External Disks  
- Remote Server (FTP, Samba)  

⚠️ **Prioritize backups stored physically apart from the system** to prevent physical attacks or damage.

---

## 📊 Types of Backups

### Full Backup  
✅ Copies all the data that can be backed up.  
🚨 **Note:** Perform periodically, as it takes time and consumes a lot of storage.  

### Incremental Backup  
🔄 Copies only recent changes since the last backup.  
💾 **Advantage:** Saves time and storage space.  

### Differential (or Cumulative) Backup  
📂 Copies all files modified since the last full backup.  
💡 **Tip:** Combines the speed of incremental backups with the simplicity of full restorations.

---

## 📜 What to Back Up?
- Important Directories:  
  - `~` (User directory)  
  - `/var/` (except `/var/cache/`, `/var/run/`, `/var/tmp/`)  
  - `/etc/` (Configuration files)  
  - `/usr/` and `/opt/` (Local software)  

---

## ⚙️ Backup Tools to Use

In this study, we will use CLI (Command-Line Interface) tools:  
- `tar`: Archives data for general use.  
- `cpio`: Archives systems for identical restoration.  

---
---
---


# Sauvegarde et Restauration sous Linux
Français 🇫🇷
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



