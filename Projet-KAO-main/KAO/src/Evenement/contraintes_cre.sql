/*
-- =========================================================================== A
-- Création des contraintes
-- -----------------------------------------------------------------------------
Produit  : KAO
Version  : 0.0.0
Statut   : en vigueur
-- =========================================================================== A
*/
--
set schema 'evenement';
--
-- Contrainte sur la date d'une activité

create or replace function evenement.valider_date_activite()
    returns trigger
    language plpgsql
as
$$
begin
    if (exists (with dates as (select date_debut as dd, date_fin as df
                               from evenement as e
                                        join THEME as t on (new.nom_theme = t.nom_theme)
                               where t.nom_evenement = e.nom_evenement)
                select *
                from dates
                where dd <= new.date
                  and df >= new.date))
    then
        return new;
    else
        raise exception 'Date de lactivité est hors des dates de lévénement dont elle fait partie';
        return null;
    end if;
end;
$$;
create or replace trigger valider_date_activite
    before insert or update
    on activite
    for each row
execute function valider_date_activite();


-- Contrainte par rapport au type d'activité quand c'est une conférence

create or replace function evenement.valider_type_conference()
    returns trigger
    language plpgsql
as
$$
begin
    if (exists (select *
                from activite
                where nom_activite = new.nom_activite
                  and (type_activite = 'présentation' or type_activite = 'atelier')))
    then
        return new;
    else
        raise exception 'Une conférence ne peut seulement que être une présentation ou un atelier';
        return null;
    end if;
end;
$$;
create or replace trigger valider_type_conference
    before insert or update
    on conference
    for each row
execute function valider_type_conference();

-- Contrainte par rapport au type d'activité quand c'est une activite_sociale

create or replace function evenement.valider_type_activite_sociale()
    returns trigger
    language plpgsql
as
$$
begin
    if (exists (select *
                from activite
                where nom_activite = new.nom_activite
                  and (type_activite = 'activité sociale')))
    then
        return new;
    else
        raise exception 'Une activité sociale ne peut seulement que être une activité de type activité sociale';
        return null;
    end if;
end;
$$;
create or replace trigger valider_type_activite_sociale
    before insert or update
    on activite_sociale
    for each row
execute function valider_type_activite_sociale();

-- Contrainte par rapport à l'id_inscription de la personne qui peut être associée à une conférence

create or replace function evenement.valider_id_inscription_conference()
    returns trigger
    language plpgsql
as
$$
begin
    if (exists (select *
                from inscription_conferencier
                where id_inscription = new.id_inscription))
    then
        return new;
    else
        raise exception 'Une conférence ne peut quêtre donnée par un conférencier';
        return null;
    end if;
end;
$$;
create or replace trigger valider_id_inscription_conference
    before insert or update
    on conference
    for each row
execute function valider_id_inscription_conference();


-- Contrainte par rapport à l'id_inscription de la personne à qui on associe une chambre

create or replace function evenement.valider_id_inscription_attribution_chambre()
    returns trigger
    language plpgsql
as
$$
begin
    if (exists (select *
                from inscription_conferencier
                where id_inscription = new.id_inscription))
    then
        return new;
    else
        raise exception 'Une chambre ne peut quêtre associée à un conférencier';
        return null;
    end if;
end;
$$;
create or replace trigger valider_id_inscription_attribution_chambre
    before insert or update
    on attribution_chambre
    for each row
execute function valider_id_inscription_attribution_chambre();

-- Contrainte par rapport à l'id_inscription de la personne à qui on attribue un transport

create or replace function evenement.valider_id_inscription_attribution_transport()
    returns trigger
    language plpgsql
as
$$
begin
    if (exists (select *
                from inscription_conferencier
                where id_inscription = new.id_inscription))
    then
        return new;
    else
        raise exception 'Un transport ne peut quêtre attribué à un conférencier';
        return null;
    end if;
end;
$$;
create or replace trigger valider_id_inscription_attribution_transport
    before insert or update
    on attribution_transport
    for each row
execute function valider_id_inscription_attribution_transport();

-- Contrainte pour valider qu'il n'y ait pas deux activité interne ou virtuelle qui se déroulent au même endroit au même moment

create or replace function evenement.valider_unicite_heure_endroit()
    returns trigger
    language plpgsql
as
$$
begin
    if (exists (with ext as (select id_endroit from endroit_externe where id_endroit = new.id_endroit),
                     act as (select date as d, heure_Debut as hD, duree as du
                             from activite
                             where id_endroit = new.id_endroit)
                select *
                from act
                where (d = new.date and
                       (select (hD::time, du::interval) overlaps (new.heure_Debut::time, new.duree::interval))
                    and (not exists(select * from ext)))))
    then
        raise exception 'Deux activités dans un endroit interne ou virtuel ne peuvent pas arriver en même temps dans le même endroit ';
        return null;
    else
        return new;
    end if;
end;
$$;
create or replace trigger valider_unicite_heure_endroit
    before insert or update
    on activite
    for each row
execute function valider_unicite_heure_endroit();

-- Contrainte pour s'assurer que deux activité du même événemnet ne se déroule pas en même temps

create or replace function evenement.valider_unicite_heure_activite()
    returns trigger
    language plpgsql
as
$$
begin
    if (exists (with evnmt as (select nom_evenement
                               from theme
                               where new.nom_theme = nom_theme),
                     evnmt_act as (select nom_activite
                                   from activite
                                            join theme using (nom_theme)
                                   where nom_evenement = (select * from evnmt))
                select *
                from activite
                where (date = new.date and
                       (select (heure_debut::time, duree::interval) overlaps
                               (new.heure_Debut::time, new.duree::interval))
                    and (exists(select * from evnmt_act where nom_activite = activite.nom_activite)))))
    then
        raise exception 'Deux activités d`un même événement ne peuvent pas se dérouler en même temps ';
        return null;
    else
        return new;
    end if;
end;
$$;
create or replace trigger valider_unicite_heure_activite
    before insert or update
    on activite
    for each row
execute function valider_unicite_heure_activite();

-- Contrainte sur l’heure de début et l’heure de fin d’une activité

create or replace function valider_heure_activite()
    returns trigger
    language plpgsql
as
$$
begin
    if (exists (with heures as (select heure_debut_min as hd, heure_fin_max as hf
                                from evenement as e
                                         join THEME as t on (new.nom_theme = t.nom_theme)
                                where t.nom_evenement = e.nom_evenement)
                select hd, hf
                from heures
                where hd <= new.heure_debut
                  and hf >= new.heure_debut + new.duree))
    then
        return new;
    else
        raise exception 'L’heure de début de l’activité ne doit pas être plus petite que l’heure de début minimale de l’événement dont elle fait partie. De plus, son heure de début + sa durée ne doit pas être plus grande que l’heure de fin maximale de l’événement dont elle fait partie.';
        return null;
    end if;
end;
$$;
create or replace trigger valider_heure_activite
    before insert or update
    on activite
    for each row
execute function valider_heure_activite();

-- Contrainte pour s'assurer qu'un conférencier n'est pas un participant

create or replace function valider_type_inscription_conferencier()
    returns trigger
    language plpgsql
as
$$
begin
    if (not exists (select *
                    from inscription_participant
                    where id_inscription = new.id_inscription))
    then
        return new;
    else
        raise exception 'Un même id_inscription ne peut pas se retrouver dans inscription_participant et inscription_conferencier en même temps.';
        return null;
    end if;
end;
$$;
create or replace trigger valider_type_inscription_conferencier
    before insert or update
    on inscription_conferencier
    for each row
execute function valider_type_inscription_conferencier();

-- Contrainte pour s'assurer qu'un participant n'est pas un conférencier

create or replace function valider_type_inscription_participant()
    returns trigger
    language plpgsql
as
$$
begin
    if (not exists (select *
                    from inscription_conferencier
                    where id_inscription = new.id_inscription))
    then
        return new;
    else
        raise exception 'Un même id_inscription ne peut pas se retrouver dans inscription_participant et inscription_conferencier en même temps.';
        return null;
    end if;
end;
$$;
create or replace trigger valider_type_inscription_participant
    before insert or update
    on inscription_participant
    for each row
execute function valider_type_inscription_participant();

-- Contrainte pour s'assurer qu'un étudiant n'est pas un professionnel

create or replace function valider_type_inscription_etudiant()
    returns trigger
    language plpgsql
as
$$
begin
    if (not exists (select *
                    from inscription_professionnel
                    where id_inscription = new.id_inscription))
    then
        return new;
    else
        raise exception 'Un même id_inscription ne peut pas se retrouver dans inscription_etudiant et inscription_professionnel en même temps.';
        return null;
    end if;
end;
$$;
create or replace trigger valider_type_inscription_etudiant
    before insert or update
    on inscription_etudiant
    for each row
execute function valider_type_inscription_etudiant();

-- Contrainte pour s'assurer qu'un professionnel n'est pas un étudiant

create or replace function valider_type_inscription_professionnel()
    returns trigger
    language plpgsql
as
$$
begin
    if (not exists (select *
                    from inscription_etudiant
                    where id_inscription = new.id_inscription))
    then
        return new;
    else
        raise exception 'Un même id_inscription ne peut pas se retrouver dans inscription_etudiant et inscription_professionnel en même temps.';
        return null;
    end if;
end;
$$;
create or replace trigger valider_type_inscription_professionnel
    before insert or update
    on inscription_professionnel
    for each row
execute function valider_type_inscription_professionnel();

-- Contrainte pour s'assurer qu'un endroit interne n'est pas un externe ou virtuel

create or replace function valider_type_endroit_interne()
    returns trigger
    language plpgsql
as
$$
begin
    if ((not exists (select *
                     from endroit_externe
                     where id_endroit = new.id_endroit))
        and
        (not exists (select *
                     from endroit_virtuel
                     where id_endroit = new.id_endroit)))
    then
        return new;
    else
        raise exception 'Un même id_endroit ne peut pas se retrouver dans dans deux types d’endroits différents.';
        return null;
    end if;
end;
$$;
create or replace trigger valider_type_endroit_interne
    before insert or update
    on endroit_interne
    for each row
execute function valider_type_endroit_interne();

-- Contrainte pour s'assurer qu'un endroit externe n'est pas un interne ou virtuel

create or replace function valider_type_endroit_externe()
    returns trigger
    language plpgsql
as
$$
begin
    if ((not exists (select *
                     from endroit_interne
                     where id_endroit = new.id_endroit))
        and
        (not exists (select *
                     from endroit_virtuel
                     where id_endroit = new.id_endroit)))
    then
        return new;
    else
        raise exception 'Un même id_endroit ne peut pas se retrouver dans dans deux types d’endroits différents.';
        return null;
    end if;
end;
$$;
create or replace trigger valider_type_endroit_externe
    before insert or update
    on endroit_externe
    for each row
execute function valider_type_endroit_externe();

-- Contrainte pour s'assurer qu'un endroit virtuel n'est pas un interne ou externe

create or replace function valider_type_endroit_virtuel()
    returns trigger
    language plpgsql
as
$$
begin
    if ((not exists (select *
                     from endroit_interne
                     where id_endroit = new.id_endroit))
        and
        (not exists (select *
                     from endroit_externe
                     where id_endroit = new.id_endroit)))
    then
        return new;
    else
        raise exception 'Un même id_endroit ne peut pas se retrouver dans dans deux types d’endroits différents.';
        return null;
    end if;
end;
$$;
create or replace trigger valider_type_endroit_virtuel
    before insert or update
    on endroit_virtuel
    for each row
execute function valider_type_endroit_virtuel();

-- Contrainte pour valider la durée des activitées

create or replace function valider_duree_activite()
    returns trigger
    language plpgsql
as
$$
begin
    if (case
            when new.type_activite = 'présentation'
                and new.duree >= '15 minute' and new.duree <= '60 minute' then true
            when new.type_activite = 'atelier'
                and new.duree >= '90 minute' and new.duree <= '190 minute' then true
            when new.type_activite = 'évaluation'
                and new.duree != '120 minute' then true
            when new.type_activite = 'travail d''équipe'''
                and new.duree >= '60 minute' and new.duree <= '90 minute' then true
            when new.type_activite = 'activité sociale'
                then true
            when new.type_activite = 'dîner'
                and new.duree != '90 minute' then true
            when new.type_activite = 'pause'
                and new.duree != '30 minute' then true
            else false
        end)
    then
        return new;
    else
        raise exception 'Le type d’activité ne respecte pas sa durée associée.';
        return null;
    end if;
end;
$$;

create or replace trigger valider_duree_activite
    before insert or update
    on activite
    for each row
execute function valider_duree_activite();

-- Contrainte pour valider que les étudiant ou le professionnels sont des participants

create or replace function valider_etudiant_professionnel()
    returns trigger
    language plpgsql
as
$$
begin
    if (exists (select *
                from inscription_participant
                where id_inscription = new.id_inscription))
    then
        return new;
    else
        raise exception 'Un professionnel ou un étudiant doit être un participant.';
        return null;
    end if;
end;
$$;
create or replace trigger valider_etudiant_professionnel
    before insert or update
    on inscription_professionnel
    for each row
execute function valider_etudiant_professionnel();
create or replace trigger valider_etudiant_professionnel
    before insert or update
    on inscription_etudiant
    for each row
execute function valider_etudiant_professionnel();

-- Contrainte pour s'assurer qu'un conférencier ne donne pas deux conférences en même temps

create or replace function valider_unicite_conferencier()
    returns trigger
    language plpgsql
as
$$
begin
    if (exists (with conf as (select *
                              from conference
                              where new.id_inscription = id_inscription),
                     act as (select 1 from activite where new.nom_activite = nom_activite)
                select *
                from activite
                where (date = (select date from act) and
                       (select (heure_debut::time, duree::interval) overlaps
                               ((select heure_Debut::time from act), (select duree::interval from act)))
                    and (exists(select * from conf where nom_activite = activite.nom_activite)))))
    then
        raise exception 'Un conférenccier ne peut pas être à deux conférences en même temps';
        return null;
    else
        return new;
    end if;
end;
$$;
create or replace trigger valider_unicite_conferencier
    before insert or update
    on conference
    for each row
execute function valider_unicite_conferencier();

-- Contrainte pour s'assurer qu'un conférencier est présent à la date de la conférence

create or replace function valider_conference_conferencier()
    returns trigger
    language plpgsql
as
$$
begin
    if (exists (with conferencier as (select date_arrivee as da, date_depart as dd
                                      from inscription_conferencier

                                      where id_inscription = new.id_inscription),
                     act as (select date as dt from activite where nom_activite = new.nom_activite)
                select *
                from act
                where dt between (select da from conferencier) and (select dd from conferencier)))
    then
        return new;
    else
        raise exception 'Les dates de présence du conférencier ne coincident pas avec la date de la conférence';
        return null;
    end if;
end;
$$;
create or replace trigger valider_conference_conferencier
    before insert or update
    on conference
    for each row
execute function valider_conference_conferencier();

-- Contrainte pour s'assurer qu'une personne se soit inscrite avant le début de l'événement auquel elle participe.

create or replace function valider_participation_evenement()
    returns trigger
    language plpgsql
as
$$
begin

    if (exists(with ins as (select date as di from inscription where id_inscription = new.id_inscription),
                    eve as (select date_debut dd from evenement where nom_evenement = new.nom_evenement)
                   (select *
                    from eve
                    where (select di from ins) < dd)))
    then
        return new;
    else
        raise exception 'Une personne doit s`être inscrite avant le début de l`événement';
        return null;
    end if;
end ;
$$;
create or replace trigger valider_participation_evenement
    before insert or update
    on participation_evenement
    for each row
execute function valider_participation_evenement();

--Contrainte pour valider l'heure de début d'un diner
create or replace function valider_heure_diner()
    returns trigger
    language plpgsql
as
$$
begin

    if (new.type_activite != 'dîner')
    then
        return new;
    else
        if (new.heure_debut != '12:30'::time)
        then
            raise exception 'Un diner doit commencer à 12h30';
            return null;
        else
            return new;
        end if;
    end if;
end;
$$;
create or replace trigger valider_heure_diner
    before insert or update
    on activite
    for each row
execute function valider_heure_diner();

--Contrainte pour valider l'heure de début d'une activité sociale
create or replace function valider_heure_activite_sociale()
    returns trigger
    language plpgsql
as
$$
begin

    if (new.type_activite != 'activité sociale')
    then
        return new;
    else
        if (new.heure_debut < '18:00'::time)
        then
            raise exception 'Les activités sociales débutent à partir de 18h';
            return null;
        else
            return new;
        end if;
    end if;
end;
$$;
create or replace trigger valider_heure_activite_sociale
    before insert or update
    on activite
    for each row
execute function valider_heure_activite_sociale();


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
-- Fin contraintes_cre.sql
-- =========================================================================== Z
*/
