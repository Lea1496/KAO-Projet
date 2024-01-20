/*
-- =========================================================================== A
-- Création des tables du schéma Evenement
-- -----------------------------------------------------------------------------
Produit  : KAO
Version  : 0.0.0
Statut   : en développement
-- =========================================================================== A
*/
--
set schema 'evenement';
--
create domain annee as char(4) check (value similar to '[0-9]{4}');
comment on domain annee is
    $$ Le domaine pour une année $$;

create domain prix as float check (value > 0);
comment on domain prix is
    $$ Le domaine pour le prix dune inscription $$;

create domain courriel as varchar(320) check ( value ~
                                               '[A-Z,a-z,0-9,!,#,$,%,&,*,+,-,\/,=,?,^,_,`,{,|,},~]{1}[A-Z,a-z,0-9,!,#,$,%,&,*,+,-,\/,=,?,^,_,`,{,|,},~,.]{0,53}[A-Z,a-z,0-9,!,#,$,%,&,*,+,-,\/,=,?,^,_,`,{,|,},~]{1}@([A-Z,a-z,0-9,-]{0,63}\.)+[A-Z,a-z,0-9,-]{0,63}' );
comment on domain courriel is
    $$ Le domaine pour un courriel $$;

create type preference_Alimentaire as enum ('viande avec poisson','viande sans poisson','végétarien','végan','aucune préférence');
comment on type preference_Alimentaire is
    $$L'enum pour une préférence alimentaire$$;

create domain cip as char(8)
    check (value similar to '[a-z]{4}[0-9]{4}');
comment on domain cip is
    $$ Le domaine pour un cip de 8 caractères $$;

create domain id_Inscription as integer;
comment on domain id_Inscription is
    $$  Le domaine pour une clé artificielle pour une inscription$$;

create domain matricule as char(8)
    check (value similar to '[0-9]{8}');
comment on domain matricule is
    $$ Le domaine pour un matricule $$;

create domain nb_Personnes as integer check (value > 0);
comment on domain nb_Personnes is
    $$ Le domaine pour un nombre de personnes  $$;

create domain nom as varchar(60);
comment on domain nom is
    $$Le domaine pour un nom de personne  $$;

create domain id_Nourriture as integer;
comment on domain id_Nourriture is
    $$Le domaine pour une clé artificielle pour de la nourriture$$;

create domain nb_Chambres as integer check (value > 0);
comment on domain nb_Chambres is
    $$Le domaine pour un nombre de chambres$$;

create domain no_Tel as varchar(14)
    check ( value ~ '^\s*(?:\+?(\d{1,3}))?[-. (]*(\d{3})[-. )]*(\d{3})[-. ]*(\d{4})(?: *x(\d+))?\s*$');
comment on domain no_Tel is
    $$Le domaine pour un numéro de téléphone$$;

create type type_Nourriture as enum ('viande avec poisson','viande sans poisson','végétarien','végan');
comment on type type_Nourriture is
    $$Le domaine pour un type de nourriture$$;

create domain duree interval check (value <= '190 minute' and value > '0 minute');
comment on domain duree is
    $$ Le domaine pour une durée d'une activité $$;

create domain id_Organisateur integer;
comment on domain id_Organisateur is
    $$ Le domaine pour l'identifiant d'un organisateur $$;

create domain id_Endroit integer;
comment on domain id_Organisateur is
    $$ Le domaine pour une clé artificielle pour un endroit $$;

create domain numero_Salle varchar(10);
comment on domain numero_Salle is
    $$ Le domaine d'un numéro de salle d'une chaîne de caractères
    d'au plus 10 caractères qui débutent par une lettre de bâtiment
    suivie par un chiffre de bâtiment, un trait d'union, 4 chiffres,
    un trait d'union et 2 chiffres pour le numéro de la porte. $$;

create domain nb_Places integer check (value > 0);
comment on domain nb_Places is
    $$ Le domaine pour le nombre de place disponibles dans un endroit $$;

create type type_Activite as enum ('présentation', 'atelier', 'évaluation', 'travail d''équipe''', 'activité sociale', 'dîner', 'pause');
comment on type type_Activite is
    $$ Le type représantant le type de l'activité $$;

create type dernier_Diplome as enum ('baccalauréat', 'maitrise', 'doctorat');
comment on type dernier_Diplome is
    $$ Le type représantant le dernier diplome d'un participant $$;

create type type_inscription as enum ('étudiant', 'professionnel', 'conférencier');
comment on type type_inscription is
    $$ Le type pour le type d'inscription$$;

create type type_endroit as enum ('interne', 'externe', 'virtuel');
comment on type type_endroit is
    $$ Le type pour un type d'endroit $$;

create table evenement
(
    nom_Evenement                  varchar(42) not null,
    annee                          annee       not null,
    date_Debut                     date        not null,
    date_Fin                       date        not null,
    heure_Debut_Min                time        not null,
    heure_Fin_Max                  time        not null,
    prix_Inscription_Etudiant      prix        not null,
    prix_Inscription_Professionnel prix        not null,
    constraint evenement_cc00 primary key (nom_Evenement, annee),
    constraint heure_contrainte check (heure_Debut_Min < heure_Fin_Max),
    constraint date_contrainte check (date_Debut < date_Fin),
    constraint annee_contrainte check (extract(year from date_Debut) = annee::numeric),
    unique (nom_Evenement)

);
comment on table evenement is
    $$ Lévénement a un nom "nom_Evenement" se déroulant durant l’année “annee”
     a comme date de début “date_Debut” et finit la date “date_Fin”,
     a une heure de début minimum "heure_Debut_Min" et une heure de fin maximum "heure_Fin_Max",
     coûte “prix_Inscription_Etudiant” pour les étudiants
     et “prix_Inscription_Professionnel” pour les professionnels $$;

create table inscription
(
    id_Inscription         id_Inscription         not null,
    nom                    nom                    not null,
    prenom                 nom                    not null,
    courriel               courriel               not null,
    preference_Alimentaire preference_alimentaire not null,
    passe_STS              bool                   not null,
    commentaire            text                   not null,
    date                   date                   not null,
    constraint inscription_cc00 primary key (id_Inscription),
    constraint inscription_cu00 unique (courriel)
);
comment on table inscription is
    $$ L’inscrit identifié par “id_Inscription”” est décrit par son nom “nom”, prénom “prenom”,
    a le courriel “courriel”, est de type “type_Inscription”, a la préférence alimentaire “preference_Alimentaire”,
    a les intolérances ou allergies “intolerances_Alimentaire”, désire une passe STS “passe_STS”, a donné le commentaire “commentaire”,
   et a fait son inscription à la date “date”
  $$;

create table inscription_professionnel
(
    id_Inscription id_Inscription not null,
    domaine        varchar(42)    not null,
    poste          varchar(42)    not null,
    constraint inscription_professionnel_cc00 primary key (id_Inscription),
    constraint inscription_professionnel_cr00 foreign key (id_Inscription) references inscription (id_Inscription)
);
comment on table inscription_professionnel is
    $$ Le professionnel identifié par “id_Inscription” travaille dans le domaine “domaine” et occupe le poste “poste” $$;

create table inscription_participant
(
    id_Inscription  id_Inscription not null,
    dernier_Diplome dernier_Diplome  not null,
    constraint inscription_participant_cc00 primary key (id_Inscription),
    constraint inscription_participant_cr00 foreign key (id_Inscription) references inscription (id_Inscription)
);
comment on table inscription_participant is
    $$ Le participant “id_Inscription” a comme dernier diplôme “dernier_Diplome”  $$;

create table inscription_etudiant
(
    id_Inscription  id_Inscription not null,
    programme_Etude varchar(42)    not null,
    universite      varchar(42)    not null,
    constraint inscription_etudiant_cc00 primary key (id_Inscription),
    constraint inscription_etudiant_cr00 foreign key (id_Inscription) references inscription (id_Inscription)
);
comment on table inscription_etudiant is
    $$ L’étudiant identifié par “id_Inscription” a comme programme d’étude “programme_Etude” et va à l’université “universite”  $$;

create table inscription_conferencier
(
    id_Inscription id_Inscription not null,
    date_Arrivee   date           not null,
    date_Depart    date           not null,
    nb_Personnes   nb_Personnes   not null,
    constraint inscription_conferencier_cc00 primary key (id_Inscription),
    constraint inscription_conferencier_cr00 foreign key (id_Inscription) references inscription (id_Inscription),
    constraint inscription_conferencier_date check (date_Arrivee < date_Depart)
);
comment on table inscription_conferencier is
    $$ Le conférencier identifié par “id_Inscription” arrive à la date “date_Arrivee”
  et part à la date “date_Depart” avec “nb_Personnes” incluant lui-même  $$;

create table cip_matricule
(
    id_Inscription id_Inscription not null,
    matricule      matricule      not null,
    cip            cip            not null,
    constraint cip_matricule_cc00 primary key (id_Inscription),
    constraint cip_matricule_cr00 foreign key (id_Inscription) references inscription (id_Inscription),
    constraint cip_matricule_cu00 unique (matricule),
    constraint cip_matricule_cu01 unique (cip)
);
comment on table cip_matricule is
    $$ L’inscrit “id_Inscription” possède un code d’identification personnel “cip" et un matricule “matricule”  $$;

create table participation_evenement
(
    id_Inscription id_Inscription not null,
    nom_Evenement  varchar(42)    not null,
    constraint participation_evenement_cc00 primary key (id_Inscription, nom_Evenement),
    constraint participation_evenement_cr00 foreign key (id_Inscription) references inscription (id_Inscription),
    constraint participation_evenement_cr01 foreign key (nom_Evenement) references evenement (nom_Evenement)
);
comment on table participation_evenement is
    $$ L’inscrit “id_Inscription” participe à un événement "nom_Evenement"  $$;

create table intolerance
(
    nom_Intolerance varchar(42) not null,
    constraint intolerance_cc00 primary key (nom_Intolerance)
);
comment on table intolerance is
    $$L’intolérance ou allergie a pour nom “nom_Intolerance”$$;

create table participation_intolerance
(
    id_Inscription  id_Inscription not null,
    nom_Intolerance varchar(42)    not null,
    constraint participation_intolerance_cc00 primary key (id_Inscription, nom_Intolerance),
    constraint participation_intolerance_cr00 foreign key (id_Inscription) references inscription (id_Inscription),
    constraint participation_intolerance_cr01 foreign key (nom_Intolerance) references intolerance (nom_Intolerance)
);
comment on table participation_intolerance is
    $$L’inscrit “id_Inscription” possède l’intolérance ou allergie “nom_Intolerance”$$;

create table traiteur
(
    nom_Traiteur varchar(42) not null,
    no_Tel       no_Tel      not null,
    courriel     courriel    not null,
    constraint traiteur_cc00 primary key (nom_Traiteur),
    constraint traiteur_cu00 unique (courriel)
);
comment on table traiteur is
    $$ Le traiteur identifié par le nom “nom_Traiteur” a comme numéro de téléphone “no_Tel” et le courriel “courriel” $$;

create table nourriture
(
    id_Nourriture   id_Nourriture   not null,
    nom_Nourriture  varchar(42)     not null,
    type_Nourriture type_Nourriture not null,
    nom_Traiteur    varchar(42)     not null,
    constraint nourriture_cc00 primary key (id_Nourriture),
    constraint nourriture_cr00 foreign key (nom_Traiteur) references traiteur (nom_Traiteur)
);
comment on table nourriture is
    $$La nourriture identifiée par “id_Nourriture”
     a pour nom “nom_Nourriture” est de type “type_Nourriture” et est offert par “nom_Traiteur”$$;

create table nourriture_du_jour
(
    date              date          not null,
    moment_Nourriture time          not null,
    id_Nourriture     id_nourriture not null,
    constraint nourriture_du_jour_cc00 primary key (date, moment_Nourriture, id_Nourriture),
    constraint nourriture_du_jour_cr00 foreign key (id_Nourriture) references nourriture (id_Nourriture)
);
comment on table nourriture_du_jour is
    $$La nourriture identifiée par “id_Nourriture”
     est donnée à la date “date” au moment “moment_Nourriture”$$;

create table intolerance_nourriture
(
    id_Nourriture   id_nourriture not null,
    nom_Intolerance varchar(42)   not null,
    constraint intolerance_nourriture_cc00 primary key (id_Nourriture, nom_Intolerance),
    constraint intolerance_nourriture_cr00 foreign key (nom_Intolerance) references intolerance (nom_Intolerance),
    constraint intolerance_nourriture_cr01 foreign key (id_Nourriture) references nourriture (id_Nourriture)
);
comment on table intolerance_nourriture is
    $$La nourriture identifiée par “id_Nourriture” peut causer l’intolérance ou allergie “nom_Intolerance”$$;

create table participation_nourriture
(
    date              date           not null,
    moment_Nourriture time           not null,
    id_Inscription    id_inscription not null,
    constraint participation_nourriture_cc00 primary key (id_Inscription, date, moment_Nourriture),
    constraint participation_nourriture_cr00 foreign key (id_Inscription) references inscription (id_Inscription)
);
comment on table participation_nourriture is
    $$L’inscrit identifié par “id_Inscription”
    a besoin d’un repas à la date “date” au moment “moment_Repas”$$;

create table hotel
(
    nom_Hotel   varchar(42) not null,
    no_Tel      no_Tel      not null,
    courriel    courriel    not null,
    adresse     varchar(42) not null,
    nb_Chambres nb_Chambres not null,
    constraint hotel_cc00 primary key (nom_Hotel),
    constraint hotel_cu00 unique (courriel)
);
comment on table hotel is
    $$L’hôtel identifié par le nom “nom_Hotel”
    a comme numéro de téléphone “no_Tel”
    et le courriel “courriel”, est situé à l’adresse “adresse”
    et a un nombre de chambres disponibles “nb_Chambres” $$;

create table transporteur
(
    nom_Transporteur varchar(42) not null,
    no_Tel           no_Tel      not null,
    courriel         courriel    not null,
    constraint transporteur_cc00 primary key (nom_Transporteur),
    constraint transporteur_cu00 unique (courriel)
);
comment on table transporteur is
    $$Le transporteur identifié par le nom “nom_Transporteur”
     a comme numéro de téléphone “no_Tel” et le courriel “courriel”$$;

create table attribution_chambre
(
    id_Inscription id_Inscription not null,
    nom_Hotel      varchar(42)    not null,
    date_Debut     date           not null,
    date_Fin       date           not null,
    constraint attribution_chambre_cc00 primary key (id_Inscription, nom_Hotel, date_Debut, date_Fin),
    constraint attribution_chambre_cr00 foreign key (id_Inscription) references inscription (id_Inscription),
    constraint attribution_chambre_cr01 foreign key (nom_Hotel) references hotel (nom_Hotel),
    constraint date check ( date_Debut < date_Fin )
);
comment on table attribution_chambre is
    $$ L’inscrit identifié par “id_Inscription”
    a été attribué une chambre à l’hôtel “nom_Hotel”
    pour loger “nb_Personnes” de la date de début
    “date_Debut” jusqu’à la date “date_Fin” $$;

create table attribution_transport
(
    id_Inscription   id_Inscription not null,
    nom_Transporteur varchar(42)    not null,
    date             date           not null,
    heure            time           not null,
    constraint attribution_transport_cc00 primary key (id_Inscription, nom_Transporteur, date, heure),
    constraint attribution_transport_cr00 foreign key (id_Inscription) references inscription (id_Inscription),
    constraint attribution_transport_cr01 foreign key (nom_Transporteur) references transporteur (nom_Transporteur)
);
comment on table attribution_transport is
    $$ L’inscrit identifié par “id_Inscription” a été attribué un transport chez “nom_Transporteur” à la date "date" et à l’heure “heure” $$;

create table organisateur
(
    id_Organisateur id_Organisateur not null,
    nom             nom             not null,
    prenom          nom             not null,
    domaine         varchar(42)     not null,
    constraint organisateur_cc00 primary key (id_Organisateur)
);
comment on table organisateur is
    $$ L’organisateur identifié par “id_Organisateur”
est décrit par son nom “nom”, prénom “prenom”
et est expert dans le domaine “domaine” $$;

create table endroit
(
    id_Endroit id_Endroit not null,
    constraint endroit_cc00 primary key (id_Endroit)
);
comment on table endroit is
    $$ L'endroit est identifié par “id_Endroit” $$;

create table endroit_interne
(
    id_Endroit   id_Endroit   not null,
    numero_Salle numero_Salle not null,
    nb_Places    nb_Places    not null,
    constraint endroit_interne_cc00 primary key (id_Endroit),
    constraint endroit_interne_cr00 foreign key (id_Endroit) references endroit (id_Endroit),
    constraint endroit_interne_cu00 unique (numero_Salle)
);
comment on table endroit_interne is
    $$ L'endroit interne identifié par “id_Endroit”
    a comme salle “numero_Salle” et un nombre de
    places “nb_Places” $$;

create table endroit_externe
(
    id_Endroit id_Endroit  not null,
    adresse    varchar(60) not null,
    nb_Places  nb_Places   not null,
    constraint endroit_externe_cc00 primary key (id_Endroit),
    constraint endroit_externe_cr00 foreign key (id_Endroit) references endroit (id_Endroit),
    constraint endroit_externe_cu00 unique (adresse)
);
comment on table endroit_externe is
    $$ L'endroit externe identifié par “id_Endroit”
    a comme adresse “adresse” et un nombre de
    places disponibles “nb_Places” $$;

create table endroit_virtuel
(
    id_Endroit id_Endroit   not null,
    lien       varchar(120) not null,
    constraint endroit_virtuel_cc00 primary key (id_Endroit),
    constraint endroit_virtuel_cr00 foreign key (id_Endroit) references endroit (id_Endroit),
    constraint endroit_virtuel_cu00 unique (lien)
);
comment on table endroit_virtuel is
    $$ L'endroit virtuel identifié par “id_Endroit” a comme
    lien pour accéder à la conférence virtuellement “lien” $$;

create table theme
(
    nom_Theme       varchar(42)     not null,
    id_Organisateur id_Organisateur not null,
    nom_Evenement   varchar(42)     not null,
    description     text            not null,
    constraint theme_cc00 primary key (nom_Theme),
    constraint theme_cr00 foreign key (id_Organisateur) references organisateur (id_Organisateur),
    constraint theme_cr01 foreign key (nom_Evenement) references evenement (nom_Evenement)
);
comment on table theme is
    $$ Le thème identifié par son nom "nom_Theme"
    est organisé par un responsable identifié par son "id_Organisateur",
    fait parti de l'événement "nom_evenement"
     et sa description "description" $$;

create table activite
(
    nom_Activite  varchar(42)   not null,
    description   text          not null,
    nom_Theme     varchar(42)   not null,
    id_Endroit    id_Endroit    not null,
    type_Activite type_Activite not null,
    date          date          not null,
    heure_Debut   time          not null,
    duree         duree         not null,
    constraint activite_cc00 primary key (nom_Activite, date, heure_Debut),
    constraint activite_cr00 foreign key (id_Endroit) references endroit (id_Endroit),
    constraint activite_cr01 foreign key (nom_Theme) references theme (nom_Theme),
    constraint activite_cu00 unique (nom_Activite)
);
comment on table activite is
    $$ L’activité identifiée par le nom “nom_Activite”,
     a comme description "description",
a pour thème “nom_Theme”, est à l'endroit "id_Endroit",
est de type “type_Activite”, est donnée à la date “date”,
 commence à l’heure “heure_Debut” et a une durée “duree”$$;

create table activite_sociale
(
    nom_Activite   varchar(42)    not null,
    id_Inscription id_Inscription not null,
    constraint activiteso_cc00 primary key (nom_Activite, id_Inscription),
    constraint activiteso_cr00 foreign key (nom_Activite) references activite (nom_Activite),
    constraint activiteso_cr01 foreign key (id_Inscription) references inscription (id_Inscription)

);
comment on table activite_sociale is
    $$L'activité sociale a pour nom "nom_Activite"
et le participant identifié par "id_Inscription" y participe $$;

create table conference
(
    nom_Activite   varchar(42)    not null,
    id_Inscription id_Inscription not null,
    constraint conference_cc00 primary key (nom_Activite, id_Inscription),
    constraint conference_cr00 foreign key (nom_Activite) references activite (nom_Activite),
    constraint conference_cr01 foreign key (id_Inscription) references inscription (id_Inscription)
);
comment on table conference is
    $$La conférence a pour nom "nom_Activite"
et c'est le conférencier identifié par "id_Inscription" qui la donne$$;
--
/*
-- =========================================================================== Z
Contributeurs :
  (LR) Lea.Roy4@USherbrooke.ca
  (MBL)Matis.BerubeLauziere@USherbrooke.ca
  (GK) Kosg1101@usherbrooke.ca

Tâches projetées :

Tâches réalisées :
  2023-11-16 (LR) : Création
-- -----------------------------------------------------------------------------
-- Fin de table_cre.sql
-- =========================================================================== Z
*/

