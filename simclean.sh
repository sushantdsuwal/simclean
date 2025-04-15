#!/bin/bash

# Function to list running simulators and extract the UDID (unique device ID)
list_simulators() {
  xcrun simctl list devices | grep 'Booted' | awk -F '[()]' '{print $2 " " $3}'
}

# Function to list installed apps from the simulator's Applications directory
list_installed_apps() {
  local simulator_id="$1"
  local installed_apps=$(xcrun simctl listapps "$simulator_id")

  # Filter for CFBundleIdentifier and exclude Apple IDs
  echo "$installed_apps" | grep 'CFBundleIdentifier' | awk -F ' = ' '{print $2}' | tr -d '";' | grep -v '^com.apple'
}

# Function to clear the cache of the app
clear_cache() {
  local simulator_id="$1"
  local package_id="$2"

  # Get the app's data container directory
  app_data_dir=$(xcrun simctl get_app_container "$simulator_id" "$package_id" data)

  # Debug: Print the app data directory
  echo "App data directory for $package_id: $app_data_dir"

  # Check if the data directory exists
  if [ -d "$app_data_dir" ]; then
    echo "Clearing App data directory for $package_id on simulator $simulator_id..."
    rm -rf "$app_data_dir"
  else
    echo "App data directory not found. Make sure the app is installed on the simulator."
  fi
}

# List running simulators
echo "Fetching running simulators..."
simulators=$(list_simulators)

if [ -z "$simulators" ]; then
  echo "No running simulators found."
  exit 1
fi

# Display available simulators
echo "Running simulators:"
IFS=$'\n' simulators_list=($simulators)
for i in "${!simulators_list[@]}"; do
  echo "$((i+1)). ${simulators_list[$i]}"
done

# Prompt for simulator selection if more than one
if [ "${#simulators_list[@]}" -gt 1 ]; then
  read -p "Select a simulator (enter the number): " simulator_choice
  if ! [[ "$simulator_choice" =~ ^[0-9]+$ ]] || [ "$simulator_choice" -le 0 ] || [ "$simulator_choice" -gt "${#simulators_list[@]}" ]; then
    echo "Invalid selection."
    exit 1
  fi
  selected_simulator="${simulators_list[$((simulator_choice-1))]}"
else
  selected_simulator="${simulators_list[0]}"
fi

# Extract the simulator ID (UDID)
simulator_id=$(echo "$selected_simulator" | awk '{print $NF}')

# List installed apps on the selected simulator excluding Apple apps
echo "Fetching installed non-Apple apps on simulator $simulator_id..."
installed_apps=$(list_installed_apps "$simulator_id")

if [ -z "$installed_apps" ]; then
  echo "No non-Apple apps installed on this simulator."
  exit 1
fi

# Display available non-Apple apps
IFS=$'\n' installed_apps_list=($installed_apps)
for i in "${!installed_apps_list[@]}"; do
  echo "$((i+1)). ${installed_apps_list[$i]}"
done

# Prompt for app selection
read -p "Select an app to clear cache (enter the number): " app_choice
if ! [[ "$app_choice" =~ ^[0-9]+$ ]] || [ "$app_choice" -le 0 ] || [ "$app_choice" -gt "${#installed_apps_list[@]}" ]; then
  echo "Invalid selection."
  exit 1
fi

selected_app="${installed_apps_list[$((app_choice-1))]}"
package_id="$selected_app"

# Clear cache for the selected app on the selected simulator
clear_cache "$simulator_id" "$package_id"
