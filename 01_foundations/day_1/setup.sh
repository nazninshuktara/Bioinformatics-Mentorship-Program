# Day 1 — Bioinformatics Environment Setup
# Author: Naznin

# 1. system update
message("Updating system package list...")
system("sudo apt update && sudo apt upgrade -y")
system("sudo apt install -y curl wget git gdebi-core r-base")

# 2. Miniconda install
if (system("command -v conda", ignore.stdout = TRUE) != 0) {
  message("Installing Miniconda...")
  system("wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh")
  system("bash ~/miniconda.sh -b -p $HOME/miniconda3")
  system("rm ~/miniconda.sh")
  system("$HOME/miniconda3/bin/conda init bash")
  message("Miniconda installed successfully!")
} else {
  message("Miniconda is already installed.")
}

# 3. Configure Bioconda channels
message("Configuring Bioconda channels in strict priority order...")
system("conda config --add channels defaults")
system("conda config --add channels bioconda")
system("conda config --add channels conda-forge")
system("conda config --set channel_priority strict")
system("conda config --set auto_activate_base false")

# 4. Install Mamba
message("Installing Mamba fast solver...")
system("conda install -n base -c conda-forge mamba -y")

# 5. Install uv
if (system("command -v uv", ignore.stdout = TRUE) != 0) {
  message("Installing uv...")
  system("curl -LsSf https://astral.sh/uv/install.sh | sh")
  message("uv installed successfully!")
} else {
  message("uv is already installed.")
}

# 6. Create Conda environment from environment.yml
if (file.exists("environment.yml")) {
  message("Creating conda environment from environment.yml...")
  system("$HOME/miniconda3/bin/mamba env create -f environment.yml")
}

