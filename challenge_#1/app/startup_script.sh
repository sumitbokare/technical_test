#!/bin/bash -v

#####################################
## DB Connection Settings in MyApp
######################################

if [[ $(sudo grep PERSISTENCE_URL_POSTGRES /usr/share/myapp/WEB-INF/classes/myapp.properties | wc -l) == "0" ]]; then
  echo "PERSISTENCE_URL_POSTGRES=jdbc:postgresql://${POSTGRESS_INSTANCE}:5432/${DATABASE_NAME}" >> /usr/share/myapp/WEB-INF/classes/myapp.properties
else
  sudo sed -i -e "/^PERSISTENCE_URL_POSTGRES=/ s/=.*/=jdbc:postgresql://${POSTGRESS_INSTANCE}:5432/${DATABASE_NAME}/" /usr/share/myapp/WEB-INF/classes/myapp.properties
fi

if [[ $(sudo grep PERSISTENCE_USERNAME_POSTGRES /usr/share/myapp/WEB-INF/classes/myapp.properties | wc -l) == "0" ]]; then
  echo "PERSISTENCE_USERNAME_POSTGRES=${POSTGRESS_USER}" >> /usr/share/myapp/WEB-INF/classes/myapp.properties
else
  sudo sed -i -e "/^PERSISTENCE_USERNAME_POSTGRES=/ s/=.*/=${POSTGRESS_USER}/" /usr/share/myapp/WEB-INF/classes/myapp.properties
fi

if [[ $(sudo grep PERSISTENCE_PASSWORD_POSTGRES /usr/share/myapp/WEB-INF/classes/myapp.properties | wc -l) == "0" ]]; then
  echo "PERSISTENCE_PASSWORD_POSTGRES=${POSTGRESS_PASSWORD}" >> /usr/share/myapp/WEB-INF/classes/myapp.properties
else
  sudo sed -i -e "/^PERSISTENCE_PASSWORD_POSTGRES=/ s/=.*/=${POSTGRESS_PASSWORD}/" /usr/share/myapp/WEB-INF/classes/myapp.properties
fi

sudo systemctl restart tomcat8.service
