create directory dir_img as 'C:\blobs2';

select * from all_directories;

create table perrito(
    id number,
    imagen blob default empty_blob()
)

set SERVEROUTPUT ON

declare
    v_blob blob;
    v_bfile bfile;
begin
    insert into perrito values(1,empty_blob()) returning imagen into v_blob;
    v_bfile := bfilename('DIR_IMG','pompom.jpeg');
    DBMS_LOB.OPEN(v_bfile,DBMS_LOB.LOB_READONLY);
    DBMS_LOB.LOADFROMFILE(v_blob,v_bfile,SYS.DBMS_LOB.GETLENGTH(v_bfile));
    DBMS_LOB.CLOSE(v_bfile);
    commit;
end;

select * from perrito
