-- Album → Artist
select * from artist
select * from album

ALTER TABLE Album
ADD CONSTRAINT FK_Album_Artist
FOREIGN KEY (artist_id) REFERENCES Artist(artist_id);

-- Track → Album
select * from track

ALTER TABLE Track
ADD CONSTRAINT FK_Track_Album
FOREIGN KEY (Album_Id) REFERENCES Album(Album_Id);

-- Track → MediaType
select * from media_type

ALTER TABLE Track
ADD CONSTRAINT FK_Track_MediaType
FOREIGN KEY (Media_Type_Id) REFERENCES Media_Type(Media_Type_Id);

-- Track → Genre
select * from genre

ALTER TABLE Track
ADD CONSTRAINT FK_Track_Genre
FOREIGN KEY (Genre_Id) REFERENCES Genre(Genre_Id);

-- PlaylistTrack → Playlist
select * from playlist_track

ALTER TABLE Playlist_Track
ADD CONSTRAINT FK_Playlist_Track_Playlist
FOREIGN KEY (Playlist_Id) REFERENCES Playlist(Playlist_Id);

-- PlaylistTrack → Track


ALTER TABLE Playlist_Track
ADD CONSTRAINT FK_PlaylistTrack_Track
FOREIGN KEY (Track_Id) REFERENCES Track(Track_Id);

-- Invoice → Customer
select * from customer

ALTER TABLE Invoice
ADD CONSTRAINT FK_Invoice_Customer
FOREIGN KEY (Customer_Id) REFERENCES Customer(Customer_Id);

-- InvoiceLine → Invoice
select * from invoice_line

ALTER TABLE Invoice_Line
ADD CONSTRAINT FK_InvoiceLine_Invoice
FOREIGN KEY (Invoice_Id) REFERENCES Invoice(Invoice_Id);

-- InvoiceLine → Track
ALTER TABLE Invoice_Line
ADD CONSTRAINT FK_InvoiceLine_Track
FOREIGN KEY (TrackId) REFERENCES Track(TrackId);

-- Customer → Employee (SupportRepId)
ALTER TABLE Customer
ADD CONSTRAINT FK_Customer_Employee
FOREIGN KEY (Support_Rep_Id) REFERENCES Employee(Employee_Id);

-- Employee → Employee (ReportsTo)
ALTER TABLE Employee
ADD CONSTRAINT FK_Employee_Manager
FOREIGN KEY (Reports_To) REFERENCES Employee(Employee_Id);

ALTER TABLE Invoice_Line
ADD CONSTRAINT FK_InvoiceLine_Track
FOREIGN KEY (Track_Id) REFERENCES Track(Track_Id);
