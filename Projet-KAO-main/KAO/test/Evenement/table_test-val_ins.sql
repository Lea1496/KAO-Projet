/*
-- =========================================================================== A
-- Insertion des données valides pour tester les tables.
-- -----------------------------------------------------------------------------
Produit  : KAO
Version  : 0.0.0
Statut   : en développement
-- =========================================================================== A
*/
--
set schema 'evenement';
--
insert into evenement(nom_evenement, annee, date_debut, date_fin, heure_debut_min, heure_fin_max,
                      prix_inscription_etudiant, prix_inscription_professionnel)
values ('Wahou', 2016, '2016-06-08'::date, '2016-06-15'::date, '8:00'::time, '20:00'::time, 1900, 1500),
       ('Wehee', 2016, '2016-06-08'::date, '2016-06-15'::date, '8:00'::time, '20:00'::time, 1900, 1500);

insert into inscription(id_inscription, nom, prenom, courriel, preference_alimentaire,
                        passe_sts, commentaire, date)
values (0, 'nom', 'prenom', 'abcde@fgh.ijk', 'viande avec poisson', true, '', '2023-11-19');

insert into inscription(id_inscription, nom, prenom, courriel, preference_Alimentaire,
                        passe_STS, commentaire, date)
values (12345678, 'Dupont', 'Jean', 'jean.dupont@example.com', 'aucune préférence', true,
        'Pas de commentaire','2015-11-20'),
       (1, 'Dupont', 'Jean', 'je.dupont@example.com', 'végétarien', true,
        'Pas de commentaire', '2023-11-20'),
       (2, 'nom2', 'prenom2', 'abcde2@fgh.ijk', 'viande avec poisson', true, '', '2015-11-20'),
       (3, 'nom3', 'prenom3', 'abcde3@fgh.ijk', 'végan', true, '',  '2023-11-20')
;
insert into inscription_participant(id_inscription, dernier_Diplome)
values (0, 'baccalauréat'),
       (2, 'maitrise'),
       (12345678, 'doctorat');
insert into inscription_professionnel(id_inscription, domaine, poste)
values (2, 'Informatique', 'Développeur');
insert into inscription_etudiant(id_inscription, programme_Etude, universite)
values (12345678, 'Génie Logiciel', 'Université de Sherbrooke');
insert into inscription_conferencier(id_inscription, date_Arrivee, date_Depart, nb_Personnes)
values (1, '2016-06-8', '2016-06-11', 1),
       (3, '2023-11-25', '2023-11-30', 1);
insert into cip_matricule(id_inscription, matricule, cip)
values (12345678, '00000001', 'abcd1234');

insert into participation_evenement(id_Inscription, nom_Evenement)
values (12345678, 'Wahou');

insert into intolerance(nom_intolerance)
values ('Arachides');
insert into participation_intolerance(id_inscription, nom_intolerance)
values (0, 'Arachides');
insert into traiteur(nom_traiteur, no_tel, courriel)
values ('traiteur', '000-000-0000', 'abcde@fgh.ijk'),
       ('traiteur1', '000-000-0000', 'abcde1@fgh.ijk');
insert into nourriture(id_nourriture, nom_nourriture, type_nourriture, nom_traiteur)
values (0, 'nourriture', 'viande avec poisson', 'traiteur'),
       (1, 'nourriture1', 'végan', 'traiteur1');
insert into nourriture_du_jour(date, moment_nourriture, id_nourriture)
values ('2023-11-19', '12:00', 0),
       ('2023-11-20', '12:00', 1);
insert into intolerance_nourriture(id_nourriture, nom_intolerance)
values (0, 'Arachides');
insert into participation_nourriture(date, moment_nourriture, id_inscription)
values ('2023-11-19', '12:00', 0),
       ('2023-11-20', '12:00', 0),
       ('2023-11-20', '12:00', 2),
       ('2023-11-20', '12:00', 3),
       ('2023-11-20', '12:00', 12345678),
       ('2023-11-21', '12:00', 2),
       ('2023-11-21', '12:00', 3),
       ('2023-11-21', '12:00', 12345678);
insert into hotel(nom_hotel, no_tel, courriel, adresse, nb_chambres)
values ('hotel', '000-000-0000', 'abcde@fgh.ijk', 'adresse', 100);
insert into transporteur(nom_transporteur, no_tel, courriel)
values ('transporteur', '000-000-0000', 'abcde@fgh.ijk');
insert into attribution_chambre(id_inscription, nom_hotel, date_debut, date_fin)
values (1, 'hotel', '2023-11-19', '2023-11-20');
insert into attribution_transport (id_inscription, nom_transporteur, date, heure)
values (1, 'transporteur', '2023-05-03'::date, '13:00'::time);

-- Insertion d'un organisateur
insert into organisateur(id_organisateur, nom, prenom, domaine)
values (12345, 'Tanguay', 'Melissa', 'Informatique');
-- Insertion d'un endroit
insert into endroit(id_endroit)
values (0),
       (1),
       (2);
-- Insertion d'un endroit interne
insert into endroit_interne(id_endroit, numero_salle, nb_places)
values (0, 'D4-2023', 190);
-- Insertion d'un endroit externe
insert into endroit_externe(id_endroit, adresse, nb_places)
values (1, '123 rue wistiti', 190);
-- Insertion d'un endroit virtuel
insert into endroit_virtuel(id_endroit, lien)
values (2, 'teams.com');
-- Insertion d'un thème
insert into theme(nom_theme, id_organisateur, nom_evenement, description)
values ('Les sirènes', 12345, 'Wahou', 'Les sirènes sont belles'),
       ('Les tritons', 12345, 'Wehee', 'Les tritons sont forts');
-- Insertion d'une activité
insert into activite(nom_activite, description, nom_theme, id_endroit, type_activite, date, heure_debut, duree)
values ('Crustacés', 'Jaime les crustacés', 'Les sirènes', 1, 'présentation', '2016-06-10'::date,
        '8:00'::time, '60 minute'),
       ('Oranhoutang', 'Jaime les crustacés', 'Les sirènes', 2, 'activité sociale', '2016-06-10'::date,
        '18:00'::time, '60 minute'),
       ('Crevettes', 'Miam les crevettes', 'Les tritons', 1, 'présentation', '2016-06-10'::date,
        '9:00'::time, '60 minute');
-- Insertion d'une activité sociale
insert into activite_sociale(nom_activite, id_inscription)
values ('Oranhoutang', 0);
-- Insertion d'une conférence
insert into conference(nom_activite, id_inscription)
values ('Crustacés', 1);

-- Insertion d'une inscription à l'aide de la procedure
call inserer_inscription('étudiant'::type_inscription, '2016-06-08'::date, '2016-06-10'::date, 'Amigo'::nom, 'Mi'::nom, 'mi.amigo@outlook.com'::courriel, 'végétarien'::preference_alimentaire, true::bool, 'ouioui'::text,
                         '2016-05-12'::date, 1::integer, 'baccalauréat'::dernier_diplome, 'info'::varchar(42), 'UdeS'::varchar(42), null::varchar(42), null::varchar(42), null::varchar(42), null::nom, null::date, null::time,
                         'royl1308'::cip, '12345678'::matricule);

-- Insertion d'un endroit à l'aide d'une procédure
call inserer_endroit('interne'::type_endroit, '123'::numero_salle, 120::integer, null::varchar(42), null::varchar(42));

-- Insertion d'une participation à un événement à l'aide d'une procédure
call inserer_participation_evenement('2'::id_inscription, 'Wehee'::varchar(42));
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
-- Fin de table-test-val_ins.sql
-- =========================================================================== Z
*/