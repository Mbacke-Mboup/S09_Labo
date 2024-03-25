
	-- Nouvelle colonne pour la PK de Musique.Chanteur et la FK de Musique.Chanson
		alter table Musique.Chanteur add ChanteurID int identity(1,1)
		go
		
		alter table  Musique.Chanson add ChanteurID int null
		go
	
	-- Supprimer les anciennes contraintes FK puis PK (attention, l'ordre de suppression est important ici)
	
		alter table Musique.Chanson drop constraint FK_Chanson_NomChanteur
		go

		alter table Musique.Chanteur drop constraint PK_Chanteur_Nom
		go

	
	-- Nouvelles contraintes PK puis FK
	
		alter table Musique.Chanteur add
		constraint PK_Chanteurs primary key (ChanteurID)
		go

		alter table  Musique.Chanson add constraint FK_Chanteurs FOREIGN KEY (ChanteurID) REFERENCES Musique.Chanteur(ChanteurID)
		go
	
	-- Remplir la nouvelle colonne FK et faire en sorte que le nouveau champ que vous avez crée ChanteurID n'est pas null maintenant
		use S09_Labo
go
		UPDATE Musique.Chanson
		SET ChanteurID = (select CH.ChanteurID from Musique.Chanteur CH where CH.Nom = NomChanteur)
	-- Supprimer l'ancienne colonne FK de Musique.Chanson (On veut garder le nom des chanteurs, donc on ne supprime pas l'ancienne PK !)
	

	