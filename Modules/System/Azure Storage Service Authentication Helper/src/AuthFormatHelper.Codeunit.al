// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------

codeunit 9060 "Auth. Format Helper"
{
    Access = Internal;

    procedure NewLine(): Text
    var
        LF: Char;
    begin
        LF := 10;
        exit(Format(LF));
    end;

    procedure GetIso8601DateTime(MyDateTime: DateTime): Text
    begin
        exit(FormatDateTime(MyDateTime, 's')); // https://docs.microsoft.com/en-us/dotnet/standard/base-types/standard-date-and-time-format-strings
    end;

    procedure GetRfc1123DateTime(MyDateTime: DateTime): Text
    begin
        exit(FormatDateTime(MyDateTime, 'R')); // https://docs.microsoft.com/en-us/dotnet/standard/base-types/standard-date-and-time-format-strings
    end;

    local procedure FormatDateTime(MyDateTime: DateTime; FormatSpecifier: Text): Text
    var
        DateTimeAsXmlString: Text;
        DateTimeDotNet: DotNet DateTime;
    begin
        DateTimeAsXmlString := Format(MyDateTime, 0, 9); // Format as XML, e.g.: 2020-11-11T08:50:07.553Z
        exit(DateTimeDotNet.Parse(DateTimeAsXmlString).ToUniversalTime().ToString(FormatSpecifier));
    end;

    [NonDebuggable]
    procedure GetAccessKeyHashCode(StringToSign: Text; AccessKey: Text): Text;
    var
        CryptographyMgmt: Codeunit "Cryptography Management";
        HashAlgorithmType: Option HMACMD5,HMACSHA1,HMACSHA256,HMACSHA384,HMACSHA512;
    begin
        exit(CryptographyMgmt.GenerateBase64KeyedHashAsBase64String(StringToSign, AccessKey, HashAlgorithmType::HMACSHA256));
    end;

    procedure GetCanonicalizedHeaders(Headers: Dictionary of [Text, Text]): Text
    var
        HeaderKey: Text;
        HeaderValue: Text;
        CanonicalizedHeaders: Text;
        KeyValuePairLbl: Label '%1:%2', Comment = '%1 = Key; %2 = Value';
    begin
        // "Headers" needs to be a sorted dictionary
        foreach HeaderKey in Headers.Keys do
            if (HeaderKey.ToLower().StartsWith('x-ms-')) then begin // only add headers that start with "x-ms-"
                if CanonicalizedHeaders <> '' then
                    CanonicalizedHeaders += NewLine();
                HeaderValue := Headers.Get(HeaderKey);
                CanonicalizedHeaders += StrSubstNo(KeyValuePairLbl, HeaderKey.ToLower(), HeaderValue)
            end;
        exit(CanonicalizedHeaders);
    end;

    procedure GetCanonicalizedResource(StorageAccount: Text; UriString: Text): Text
    var
        Uri: Codeunit Uri;
        UriBuider: Codeunit "Uri Builder";
        SortedDictionaryQuery: DotNet SortedDictionary2;
        SortedDictionaryEntry: DotNet GenericKeyValuePair2;
        QueryString: Text;
        Segments: List of [Text];
        Segment: Text;
        StringBuilderResource: TextBuilder;
        StringBuilderQuery: TextBuilder;
        StringBuilderCanonicalizedResource: TextBuilder;
        KeyValuePairLbl: Label '%1:%2', Comment = '%1 = Key; %2 = Value';
    begin
        Uri.Init(UriString);
        Uri.GetSegments(Segments);

        UriBuider.Init(UriString);
        QueryString := UriBuider.GetQuery();

        StringBuilderResource.Append('/');
        StringBuilderResource.Append(StorageAccount);
        foreach Segment in Segments do
            StringBuilderResource.Append(Segment);

        if QueryString <> '' then begin
            // According to documentation it should be lexicographically, but I didn't find a better way than SortedDictionary
            // see: https://docs.microsoft.com/en-us/rest/api/storageservices/authorize-with-shared-key#constructing-the-canonicalized-headers-string
            SplitQueryStringIntoSortedDictionary(QueryString, SortedDictionaryQuery);
            foreach SortedDictionaryEntry in SortedDictionaryQuery do begin
                StringBuilderQuery.Append(NewLine());
                StringBuilderQuery.Append(StrSubstNo(KeyValuePairLbl, SortedDictionaryEntry."Key", Uri.UnescapeDataString(SortedDictionaryEntry.Value)));
            end;
        end;
        StringBuilderCanonicalizedResource.Append(StringBuilderResource.ToText());
        StringBuilderCanonicalizedResource.Append(StringBuilderQuery.ToText());
        exit(StringBuilderCanonicalizedResource.ToText());
    end;

    local procedure SplitQueryStringIntoSortedDictionary(QueryString: Text; var NewSortedDictionary: DotNet SortedDictionary2)
    var
        Segments: List of [Text];
        Segment: Text;
        CurrIdentifier: Text;
        CurrValue: Text;
    begin
        if QueryString.StartsWith('?') then
            QueryString := CopyStr(QueryString, 2);
        Segments := QueryString.Split('&');

        NewSortedDictionary := NewSortedDictionary.SortedDictionary();

        foreach Segment in Segments do begin
            GetKeyValueFromQueryParameter(Segment, CurrIdentifier, CurrValue);
            NewSortedDictionary.Add(CurrIdentifier, CurrValue);
        end;
    end;

    local procedure GetKeyValueFromQueryParameter(QueryString: Text; var CurrIdentifier: Text; var CurrValue: Text)
    var
        Split: List of [Text];
    begin
        Split := QueryString.Split('=');
        if Split.Count <> 2 then
            Error('This should not happen'); // TODO: Make better error
        CurrIdentifier := Split.Get(1);
        CurrValue := Split.Get(2);
    end;

    procedure CreateSharedKeyStringToSign(ApiVersion: Enum "Storage service API Version"; HeaderValues: Dictionary of [Text, Text]; HttpRequestType: Enum "Http Request Type"; StorageAccount: Text; UriString: Text): Text
    var
        StringToSign: Text;
    begin
        // TODO: Add Handling-structure for different API-versions
        StringToSign += Format(HttpRequestType) + NewLine();
        StringToSign += GetHeaderValueOrEmpty(HeaderValues, 'Content-Encoding') + NewLine();
        StringToSign += GetHeaderValueOrEmpty(HeaderValues, 'Content-Language') + NewLine();
        StringToSign += GetHeaderValueOrEmpty(HeaderValues, 'Content-Length') + NewLine();
        StringToSign += GetHeaderValueOrEmpty(HeaderValues, 'Content-MD5') + NewLine();
        StringToSign += GetHeaderValueOrEmpty(HeaderValues, 'Content-Type') + NewLine();
        StringToSign += GetHeaderValueOrEmpty(HeaderValues, 'Date') + NewLine();
        StringToSign += GetHeaderValueOrEmpty(HeaderValues, 'If-Modified-Since') + NewLine();
        StringToSign += GetHeaderValueOrEmpty(HeaderValues, 'If-Match') + NewLine();
        StringToSign += GetHeaderValueOrEmpty(HeaderValues, 'If-None-Match') + NewLine();
        StringToSign += GetHeaderValueOrEmpty(HeaderValues, 'If-Unmodified-Since') + NewLine();
        StringToSign += GetHeaderValueOrEmpty(HeaderValues, 'Range') + NewLine();
        StringToSign += GetCanonicalizedHeaders(HeaderValues) + NewLine();
        StringToSign += GetCanonicalizedResource(StorageAccount, UriString);
        exit(StringToSign);
    end;

    local procedure GetHeaderValueOrEmpty(HeaderValues: Dictionary of [Text, Text]; HeaderKey: Text): Text
    var
        ReturnValue: Text;
    begin
        if not HeaderValues.Get(HeaderKey, ReturnValue) then
            exit('');
        if HeaderKey = 'Content-Length' then
            if ReturnValue = '0' then // TODO: In version 2014-02-14 and earlier, the content length was included even if zero.  
                exit('');
        exit(ReturnValue);
    end;

    // #region Used for Shared Access Signature creation
    procedure CreateSharedAccessSignatureStringToSign(AccountName: Text; ApiVersion: Enum "Storage Service API Version"; StartDate: DateTime; EndDate: DateTime; Services: List of [Enum "Storage Service Type"]; Resources: List of [Enum "Storage Service Resource Type"]; Permissions: List of [Enum "Storage Service Permission"]; Protocols: List of [Text]; IPRange: Text): Text
    var
        StringToSign: Text;
    begin
        StringToSign += AccountName + NewLine();
        StringToSign += PermissionsToString(Permissions) + NewLine();
        StringToSign += ServicesToString(Services) + NewLine();
        StringToSign += ResourcesToString(Resources) + NewLine();
        StringToSign += DateToString(StartDate) + NewLine();
        StringToSign += DateToString(EndDate) + NewLine();
        StringToSign += IPRange + NewLine();
        StringToSign += ProtocolsToString(Protocols) + NewLine();
        StringToSign += VersionToString(ApiVersion) + NewLine();
        exit(StringToSign);
    end;

    procedure CreateSasUrlString(ApiVersion: Enum "Storage Service API Version"; StartDate: DateTime; EndDate: DateTime; Services: List of [Enum "Storage Service Type"]; Resources: List of [Enum "Storage Service Resource Type"]; Permissions: List of [Enum "Storage Service Permission"]; Protocols: List of [Text]; IPRange: Text; Signature: Text): Text
    var
        Uri: Codeunit Uri;
        Builder: TextBuilder;
        KeyValueLbl: Label '%1=%2', Comment = '%1 = Key; %2 = Value';
    begin
        Builder.Append('?');
        Builder.Append(StrSubstNo(KeyValueLbl, 'sv', VersionToString(ApiVersion)));
        Builder.Append('&');
        Builder.Append(StrSubstNo(KeyValueLbl, 'ss', ServicesToString(Services)));
        Builder.Append('&');
        Builder.Append(StrSubstNo(KeyValueLbl, 'srt', ResourcesToString(Resources)));
        Builder.Append('&');
        Builder.Append(StrSubstNo(KeyValueLbl, 'sp', PermissionsToString(Permissions)));
        Builder.Append('&');
        Builder.Append(StrSubstNo(KeyValueLbl, 'se', DateToString(EndDate)));
        Builder.Append('&');
        Builder.Append(StrSubstNo(KeyValueLbl, 'st', DateToString(StartDate)));
        Builder.Append('&');
        Builder.Append(StrSubstNo(KeyValueLbl, 'spr', ProtocolsToString(Protocols)));
        Builder.Append('&');
        Builder.Append(StrSubstNo(KeyValueLbl, 'sig', Uri.EscapeDataString(Signature)));
        exit(Builder.ToText());
    end;

    local procedure VersionToString(ApiVersion: Enum "Storage Service API Version"): Text
    begin
        exit(Format(ApiVersion));
    end;

    local procedure DateToString(MyDateTime: DateTime): Text
    begin
        exit(GetIso8601DateTime(MyDateTime));
    end;

    local procedure ServicesToString(Services: List of [Enum "Storage Service Type"]): Text
    var
        Service: Enum "Storage Service Type";
        Builder: TextBuilder;
    begin
        foreach Service in Enum::"Storage Service Type".Ordinals() do
            if Services.Contains(Service) then
                Builder.Append(Format(Service));

        exit(Builder.ToText());
    end;

    local procedure ResourcesToString(Resources: List of [Enum "Storage Service Resource Type"]): Text
    var
        Resource: Enum "Storage Service Resource Type";
        Builder: TextBuilder;
    begin
        foreach Resource in Enum::"Storage Service Resource Type".Ordinals() do
            if Resources.Contains(Resource) then
                Builder.Append(Format(Resource));

        exit(Builder.ToText());
    end;

    local procedure PermissionsToString(Permissions: List of [Enum "Storage Service Permission"]): Text
    var
        Permission: Enum "Storage Service Permission";
        Builder: TextBuilder;
    begin
        foreach Permission in Enum::"Storage Service Permission".Ordinals() do
            if Permissions.Contains(Permission) then
                Builder.Append(Format(Permission));

        exit(Builder.ToText());
    end;

    local procedure ProtocolsToString(Protocols: List of [Text]): Text
    var
        Protocol: Text;
        Builder: TextBuilder;
    begin
        foreach Protocol in Protocols do begin
            if Builder.ToText() <> '' then
                Builder.Append(',');
            Builder.Append(Protocol)
        end;
        exit(Builder.ToText());
    end;
    // #endregion
}