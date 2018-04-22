# vps-traffic-bot
<img alt="screenshot" src="https://github.com/frostbolt/vps-traffic-bot/raw/master/imgs/screenshot.jpg" width=250>

simple telegram-bot based on [vnStat](http://humdi.net/vnstat/) utility that shows how much traffic you spent this month
## Installation

### 1. Install requirenments
* Install ruby with bundler
  ```
  # mpapis public key used to verify installation package to ensure security.
  gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
  # RVM stable with ruby and bundler (may take a while)
  sudo \curl -sSL https://get.rvm.io | bash -s stable --gems=bundler
  ```
* Install vnstat
  ```
  sudo apt-get install vnstat
  ```

### 2. Setup an application
* add a new user, clone repo to it's ~, install dependencies locally
    ```
    sudo adduser trafficbot_app
    su trafficbot_app
    cd ~ 
    git clone https://github.com/frostbolt/vps-traffic-bot
    cd vps-traffic-bot
    bundle install --path vendor/bundle
    ```
* create bot with [@botfather](http://t.me/botfather), place your token to `config.yml`
* check if everything is OK
    ```
    bundle exec ruby app.rb
    ```
* make sure to `exit` so you return to your usual user
    
### 3. Create a systemctl service
  run `nano /usr/lib/systemd/system/vpstrafficbot.service`, insert the following fragment

  ```
  #[Unit]
  #Description=telegram bot for checking network adapter TX packages
  #After=syslog.target network.target remote-fs.target nss-lookup.target

  #[Service]
  #Type=simple
  #User=trafficbot_app
  #Group=trafficbot_app

  #WorkingDirectory=/home/trafficbot_app/vps-traffic-bot
  #PIDFile=/home/trafficbot_app/vps-traffic-bot/pi_tweet_bot.pid

  #ExecStart=/bin/bash -lc 'bundle exec ruby app.rb'
  #ExecStop=/bin/kill -s TERM $MAINPID ; /bin/sleep 1
  #TimeoutSec=30
  #RestartSec=15s
  #Restart=always

  #[Install]
  #WantedBy=multi-user.target
  ```

### 3. enjoy!
  run `systemctl start vpstrafficbot` and that's it.

## Thanks
* [ykslol](https://github.com/ykslol)
