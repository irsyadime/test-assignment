create table gudang(
	id int primary key,
	kode_gudang varchar(25),
	nama_gudang varchar(50)
);

create table barang(
	id int primary key,
	kode_barang varchar(25),
	nama_barang varchar(50),
	harga int,
	jumlah int,
	expired_date date,
	CONSTRAINTS fk_gudang foreign key (id_gudang) references gudang(id)
 );
 
 Delimiter //
 
 create procedure GetPagedAllData(
 	IN SearchTerm VARCHAR(50),
    IN SortColumn VARCHAR(50),
    IN SortOrder VARCHAR(4),
    IN PageNumber INT,
    IN PageSize INT
 )
 begin
 	set @offset = (PageNumber - 1) * PageSize;
	set @sql = 'select kode_gudang,nama_gudang,kode_barang,nama_barang,harga,jumlah,expired_date
				from gudang join barang on id = id_gudang
				';
	IF SearchTerm IS NOT NULL AND SearchTerm != '' THEN
        SET @SQL = CONCAT(@SQL, ' AND (kode_barang LIKE ''%', SearchTerm, '%'' OR nama_barang LIKE ''%', SearchTerm, '%'' OR expired_date LIKE ''%', SearchTerm, '%'')');
    END IF;
	
	SET @SQL = CONCAT(@SQL, ' ORDER BY ', SortColumn, ' ', SortOrder);
    SET @SQL = CONCAT(@SQL, ' LIMIT ', @Offset, ', ', PageSize);
    
    PREPARE stmt FROM @SQL;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
end //

Delimiter;