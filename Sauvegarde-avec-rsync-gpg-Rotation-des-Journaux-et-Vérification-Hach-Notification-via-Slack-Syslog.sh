#!/bin/bash


# Variables
SOURCE_DIR="/cehmin/vers/la/source"           # Répertoire source à sauvegarder
BACKUP_DIR="/cehmin/vers/le/backup"           # Répertoire de sauvegarde
DATE=$(date +%Y-%m-%d_%H-%M-%S)        # Date actuelle pour le nom du fichier
BACKUP_FILE="backup_$DATE.tar.gz"      # Nom de l'archive
GPG_KEY="user@example.com"             # Clé GPG pour le chiffrement
SLACK_WEBHOOK_URL="https://hooks.slack.com/services/xxxx/xxxx/xxxx" # Webhook Slack
LOG_FILE="/var/log/backup.log"         # Fichier de log
ERROR_LOG="/var/log/backup_error.log"  # Fichier pour les erreurs
SHA256_FILE="/var/log/backup_sha256.txt" # Fichier pour la vérification du hachage

# Fonction de notification Slack
send_slack_notification() {
    local message="$1"
    curl -X POST -H 'Content-type: application/json' --data "{\"text\":\"$message\"}" $SLACK_WEBHOOK_URL
}

# Fonction de rotation des journaux
rotate_logs() {
    logrotate -f /etc/logrotate.d/backup_log
}

# Vérification des répertoires
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Source directory does not exist." >> $ERROR_LOG
    send_slack_notification "Backup failed: Source directory does not exist."
    exit 1
fi

# Création de l'archive avec rsync et tar
echo "Starting backup at $(date)" >> $LOG_FILE
rsync -avz $SOURCE_DIR $BACKUP_DIR --exclude '.git' --exclude '.svn' >> $LOG_FILE 2>&1
tar -czf $BACKUP_DIR/$BACKUP_FILE -C $SOURCE_DIR . >> $LOG_FILE 2>&1

# Vérification du succès de la sauvegarde
if [ $? -ne 0 ]; then
    echo "Error creating backup archive." >> $ERROR_LOG
    send_slack_notification "Backup failed: Error creating backup archive."
    exit 1
fi

# Vérification de l'intégrité via SHA256
echo "Verifying integrity of backup..." >> $LOG_FILE
sha256sum $BACKUP_DIR/$BACKUP_FILE > $SHA256_FILE
if [ $? -ne 0 ]; then
    echo "Integrity check failed." >> $ERROR_LOG
    send_slack_notification "Backup failed: Integrity check failed."
    exit 1
fi

# Chiffrement avec GPG
echo "Encrypting backup with GPG..." >> $LOG_FILE
gpg --batch --yes --encrypt --recipient $GPG_KEY --output $BACKUP_DIR/$BACKUP_FILE.gpg $BACKUP_DIR/$BACKUP_FILE >> $LOG_FILE 2>&1

# Vérification du succès du chiffrement
if [ $? -ne 0 ]; then
    echo "Error during GPG encryption." >> $ERROR_LOG
    send_slack_notification "Backup failed: Error during GPG encryption."
    exit 1
fi

# Rotation des journaux pour garder un historique propre
rotate_logs

# Nettoyage de l'archive originale
rm -f $BACKUP_DIR/$BACKUP_FILE

# Notification de succès
send_slack_notification "Backup completed successfully: $BACKUP_FILE"

# Fin du script
