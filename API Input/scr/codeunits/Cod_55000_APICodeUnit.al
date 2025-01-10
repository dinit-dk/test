codeunit 55000 "API Code Unit"
{
    procedure HttpMessage()
    var
        HttpCl: HttpClient;
        HttpRspn: HttpResponseMessage;
        Response: Text;
        URL: Label 'https://catfact.ninja/fact/';
        Jvalue: JsonValue;
        Jtoken: JsonToken;
        Jobject: JsonObject;
        CatFact: Text;
    begin
        HttpCl.Get(URL, HttpRspn);
        HttpRspn.Content.ReadAs(Response);
        Jobject.ReadFrom(Response);
        Jobject.Get('fact', Jtoken);
        Jtoken.WriteTo(CatFact);
        Message(CatFact);
    end;

    // Here we create a function to get the key from the Jsonobject and put it into a list.
    procedure HttpFact(ApiAddress: Record "API Address"; var Jobject: JsonObject) Jkey: List of [Text];
    var
        Httpcl: HttpClient;
        HttpRsp: HttpResponseMessage;
        Rsp: Text;
        Jtoken: JsonToken;
        Jarray: JsonArray;
    begin
        Httpcl.SetBaseAddress(ApiAddress.UrlSite());
        Httpcl.Get(ApiAddress.UrlSite(), HttpRsp);
        HttpRsp.Content.ReadAs(Rsp);
        Jtoken.ReadFrom(Rsp);
        if Jtoken.IsArray then begin
            Jarray := Jtoken.AsArray();
            Message('Count array: %1', Jarray.Count);
            if Jarray.Get(1, Jtoken) then;
            //[{"amiiboSeries":"Mario Sports Superstars","character":"Metal Mario","gameSeries":"Mario Sports Superstars","head":"09d00301","image":"https://raw.githubusercontent.com/N3evin/AmiiboAPI/master/images/...
        end;
        if Jtoken.IsObject then begin
            Jobject := Jtoken.AsObject();
            Jkey := Jobject.Keys();
        end
    end;

    procedure InsertCountValueFact(APIAddress: Record "API Address")
    var
        ApiContent: Record "API Content";
        Jobject: JsonObject;
        Jtoken: JsonToken;
        Address, TeKey : Text;
        Jkey: List of [Text];
        JkeyTxt: Text;
        i: Integer;
        ValueText: Text;
        outs: OutStream;
        crlf: Text;
        squarepos: Integer;
        comma: Text;
    begin
        // Text that contains a new line.
        crlf[1] := 13;
        crlf[2] := 10;

        //Delete all content before retrieving new content
        ApiContent.SetRange(Name, APIAddress.Name);
        ApiContent.DeleteAll();

        Jkey := HttpFact(APIAddress, Jobject);
        i := 0;
        while i < Jkey.count do begin
            i += 1;
            JkeyTxt := Jkey.Get(i);
            Jobject.Get(JkeyTxt, Jtoken);
            ApiContent.Fact := JkeyTxt;
            Jobject.Get(JkeyTxt, Jtoken);
            Jtoken.WriteTo(ValueText);
            ApiContent.Value := CopyStr(ValueText, 1, 400);
            ApiContent.Json.CreateOutStream(outs); //Opretter rør til Json
            outs.Write(ValueText); //Putter data i json feltet igennem røret
            ApiContent.No := i;
            ApiContent.Name := APIAddress.Name;
            ApiContent.Insert();
        end;
    end;

    // Here we create a function to get the value from the jsonobject
    procedure HttpValue(ApiAddress: Record "API Address") answer: Text;
    var
        Jobject: JsonObject;
        Jtoken, JVtoken : JsonToken;
        JLtoken: List of [JsonToken];
        Httpcl: HttpClient;
        HttpRsp: HttpResponseMessage;
        Rsp: Text;
        int, null : Integer;
    begin
        Httpcl.SetBaseAddress(ApiAddress.UrlSite());
        Httpcl.Get(ApiAddress.UrlSite(), HttpRsp);
        HttpRsp.Content.ReadAs(Rsp);
        Jtoken.ReadFrom(Rsp);
        if Jtoken.IsObject then begin
            Jobject := Jtoken.AsObject();
            JLtoken := Jobject.Values();
            int := JLtoken.Count;
            null := 0;
            while null < int do begin
                null += 1;
                JLtoken.Get(null, JVtoken);
                JVtoken.WriteTo(answer);
            end;
        end;
    end;

    // Here we create a function designed as a counter
    procedure "No."(APIAddress: Record "API Address") i: Integer;
    var
        HttpCl: HttpClient;
        HttpRsp: HttpResponseMessage;
        Rsp: Text;
        Token: JsonToken;
        Object: JsonObject;
        Lkey: List of [Text];
    begin
        Httpcl.SetBaseAddress(APIAddress.UrlSite());
        HttpCl.Get(APIAddress.UrlSite(), HttpRsp);
        HttpRsp.Content.ReadAs(Rsp);
        Token.ReadFrom(Rsp);
        if Token.IsObject then begin
            Object := Token.AsObject();
            Lkey := Object.Keys();
            i := 0;
            while i < Lkey.Count do begin
                i += 1;
            end;
        end;
    end;

    procedure InsertNewLine(ValueTxt: Text; Value: Text; NewLineLast: Boolean): Text
    var
        crlf: Text;
        ValuePos: Integer;
        ListPos: List of [Integer];
        TempValueTxt: Text;
        ValueLen: Integer;
    begin
        crlf[1] := 13;
        crlf[2] := 10;
        TempValueTxt := ValueTxt;
        ValuePos := StrPos(ValueTxt, Value);
        ValueLen := Strlen(Value);
        while ValuePos > 0 do begin

            // Insert new line
            if NewLineLast then
                ValueTxt := CopyStr(ValueTxt, 1, ValuePos + ValueLen - 1) + crlf + CopyStr(ValueTxt, ValuePos + ValueLen)
            else
                ValueTxt := CopyStr(ValueTxt, 1, ValuePos - 1) + crlf + CopyStr(ValueTxt, ValuePos);



            // Find next text
            if NewLineLast then
                TempValueTxt := CopyStr(ValueTxt, ValuePos + ValueLen)
            else
                TempValueTxt := CopyStr(ValueTxt, ValuePos + ValueLen + StrLen(crlf));


            // Find next pos
            if TempValueTxt.Contains(Value) then begin
                // Changes value's position to the next value in the text.
                ValuePos += StrPos(TempValueTxt, Value);
                if NewLineLast then
                    ValuePos += StrLen(crlf) + 1;
            end else
                ValuePos := 0;
        end;
        exit(valuetxt);
    end;

    procedure SaveJsonTokenToTempBlob()
    var
        JsonToken: JsonToken;
        TempBlob: Codeunit "Temp Blob";
        JsonObject: JsonObject;
        JsonArray: JsonArray;
        JsonTextWriter: Text;
        JsonText: Text;
        OutStream: OutStream;
        Ins: InStream;
        FileName: Text;
        MimeType: Text;
        CRLF: Text;
        T: Text;
        ApiAddress: Record "API Address";
        ApiContent: Record "API Content";
        Url: Text;
    begin
        // Define CRLF (Carriage Return + Line Feed) for new lines
        CRLF[1] := 13;
        CRLF[2] := 10;
        
        // Example of initializing a JsonToken (adjust to your scenario)
        JsonToken.ReadFrom(T); // This is just a placeholder example.

        // Format the JsonToken into a readable JSON string
        JsonText := ReturnFormatJsonText(JsonToken, 0, false);

        // Write the JSON text to the TempBlob outstream
        TempBlob.CreateOutStream(OutStream);
        OutStream.WriteText(JsonText);

        // Create an instream from the TempBlob
        TempBlob.CreateInStream(Ins);

        // Define the MIME type and file name for the JSON file
        FileName := 'MyJsonFile.json'; // Name of the output file

        // Save the file by downloading it
        DownloadFromStream(Ins, '', '', '', FileName);
    end;

    procedure ReturnFormatJsonText(JToken: JsonToken; Indent: Integer; IsValue: Boolean) JsonText: Text
    var
        JArray: JsonArray;
        JObject: JsonObject;
        LocalJToken: JsonToken;
        LocalText: Text;
        CRLF: Text;
        JCount: Integer;
        i: Integer;
    begin
        // Define CRLF for new lines
        CRLF[1] := 13;
        CRLF[2] := 10;

        if JToken.IsValue() then begin
            // If the token is a value, write it directly to the JSON text
            JToken.WriteTo(LocalText);
            JsonText := LocalText;
        end else if JToken.IsObject() then begin
            // If the token is an object, start formatting it
            if IsValue then
                JsonText := '{' + CRLF
            else
                JsonText := GetStringOfSpaces(Indent) + '{' + CRLF;

            // Convert the object keys and values into JSON format
            JObject := JToken.AsObject();
            JCount := JObject.Keys.Count;
            i := 0;
            while i < JCount do begin
                i += 1;
                if JObject.Keys.Get(i, LocalText) then begin
                    JsonText += GetStringOfSpaces(Indent + 2) + '"' + LocalText + '": ';
                    if JObject.Values.Get(i, LocalJToken) then begin
                        JsonText += ReturnFormatJsonText(LocalJToken, Indent + 2, true);
                        if not (i = JCount) then
                            JsonText += ',';
                        JsonText += CRLF;
                    end;
                end;
            end;

            // Close the object with a closing brace
            JsonText += GetStringOfSpaces(Indent) + '}';
        end else if JToken.IsArray() then begin
            // If the token is an array, start formatting it
            JsonText := GetStringOfSpaces(Indent) + '[' + CRLF;

            JArray := JToken.AsArray();
            JCount := JArray.Count;
            i := 0;
            while i < JCount do begin
                if JArray.Get(i, LocalJToken) then begin
                    JsonText += ReturnFormatJsonText(LocalJToken, Indent + 2, false);
                    if not (i + 1 = JCount) then
                        JsonText += ',';
                    JsonText += CRLF;
                end;
                i += 1;
            end;

            // Close the array with a closing bracket
            JsonText += GetStringOfSpaces(Indent) + ']';
        end else
            // If the token type is unknown, raise an error
            Error('Unknown JsonToken type.');
    end;

    procedure GetStringOfSpaces(NumberOfSpaces: Integer): Text
    var
        SpaceString: Text;
    begin
        while NumberOfSpaces > 0 do begin
            NumberOfSpaces -= 1;
            SpaceString += '  ';
        end;
        exit(SpaceString);
    end;

    local procedure JsonTextSample(): Text
    var
        Httpcl: HttpClient;
        Httprsp: HttpResponseMessage;
        JsonTxt, Rsp : Text;
        APIAddress: Record "API Address";
        ApiContent: Record "API Content";
    begin
        // Return a sample JSON text for demonstration purposes
        ApiContent.Init();

        Httpcl.SetBaseAddress(APIAddress.Url + APIAddress.Search);
        Httpcl.Get(APIAddress.UrlSite(), Httprsp);
        Httprsp.Content.ReadAs(Rsp);
        JsonTxt := Rsp;

        ApiContent.Insert();
    end;

    procedure JsonTextCall(Url: Text) Rsp: Text;
    var
        Httpcl: HttpClient;
        HttpRsp: HttpResponseMessage;
        Jtoken: JsonToken;

    begin
        Httpcl.SetBaseAddress(Url);
        Httpcl.Get(Url, HttpRsp);
        HttpRsp.Content.ReadAs(Rsp);
        Jtoken.ReadFrom(Rsp);
    end;
}