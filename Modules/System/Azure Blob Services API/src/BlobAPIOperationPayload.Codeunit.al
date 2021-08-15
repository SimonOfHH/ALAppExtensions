// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------

codeunit 9042 "Blob API Operation Payload"
{
    Access = Internal;

    var
        Authorization: Interface "Storage Service Authorization";
        ApiVersion: Enum "Storage Service API Version";
        StorageAccountName: Text;
        ContainerName: Text;
        BlobName: Text;
        Operation: Enum "Blob Service API Operation";
        HeaderValues: Dictionary of [Text, Text];
        UriParameters: Dictionary of [Text, Text];

    procedure GetAuthorization(): Interface "Storage Service Authorization"
    begin
        exit(Authorization);
    end;

    procedure SetAuthorization(StorageServiceAuthorization: Interface "Storage Service Authorization")
    begin
        Authorization := StorageServiceAuthorization;
    end;

    procedure SetOperation(NewOperation: Enum "Blob Service API Operation")
    var
        HelperLibrary: Codeunit "Blob API Helper Library";
    begin
        Operation := NewOperation;
        // Only API Versions after 2017-04-17 are considered
        case Operation of
            Operation::GetAccountInformation:
                HelperLibrary.ValidateApiVersion(ApiVersion, ApiVersion::"2018-03-28", NewOperation, true);
            Operation::SetBlobExpiry:
                HelperLibrary.ValidateApiVersion(ApiVersion, ApiVersion::"2020-02-10", NewOperation, true);
            Operation::UndeleteBlob:
                HelperLibrary.ValidateApiVersion(ApiVersion, ApiVersion::"2017-07-29", NewOperation, true);
            Operation::PutBlockFromURL:
                HelperLibrary.ValidateApiVersion(ApiVersion, ApiVersion::"2018-03-28", NewOperation, true);
            Operation::GetUserDelegationKey:
                Error('Only works with Azure AD authentication, which is not implemented yet'); // TODO: Make real error
        end
    end;

    procedure GetApiVersion(): Enum "Storage Service API Version"
    begin
        exit(ApiVersion);
    end;

    procedure SetApiVersion(StorageServiceApiVersion: Enum "Storage Service API Version");
    begin
        ApiVersion := StorageServiceApiVersion;
    end;

    procedure GetStorageAccountName(): Text
    begin
        exit(StorageAccountName);
    end;

    procedure SetStorageAccountName(StorageAccount: Text);
    begin
        StorageAccountName := StorageAccount;
    end;

    procedure GetContainerName(): Text
    begin
        exit(ContainerName);
    end;

    procedure SetContainerName(Container: Text);
    begin
        ContainerName := Container;
    end;

    procedure GetBlobName(): Text
    begin
        exit(BlobName);
    end;

    procedure SetBlobName("Blob": Text);
    begin
        BlobName := "Blob";
    end;

    procedure GetOperation(): Enum "Blob Service API Operation"
    begin
        exit(Operation);
    end;

    procedure GetHeaders(): Dictionary of [Text, Text];
    begin
        exit(HeaderValues);
    end;

    procedure SetHeaders(Headers: Dictionary of [Text, Text])
    begin
        HeaderValues := Headers;
    end;

    procedure AddHeader(HeaderKey: Text; HeaderValue: Text)
    begin
        HeaderValues.Remove(HeaderKey);

        HeaderValues.Add(HeaderKey, HeaderValue);
    end;

    procedure Initialize(StorageAccount: Text; Container: Text; BlobName: Text; Authorization: Interface "Storage Service Authorization"; APIVersion: Enum "Storage Service API Version")
    begin
        StorageAccountName := StorageAccount;
        ApiVersion := APIVersion;
        Authorization := Authorization;
        ContainerName := Container;
        BlobName := BlobName;

        Clear(HeaderValues);
        Clear(UriParameters);
    end;

    /// <summary>
    /// Creates the Uri for this object, based on given values
    /// </summary>
    /// <returns>An Uri (as Text) for this API Operation</returns>
    internal procedure ConstructUri(): Text
    var
        URIHelper: Codeunit "Blob API URI Helper";
    begin
        URIHelper.SetOptionalUriParameter(UriParameters);
        exit(URIHelper.ConstructUri(StorageAccountName, ContainerName, BlobName, Operation));
    end;

    /// <summary>
    /// Adds an entry to the internally used Header-Dictionary and to a HttpHeaders-variable at the same time
    /// </summary>
    /// <param name="Headers">HttpHeaders that should have the specified Header-value</param>
    /// <param name="Key">Identifier for the Header</param>
    /// <param name="Value">Value for the Header</param>
    // TODO is this one needed
    procedure AddHeader(var Headers: HttpHeaders; "Key": Text; "Value": Text)
    begin
        AddHeader("Key", "Value");
        if Headers.Contains("Key") then
            Headers.Remove("Key");
        Headers.Add("Key", "Value");
    end;

    /// <summary>
    /// Removes an entry from the internally used Header-Dictionary and from a HttpHeaders-variable at the same time
    /// </summary>
    /// <param name="Headers">HttpHeaders that should have the specified Header-value</param>
    /// <param name="Key">Identifier for the Header</param>
    procedure RemoveHeader(var Headers: HttpHeaders; "Key": Text)
    var
    begin
        if HeaderValues.ContainsKey("Key") then
            HeaderValues.Remove("Key");
        if Headers.Contains("Key") then
            Headers.Remove("Key");
    end;

    /// <summary>
    /// Creates a sorted Dictionary containg all Headers and OptionalHeaderValues from this object.
    /// </summary>
    /// <returns>Sorted Dictionary of [Text, Text] containg all Headers and OptionalHeaderValues from this object.</returns>
    internal procedure GetSortedHeadersDictionary() NewHeaders: Dictionary of [Text, Text]
    var
        SortedDictionary: DotNet GenericSortedDictionary2;
        SortedDictionaryEntry: DotNet GenericKeyValuePair2;
        HeaderKey: Text;
    begin
        SortedDictionary := SortedDictionary.SortedDictionary();

        Clear(NewHeaders);

        foreach HeaderKey in HeaderValues.Keys do
            SortedDictionary.Add(HeaderKey, HeaderValues.Get(HeaderKey));

        foreach SortedDictionaryEntry in SortedDictionary do
            NewHeaders.Add(SortedDictionaryEntry."Key", SortedDictionaryEntry.Value);
    end;

    procedure AddUriParameter(ParameterKey: Text; ParameterValue: Text)
    begin
        UriParameters.Remove(ParameterKey);
        UriParameters.Add(ParameterKey, ParameterValue);
    end;
}