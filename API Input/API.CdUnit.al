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
    procedure HttpFact() Jkey: List of [Text];
    var
        Httpcl: HttpClient;
        HttpRsp: HttpResponseMessage;
        Rsp, URL : Text;
        Jobject: JsonObject;
        Jtoken: JsonToken;
        ApiSite: Record "API Address";

    begin
        Httpcl.SetBaseAddress(ApiSite.UrlSite());
        Httpcl.Get(ApiSite.UrlSite(), HttpRsp);
        HttpRsp.Content.ReadAs(Rsp);
        Jtoken.ReadFrom(Rsp);
        if Jtoken.IsObject then begin
            Jobject := Jtoken.AsObject();
            Jkey := Jobject.Keys();
        end
    end;

    procedure ListkeyToIndKey() TeKey: Text;
    var
        i, counter : Integer;
    begin
        i := 0;
        counter := HttpFact().Count;
        while i < HttpFact().count do begin
            i += 1;
            HttpFact().Get(i, TeKey);
        end;
    end;

    procedure InsertCountValueFact()
    var
        ApiAddress: Record "API Address";
        Address, TeKey : Text;
        Counter: Integer;
    begin
        ApiAddress.Init();
        ApiAddress.Fact := ListkeyToIndKey();
        ApiAddress.Value := HttpValue();
        ApiAddress.No := "No."();
        ApiAddress.Insert();
    end;
    // Here we create a function to get the value from the jsonobject
    procedure HttpValue() answer: Text;
    var
        Jobject: JsonObject;
        Jtoken, JVtoken : JsonToken;
        JLtoken: List of [JsonToken];
        Httpcl: HttpClient;
        HttpRsp: HttpResponseMessage;
        Rsp: Text;
        int, null : Integer;
        ApiRec: Record "API Address";

    begin
        Httpcl.SetBaseAddress(ApiRec.UrlSite());
        Httpcl.Get(ApiRec.UrlSite(), HttpRsp);
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
    procedure "No."() i: Integer;
    var
        HttpCl: HttpClient;
        HttpRsp: HttpResponseMessage;
        Rsp: Text;
        Token: JsonToken;
        Object: JsonObject;
        Lkey: List of [Text];
        ApiSite: Record "API Address";

    begin
        Httpcl.SetBaseAddress(ApiSite.UrlSite());
        HttpCl.Get(ApiSite.UrlSite(), HttpRsp);
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
}