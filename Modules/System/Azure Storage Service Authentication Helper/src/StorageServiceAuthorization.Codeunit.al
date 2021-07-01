// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------

/// <summary>
/// TODO
/// </summary>
codeunit 9063 "Storage Service Authorization"
{
    Access = Public;

    procedure CreateSaSAuthorization(SigningKey: Text): Interface "Storage Service Authorization"
    var
        StorageServAuthSAS: Codeunit "Storage Serv. Auth. SAS";
    begin
        StorageServAuthSAS.SetSigningKey(SigningKey);
        exit(StorageServAuthSAS);
    end;

    procedure CreateSharedKeyAuthorization(Secret: Text): Interface "Storage Service Authorization"
    var
        StorageServAuthSharedKey: Codeunit "Storage Serv. Auth. Shared Key";
    begin
        StorageServAuthSharedKey.SetSecret(Secret);
        exit(StorageServAuthSharedKey);
    end;
}