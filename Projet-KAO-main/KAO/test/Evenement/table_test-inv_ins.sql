/*
-- =========================================================================== A
-- Insertion des données invalides pour tester les tables.
-- -----------------------------------------------------------------------------
Produit  : KAO
Version  : 0.0.0
Statut   : en développement
-- =========================================================================== A
*/
--
set schema 'evenement';
--
-- Tests pour evenement
-- Insertion d'une annee invalide
insert into evenement(nom_evenement, annee, date_debut, date_fin, heure_debut_min, heure_fin_max,
                      prix_inscription_etudiant, prix_inscription_professionnel)
values ('Wahou', 'oui', '2016-06-08'::date, '2016-06-15'::date, '8:00'::time, '20:00'::time, 1900, 1500);
-- Insertion de dates invalides
insert into evenement(nom_evenement, annee, date_debut, date_fin, heure_debut_min, heure_fin_max,
                      prix_inscription_etudiant, prix_inscription_professionnel)
values ('Wahou', 2016, 20, '2016-06-15'::date, '8:00'::time, '20:00'::time, 1900, 1500);
insert into evenement(nom_evenement, annee, date_debut, date_fin, heure_debut_min, heure_fin_max,
                      prix_inscription_etudiant, prix_inscription_professionnel)
values ('Wahou', 2016, '2016-06-17'::date, '2016-06-15'::date, '8:00'::time, '20:00'::time, 1900, 1500);
insert into evenement(nom_evenement, annee, date_debut, date_fin, heure_debut_min, heure_fin_max,
                      prix_inscription_etudiant, prix_inscription_professionnel)
values ('Wahou', 2016, '2019-06-08'::date, '2019-06-15'::date, '8:00'::time, '20:00'::time, 1900, 1500);
-- Insertion d'une heure de début min invalide
insert into evenement(nom_evenement, annee, date_debut, date_fin, heure_debut_min, heure_fin_max,
                      prix_inscription_etudiant, prix_inscription_professionnel)
values ('Wahou', 2016, '2016-06-08'::date, '2016-06-15'::date, 'allo', '20:00'::time, 1900, 1500);
insert into evenement(nom_evenement, annee, date_debut, date_fin, heure_debut_min, heure_fin_max,
                      prix_inscription_etudiant, prix_inscription_professionnel)
values ('Wahou', 2016, '2016-06-08'::date, '2016-06-15'::date, '21:00'::time, '20:00'::time, 1900, 1500);
-- Insertion d'un prix invalide
insert into evenement(nom_evenement, annee, date_debut, date_fin, heure_debut_min, heure_fin_max,
                      prix_inscription_etudiant, prix_inscription_professionnel)
values ('Wahou', 2016, '2016-06-08'::date, '2016-06-15'::date, '8:00'::time, '20:00'::time, 'prix', 1500);

-- Tests pour inscription
-- Id inscription invalide
insert into inscription(id_inscription, nom, prenom, courriel, preference_Alimentaire,
                        passe_STS, commentaire, date)
values ('a', 'Dupont', 'Jean', 'jean.dupont@example.com', 'végétarien', true,
        'Pas de commentaire', '2023-11-20');
-- Courriel invalide
insert into inscription(id_inscription, nom, prenom, courriel, preference_Alimentaire,
                        passe_STS, commentaire, date)
values (1, 'Dupont', 'Jean', 'jean.dupontexample.com', 'végétarien', true,
        'Pas de commentaire','2023-11-20');
-- Preference alimentaire invalide
insert into inscription(id_inscription, nom, prenom, courriel, preference_Alimentaire,
                        passe_STS, commentaire, date)
values (1, 'Dupont', 'Jean', 'jean.dupont@example.com', 'végetarien', true,
        'Pas de commentaire','2023-11-20');
-- Inscription dupliquée
insert into inscription(id_inscription, nom, prenom, courriel, preference_Alimentaire,
                        passe_STS, commentaire, date)
values (12345678, 'Dupont', 'Jean', 'jean.dupont@example.com', 'végétarien', true,
        'Pas de commentaire', '2023-11-20');
-- Courriel dupliqué
insert into inscription(id_inscription, nom, prenom, courriel, preference_Alimentaire,
                        passe_STS, commentaire, date)
values (12345679, 'Dupont', 'Jean', 'jean.dupont@example.com', 'végétarien', true,
        'Pas de commentaire', '2023-11-20');

-- Tests pour inscription_professionnel
-- Id inscription invalide
insert into inscription_professionnel(id_inscription, domaine, poste)
values (-1, 'Informatique', 'Développeur');

-- Tests pour inscription_participant
-- Id inscription invalide
insert into inscription_participant(id_inscription, dernier_Diplome)
values (-1, 'Master Informatique');

-- Tests pour inscription_etudiant
-- Id inscription invalide
insert into inscription_etudiant(id_inscription, programme_Etude, universite)
values (-1, 'Génie Logiciel', 'Université de Sherbrooke');

-- Tests pour inscription_conferencier
-- Id inscription invalide
insert into inscription_conferencier(id_inscription, date_Arrivee, date_Depart, nb_Personnes)
values (1, '2023-11-25', '2023-11-30', 1);
-- Date d'arrivée > date de départ
insert into inscription_conferencier(id_inscription, date_Arrivee, date_Depart, nb_Personnes)
values (1, '2023-11-25', '2023-11-20', 1);
-- Nombre de personnes invalide
insert into inscription_conferencier(id_inscription, date_Arrivee, date_Depart, nb_Personnes)
values (1, '2023-11-25', '2023-11-30', -1);

-- Tests pour cip_matricule
-- Id inscription invalide
insert into cip_matricule(id_inscription, matricule, cip)
values (-1, '00000002', 'abcd2234');
-- Matricule invalide
insert into cip_matricule(id_inscription, matricule, cip)
values (12345678, '00001', 'abcd1234');
-- Cip invalide
insert into cip_matricule(id_inscription, matricule, cip)
values (12345678, '00000001', 'abc1d234');

-- Tests pour participation_evenement
-- Id inscription invalide
insert into participation_evenement(id_Inscription, nom_Evenement)
values (-1, 'Wahou');
-- Événement invalide
insert into participation_evenement(id_Inscription, nom_Evenement)
values (12345678, 'Wahou0');

-- Tests pour participation_intolerance
-- Id inscription invalide
insert into participation_intolerance(id_inscription, nom_intolerance)
values (-1, 'Arachides');
-- Nom intolérance invalide
insert into participation_intolerance(id_inscription, nom_intolerance)
values (0, 'arachides');
-- Nom intolérance dupliqué
insert into participation_intolerance(id_inscription, nom_intolerance)
values (0, 'Arachides');

-- Tests pour traiteur
-- Numéro de téléphone invalide
insert into traiteur(nom_traiteur, no_tel, courriel)
values ('traiteur0', '000-000-000', 'abcde@fgh.ijk');
-- Courriel invalide
insert into traiteur(nom_traiteur, no_tel, courriel)
values ('traiteur0', '000-000-0000', 'abcdefgh.ijk');
-- Traiteur dupliqué
insert into traiteur(nom_traiteur, no_tel, courriel)
values ('traiteur', '000-000-0000', 'abcde@fgh.ijk');
-- Courriel dupliqué
insert into traiteur(nom_traiteur, no_tel, courriel)
values ('traiteur0', '000-000-0000', 'abcde@fgh.ijk');

-- Tests pour nourriture
-- Id nourriture dupliqué
insert into nourriture(id_nourriture, nom_nourriture, type_nourriture, nom_traiteur)
values (0, 'nourriture', 'viande avec poisson', 'traiteur');
-- Type nourriture invalide
insert into nourriture(id_nourriture, nom_nourriture, type_nourriture, nom_traiteur)
values (1, 'nourriture', 'viande', 'traiteur');
-- Traiteur invalide
insert into nourriture(id_nourriture, nom_nourriture, type_nourriture, nom_traiteur)
values (1, 'nourriture', 'viande avec poisson', 'traiteur0');

-- Tests pour nourriture_du_jour
-- Id nourriture invalide
insert into nourriture_du_jour(date, moment_nourriture, id_nourriture)
values ('2023-11-19', '13:00', 'allo');
-- Date et moment dupliqué
insert into nourriture_du_jour(date, moment_nourriture, id_nourriture)
values ('2023-11-19', '12:00', 0);

-- Tests pour intolerance_nourriture
-- Id inscription invalide
insert into intolerance_nourriture(id_nourriture, nom_intolerance)
values ('allo', 'Arachides');
-- Nom intolérance invalide
insert into intolerance_nourriture(id_nourriture, nom_intolerance)
values (0, 'arachides');
-- Intolérance dupliquée
insert into intolerance_nourriture(id_nourriture, nom_intolerance)
values (0, 'Arachides');

-- Tests pour participation_nourriture
-- Id inscription invalide
insert into participation_nourriture(date, moment_nourriture, id_inscription)
values ('2023-11-19', '12:00', -1);
-- Date et moment dupliqué
insert into participation_nourriture(date, moment_nourriture, id_inscription)
values ('2023-11-19', '12:00', 0);

-- Tests pour hotel
-- Numéro de téléphone invalide
insert into hotel(nom_hotel, no_tel, courriel, adresse, nb_chambres)
values ('hotel', '000-000-000', 'abcde@fgh.ijk', 'adresse', 100);
-- Courriel invalide
insert into hotel(nom_hotel, no_tel, courriel, adresse, nb_chambres)
values ('hotel', '000-000-0000', 'abcdefgh.ijk', 'adresse', 100);
-- Nombre de chambres invalide
insert into hotel(nom_hotel, no_tel, courriel, adresse, nb_chambres)
values ('hotel', '000-000-0000', 'abcde@fgh.ijk', 'adresse', -1);
-- Hotel dupliqué
insert into hotel(nom_hotel, no_tel, courriel, adresse, nb_chambres)
values ('hotel', '000-000-0000', 'abcde@fgh.ijk', 'adresse', 100);
-- Courriel dupliqué
insert into hotel(nom_hotel, no_tel, courriel, adresse, nb_chambres)
values ('hotel0', '000-000-0000', 'abcde@fgh.ijk', 'adresse', 100);

-- Tests pour transporteur
-- Numéro de téléphone invalide
insert into transporteur(nom_transporteur, no_tel, courriel)
values ('transporteur', '000-000-000', 'abcde@fgh.ijk');
-- Courriel invalide
insert into transporteur(nom_transporteur, no_tel, courriel)
values ('transporteur', '000-000-0000', 'abcdefgh.ijk');
-- Transporteur dupliqué
insert into transporteur(nom_transporteur, no_tel, courriel)
values ('transporteur', '000-000-0000', 'abcde@fgh.ijk');
-- Courriel dupliqué
insert into transporteur(nom_transporteur, no_tel, courriel)
values ('transporteur0', '000-000-0000', 'abcde@fgh.ijk');

-- Tests pour attribution_chambre
-- Id inscription invalide
insert into attribution_chambre(id_inscription, nom_hotel, date_debut, date_fin)
values (1, 'hotel', '2023-11-19', '2023-11-20');
-- Hotel invalide
insert into attribution_chambre(id_inscription, nom_hotel, date_debut, date_fin)
values (1, 'hotel0', '2023-11-20', '2023-11-21');
-- Date de début > date de fin
insert into attribution_chambre(id_inscription, nom_hotel, date_debut, date_fin)
values (1, 'hotel', '2023-11-19', '2023-11-18');
-- Attribution hotel dupliquée
insert into attribution_chambre(id_inscription, nom_hotel, date_debut, date_fin)
values (1, 'hotel', '2023-11-19', '2023-11-20');

-- Tests pour attribution_transport
-- Id inscription invalide
insert into attribution_transport(id_inscription, nom_transporteur, date, heure)
values (-1, 'transporteur', '2023-11-20', '13:00');
-- Transporteur invalide
insert into attribution_transport(id_inscription, nom_transporteur, date, heure)
values (1, 'transporteur0', '2023-11-20', '14:00');
-- Attribution transport dupliquée
insert into attribution_transport (id_inscription, nom_transporteur, date, heure)
values (1, 'transporteur', '2023-05-03'::date, '13:00'::time);

-- Tests pour organisateur
-- Insertion de deux organisateur avec le même id_Organisateur
insert into organisateur(id_organisateur, nom, prenom, domaine)
values (1234, 'Tanguay', 'Melissa', 'Informatique'),
       (1234, 'Tremblay', 'Meliandre', 'Informatique');
-- Insertion d'un id_organisateur invalide
insert into organisateur(id_organisateur, nom, prenom, domaine)
values ('a', 'Tanguay', 'Melissa', 'Informatique');

-- Tests pour endroit
-- Id_endroit dupliqué
insert into endroit(id_endroit)
values (0);

-- Tests pour endroit_interne
-- Id_endroit invalide
insert into endroit_interne(id_endroit, numero_salle, nb_places)
values (10, 'D4-2023', 190);
-- Nb_places invalide
insert into endroit_interne(id_endroit, numero_salle, nb_places)
values (10, 'D4-2023', -1);
-- Numero_salle dupliqué
insert into endroit_interne(id_endroit, numero_salle, nb_places)
values (10, 'D4-2023', 190);

-- Tests pour endroit_externe
-- Id_endroit invalide
insert into endroit_externe(id_endroit, adresse, nb_places)
values (10, '123 rue wistiti', 190);
-- Nb_places invalide
insert into endroit_externe(id_endroit, adresse, nb_places)
values (10, '123 rue wistiti', -1);
-- Adresse dupliquée
insert into endroit_externe(id_endroit, adresse, nb_places)
values (10, '123 rue wistiti', 190);

-- Tests pour endroit_virtuel
-- Id_endroit invalide
insert into endroit_virtuel(id_endroit, lien)
values (10, 'teams.com');
-- Lien dupliqué
insert into endroit_virtuel(id_endroit, lien)
values (10, 'teams.com');

-- Tests pour theme
-- Insertion de deux thèmes dupliqués
insert into theme(nom_theme, id_organisateur, nom_evenement, description)
values ('Amigos', 12345, 'Wahou', 'Les sirènes sont belles'),
       ('Amigos', 12345, 'Wahou', 'Les sirènes sont belles');
-- Insertion d'un thème avec un id_Organisateur inexistant
insert into theme(nom_theme, id_organisateur, nom_evenement, description)
values ('Les sirènes', 0, 'Wahou', 'Les sirènes sont belles');

-- Tests pour activite
-- Insertion de deux activités dupliquées
insert into activite(nom_activite, description, nom_theme, id_endroit, type_activite, date, heure_debut, duree)
values ('Animaux', 'Jaime les crustacés', 'Les sirènes', 1, 'évaluation', '2016-06-12'::date,
        '8:00'::time, '60 minute'),
       ('Animaux', 'Jaime les crustacés', 'Les sirènes', 1, 'évaluation', '2016-06-12'::date,
        '8:00'::time, '60 minute');
-- Insertion d'un type d'activité invalide
insert into activite(nom_activite, description, nom_theme, id_endroit, type_activite, date, heure_debut, duree)
values ('Crustacé', 'Jaime les crustacés', 'Les sirènes', 1, 'baignade', '2016-06-12'::date,
        '8:00'::time, '60 minute');
-- Insertion d'une date invalide
insert into activite(nom_activite, description, nom_theme, id_endroit, type_activite, date, heure_debut, duree)
values ('Crustacé', 'Jaime les crustacés', 'Les sirènes', 1, 'évaluation', 'miam', '8:00'::time, 60);
-- Insertion d'une heure de début invalide
insert into activite(nom_activite, description, nom_theme, id_endroit, type_activite, date, heure_debut, duree)
values ('Crustacé', 'Jaime les crustacés', 'Les sirènes', 1, 'évaluation', '2016-06-12'::date, 'oui',
        '60 minute');
-- Insertion d'une durée invalide
insert into activite(nom_activite, description, nom_theme, id_endroit, type_activite, date, heure_debut, duree)
values ('Crustacé', 'Jaime les crustacés', 'Les sirènes', 1, 'évaluation', '2016-06-12'::date,
        '8:00'::time, '300 minute');

-- Tests pour activite_sociale
-- Insertion d'un nom d'activité inexistant
insert into activite_sociale(nom_activite, id_inscription)
values ('Amigo', 0);
-- Insertion d'un id_inscription inexistant
insert into activite_sociale(nom_activite, id_inscription)
values ('Crustacés', 019343);

-- Tests pour conference
-- Insertion d'un nom d'activité inexistant
insert into conference(nom_activite, id_inscription)
values ('Jouer', 1);
-- Insertion d'un id_inscription inexistant
insert into conference(nom_activite, id_inscription)
values ('Crustacés', 019343);
-- Tests pour la contrainte valider_date_activité
-- Insertion de date en dehors des dates de l'événement
insert into activite(nom_activite, description, nom_theme, id_endroit, type_activite, date, heure_debut, duree)
values ('Babouche', 'Jaime les crustacés', 'Les sirènes', 1, 'présentation', '2016-06-08'::date,
        '14:00'::time, '60 minute'),
       ('Babouchka', 'Jaime les crustacés', 'Les sirènes', 2, 'activité sociale', '2016-06-16'::date,
        '10:00'::time, '60 minute')
;

-- Test pour la contrainte valider_type_conference
-- Insertion d'un id_inscription qui n'est pas dans la table id_conférencier
insert into conference(nom_activite, id_inscription)
values ('Babouche', 0);

-- Test pour la contrainte valider_id_inscription_conference
-- Insertion d'un activité qui n'est pas de type 'présentation' ou 'atelier'
insert into conference (nom_activite, id_inscription)
values ('Babouchka', 1);

-- Test pour la contrainte valider_type_activite_sociale
-- Insertion d'une activité sociale qui n'est pas de type 'activité sociale'
insert into activite_sociale(nom_activite, id_inscription)
values ('Babouche', 0);

-- Test pour la contrainte valider_id_inscription_attribution_chambre
-- Insertion d'une chambre pour un id_insccription qui n'est pas dans la table inscription_conferencier
insert into attribution_chambre(id_inscription, nom_hotel, date_debut, date_fin)
values (2, 'hotel', '2024-11-19', '2025-11-20');

-- Test pour la contrainte valider_id_inscription_attribution_transport
-- Insertion d'un transport pour un id_inscription qui n'est pas dans la table inscription_conferencier
insert into attribution_transport (id_inscription, nom_transporteur, date, heure)
values (2, 'transporteur', '2024-05-03'::date, '13:00'::time);

-- Test pour la contrainte valider_unicite_heure_endroit
-- Insertion de deux activité au même moment au même endroit
insert into activite(nom_activite, description, nom_theme, id_endroit, type_activite, date, heure_debut, duree)
values ('Crus', 'Jaime les crustacés', 'Les sirènes', 2, 'présentation', '2016-06-12'::date,
        '8:00'::time, '60 minute'),
       ('Cristophe Colomb', 'Jaime les crustacés', 'Les sirènes', 2, 'présentation', '2016-06-12'::date,
        '8:00'::time, '60 minute');
insert into activite(nom_activite, description, nom_theme, id_endroit, type_activite, date, heure_debut, duree)
values ('Cros', 'Jaime les crustacés', 'Les sirènes', 0, 'présentation', '2016-06-10'::date,
        '8:59'::time, '60 minute'),
       ('Cres', 'Jaime les crustacés', 'Les sirènes', 0, 'présentation', '2016-06-10'::date,
        '8:59'::time, '60 minute');
-- Test pour la contrainte valider_unicite_heure_activite
-- Insertion de deux activite avec le même evenement au même moment
insert into activite(nom_activite, description, nom_theme, id_endroit, type_activite, date, heure_debut, duree)
values ('Crustacés', 'Jaime les crustacés', 'Les sirènes', 1, 'présentation', '2016-06-10'::date,
        '8:00'::time, '60 minute'),
       ('Oranhoutang', 'Jaime les crustacés', 'Les sirènes', 2, 'activité sociale', '2016-06-10'::date,
        '8:00'::time, '60 minute');

-- Tests pour la contrainte valider_heure_activite
insert into activite(nom_activite, description, nom_theme, id_endroit, type_activite, date, heure_debut, duree)
values ('Babouche', 'Jaime les crustacés', 'Les sirènes', 1, 'évaluation', '2016-06-09'::date,
        '7:00'::time, '60 minute');
insert into activite(nom_activite, description, nom_theme, id_endroit, type_activite, date, heure_debut, duree)
values ('Babouche', 'Jaime les crustacés', 'Les sirènes', 0, 'activité sociale', '2016-06-09'::date,
        '19:00'::time, '120 minute');

-- Tests pour la contrainte valider_type_inscription_conferencier
insert into inscription_conferencier(id_inscription, date_Arrivee, date_Depart, nb_Personnes)
values (0, '2023-11-25', '2023-11-30', 1);

-- Tests pour la contrainte valider_type_inscription_participant
insert into inscription_participant(id_inscription, dernier_Diplome)
values (1, 'Master Informatique');

-- Tests pour la contrainte valider_type_inscription_etudiant
insert into inscription_etudiant(id_inscription, programme_Etude, universite)
values (2, 'Génie Logiciel', 'Université de Sherbrooke');

-- Tests pour la contrainte valider_type_inscription_professionnel
insert into inscription_professionnel(id_inscription, domaine, poste)
values (12345678, 'Informatique', 'Développeur');

-- Tests pour la contrainte valider_type_endroit_interne
insert into endroit_interne(id_endroit, numero_salle, nb_places)
values (1, 'D4-2023', 190);

-- Tests pour la contrainte valider_type_endroit_externe
insert into endroit_externe(id_endroit, adresse, nb_places)
values (2, '123 rue wistiti', 190);

-- Tests pour la contrainte valider_type_endroit_virtuel
insert into endroit_virtuel(id_endroit, lien)
values (0, 'teams.com');

-- Tests pour la contrainte valider_duree_activite
insert into activite(nom_activite, description, nom_theme, id_endroit, type_activite, date, heure_debut, duree)
values ('Crustacés', 'Jaime les crustacés', 'Les sirènes', 1, 'présentation', '2016-06-10'::date,
        '8:00'::time, '120 minute');

-- Tests pour la contrainte valider_etudiant_professionnel
insert into inscription_professionnel(id_inscription, domaine, poste)
values (1, 'Informatique', 'Développeur');
insert into inscription_etudiant(id_inscription, programme_Etude, universite)
values (1, 'Génie Logiciel', 'Université de Sherbrooke');

-- Tests pour valider la contrainte valider_unicite_conferencier
-- Insertion d'un conférencier à un conférence à un moment où il donne déjà une conférence
insert into conference (nom_activite, id_inscription)
values ('Crevettes', 0);

-- Tests pour valider la contrainte valider_contrainte_conferencier
-- Insertion d'un conférencier qui n'est pas là à la date de la conférence
insert into conference (nom_activite, id_inscription)
values ('Crevette', 3);

-- Test pour valider la contrainte valider_participation_evenement
-- Insertion d'une inscription après la date d'un événement
insert into participation_evenement (id_inscription, nom_evenement)
values (1, 'Wahou');

-- Test pour valider la contrainte valider_heure_activite_sociale
-- Insertion d'une activité sociale avant 18h
insert into activite (nom_activite, description, nom_theme, id_endroit, type_activite, date, heure_debut, duree)
values ('Les chatons', 'J`aime les chats', 'Les sirènes', 1, 'activité sociale', '2016-06-10'::date, '12:00'::time, '90');

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
-- Fin de table_test-inv_ins.sql
-- =========================================================================== Z
*/