# Mili
<p align="center">
  <img src="images/logo.png" alt="mili logo" width="400">
</p>

<p align="center">
	<img src="https://img.shields.io/github/license/SadeghHayeri/Mili.svg?colorB=red&style=for-the-badge"> <img src="https://img.shields.io/github/repo-size/SadeghHayeri/Mili.svg?colorB=blue&style=for-the-badge">
</p>


### Never see login pages again!

Mili is an open source tool for auto login hotspot pages. if you are tired of inserting username and password for internet access, Mili is your friend!

Every time you connect to a new WiFi, Mili checks Mikrotik services and try to login.

<p align="center">
	<img src="images/linux-notif.png" alt="linux mili notify" style="width: 471px;padding-bottom: 77px;"> <img src="images/mac-notif.png" alt="macos mili notify" style="width: 400px;padding-top: 45px;">
</p>

In addition, you can set more than one login info (for example your close friend password)
for Mili. every time Mili tries to use a random user! (yes! you can set **share percentage** too)

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
cd Mili/scripts
./install.sh
```

### Usage

##### `Init/change configs`
```
mili config
```

##### `Check and login`
```
mili
```

##### `Force login`
```
mili login
```

##### `Login with specific user (password must saved before)`
```
mili login <UserName>
```

##### `Status`
```
mili status
```

##### `Logout`
```
mili logout
```
