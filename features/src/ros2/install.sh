#!/usr/bin/env bash

set -euo pipefail

ros_distro="${DISTRO:-auto}"
ros_package="${PACKAGE:-desktop}"
ros_workspace="${WORKSPACE:-${_REMOTE_USER_HOME:-/workspaces}/ros2_ws}"
feature_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
distribution_config="${feature_dir}/distributions.json"

if [[ "$(id -u)" -ne 0 ]]; then
    echo "The ROS 2 Feature must run as root." >&2
    exit 1
fi

if [[ ! -r /etc/os-release ]]; then
    echo "Unable to determine the base operating system." >&2
    exit 1
fi

# shellcheck disable=SC1091
source /etc/os-release

if [[ "${ID:-}" != "ubuntu" ]]; then
    echo "ROS 2 deb packages are supported only on Ubuntu; found ${ID:-unknown}." >&2
    exit 1
fi

case "${ros_package}" in
    ros-base | desktop)
        ;;
    *)
        echo "Unsupported ROS 2 package: ${ros_package}." >&2
        exit 1
        ;;
esac

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    jq \
    locales \
    software-properties-common

ubuntu_codename="${UBUNTU_CODENAME:-${VERSION_CODENAME:-}}"
ubuntu_release="$(jq -c --arg codename "${ubuntu_codename}" '.ubuntuReleases[$codename] // empty' "${distribution_config}")"

if [[ -z "${ubuntu_release}" ]]; then
    echo "Ubuntu ${VERSION_ID:-unknown} (${ubuntu_codename:-unknown}) is not supported by this ROS 2 Feature." >&2
    exit 1
fi

ubuntu_version="$(jq -r '.version' <<<"${ubuntu_release}")"

mapfile -t installed_distros < <(find /opt/ros -mindepth 1 -maxdepth 1 -type d -exec test -f '{}/setup.sh' \; -printf '%f\n' 2>/dev/null | sort)
existing_env_distro="${ROS_DISTRO:-}"

if [[ -n "${existing_env_distro}" && ! -f "/opt/ros/${existing_env_distro}/setup.sh" ]]; then
    echo "ROS_DISTRO=${existing_env_distro} is set, but /opt/ros/${existing_env_distro}/setup.sh does not exist." >&2
    exit 1
fi

if [[ "${ros_distro}" != "auto" ]]; then
    if [[ -n "${existing_env_distro}" && "${existing_env_distro}" != "${ros_distro}" ]]; then
        echo "Requested ROS 2 ${ros_distro}, but the base image selects ROS 2 ${existing_env_distro}. Refusing to create a mixed ROS environment." >&2
        exit 1
    fi
elif [[ -n "${existing_env_distro}" ]]; then
    ros_distro="${existing_env_distro}"
    echo "Using existing ROS_DISTRO=${ros_distro} from the base image."
elif [[ "${#installed_distros[@]}" -eq 1 ]]; then
    ros_distro="${installed_distros[0]}"
    echo "Using existing ROS 2 ${ros_distro} installation from the base image."
elif [[ "${#installed_distros[@]}" -gt 1 ]]; then
    echo "Multiple ROS 2 installations were found under /opt/ros and ROS_DISTRO is unset; select one explicitly with the distro option." >&2
    exit 1
else
    ros_distro="$(jq -r '.defaultDistro' <<<"${ubuntu_release}")"
    echo "Selected ROS 2 ${ros_distro} for Ubuntu ${VERSION_ID:-unknown} (${ubuntu_codename})."
fi

if ! jq -e --arg distro "${ros_distro}" '.supportedDistros | index($distro) != null' <<<"${ubuntu_release}" >/dev/null; then
    supported_distros="$(jq -r '.supportedDistros | join(", ")' <<<"${ubuntu_release}")"
    echo "ROS 2 ${ros_distro} is not supported on Ubuntu ${ubuntu_version} (${ubuntu_codename}); select one of: ${supported_distros}." >&2
    exit 1
fi

for installed_distro in "${installed_distros[@]}"; do
    if [[ "${installed_distro}" != "${ros_distro}" ]]; then
        echo "ROS 2 ${installed_distro} is already installed alongside selected ROS 2 ${ros_distro}. Refusing to configure an ambiguous ROS environment." >&2
        exit 1
    fi
done

apt-get install -y --no-install-recommends \
    bash-completion \
    build-essential \
    cmake \
    gdb \
    git \
    openssh-client \
    python3 \
    python3-argcomplete \
    python3-pip
locale-gen en_US en_US.UTF-8
update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
add-apt-repository -y universe

ros_apt_source_release_url="$(
    curl --fail --silent --show-error --location \
        --output /dev/null \
        --write-out '%{url_effective}' \
        https://github.com/ros-infrastructure/ros-apt-source/releases/latest
)"
ros_apt_source_version="${ros_apt_source_release_url##*/}"

if [[ ! "${ros_apt_source_version}" =~ ^[0-9]+(\.[0-9]+)+$ ]]; then
    echo "Unable to determine the latest ros2-apt-source release." >&2
    exit 1
fi

ros_apt_source_package="/tmp/ros2-apt-source.deb"
curl --fail --silent --show-error --location \
    "https://github.com/ros-infrastructure/ros-apt-source/releases/download/${ros_apt_source_version}/ros2-apt-source_${ros_apt_source_version}.${ubuntu_codename}_all.deb" \
    --output "${ros_apt_source_package}"
dpkg -i "${ros_apt_source_package}"
rm -f "${ros_apt_source_package}"

apt-get update
apt-get install -y --no-install-recommends \
    "ros-${ros_distro}-${ros_package}" \
    python3-colcon-common-extensions \
    python3-rosdep \
    python3-vcstool \
    ros-dev-tools \
    "ros-${ros_distro}-ament-*"

if [[ ! -e /etc/ros/rosdep/sources.list.d/20-default.list ]]; then
    rosdep init
fi

if [[ ! -e /etc/ros/rosdep/sources.list.d/20-default.list ]]; then
    echo "rosdep initialization did not create its default sources list." >&2
    exit 1
fi

cat > /etc/profile.d/ros2.sh <<EOF
export ROS_DISTRO="${ros_distro}"
export AMENT_CPPCHECK_ALLOW_SLOW_VERSIONS=1

if [ -f "/opt/ros/${ros_distro}/setup.sh" ]; then
    . "/opt/ros/${ros_distro}/setup.sh"
fi

if [ -f "${ros_workspace}/install/setup.sh" ]; then
    . "${ros_workspace}/install/setup.sh"
fi
EOF
chmod 0644 /etc/profile.d/ros2.sh

remote_user="${_REMOTE_USER:-${_CONTAINER_USER:-}}"
remote_user_home="${_REMOTE_USER_HOME:-${_CONTAINER_USER_HOME:-}}"
if [[ -n "${remote_user}" && -n "${remote_user_home}" && -d "${remote_user_home}" ]]; then
    shell_init="${remote_user_home}/.bashrc"
    touch "${shell_init}"
    if ! grep -Fq '[ -f /etc/profile.d/ros2.sh ] && . /etc/profile.d/ros2.sh' "${shell_init}"; then
        printf '\n%s\n' '[ -f /etc/profile.d/ros2.sh ] && . /etc/profile.d/ros2.sh' >> "${shell_init}"
    fi
    if ! grep -Fq '[ -f /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash ] && . /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash' "${shell_init}"; then
        printf '%s\n' '[ -f /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash ] && . /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash' >> "${shell_init}"
    fi
    chown "${remote_user}:$(id -gn "${remote_user}")" "${shell_init}"
else
    echo "No effective Dev Container user was provided; skipping user-specific shell configuration."
fi

rm -rf /var/lib/apt/lists/*

echo "Configured ROS 2 ${ros_distro} (${ros_package}) development environment."
