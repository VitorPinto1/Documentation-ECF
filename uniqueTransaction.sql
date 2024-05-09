DELIMITER //

CREATE PROCEDURE AjouterJoueur(
    IN _nom_joueur VARCHAR(255), 
    IN _prenom_joueur VARCHAR(255), 
    IN _numero_tshirt INT, 
    IN _equipe_id VARCHAR(255))
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        -- Ce bloc sera exécuté en cas d'erreur
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erreur lors de l\'insertion du joueur.';
    END;

    START TRANSACTION;
        -- Vérifiez d'abord si l'équipe existe
        IF NOT EXISTS (SELECT 1 FROM equipes WHERE nom_equipe = _equipe_id) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'L\'équipe spécifiée n\'existe pas.';
        END IF;

        -- Insérer le joueur
        INSERT INTO joueurs (nom_joueur, prenom_joueur, numero_tshirt, equipe_id)
        VALUES (_nom_joueur, _prenom_joueur, _numero_tshirt, _equipe_id);
    COMMIT;
END //

DELIMITER ;
CALL AjouterJoueur('NomJoueur', 'PrenomJoueur', 10, 'NomEquipeExistante');
