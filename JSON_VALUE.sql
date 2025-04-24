DECLARE @jsonInfo NVARCHAR(MAX)

SET @jsonInfo=N'{  
     "info":{    
       "type":1,  
       "address":{    
         "town":"Bristol",  
         "county":"Avon",  
         "country":"England"  
       },  
       "tags":["Sport", "Water polo"]  
    },  
    "type":"Basic"  
 }' 

SELECT JSON_VALUE(@jsonInfo, '$.info.type') AS Type,  
       JSON_VALUE(@jsonInfo, '$.info.address.town') AS Town,  
       JSON_VALUE(@jsonInfo, '$.info.tags[0]') AS Tag1,  
       JSON_VALUE(@jsonInfo, '$.info.tags[1]') AS Tag2,  
       JSON_VALUE(@jsonInfo, '$.type') AS Type2;
