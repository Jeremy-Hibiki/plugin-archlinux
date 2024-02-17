# Ported from ohmyzsh plugin archlinux
# https://github.com/ohmyzsh/ohmyzsh/blob/872b5cd4086a5547dbf788dda4e96ab3868cf59b/plugins/archlinux/archlinux.plugin.zsh

#######################################
#               Pacman                #
#######################################

# Pacman - https://wiki.archlinux.org/index.php/Pacman_Tips
function pacupg --wraps 'sudo pacman -Syu' --description 'Sync with repositories before upgrading packages'
    sudo pacman -Syu $argv
end

function pacin --wraps 'sudo pacman -S' --description 'Install packages from the repositories'
    sudo pacman -S $argv
end

function paclean --wraps 'sudo pacman -Sc' --description 'Clean out old and unused caches and packages'
    sudo pacman -Sc $argv
end

function pacins --wraps 'sudo pacman -U' --description 'Install a package from a local file'
    sudo pacman -U $argv
end

function paclr --wraps 'sudo pacman -Scc' --description 'Remove all files from the cache'
    sudo pacman -Scc $argv
end

function pacre --wraps 'sudo pacman -R' --description 'Remove packages, keeping its settings and dependencies'
    sudo pacman -R $argv
end

function pacrem --wraps 'sudo pacman -Rns' --description 'Remove packages, including its settings and dependencies'
    sudo pacman -Rns $argv
end

function pacrep --wraps 'pacman -Si' --description 'Display information about a package in the repositories'
    pacman -Si $argv
end

function pacreps --wraps 'pacman -Ss' --description 'Search for packages in the repositories'
    pacman -Ss $argv
end

function pacloc --wraps 'pacman -Qi' --description 'Display information about a package in the local database'
    pacman -Qi $argv
end

function paclocs --wraps 'pacman -Qs' --description 'Search for packages in the local database'
    pacman -Qs $argv
end

function pacinsd --wraps 'sudo pacman -S --asdeps' --description 'Install packages as dependencies of another package'
    sudo pacman -S --asdeps $argv
end

function pacmir --wraps 'sudo pacman -Syy' --description 'Force refresh of all package lists after updating mirrorlist'
    sudo pacman -Syy $argv
end

function paclsorphans --wraps 'sudo pacman -Qdt' --description 'List all orphaned packages'
    sudo pacman -Qdt $argv
end

function pacrmorphans --wraps 'sudo pacman -Rs $(pacman -Qtdq)' --description 'Delete all orphaned packages'
    sudo pacman -Rs $(pacman -Qtdq) $argv
end

function pacfileupg --wraps 'sudo pacman -Fy' --description 'Download fresh package databases from the server'
    sudo pacman -Fy $argv
end

function pacfiles --wraps 'pacman -F' --description 'Search package file names for matching strings'
    pacman -F $argv
end

function pacls --wraps 'pacman -Ql' --description 'List files in a package'
    pacman -Ql $argv
end

function pacown --wraps 'pacman -Qo' --description 'Show which package owns a file'
    pacman -Qo $argv
end

function pacupd --wraps 'sudo pacman -Sy' --description 'Update and refresh local package, ABS and AUR databases'
    sudo pacman -Sy $argv
end


function pacdisowned --description 'List all disowned files in your system'
    set -l tmp_dir $(mktemp --directory)
    set -l db $tmp_dir/db
    set -l fs $tmp_dir/fs

    trap "rm -rf $tmp_dir" EXIT

    pacman -Qlq | sort -u >"$db"

    find /etc /usr ! -name lost+found \
        \( -type d -printf '%p/\n' -o -print \) | sort >"$fs"

    comm -23 "$fs" "$db"

    rm -rf $tmp_dir
end

function paclist --description 'List all explicitly installed packages with a description'
    pacman -Qqe | xargs -I{} -P0 --no-run-if-empty pacman -Qs --color=auto "^{}\$"
end

function pacmanallkeys --description 'Get all keys for developers and trusted users'
    sudo pacman-key --refresh-keys
end

function pacmansignkeys --description 'Locally trust all keys passed as parameters'
    for key in $argv
        sudo pacman-key --recv-keys $key
        sudo pacman-key --lsign-key $key
        printf 'trust\n3\n' | sudo gpg --homedir /etc/pacman.d/gnupg \
            --no-permission-warning --command-fd 0 --edit-key $key
    end
end

#######################################
#             AUR helpers             #
#######################################

if type -q aura
    function auin --wraps 'sudo aura -S' --description 'Install packages from the repositories'
        sudo aura -S $argv
    end

    function aurin --wraps 'sudo aura -A' --description 'Install packages from the repositories'
        sudo aura -A $argv
    end
    function auclean --wraps 'sudo aura -Sc' --description 'Clean out old and unused caches and packages'
        sudo aura -Sc $argv
    end

    function auclr --wraps 'sudo aura -Scc' --description 'Remove all files from the cache'
        sudo aura -Scc $argv
    end

    function auins --wraps 'sudo aura -U' --description 'Install a package from a local file'
        sudo aura -U $argv
    end

    function auinsd --wraps 'sudo aura -S --asdeps' --description 'Install packages as dependencies of another package (repositories only)'
        sudo aura -S --asdeps $argv
    end

    function aurinsd --wraps 'sudo aura -A --asdeps' --description 'Install packages as dependencies of another package (AUR only)'
        sudo aura -A --asdeps $argv
    end

    function auloc --wraps 'aura -Qi' --description 'Display information about a package in the local database'
        aura -Qi $argv
    end

    function aulocs --wraps 'aura -Qs' --description 'Search for packages in the local database'
        aura -Qs $argv
    end

    function aulst --wraps 'aura -Qe' --description 'List installed packages including from AUR (tagged as "local")'
        aura -Qe $argv
    end

    function aumir --wraps 'sudo aura -Syy' --description 'Force refresh of all package lists after updating mirrorlist'
        sudo aura -Syy $argv
    end

    function aurph --wraps 'sudo aura -Oj' --description 'Remove orphans using aura'
        sudo aura -Oj $argv
    end

    function aure --wraps 'sudo aura -R' --description 'Remove packages, keeping its settings and dependencies'
        sudo aura -R $argv
    end

    function aurem --wraps 'sudo aura -Rns' --description 'Remove packages, including its settings and unneeded dependencies'
        sudo aura -Rns $argv
    end

    function aurep --wraps 'aura -Si' --description 'Display information about a package in the repositories'
        aura -Si $argv
    end

    function aurrep --wraps 'aura -Ai' --description 'Display information about a package from AUR'
        aura -Ai $argv
    end

    function aureps --wraps 'aura -As --both' --description 'Search for packages in the repositories and AUR'
        aura -As --both $argv
    end

    function auras --wraps 'aura -As --both' --description 'Search for packages in the repositories and AUR'
        aura -As --both $argv
    end

    function auupd --wraps 'sudo aura -Sy' --description 'Update and refresh local package, ABS and AUR databases'
        sudo aura -Sy $argv
    end

    function auupg --description 'Sync with repositories before upgrading all packages (from AUR too)'
        sudo sh -c "aura -Syu && aura -Au"
    end

    function ausu --description 'Same as `auupg`, but without confirmation'
        sudo sh -c "aura -Syu --no-confirm && aura -Au --no-confirm"
    end

    # extra bonus specially for aura
    function auown --wraps 'aura -Qqo' --description 'Search for packages that own the specified file(s)'
        aura -Qqo $argv
    end

    function auls --wraps 'aura -Qql' --description 'List all files owned by a given package'
        aura -Qql $argv
    end

    function auownloc --description 'Display information about a package that owns the specified file(s)'
        aura -Qi $(aura -Qqo $argv)
    end

    function auownls --description 'List all files owned by a package that owns the specified file(s)'
        aura -Qql $(aura -Qqo $argv)
    end
end

if type -q pacaur
    function pacclean --wraps 'pacaur -Sc' --description 'Clean out old and unused caches and packages'
        pacaur -Sc $argv
    end

    function pacclr --wraps 'pacaur -Scc' --description 'Remove all files from the cache'
        pacaur -Scc $argv
    end

    function paupg --wraps 'pacaur -Syua' --description 'Sync with repositories before upgrading all packages (from AUR too)'
        pacaur -Syua $argv
    end

    function pasu --wraps 'pacaur -Syua --no-confirm' --description 'Same as `paupg`, but without confirmation'
        pacaur -Syua --no-confirm $argv
    end

    function pain --wraps 'pacaur -S' --description 'Install packages from the repositories'
        pacaur -S $argv
    end

    function pains --wraps 'pacaur -U' --description 'Install a package from a local file'
        pacaur -U $argv
    end

    function pare --wraps 'pacaur -R' --description 'Remove packages, keeping its settings and dependencies'
        pacaur -R $argv
    end

    function parem --wraps 'pacaur -Rns' --description 'Remove packages, including its settings and unneeded dependencies'
        pacaur -Rns $argv
    end

    function parep --wraps 'pacaur -Si' --description 'Display information about a package in the repositories'
        pacaur -Si $argv
    end

    function pareps --wraps 'pacaur -Ss' --description 'Search for packages in the repositories'
        pacaur -Ss $argv
    end

    function paloc --wraps 'pacaur -Qi' --description 'Display information about a package in the local database'
        pacaur -Qi $argv
    end

    function palocs --wraps 'pacaur -Qs' --description 'Search for packages in the local database'
        pacaur -Qs $argv
    end

    function palst --wraps 'pacaur -Qe' --description 'List installed packages including from AUR (tagged as "local")'
        pacaur -Qe $argv
    end

    function paorph --wraps 'pacaur -Qtd' --description 'Remove orphans using pacaur'
        pacaur -Qtd $argv
    end

    function painsd --wraps 'pacaur -S --asdeps' --description 'Install packages as dependencies of another package'
        pacaur -S --asdeps $argv
    end

    function pamir --wraps 'pacaur -Syy' --description 'Force refresh of all package lists after updating mirrorlist'
        pacaur -Syy $argv
    end

    function paupd --wraps 'pacaur -Sy' --description 'Update and refresh local package, ABS and AUR databases'
        pacaur -Sy $argv
    end
end

if type -q trizen
    function trconf --wraps 'trizen -C' --description 'Fix all configuration files with vimdiff'
        trizen -C $argv
    end

    function trupg --wraps 'trizen -Syua' --description 'Sync with repositories before upgrading all packages (from AUR too)'
        trizen -Syua $argv
    end

    function trsu --wraps 'trizen -Syua --no-confirm' --description 'Same as `trupg`, but without confirmation'
        trizen -Syua --no-confirm $argv
    end

    function trin --wraps 'trizen -S' --description 'Install packages from the repositories'
        trizen -S $argv
    end

    function trclean --wraps 'trizen -Sc' --description 'Clean out old and unused caches and packages'
        trizen -Sc $argv
    end

    function trclr --wraps 'trizen -Scc' --description 'Remove all files from the cache'
        trizen -Scc $argv
    end

    function trins --wraps 'trizen -U' --description 'Install a package from a local file'
        trizen -U $argv
    end

    function trre --wraps 'trizen -R' --description 'Remove packages, keeping its settings and dependencies'
        trizen -R $argv
    end

    function trrem --wraps 'trizen -Rns' --description 'Remove packages, including its settings and unneeded dependencies'
        trizen -Rns $argv
    end

    function trrep --wraps 'trizen -Si' --description 'Display information about a package in the repositories'
        trizen -Si $argv
    end

    function trreps --wraps 'trizen -Ss' --description 'Search for packages in the repositories'
        trizen -Ss $argv
    end

    function trloc --wraps 'trizen -Qi' --description 'Display information about a package in the local database'
        trizen -Qi $argv
    end

    function trlocs --wraps 'trizen -Qs' --description 'Search for packages in the local database'
        trizen -Qs $argv
    end

    function trlst --wraps 'trizen -Qe' --description 'List installed packages including from AUR (tagged as "local")'
        trizen -Qe $argv
    end

    function trorph --wraps 'trizen -Qtd' --description 'Remove orphans using yaourt'
        trizen -Qtd $argv
    end

    function trinsd --wraps 'trizen -S --asdeps' --description 'Install packages as dependencies of another package'
        trizen -S --asdeps $argv
    end

    function trmir --wraps 'trizen -Syy' --description 'Force refresh of all package lists after updating mirrorlist'
        trizen -Syy $argv
    end

    function trupd --wraps 'trizen -Sy' --description 'Update and refresh local package, ABS and AUR databases'
        trizen -Sy $argv
    end
end

if type -q yay
    function yaconf --wraps 'yay -Pg' --description 'Print current configuration'
        yay -Pg $argv
    end

    function yaclean --wraps 'yay -Sc' --description 'Clean out old and unused caches and packages'
        yay -Sc $argv
    end

    function yaclr --wraps 'yay -Scc' --description 'Remove all files from the cache'
        yay -Scc $argv
    end

    function yaupg --wraps 'yay -Syu' --description 'Sync with repositories before upgrading packages'
        yay -Syu $argv
    end

    function yasu --wraps 'yay -Syu --no-confirm' --description 'Same as `yaupg`, but without confirmation'
        yay -Syu --no-confirm $argv
    end

    function yain --wraps 'yay -S' --description 'Install packages from the repositories'
        yay -S $argv
    end

    function yains --wraps 'yay -U' --description 'Install a package from a local file'
        yay -U $argv
    end

    function yare --wraps 'yay -R' --description 'Remove packages, keeping its settings and dependencies'
        yay -R $argv
    end

    function yarem --wraps 'yay -Rns' --description 'Remove packages, including its settings and unneeded dependencies'
        yay -Rns $argv
    end

    function yarep --wraps 'yay -Si' --description 'Display information about a package in the repositories'
        yay -Si $argv
    end

    function yareps --wraps 'yay -Ss' --description 'Search for packages in the repositories'
        yay -Ss $argv
    end

    function yaloc --wraps 'yay -Qi' --description 'Display information about a package in the local database'
        yay -Qi $argv
    end

    function yalocs --wraps 'yay -Qs' --description 'Search for packages in the local database'
        yay -Qs $argv
    end

    function yalst --wraps 'yay -Qe' --description 'List installed packages including from AUR (tagged as "local")'
        yay -Qe $argv
    end

    function yaorph --wraps 'yay -Qtd' --description 'Remove orphans using yay'
        yay -Qtd $argv
    end

    function yainsd --wraps 'yay -S --asdeps' --description 'Install packages as dependencies of another package'
        yay -S --asdeps $argv
    end

    function yamir --wraps 'yay -Syy' --description 'Force refresh of all package lists after updating mirrorlist'
        yay -Syy $argv
    end

    function yaupd --wraps 'yay -Sy' --description 'Update and refresh local package, ABS and AUR databases'
        yay -Sy $argv
    end
end

if type -q paru
    function puclean --wraps 'paru -Sc' --description 'Clean out old and unused caches and packages'
        paru -Sc $argv
    end

    function puclr --wraps 'paru -Scc' --description 'Remove all files from the cache'
        paru -Scc $argv
    end

    function puin --wraps 'paru -S' --description 'Install packages from the repositories'
        paru -S $argv
    end

    function puins --wraps 'paru -U' --description 'Install a package from a local file'
        paru -U $argv
    end

    function puinsd --wraps 'paru -S --asdeps' --description 'Install packages as dependencies of another package'
        paru -S --asdeps $argv
    end

    function puloc --wraps 'paru -Qi' --description 'Display information about a package in the local database'
        paru -Qi $argv
    end

    function pulocs --wraps 'paru -Qs' --description 'Search for packages in the local database'
        paru -Qs $argv
    end

    function pulst --wraps 'paru -Qe' --description 'List installed packages including from AUR (tagged as "local")'
        paru -Qe $argv
    end

    function pumir --wraps 'paru -Syy' --description 'Force refresh of all package lists after updating mirrorlist'
        paru -Syy $argv
    end

    function puorph --wraps 'paru -Qtd' --description 'Remove orphans using paru'
        paru -Qtd $argv
    end

    function pure --wraps 'paru -R' --description 'Remove packages, keeping its settings and dependencies'
        paru -R $argv
    end

    function purem --wraps 'paru -Rns' --description 'Remove packages, including its settings and unneeded dependencies'
        paru -Rns $argv
    end

    function purep --wraps 'paru -Si' --description 'Display information about a package in the repositories'
        paru -Si $argv
    end

    function pureps --wraps 'paru -Ss' --description 'Search for packages in the repositories'
        paru -Ss $argv
    end

    function puupd --wraps 'paru -Sy' --description 'Update and refresh local package, ABS and AUR databases'
        paru -Sy $argv
    end

    function puupg --wraps 'paru -Syu' --description 'Sync with repositories before upgrading packages'
        paru -Syu $argv
    end

    function pusu --wraps 'paru -Syu --no-confirm' --description 'Same as `puupg`, but without confirmation'
        paru -Syu --no-confirm $argv
    end

    function pufiles --wraps 'paru -F' --description 'Search package file names for matching strings'
        paru -F $argv
    end
end

function upgrade --description 'Sync with repositories before upgrading packages'
    echo ":: Checking Arch Linux PGP Keyring..."
    set -l installedver (sudo pacman -Qi archlinux-keyring | grep -Po '(?<=Version         : ).*')
    set -l currentver (sudo pacman -Si archlinux-keyring | grep -Po '(?<=Version         : ).*')

    if test $installedver != $currentver
        echo " Arch Linux PGP Keyring is out of date."
        echo " Updating before full system upgrade."
        sudo pacman -Sy --needed --noconfirm archlinux-keyring
    else
        echo " Arch Linux PGP Keyring is up to date."
        echo " Proceeding with full system upgrade."
    end

    if type -q yay
        yay -Syu
    else if type -q trizen
        trizen -Syu
    else if type -q paru
        paru -Syu
    else if type -q pacaur
        pacaur -Syu
    else if type -q aura
        sudo aura -Syu
    else
        sudo pacman -Syu
    end
end
