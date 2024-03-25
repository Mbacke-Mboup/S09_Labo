
	-- Nouvelle procédure
	
	
	CREATE PROCEDURE Musique.USP_ChanteurChansons
	@ChanteurID int
	AS
	BEGIN
		select * from Musique.Chanson
		where ChanteurID = @ChanteurID
	END
	GO

	