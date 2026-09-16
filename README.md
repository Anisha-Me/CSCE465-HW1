
## Environment
- VM: Ubuntu 22.04 LTS x86-64
- Virtualization: VirtualBox 7.2.x
- VM Resources: 4 vCPUs, 8GB RAM, 80GB dynamically allocated disk, NAT networking
- Node.js: 24.18.0 (via nvm)
- OpenClaw: 2026.7.1-2
- Model: TAMUS API (protected.gpt-4o) via local shim

Downloaded Ubuntu 22.04 LTS x86-64 ISO from:
https://releases.ubuntu.com/24.04/

Created a new VirtualBox VM with:
- Type: Linux, Ubuntu 64-bit
- 4 vCPUs, 8GB RAM
- 80GB dynamically allocated disk
- NAT networking only

Completed Ubuntu installation, created a course-only local user, rebooted,
and ejected the ISO.

Verified architecture and network:
uname -m        # x86_64
ip -brief address
ip route


### Base OS Packages
sudo apt update
sudo apt full-upgrade -y
sudo apt install -y curl git
sudo reboot

### Node.js and OpenClaw Installation

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
source "$HOME/.nvm/nvm.sh"
nvm install 24.18.0
nvm alias default 24.18.0
node --version
npm --version
npm install -g openclaw@2026.7.1-2
openclaw --version

### Model Setup — Option B (TAMUS API)

Start the shim (must be running at all times during agent use):
export TAMU_API_KEY="<your key>"
node tamu-shim.mjs

Onboard OpenClaw against the shim:
openclaw onboard --non-interactive --accept-risk \
  --auth-choice custom-api-key --custom-provider-id tamus \
  --custom-compatibility openai \
  --custom-base-url "http://127.0.0.1:8899/openai" \
  --custom-api-key via-shim \
  --custom-model-id "protected.gpt-4o" --skipchannels

openclaw config set models.providers.tamus.request.allowPrivateNetwork true
openclaw config set agents.defaults.timeoutSeconds 600
openclaw config set agents.defaults.memorySearch.enabled false
openclaw config validate
openclaw models set tamus/protected.gpt-4o
openclaw daemon install && openclaw daemon start

### Verify Lab Setup

openclaw gateway status
