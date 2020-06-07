import urllib.request
import urllib.parse
import json
import csv
import traceback
import logging
from robot.api.deco import keyword

baseUrl = "https://api.clashroyale.com/v1"
clanTagStartsWith = "#9V2Y"
status = {"status":"Success","details":""}

## make Generic calls to API clash royale
def makeApiCall(endPoint,body,header) :
    try :
        # building the call
        request = urllib.request.Request(
            baseUrl+endPoint,
            body,
            header
        )
        # parsing the result
        return json.loads(urllib.request.urlopen(request).read().decode("utf-8"))
    except Exception:
        return traceback.format_exc()
    
@keyword('Generate ClanMembers Csv')
def generateClanMembersCsv(clanName, location, token) :
    header = {
        "Authorization": "Bearer "+token
    }
    ## get country location id on clash royale locations
    data = makeApiCall("/locations",None,header)
    # check for errors
    if isinstance(data, str):
        status["status"] = "Erro ao recuperar localização"
        status["details"] = data
        return status
    else:  
        locationId = [item.get("id") for item in data["items"] if item.get("name") == location][0]
    
    ## get clan tag using the name of the clan, location id and the beginning of clan tag
    data = makeApiCall("/clans?name="+urllib.parse.quote(clanName)+"&locationId="+str(locationId),None,header)
    # check for errors
    if isinstance(data, str):
        status["status"] = "Erro ao recuperar clan tag"
        status["details"] = data
        return status
    else:  
        clanTag = [item.get("tag") for item in data["items"] if item.get("tag").startswith(clanTagStartsWith)][0]

    ## get the clan members list using clan tag and export to csv file
    data = makeApiCall("/clans/"+urllib.parse.quote(clanTag)+"/members",None,header)
    # check for errors
    if isinstance(data, str):
        status["status"] = "Erro ao obter lista de membros"
        status["details"] = data
        return status
    else:
        # encoding ascii is generating erros at chars like 'ú' but its making a better result then utf-8. Try to use Pandas library to generate the csv
        try:
            with open('results/clanMembers.csv', 'w', encoding="ascii", errors="ignore", newline='') as file:
                writer = csv.writer(file)
                [writer.writerow([i]) for i in [(item.get("name")+","+str(item.get("expLevel"))+","+str(item.get("trophies"))+","+item.get("role")) for item in data["items"]]]
            return status 
        except Exception:
            status["status"] = "Erro ao obter lista de membros"
            status["details"] = traceback.format_exc()
            return status


#generateClanMembersCsv("The resistance", "Brazil", 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiIsImtpZCI6IjI4YTMxOGY3LTAwMDAtYTFlYi03ZmExLTJjNzQzM2M2Y2NhNSJ9.eyJpc3MiOiJzdXBlcmNlbGwiLCJhdWQiOiJzdXBlcmNlbGw6Z2FtZWFwaSIsImp0aSI6IjU0Yjc5ZjJmLTM0M2MtNGM4Yi05OGE4LWYxZGQ2NWQwYTk2OCIsImlhdCI6MTU5MTQ2ODQ4NSwic3ViIjoiZGV2ZWxvcGVyL2EyNTE1MTk5LTczY2UtOGQ1MC0wOTljLTdiYWM2M2Y1NjgzNSIsInNjb3BlcyI6WyJyb3lhbGUiXSwibGltaXRzIjpbeyJ0aWVyIjoiZGV2ZWxvcGVyL3NpbHZlciIsInR5cGUiOiJ0aHJvdHRsaW5nIn0seyJjaWRycyI6WyIxOTEuMjU0LjEwMy4xOTgiXSwidHlwZSI6ImNsaWVudCJ9XX0.5Iq8Q4UWKWc3LYfisnzlbU42fb44f-i2LKgOzcjAGJChVP1VE-HDeyVFtmIMRlyjRkFtyR6VrLvTvdn_fKHuww')