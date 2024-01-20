/*
-- =========================================================================== A
-- Retrait des données des tables du schéma Evenement
-- -----------------------------------------------------------------------------
Produit  : KAO
Version  : 0.0.0
Statut   : en développement
-- =========================================================================== A
*/
--
set schema 'evenement';
--
delete from evenement;
delete from inscription;
delete from inscription_professionnel;
delete from inscription_participant;
delete from inscription_etudiant;
delete from inscription_conferencier;
delete from cip_matricule;
delete from participation_evenement;
delete from intolerance;
delete from participation_intolerance;
delete from traiteur;
delete from nourriture;
delete from nourriture_du_jour;
delete from intolerance_nourriture;
delete from participation_nourriture;
delete from hotel;
delete from transporteur;
delete from attribution_chambre;
delete from attribution_transport;
delete from organisateur;
delete from endroit;
delete from endroit_interne;
delete from endroit_externe;
delete from endroit_virtuel;
delete from theme;
delete from activite;
delete from activite_sociale;
delete from conference;
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
-- Fin de table_ret.sql
-- =========================================================================== Z
*/

