DECLARE @searchString NVARCHAR(255) = '%string%'

SELECT name
FROM   sys.procedures
WHERE  Object_definition(object_id) LIKE @searchString -- Use the search string to find the procedure names