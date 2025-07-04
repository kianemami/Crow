# Requirement

    Install Packages 
    gcc mosquitto mosquitto-clients libmosquitto-dev libpthread-stubs0-dev


# Compile using GNU Make


### Clean old build forlder 

    make clean 

### if you prevoius version , you can delete old Exceutable file

    make unistall

### Compile the program

    make 

### install it in "/usr/local/bin"

    make install

# Before Run

### Run the environmet setup script with sudo privileges 

    chmod +x ./crow_installl_env.sh
    sudo ./crow_installl_env.sh

# Running The program 

### make the script exceutable to run 

    chmod +x ./crow_run.sh

### place this inside systemd daemon or .bashrc to run the program on the startup 

    sudo ./crow_run.sh
 
