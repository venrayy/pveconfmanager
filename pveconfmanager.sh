#!/bin/bash

# Proxmox .conf Manager - Interactive Edition
# Simplifies copying .conf files for LXC and VMs in Proxmox

PVE_CONF_DIR="/etc/pve"
LXC_CONF_DIR="$PVE_CONF_DIR/lxc"
QEMU_CONF_DIR="$PVE_CONF_DIR/qemu-server"

function list_ids() {
    local type=$1
    if [[ $type == "vm" ]]; then
        ls "$QEMU_CONF_DIR" | grep -E '^[0-9]+\.conf$' | sed 's/\.conf//'
    elif [[ $type == "lxc" ]]; then
        ls "$LXC_CONF_DIR" | grep -E '^[0-9]+\.conf$' | sed 's/\.conf//'
    fi
}

function select_id() {
    local type=$1
    echo "Available $type IDs:"
    list_ids "$type"
    echo
    read -p "Enter the $type ID: " id
    echo $id
}

function copy_conf() {
    local source_id=$1
    local dest_id=$2
    local type=$3

    if [[ $type == "vm" ]]; then
        CONF_DIR=$QEMU_CONF_DIR
    elif [[ $type == "lxc" ]]; then
        CONF_DIR=$LXC_CONF_DIR
    else
        echo "Invalid type: $type"
        return 1
    fi

    SOURCE_CONF="$CONF_DIR/$source_id.conf"
    DEST_CONF="$CONF_DIR/$dest_id.conf"

    if [[ ! -f $SOURCE_CONF ]]; then
        echo "Source configuration file ($SOURCE_CONF) does not exist!"
        return 1
    fi

    if [[ -f $DEST_CONF ]]; then
        echo "Destination configuration file ($DEST_CONF) already exists!"
        return 1
    fi

    echo "Copying configuration from $SOURCE_CONF to $DEST_CONF..."
    cp "$SOURCE_CONF" "$DEST_CONF"

    echo "Updating VMID in the destination configuration..."
    sed -i "s/\<$source_id\>/$dest_id/g" "$DEST_CONF"

    echo "Configuration copied successfully!"
    echo "Verify the new configuration at: $DEST_CONF"
}

function main_menu() {
    echo "=== Proxmox .conf Manager ==="
    echo "1. Copy VM configuration"
    echo "2. Copy LXC configuration"
    echo "3. Exit"
    echo

    read -p "Select an option [1-3]: " option
    case $option in
        1)
            echo "Selected: Copy VM configuration"
            echo
            echo "Step 1: Select source VM"
            source_id=$(select_id "vm")
            echo "Step 2: Enter destination VM ID"
            read -p "Destination VM ID: " dest_id
            copy_conf "$source_id" "$dest_id" "vm"
            ;;
        2)
            echo "Selected: Copy LXC configuration"
            echo
            echo "Step 1: Select source LXC"
            source_id=$(select_id "lxc")
            echo "Step 2: Enter destination LXC ID"
            read -p "Destination LXC ID: " dest_id
            copy_conf "$source_id" "$dest_id" "lxc"
            ;;
        3)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid option, try again."
            ;;
    esac
}

while true; do
    main_menu
done
