/*
-- =========================================================================== A
-- Création des vues
-- -----------------------------------------------------------------------------
Produit  : KAO
Version  : 0.0.0
Statut   : en développement
-- =========================================================================== A
*/
--
set schema 'evenement';
--
create or replace function clamp(n bigint, min bigint, max bigint)
    returns bigint as
$$
begin
    if (n < min) then
        return min;
    else
        if (n > max) then
            return max;
        else
            return n;
        end if;
    end if;
end;
$$ language plpgsql;

create or replace view horaire
    (evenement, date, heure_debut, heure_fin, informations) as
with type_endroit as (select id_endroit, concat(v.lien, i.numero_salle, ext.adresse) as info
                      from endroit as e
                               left join endroit_virtuel as v using (id_endroit)
                               left join endroit_interne as i using (id_endroit)
                               left join endroit_externe as ext using (id_endroit))

select t.nom_evenement,
       a.date,
       a.heure_debut,
       (a.heure_debut + a.duree) as heure_fin,
       concat('Nom de l`activité : ', a.nom_activite, E'\nConférencier : ', i.prenom, ' ', i.nom,
              E'\nType de l`activité : ', a.type_activite,
              E'\nDescritpion de l`activité : ', a.description, E'\nNom du thème : ', a.nom_theme, E'\nEndroit : ',
              e.info)
from activite as a
         join theme as t using (nom_theme)
         join type_endroit as e using (id_endroit)
         join conference as c using (nom_activite)
         join inscription as i using (id_inscription)
;

select *
from horaire
where evenement = 'Wahou'
  and date = '2016-06-10';

create or replace view commandes_repas
            (traiteur, nb_repas_viande_avec_poisson, nb_repas_viande_sans_poisson, nb_repas_végétarien, nb_repas_vegan,
             date)
as
with commande_participation as (select i.id_inscription, i.preference_alimentaire, pr.date, pr.moment_nourriture
                                from participation_nourriture as pr
                                         join inscription as i using (id_inscription)
                                where (not exists(select *
                                                  from participation_intolerance
                                                  where participation_intolerance.id_inscription = i.id_inscription))),
     commande_nourriture as (select ndj.id_nourriture, ndj.date, n.type_nourriture, n.nom_traiteur
                             from nourriture_du_jour as ndj
                                      join nourriture as n using (id_nourriture)),
     cc_viande_avec_poisson as (select cp.date,
                                       cn.nom_traiteur,
                                       coalesce(count(preference_alimentaire), 0) as nb_cc_viande_avec_poisson
                                from commande_participation as cp
                                         left join commande_nourriture as cn
                                                   on cp.preference_alimentaire::text = cn.type_nourriture::text
                                where preference_alimentaire = 'viande avec poisson'
                                group by cp.date, cn.nom_traiteur),
     cc_viande_sans_poisson as (select cp.date,
                                       cn.nom_traiteur,
                                       coalesce(count(preference_alimentaire), 0) as nb_cc_viande_sans_poisson
                                from commande_participation as cp
                                         left join commande_nourriture as cn
                                                   on cp.preference_alimentaire::text = cn.type_nourriture::text
                                where preference_alimentaire = 'viande sans poisson'
                                group by cp.date, cn.nom_traiteur),
     cc_vegetarien as (select cp.date, cn.nom_traiteur, coalesce(count(preference_alimentaire), 0) as nb_cc_vegetarien
                       from commande_participation as cp
                                left join commande_nourriture as cn
                                          on cp.preference_alimentaire::text = cn.type_nourriture::text
                       where preference_alimentaire = 'végétarien'
                       group by cp.date, cn.nom_traiteur),
     cc_vegan as (select cp.date, cn.nom_traiteur, coalesce(count(preference_alimentaire), 0) as nb_cc_vegan
                  from commande_participation as cp
                           left join commande_nourriture as cn on cp.preference_alimentaire::text = cn.type_nourriture::text
                  where preference_alimentaire = 'végan'
                  group by cp.date, cn.nom_traiteur),
     cc_paspref as (select cp.date,
                           coalesce(floor(count(preference_alimentaire) / 4.0) +
                                    clamp(count(preference_alimentaire) % 4, 0, 1), 0)     as nb_cc_paspref_vap,
                           coalesce(floor(count(preference_alimentaire) / 4.0) +
                                    clamp(count(preference_alimentaire) % 4 - 1, 0, 1), 0) as nb_cc_paspref_vsp,
                           coalesce(floor(count(preference_alimentaire) / 4.0) +
                                    clamp(count(preference_alimentaire) % 4 - 2, 0, 1), 0) as nb_cc_paspref_vege,
                           coalesce(floor(count(preference_alimentaire) / 4.0), 0)         as nb_cc_paspref_vega
                    from commande_participation as cp
                    where preference_alimentaire = 'aucune préférence'
                    group by cp.date),
     cc as (select nom_traiteur,
                   nb_cc_viande_avec_poisson as nb_viande_avec_poisson,
                   0                         as nb_viande_sans_poisson,
                   0                         as nb_vegetarien,
                   0                         as nb_vegan,
                   date
            from cc_viande_avec_poisson as vap
            union
            select nom_traiteur,
                   0                         as nb_viande_avec_poisson,
                   nb_cc_viande_sans_poisson as nb_viande_sans_poisson,
                   0                         as nb_vegetarien,
                   0                         as nb_vegan,
                   date
            from cc_viande_sans_poisson as vsp
            union
            select nom_traiteur,
                   0                as nb_viande_avec_poisson,
                   0                as nb_viande_sans_poisson,
                   nb_cc_vegetarien as nb_vegetarien,
                   0                as nb_vegan,
                   date
            from cc_vegetarien as v
            union
            select nom_traiteur,
                   0           as nb_viande_avec_poisson,
                   0           as nb_viande_sans_poisson,
                   0           as nb_vegetarien,
                   nb_cc_vegan as nb_vegan,
                   date
            from cc_vegan as v),
     commande as (select *
                  from cc
                  union all
                  select distinct on (date) nom_traiteur,
                                            nb_cc_paspref_vap,
                                            nb_cc_paspref_vsp,
                                            nb_cc_paspref_vege,
                                            nb_cc_paspref_vega,
                                            date
                  from cc
                           join cc_paspref using (date)
                  order by date)
select nom_traiteur,
       sum(nb_viande_avec_poisson)::bigint,
       sum(nb_viande_sans_poisson)::bigint,
       sum(nb_vegetarien)::bigint,
       sum(nb_vegan)::bigint,
       date
from commande
group by nom_traiteur, date
;

select *
from commandes_repas;

create or replace view commandes_repas_personnes_intolerance
    (prenom, nom, date, intolerances, preference) as
with intolerances_personne as (select id_inscription, string_agg(nom_intolerance, ', ') as intolerances
                               from participation_intolerance
                               group by id_inscription)
select i.prenom, i.nom, pn.date, ip.intolerances, i.preference_alimentaire
from participation_nourriture as pn
         join inscription as i using (id_inscription)
         join intolerances_personne as ip using (id_inscription)
;

select *
from commandes_repas_personnes_intolerance;

create or replace view reservation_hotel
    (prenom, nom, nom_hotel, date_debut, date_fin, nb_personnes) as
select i.prenom, i.nom, ac.nom_hotel, ac.date_debut, ac.date_fin, ic.nb_personnes
from inscription_conferencier as ic
         join inscription as i using (id_inscription)
         join attribution_chambre as ac using (id_inscription)
;

select *
from reservation_hotel;

create or replace view reservation_transport
    (prenom, nom, nom_transporteur, date, heure, nb_personnes) as
select i.prenom, i.nom, at.nom_transporteur, at.date, at.heure, ic.nb_personnes
from inscription_conferencier as ic
         join inscription as i using (id_inscription)
         join attribution_transport as at using (id_inscription)
;

select *
from reservation_transport;
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

