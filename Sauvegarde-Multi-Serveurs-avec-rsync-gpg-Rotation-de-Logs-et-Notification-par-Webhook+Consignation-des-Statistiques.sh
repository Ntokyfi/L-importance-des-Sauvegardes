#!/bin/bash

# Sauvegarde multi-serveurs avec chiffrement et notifications via Webhook

# Variables
SERVERS=("server1" "server2" "server3")         # Liste des serveurs à sauvegarder
USER="admin"                                     # Utilisateur SSH
SOURCE_DIR="/path/to/source"                     # Répertoire source sur les serveurs distants
BACKUP_DIR="/path/to/backup"                     # Répertoire de sauvegarde local
DATE=$(date +%Y-%m-%d_%H-%M-%S)                  # Date actuelle
GPG_KEY="user@example.com"                       # Clé GPG pour chiffrement
WEBHOOK_URL="https://example.com/webhook"        # Webhook API pour les notifications
LOG_FILE="/var/log/multi_server_backup.log"      # Fichier de log général

# Fonction pour envoyer une notification
send_notification() {
    local message="$1"
    curl -X POST -H "Content-Type: application/json" --data "{\"text\":\"$message\"}" $WEBHOOK_URL
}

# Fonction pour sauvegarder un serveur
backup_server() {
    local server="$1"
    local timestamp="$2"
    local backup_file="$BACKUP_DIR/backup_${server}_${timestamp}.tar.gz"

    # Sauvegarde avec rsync
    rsync -avz $USER@$server:$SOURCE_DIR $BACKUP_DIR >> $LOG_FILE 2>&1
    if [ $? -ne 0 ]; then
        send_notification "Backup failed for server $server"
        echo "Error backing up $server" >> $LOG_FILE
        return 1
    fi

    # Création de l'archive
    tar -czf $backup_file -C $BACKUP_DIR . >> $LOG_FILE 2>&1
    if [ $? -ne 0 ]; then
        send_notification "Error creating archive for server $server"
        echo "Error creating archive for $server" >> $LOG_FILE
        return 1
    fi

    # Chiffrement avec GPG
    gpg --batch --yes --encrypt --recipient $GPG_KEY --output $backup_file.gpg $backup_file >> $LOG_FILE 2>&1
    if [ $? -ne 0 ]; then
        send_notification "Error encrypting backup for $server"
        echo "Error encrypting backup for $server" >> $LOG_FILE
        return 1
    fi

    # Suppression du fichier original non chiffré
    rm -f $backup_file
    send_notification "Backup successful for $server"
}

# Sauvegarde de chaque serveur
for server in "${SERVERS[@]}"; do
    backup_server $server $DATE
done

# Fin du script
