// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------

/// <summary>
/// Exposes functionality to handle the creation of a signature to sign requests to the Storage Services REST API
/// More Information: https://docs.microsoft.com/en-us/rest/api/storageservices/authorize-with-shared-key
/// </summary>
codeunit 9064 "Stor. Serv. Auth. Shared Key" implements "Storage Service Authorization"
{
    Access = Internal;

    procedure Authorize(var HttpRequest: HttpRequestMessage; StorageAccount: Text)
    var
        Headers: HttpHeaders;
    begin
        HttpRequest.GetHeaders(Headers);

        Headers.Remove('Authorization');
        Headers.Add('Authorization', GetSharedKeySignature(HttpRequest, StorageAccount));
    end;

    [NonDebuggable]
    procedure SetSharedKey(SharedKey: Text)
    begin
        Secret := SharedKey;
    end;

    procedure SetApiVersion(NewApiVersion: Enum "Storage service API Version")
    begin
        ApiVersion := NewApiVersion;
    end;

    [NonDebuggable]
    local procedure GetSharedKeySignature(HttpRequest: HttpRequestMessage; StorageAccount: Text): Text
    var
        StringToSign: Text;
        Signature: Text;
        SignaturePlaceHolderLbl: Label 'SharedKey %1:%2', Comment = '%1 = Account Name; %2 = Calculated Signature';
        SecretCanNotBeEmptyErr: Label 'Secret (Access Key) must be provided';
    begin
        if Secret = '' then
            Error(SecretCanNotBeEmptyErr);

        StringToSign := CreateSharedKeyStringToSign(HttpRequest, StorageAccount);
        Signature := AuthFormatHelper.GetAccessKeyHashCode(StringToSign, Secret);
        exit(StrSubstNo(SignaturePlaceHolderLbl, StorageAccount, Signature));
    end;

    local procedure CreateSharedKeyStringToSign(HttpRequest: HttpRequestMessage; StorageAccount: Text): Text
    var
        Headers: HttpHeaders;
        StringToSign: Text;
    begin
        // TODO: Add Handling-structure for different API-versions
        HttpRequest.GetHeaders(Headers);

        StringToSign += HttpRequest.Method() + NewLine();
        StringToSign += GetHeaderValueOrEmpty(Headers, 'Content-Encoding') + NewLine();
        StringToSign += GetHeaderValueOrEmpty(Headers, 'Content-Language') + NewLine();
        StringToSign += GetHeaderValueOrEmpty(Headers, 'Content-Length') + NewLine();
        StringToSign += GetHeaderValueOrEmpty(Headers, 'Content-MD5') + NewLine();
        StringToSign += GetHeaderValueOrEmpty(Headers, 'Content-Type') + NewLine();
        StringToSign += GetHeaderValueOrEmpty(Headers, 'Date') + NewLine();
        StringToSign += GetHeaderValueOrEmpty(Headers, 'If-Modified-Since') + NewLine();
        StringToSign += GetHeaderValueOrEmpty(Headers, 'If-Match') + NewLine();
        StringToSign += GetHeaderValueOrEmpty(Headers, 'If-None-Match') + NewLine();
        StringToSign += GetHeaderValueOrEmpty(Headers, 'If-Unmodified-Since') + NewLine();
        StringToSign += GetHeaderValueOrEmpty(Headers, 'Range') + NewLine();
        StringToSign += GetCanonicalizedHeaders(Headers) + NewLine();
        StringToSign += GetCanonicalizedResource(StorageAccount, HttpRequest.GetRequestUri());

        exit(StringToSign);
    end;

    local procedure GetHeaderValueOrEmpty(Headers: HttpHeaders; HeaderKey: Text): Text
    var
        ReturnValue: array[1] of Text;
    begin
        if not Headers.GetValues(HeaderKey, ReturnValue) then
            exit('');

        if HeaderKey = 'Content-Length' then
            if ReturnValue[1] = '0' then // TODO: In version 2014-02-14 and earlier, the content length was included even if zero.  
                exit('');

        exit(ReturnValue[1]);
    end;

    // see https://docs.microsoft.com/en-us/rest/api/storageservices/authorize-with-shared-key#constructing-the-canonicalized-headers-string
    local procedure GetCanonicalizedHeaders(Headers: HttpHeaders): Text
    var
        AzureStorageServiceHeaders: List of [Text];
        HeaderKey: Text;
        HeaderValue: array[1] of Text;
        CanonicalizedHeaders: Text;
        KeyValuePairLbl: Label '%1:%2', Comment = '%1 = Key; %2 = Value';
    begin
        // "Headers" needs to be a sorted dictionary
        // TODO there is not way to get all headers :(

        AzureStorageServiceHeaders.Add('x-ms-expiry-time');
        AzureStorageServiceHeaders.Add('x-ms-sku-name');
        AzureStorageServiceHeaders.Add('x-ms-account-kind');
        AzureStorageServiceHeaders.Add('x-ms-copy-id');
        AzureStorageServiceHeaders.Add('x-ms-snapshot');
        AzureStorageServiceHeaders.Add('x-ms-lease-state');
        AzureStorageServiceHeaders.Add('x-ms-lease-id');
        AzureStorageServiceHeaders.Add('x-ms-lease-id');
        // TODO add more ;( ... try to use .Net instead

        foreach HeaderKey in AzureStorageServiceHeaders do
            if Headers.GetValues(HeaderKey, HeaderValue) then begin
                if CanonicalizedHeaders <> '' then
                    CanonicalizedHeaders += NewLine();
                CanonicalizedHeaders += StrSubstNo(KeyValuePairLbl, HeaderKey.ToLower(), HeaderValue[1])
            end;

        exit(CanonicalizedHeaders);
    end;

    local procedure GetCanonicalizedResource(StorageAccount: Text; UriString: Text): Text
    var
        Uri: Codeunit Uri;
        UriBuider: Codeunit "Uri Builder";
        SortedDictionaryQuery: DotNet GenericSortedDictionary2;
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

    local procedure SplitQueryStringIntoSortedDictionary(QueryString: Text; var NewSortedDictionary: DotNet GenericSortedDictionary2)
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
        if Split.Count() <> 2 then
            Error('This should not happen'); // TODO: Make better error
        CurrIdentifier := Split.Get(1);
        CurrValue := Split.Get(2);
    end;

    local procedure NewLine(): Text
    begin
        exit(AuthFormatHelper.NewLine());
    end;

    var
        AuthFormatHelper: Codeunit "Auth. Format Helper";
        ApiVersion: Enum "Storage service API Version";
        [NonDebuggable]
        Secret: Text;
}