use S09_Labo
go



IF (SELECT COUNT(*) FROM sys.symmetric_keys WHERE name LIKE '%DatabaseMasterKey%') = 0
BEGIN
   create MASTER key encryption by Password='UnPassW0rd!LaYee'
END
go
select * from sys.symmetric_keys

create certificate MonCertificat with subject = 'ChiffrementCouleur'
go

create symmetric key MaSuperCle with algorithm = AES_256 encryption by Certificate MonCertificat
	-- Table d'utilisateurs
	
	CREATE TABLE Utilisateurs.Utilisateur(
		UtilisateurID int IDENTITY(1,1),
		Pseudo nvarchar(50) NOT NULL,
		MotDePasseHache varbinary(32) NOT NULL,
		Sel varbinary(16) NOT NULL,
		CouleurPrefere varbinary(max) NOT NULL,
		CONSTRAINT PK_Utilisateur_UtilisateurID PRIMARY KEY (UtilisateurID)
	);
	GO
	
	-- Contraintes
	
	ALTER TABLE Utilisateurs.Utilisateur ADD CONSTRAINT
	UC_Utilisateur_Pseudo UNIQUE (Pseudo);
	GO
	
	-- Créer une clé maîtresse avec un mot de passe
	-- ?
	
	-- Créer un certificat auto-signé
	-- ?
	
	-- Créer une clé symétrique
	-- ?
	
	-- Procédure inscription
	CREATE PROCEDURE Utilisateurs.USP_CreerUtilisateur
		@Pseudo nvarchar(50),
		@MotDePasse nvarchar(50),
		@Couleur nvarchar(30)
	AS
	BEGIN
	
		DECLARE @Sel varbinary(16) = CRYPT_GEN_RANDOM(16);
		declare @MdpEtSel nvarchar(116) = concat(@MotDePasse, @Sel);
		declare @MdpHachage varbinary(32) = hashbytes('SHA2_256',@MdpetSel)
		
		open symmetric key MaSuperCle
		decryption by certificate MonCertificat

		declare @CouleurChiff varbinary(max) = Encryptbykey(KEY_GUID('MaSuperCle'),@Couleur)
		close symmetric key MaSuperCle

		INSERT INTO Utilisateurs.Utilisateur (Pseudo, MotDePasseHache, Sel, CouleurPrefere)
		VALUES
		(@Pseudo, @MdpHachage, @Sel, @CouleurChiff);
	
	END
	GO
	
	-- Procédure authentification
	
	CREATE PROCEDURE Utilisateurs.USP_AuthUtilisateur
		@Pseudo nvarchar(50),
		@MotDePasse nvarchar(50)
	AS
	BEGIN
		declare @Sel varbinary(16);
		DECLARE @MdpHache varbinary(32);
		select @Sel = Sel, @MdpHache = MotDePasseHache
		FROM Utilisateurs.Utilisateur
		WHERE Pseudo = @Pseudo;
		
		IF HASHBYTES('SHA2_256',concat(@MotDePasse,@Sel)) = @MdpHache
		BEGIN
			SELECT * FROM Utilisateurs.Utilisateur WHERE Pseudo = @Pseudo;
		END
		ELSE
		BEGIN
			SELECT TOP 0 * FROM Utilisateurs.Utilisateur;
		END
	
	END
	GO
	
	-- Insertions de quelques utilisateurs (si jamais inscription ne marche pas, testez au moins la connexion / déconnexion)
	
	EXEC Utilisateurs.USP_CreerUtilisateur @Pseudo = 'max', @MotDePasse = 'Salut1!', @Couleur = 'indigo';
	GO
	
	EXEC Utilisateurs.USP_CreerUtilisateur @Pseudo = 'chantal', @MotDePasse = 'Allo2!', @Couleur = 'bourgogne';
	GO
	
	EXEC Utilisateurs.USP_CreerUtilisateur @Pseudo = 'kamalPro', @MotDePasse = 'Bonjour3!', @Couleur = 'cramoisi';
	GO
	
	
	
	
	
	