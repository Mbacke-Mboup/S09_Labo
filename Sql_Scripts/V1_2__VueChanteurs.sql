
	-- Nouvelle vue

	
	CREATE VIEW Musique.VW_ChanteurNbChansons AS
	
	select C.ChanteurID, C.Nom, DateNaissance as [Date de Naissance], count(CH.ChanteurID) as [Nombre de Chansons]  from Musique.Chanteur C
	left join Musique.Chanson CH
	on CH.ChanteurID = C.ChanteurID
	group by C.ChanteurID, C.Nom, C.DateNaissance
	GO
	
	-- Résultat souhaité : id du chanteur, nom du chanteur, date de naissance et son nombre de chansons
	
	-- ChanteurID |Nom  | Date de naissance |Nombre de chansons
	-- -----------|-----|-------------------|-------------------

