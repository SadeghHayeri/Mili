# Mili

<p align="center">
  <img src="logo/logo.png" alt="Notable" width="400">
  <img src="https://img.shields.io/github/license/SadeghHayeri/Mili.svg?colorB=red&style=for-the-badge"> <img src="https://img.shields.io/github/repo-size/SadeghHayeri/Mili.svg?colorB=blue&style=for-the-badge">
</p>


###### Never see login pages again!

Mili is an open source tools for auto login hotspot pages, if you tierd inserting username and password for internet access, Mili is your friend!

Every time you connect to new WiFi, Mili check Mikrotik services, if found try login using your login information and show you success notification!

[[notification sample]]

In addittonal you can set more than one login info (for example your close friend password)
for Mili, every time Mili try using random user! (yes! you can set **share percentage** too)

Example:
```
"login_information" : [
		{
			"username": "USER 1",
			"password": "PASS 1",
			"share": 5
		},
		{
			"username": "USER 2",
			"password": "PASS 2",
			"share": 1
		},
	]
```

### Installation
```
git clone https://github.com/SadeghHayeri/Mili.git
cd Mili/scritps
./install.sh
```

### Usage
```
# Check and Login
mili

# Login with specific user (password must saved before)
miili login <UserName>

# Login with unsaved username and password (NOT SAFE)
mili login <UserName> <Password>

# Status
mili status

# Logout
mili logout
```
