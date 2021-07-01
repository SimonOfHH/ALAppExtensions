// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------

/// <summary>
/// Exposes methods to create different kind of authorizations.
/// </summary>
codeunit 9063 "Storage Service Authorization"
{
    Access = Public;

    procedure SAS(SigningKey: Text): Interface "Storage Serv. Auth. SAS"
    var
        StorageServAuthSAS: Codeunit "Storage Serv. Auth. SAS";
    begin
        StorageServAuthSAS.SetSigningKey(SigningKey);
        exit(StorageServAuthSAS);
    end;

    procedure SharedKey(Secret: Text): Interface "Storage Serv. Auth. Shared Key"
    var
        StorageServAuthSharedKey: Codeunit "Storage Serv. Auth. Shared Key";
    begin
        StorageServAuthSharedKey.SetSharedKey(Secret);
        exit(StorageServAuthSharedKey);
    end;
}