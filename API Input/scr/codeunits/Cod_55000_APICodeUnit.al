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

        ApiContent.Init();
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
            ApiContent.Json.CreateOutStream(outs);
            // outs.Write('jesper' + crlf);
            // squarepos := StrPos(ValueText, '[');
            // ValueText := CopyStr(ValueText, 1, squarepos) + crlf + '  ' + CopyStr(ValueText, squarepos + 1);
            // squarepos := StrPos(ValueText, '{');
            // ValueText := CopyStr(ValueText, 1, squarepos) + crlf + '    ' + CopyStr(ValueText, squarepos + 1);
            // squarepos := StrPos(ValueText, ',');
            // ValueText := CopyStr(ValueText, 1, squarepos) + crlf + '    ' + CopyStr(ValueText, squarepos + 1);
            ValueText := InsertNewLine(ValueText, '[', true);
            ValueText := InsertNewLine(ValueText, '{', true);
            ValueText := InsertNewLine(ValueText, '",', true);
            ValueText := InsertNewLine(ValueText, '},', true);
            ValueText := InsertNewLine(ValueText, '}', false);
            ValueText := InsertNewLine(ValueText, ']', false);
            outs.Write(ValueText);
            // ApiContent.Value := HttpValue(APIAddress);
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
}