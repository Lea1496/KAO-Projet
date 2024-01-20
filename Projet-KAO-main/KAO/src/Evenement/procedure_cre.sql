/*
-- =========================================================================== A
-- Création des procédures
-- -----------------------------------------------------------------------------
Produit  : KAO
Version  : 0.0.0
Statut   : en développement
-- =========================================================================== A
*/
--
set schema 'evenement';
--

-- Procedure pour insérer une inscription

create or replace procedure inserer_inscription(t_i type_inscription, date_debut date, date_fin date, nom nom,
                                                prenom nom, courriel courriel, p_a preference_alimentaire,
                                                passe_sts bool, commentaire text, date date,
                                                nb_personnes int,
                                                dernier_diplome dernier_diplome, prog_etu varchar(42), uni varchar(42),
                                                domaine varchar(42), poste varchar(42), nom_hotel varchar(42),
                                                nom_transpo nom, date_transpo date, heure_transpo time, cip cip,
                                                matricule matricule)

    language plpgsql
as
$$
declare
    id      integer;
    i       integer;
begin

    id := (select max(id_inscription) from inscription) + 1;

    insert into inscription (id_inscription, nom, prenom, courriel, preference_alimentaire, passe_sts, commentaire,
                             date)
    values (id, nom, prenom, courriel, p_a, passe_sts, commentaire, date);

    -- Si l'inscrit a fournit une matricule et un cip les insérer
    if (cip is not null and matricule is not null)
    then
        insert into cip_matricule (id_inscription, matricule, cip)
        values (id, matricule, cip);
    end if;


    -- Insérer les bonnes valeurs selon le type d'inscription
    if
        (t_i = 'conférencier')
    then
        insert into inscription_conferencier (id_inscription, date_arrivee, date_depart, nb_personnes)
        values (id, date_debut, date_fin, nb_personnes);

        insert into attribution_chambre (id_inscription, nom_hotel, date_debut, date_fin)
        values (id, nom_hotel, date_debut, date_fin);

        insert into attribution_transport (id_inscription, nom_transporteur, date, heure)
        values (id, nom_transpo, date_transpo, heure_transpo);

        -- Ajouter toutes les conférenciers aux repas
        for i in 0 .. (date_fin - date_debut)
            loop
                insert into participation_nourriture(date, moment_nourriture, id_inscription)
                values (date_debut::date + i, '12:30'::time, id);
            end loop;


    else
        insert into inscription_participant (id_inscription, dernier_diplome)
        values (id, dernier_diplome);
        if (t_i = 'étudiant')
        then
            insert into inscription_etudiant (id_inscription, programme_etude, universite)
            values (id, prog_etu, uni);
        else
            insert into inscription_professionnel (id_inscription, domaine, poste)
            values (id, domaine, poste);
        end if;
    end if;
end;
$$;



--Procedure pour insérer un endroit
create or replace procedure inserer_endroit(t_e type_endroit, num_salle numero_salle, nb_places integer,
                                            adresse varchar(42),
                                            lien varchar(42))
    language plpgsql
as
$$
declare
    id integer;
begin
    id := (select max(id_endroit) from endroit) + 1;

    insert into endroit (id_endroit)
    values (id);

    if (t_e = 'interne')
    then
        insert into endroit_interne (id_endroit, numero_salle, nb_places)
        values (id, num_salle, nb_places);
    else
        if (t_e = 'externe')
        then
            insert into endroit_externe (id_endroit, adresse, nb_places)
            values (id, adresse, nb_places);
        else
            insert into endroit_virtuel (id_endroit, lien)
            values (id, lien);
        end if;

    end if;

end ;
$$;

--Procedure pour insérer une participation à un événement
create or replace procedure inserer_participation_evenement(id_inscription id_inscription, nom_ev varchar(42))
    language plpgsql
as
$$
declare
    debut_ev date;
    fin_ev   date;
begin

    debut_ev := (select date_debut from evenement where nom_evenement = nom_ev);
    fin_ev := (select date_fin from evenement where nom_evenement = nom_ev);

    insert into participation_evenement (id_inscription, nom_evenement)
    values (id_inscription, nom_ev);

    -- Ajouter toutes les participations aux repas
    for i in 0..  (fin_ev - debut_ev)
        loop
        insert into participation_nourriture(date, moment_nourriture, id_inscription)
        values (debut_ev::date + i, '12:30'::time, id_inscription);
        end loop;

end ;
$$;
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
-- Fin de procedure_cre.sql
-- =========================================================================== Z
*/
