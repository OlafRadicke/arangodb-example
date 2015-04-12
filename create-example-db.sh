# Bash-Skript das über die REST-API eine Datenbank erstellt.

# Passwort und User-Name setzen
PASSWORD="IFFr60y13oxMkdhc"
DBUSER="arango"
DBSERVER="http://fuerth.fritz.box:8529"
DATABASE="networkcookbook"

# Alte Datenbank löschen, wenn sie noch existiert

# curl -u ${DBUSER}:${PASSWORD} -X DELETE -d \
#    ${DBSERVER}/_api/database/${DATABASE}

curl -u ${DBUSER}:${PASSWORD} -X DELETE  \
   ${DBSERVER}/_api/database/${DATABASE}

# Abbrechen so bald etwas schief läuft
set -e

# Datenbank erstellen
curl -u ${DBUSER}:${PASSWORD} -X POST -d \
   "{ \"name\": \"${DATABASE}\", \"users\": [{  \"username\": \"cookadmin\", \"passwd\": \"${PASSWORD}\", \"active\": \"true\"}] }"  \
   ${DBSERVER}/_api/database


# curl -u ${DBUSER}:${PASSWORD} -X POST -d \
#    "{ name: \"${DATABASE}\",  username: \"${DBUSER}\", passwd: \"${PASSWORD}\", active: \"true\" }"  \
#    ${DBSERVER}/_api/database

# curl -u ${DBUSER}:${PASSWORD} -X POST -d \
#    "{ \"name\": \"${DATABASE}\"}"  \
#    ${DBSERVER}/_api/database

# curl -v -u ${DBUSER}:${PASSWORD} -X POST --data-binary @- --dump - ${DBSERVER}/_api/database
# {"name":"example"}

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
# curl -u ${DBUSER}:${PASSWORD}  -X POST -d \
#    '{ "name": "Spiegeleier", "anweisung": "Eier in die Pfanne schlagen. Pfeffern und salzen." }'  \
#    ${DBSERVER}/_db/${DATABASE}/_api/document?collection=cooking_recipe

# Rezept erstellen
curl -u ${DBUSER}:${PASSWORD} -H "Content-Type: application/json" -X POST -d \
   '{ collection: "cooking_recipe", document: "{ "name": "Ruheei", "anweisung": "Eier in die Pfanne schlagen und verrühren. Pfeffern und salzen." }"} ' \
   ${DBSERVER}/_db/${DATABASE}/_api/document/

# curl -u ${DBUSER}:${PASSWORD} -X POST --data-binary @- --dump - ${DBSERVER}/_api/document?collection=products
# { "Hello": "World" }


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
   '{ name: "2015-03-29-Muenchnerstr-7", "date": "2015-03-29", "location": "Münchnerstr. 7" }' \
   "${DBSERVER}/_db/${DATABASE}/_api/document?collection=cookingsession"

# Daten zur Kochveranstaltung
curl -u ${DBUSER}:${PASSWORD} -X POST -d \
   '{ "date": "2015-01-20", "location": "Kapperweg 17" }' \
   "${DBSERVER}/_db/${DATABASE}/_api/document?collection=cookingsession"


# Daten zur Kochveranstaltung
curl -u ${DBUSER}:${PASSWORD} -X POST -d \
   '{ "date": "2015-01-22", "location": "Hintere Gasse 22" }' \
   "${DBSERVER}/_db/${DATABASE}/_api/document?collection=cookingsession"


#### love_it ####

#curl -u ${DBUSER}:${PASSWORD} -X POST --data-binary @- -d \
#   '{ "name" : "love_it" }' \
#   "${DBSERVER}/_db/${DATABASE}/_api/edge/?collection=love_it&from=cookingfriend&to=cookingsession/1"


#### Graphen ####

# curl -u ${DBUSER}:${PASSWORD} -X POST -d \
#   '{name: "variande", edgeDefinitions: ["love_it"], orphanCollections: ["2015-03-29-Muenchnerstr-7", "Rudi"]}'
#   ${DBSERVER}/_db/${DATABASE}/_api/gharial

#### REPORT ####

# Alle Datenbanken auflisten
echo "-----------------------------------"
echo "all databases:"
echo "-----------------------------------"
curl -u ${DBUSER}:${PASSWORD} --dump - ${DBSERVER}/_api/database/


echo "-----------------------------------"
echo "informaion about databases ${DATABASE}:"
echo "-----------------------------------"
curl -u ${DBUSER}:${PASSWORD} --dump - ${DBSERVER}/_api/databases/${DATABASE}


# Alle collections
echo "-----------------------------------"
echo "all collections:"
echo "-----------------------------------"
curl -u ${DBUSER}:${PASSWORD} --dump -d \
    ${DBSERVER}/_api/collection

# Alle edges
echo "-----------------------------------"
echo "all edges"
echo "-----------------------------------"
curl -u ${DBUSER}:${PASSWORD} --dump -d \
    ${DBSERVER}/_db/${DATABASE}/_api/edge


# Alle Graphen
echo "-----------------------------------"
echo "all graphs:"
echo "-----------------------------------"
curl -u ${DBUSER}:${PASSWORD} -X GET \
   ${DBSERVER}/_db/${DATABASE}/_api/gharial

