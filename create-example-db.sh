# Bash-Skript das über die REST-API eine Datenbank erstellt.

# Passwort und User-Name setzen
PASSWORD="IFFr60y13oxMkdhc"
DBUSER="arango"
DBSERVER="http://fuerth.fritz.box:8529"
DATABASE="networkcookbook"

# Alte Datenbank löschen, wenn sie noch existiert

# curl -u ${DBUSER}:${PASSWORD} -X DELETE -d \
#    ${DBSERVER}/_api/database/${DATABASE}

curl -u ${DBUSER}:${PASSWORD} -X DELETE  @- -d \
   ${DBSERVER}/_api/database/${DATABASE}

# Abbrechen so bald etwas schief läuft
set -e

# Datenbank erstellen
curl -u ${DBUSER}:${PASSWORD} -X POST -d \
   '{"name":"networkcookbook"}'  \
   ${DBSERVER}/_api/database

#### Collection von Typ document ####

# Für die Kochrezepte eine collection von Typ document erstellen
curl -u ${DBUSER}:${PASSWORD} -X POST -d \
   '{"name":"cooking_recipe"}'   \
   ${DBSERVER}/_db/${DATABASE}/_api/collection

# Für die Kochfreunde eine collection von Typ document erstellen
curl -u ${DBUSER}:${PASSWORD} -X POST -d \
   '{"name":"cookingfriend"}'   \
   ${DBSERVER}/_db/${DATABASE}/_api/collection

# Für die Kochveranstaltungen eine collection von Typ document erstellen
curl -u ${DBUSER}:${PASSWORD} -X POST -d \
   '{"name":"cookingsession"}'   \
   ${DBSERVER}/_db/${DATABASE}/_api/collection

#### Collection des typs edges ####

# Für die Bewertung des Essens eine collection des typs edges erstellen
curl -u ${DBUSER}:${PASSWORD} -X POST -d \
   '{"name":"love_it", "type":3}' \
   ${DBSERVER}/_db/${DATABASE}/_api/collection

# Für die Rezeptvarianten der Kochrezepte eine collection des typs edges erstellen
curl -u ${DBUSER}:${PASSWORD}  -X POST -d \
   '{"name":"love_it", "type":3}' \
   ${DBSERVER}/_db/${DATABASE}/_api/collection

# Für die Köche der Treffen eine collection des typs edges erstellen
curl -u ${DBUSER}:${PASSWORD}  -X POST -d \
   '{"name":"cooked", "type":3}' \
   ${DBSERVER}/_db/${DATABASE}/_api/collection

#### KOCHREZEPTE ####

# Rezept erstellen
curl -u ${DBUSER}:${PASSWORD}  -X POST -d \
   '{ "name": "Spiegeleier", "anweisung": "Eier in die Pfanne schlagen. Pfeffern und salzen." }'  \
   ${DBSERVER}/_db/${DATABASE}/_api/document?collection=cooking_recipe

# Rezept erstellen
curl -u ${DBUSER}:${PASSWORD} -X POST -d \
   '{ "name": "Ruheei", "anweisung": "Eier in die Pfanne schlagen und verrühren. Pfeffern und salzen." }' \
   ${DBSERVER}/_db/${DATABASE}/_api/document?collection=cooking_recipe

#### KOCHFREUNDE ####

# Daten zum Koch erstellen
curl -u ${DBUSER}:${PASSWORD} -X POST -d \
   '{ "name": "Rudi", "sex": "man", dontliks: ["Fleisch", "Fisch","Rosienen"] }' \
   ${DBSERVER}/_db/${DATABASE}/_api/document?collection=cookingfriend

# Daten zum Koch erstellen
curl -u ${DBUSER}:${PASSWORD} -X POST -d \
   '{ "name": "Anne", "sex": "female", dontliks: ["Tomaten", "Knoblauch"] }' \
   ${DBSERVER}/_db/${DATABASE}/_api/document?collection=cookingfriend

# Daten zum Koch erstellen
curl -u ${DBUSER}:${PASSWORD} -X POST -d \
   '{ "name": "Gunter", "sex": "female", dontliks: ["Oliven"] }' \
   ${DBSERVER}/_db/${DATABASE}/_api/document?collection=cookingfriend

#### KOCHVERANSTALTUNGEN ####

# Daten zur Kochveranstaltung
curl -u ${DBUSER}:${PASSWORD} -X POST -d \
   '{ "date": "2015-03-29", "location": "Münchnerstr. 7" }' \
   ${DBSERVER}/_db/${DATABASE}/_api/document?collection=cookingsession

# Daten zur Kochveranstaltung
curl -u ${DBUSER}:${PASSWORD} -X POST -d \
   '{ "date": "2015-01-20", "location": "Kapperweg 17" }' \
   ${DBSERVER}/_db/${DATABASE}/_api/document?collection=cookingsession


# Daten zur Kochveranstaltung
curl -u ${DBUSER}:${PASSWORD} -X POST -d \
   '{ "date": "2015-01-22", "location": "Hintere Gasse 22" }' \
   ${DBSERVER}/_db/${DATABASE}/_api/document?collection=cookingsession


#### love_it ####

curl -u ${DBUSER}:${PASSWORD} -X POST --data-binary @- -d \
   '{ "name" : "first love_it" }' \
   ${DBSERVER}/_db/${DATABASE}/_api/edge/?collection=love_it&from=vertices/1&to=vertices/2


#### REPORT ####

curl -u ${DBUSER}:${PASSWORD} --dump -d \
    ${DBSERVER}/_db/${DATABASE}/_api/collection

curl -u ${DBUSER}:${PASSWORD} --dump -d \
    ${DBSERVER}/_db/${DATABASE}/_api/edge

