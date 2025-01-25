#!/bin/bash

# Sauvegarde avancée avec LVM, chiffrement et envoi SFTP

# Variables
VG_NAME="vg_data"                    # Nom du groupe de volumes LVM
LV_NAME="lv_data"                    # Nom du volume logique
SNAPSHOT_NAME="lv_data_snapshot"     # Nom de l'instantané
BACKUP_DIR="/path/to/backup"         # Répertoire de sauvegarde
DATE=$(date +%Y-%m-%d_%H-%M-%S)      # Date actuelle pour le nom du fichier
BACKUP_FILE="backup_$DATE.img"       # Nom du fichier de sauvegarde
GPG_KEY="user@example.com"           # Clé GPG pour le chiffrement
SFTP_HOST="sftp.server.com"          # Hôte SFTP pour le stockage distant
SFTP_USER="username"                 # Utilisateur SFTP
SFTP_DIR="/remote/backup"            # Répertoire de destination sur le serveur SFTP
LOG_FILE="/var/log/backup_lvm.log"   # Fichier de log
ERROR_LOG="/var/log/backup_lvm_error.log" # Fichier d'erreur

# Fonction de notification par email
send_email_notification() {
    local subject="$1"
    local body="$2"
    echo -e "$body" | mail -s "$subject" admin@example.com
}

# Vérification des volumes
lvdisplay $VG_NAME/$LV_NAME > /dev/null 2>&1
if [ $? -ne 0 ]; then
    send_email_notification "Backup failed" "Volume $VG_NAME/$LV_NAME does not exist."
    echo "Volume $VG_NAME/$LV_NAME does not exist." >> $ERROR_LOG
    exit 1
fi

# Création d'un instantané LVM
lvcreate --size 1G --snapshot --name $SNAPSHOT_NAME $VG_NAME/$LV_NAME >> $LOG_FILE 2>&1
if [ $? -ne 0 ]; then
    send_email_notification "Backup failed" "Error creating LVM snapshot."
    echo "Error creating LVM snapshot." >> $ERROR_LOG
    exit 1
fi

# Sauvegarde de l'instantané
dd if=/dev/$VG_NAME/$SNAPSHOT_NAME of=$BACKUP_DIR/$BACKUP_FILE bs=4M status=progress >> $LOG_FILE 2>&1
if [ $? -ne 0 ]; then
    send_email_notification "Backup failed" "Error during backup of snapshot."
    echo "Error during backup of snapshot." >> $ERROR_LOG
    exit 1
fi

# Vérification de l'intégrité avec checksum
echo "Verifying backup integrity..." >> $LOG_FILE
sha256sum $BACKUP_DIR/$BACKUP_FILE > $BACKUP_DIR/$BACKUP_FILE.sha256
if [ $? -ne 0 ]; then
    send_email_notification "Backup failed" "Checksum verification failed."
    echo "Checksum verification failed." >> $ERROR_LOG
    exit 1
fi

# Chiffrement avec GPG
gpg --batch --yes --encrypt --recipient $GPG_KEY --output $BACKUP_DIR/$BACKUP_FILE.gpg $BACKUP_DIR/$BACKUP_FILE >> $LOG_FILE 2>&1
if [ $? -ne 0 ]; then
    send_email_notification "Backup failed" "Error during GPG encryption."
    echo "Error during GPG encryption." >> $ERROR_LOG
    exit 1
fi

# Envoi via SFTP
echo "Uploading backup to SFTP server..." >> $LOG_FILE
scp $BACKUP_DIR/$BACKUP_FILE.gpg $SFTP_USER@$SFTP_HOST:$SFTP_DIR >> $LOG_FILE 2>&1
if [ $? -ne 0 ]; then
    send_email_notification "Backup failed" "Error uploading backup to SFTP."
    echo "Error uploading backup to SFTP." >> $ERROR_LOG
    exit 1
fi

# Nettoyage de l'instantané LVM
lvremove --yes /dev/$VG_NAME/$SNAPSHOT_NAME >> $LOG_FILE 2>&1

# Notification de succès
send_email_notification "Backup completed successfully" "Backup was completed successfully at $(date)."

# Fin du script
