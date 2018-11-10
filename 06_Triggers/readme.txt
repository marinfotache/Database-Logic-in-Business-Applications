Prerequisites:

1. Make sure there is a separate (sub)schema available.
  1.a If you have administrative privileges (you are working on your own laptops/desktops or you
      are a DBA or power (enough) user), create a special subschema:
        `CREATE USER sales IDENTIFIED BY sales ;
         GRANT DBA TO sales ;'
      and then connect to this sub-schema (create a special connection in Oracle SQL Developer).
      Note: if your server is public, use a different password!
  1.b If you don't have permissions to create users (subschemas), you can still create the tables into
    an existing sub-schema, but pay attention to avoid conflicts with existing tables and
    constraints (e.g. there might already be a table "invoices"...)
        
2. Execute first two scripts (`06-00-1...` and `06-00-2`) that set up the database tables (tables and constraints) by copying and execute them in Oracle SQL Developer.


Starting with `06-01a` we strongly recommend to follow the scripts statement by statement, and execute suggested pieces of code and statements as suggested.
Do not forget to activate `DBMS Output` tab (in Oracle SQL Developer, select `View` from the meniu and then the `Dbms Output` option).

