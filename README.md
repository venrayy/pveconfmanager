
Proxmox .conf Manager

a stupid simple vibe coded little script to easily copy proxmox .conf(urations) to different VM's or LXC's 

Features:

    Interactive Menus:
        Provides a list of existing VM or LXC IDs to choose from.
        Prompts for a destination ID after selecting the source.

    Validation:
        Ensures the source .conf file exists before proceeding.
        Checks that the destination .conf does not already exist.

    User Flow:
        Launch the script: ./pve-conf-man.sh
        Choose:
            Copy VM configuration
            Copy LXC configuration
            Exit
        Follow prompts to complete the copy.

    Example Interaction:

    === Proxmox .conf Manager ===
    1. Copy VM configuration
    2. Copy LXC configuration
    3. Exit

    Select an option [1-3]: 1

    Selected: Copy VM configuration

    Step 1: Select source VM
    Available vm IDs:
    100
    101
    102

    Enter the vm ID: 100

    Step 2: Enter destination VM ID
    Destination VM ID: 200

    Copying configuration from /etc/pve/qemu-server/100.conf to /etc/pve/qemu-server/200.conf...
    Updating VMID in the destination configuration...
    Configuration copied successfully!
    Verify the new configuration at: /etc/pve/qemu-server/200.conf

Additional Improvements:

    Confirmation Prompts: Ask the user to confirm actions before proceeding.
    Error Handling: More robust error messages for invalid input or file issues.
    Backup Option: Automatically create a backup of the destination .conf if it exists (optional).

