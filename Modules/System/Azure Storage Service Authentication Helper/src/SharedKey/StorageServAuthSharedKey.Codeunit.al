// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------

/// <summary>
/// Exposes functionality to handle the creation of a signature to sign requests to the Storage Services REST API
/// More Information: https://docs.microsoft.com/en-us/rest/api/storageservices/authorize-with-shared-key
/// </summary>
codeunit 9061 "Storage Serv. Auth. Shared Key" implements "Storage Service Authorization", "Storage Serv. Auth. Shared Key"
{
    Access = Internal;

    procedure Authorize(Payload: Interface "Storage Service Operation Payload")
    begin
        Payload.AddHeader('Authorization', ''); // TODO add header value
    end;

    var
        AuthFormatHelper: Codeunit "Auth. Format Helper";
        ApiVersion: Enum "Storage service API Version";
        [NonDebuggable]
        Secret: Text;
        HeaderValues: Dictionary of [Text, Text];

    /// <summary>
    /// Sets the Dictionary of HttpHeader Identifier/Value-combinations which will be use for signature-generation
    /// </summary>
    /// <param name="NewHeaderValues">Dictionary containing HttpHeader-Identifier and -values</param>

    procedure SetHeaderValues(NewHeaderValues: Dictionary of [Text, Text])
    begin
        HeaderValues := NewHeaderValues;
    end;

    procedure SetSecret(NewSecret: Text)
    begin
        Secret := NewSecret;
    end;

    /// <summary>
    /// Sets the API Version to be used for the desired operation
    /// </summary>
    /// <param name="NewApiVersion">Value of Enum "Storage service API Version" specifying the used version</param>
    procedure SetApiVersion(NewApiVersion: Enum "Storage service API Version")
    begin
        ApiVersion := NewApiVersion;
    end;

    procedure AsStorageServiceAuthorization(): Interface "Storage Service Authorization"
    var
        StorageServAuthSharedKey: Codeunit "Storage Serv. Auth. Shared Key";
    begin
        StorageServAuthSharedKey.SetSecret(Secret);
        StorageServAuthSharedKey.SetApiVersion(ApiVersion);
        StorageServAuthSharedKey.SetHeaderValues(HeaderValues);
        // TODO add everything from the state

        exit(StorageServAuthSharedKey);
    end;

    /// <summary>
    /// Returns a signature to authenticate the API operation when using "Shared Key"-authentication
    /// </summary>
    /// <param name="HttpRequestType">The "Http Request Type" Verb specifying the type of request</param>
    /// <param name="StorageAccount">The name of the Azure Storage Account</param>
    /// <param name="UriString">The Uri (as Text) for this request</param>
    /// <param name="Secret">The Secret (Access Key) to sign the request</param>
    /// <returns>Signature (as Text) to authenticate the request</returns>
    procedure GetSharedKeySignature(HttpRequestType: Enum "Http Request Type"; StorageAccount: Text; UriString: Text): Text
    var
        StringToSign: Text;
        Signature: Text;
        SignaturePlaceHolderLbl: Label 'SharedKey %1:%2', Comment = '%1 = Account Name; %2 = Calculated Signature';
        SecretCanNotBeEmptyErr: Label 'Secret (Access Key) must be provided';
    begin
        if Secret = '' then
            Error(SecretCanNotBeEmptyErr);

        StringToSign := AuthFormatHelper.CreateSharedKeyStringToSign(ApiVersion, HeaderValues, HttpRequestType, StorageAccount, UriString);
        Signature := AuthFormatHelper.GetAccessKeyHashCode(StringToSign, Secret);
        exit(StrSubstNo(SignaturePlaceHolderLbl, StorageAccount, Signature));
    end;
}