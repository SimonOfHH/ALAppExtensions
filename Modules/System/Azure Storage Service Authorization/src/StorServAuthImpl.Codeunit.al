// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------

codeunit 9063 "Stor. Serv. Auth. Impl."
{
    Access = Internal;

    procedure CreateSAS(SigningKey: Text; SignedVersion: Enum "Storage Service API Version"; SignedServices: List of [Enum "Storage Service Type"]; SignedPermissions: List of [Enum "Storage Service Permission"]; SignedExpiry: DateTime): Interface "Storage Service Authorization"
    var
        OptionalParams: Record "Stor. Serv. SAS Parameters";
    begin
        OptionalParams.Init();
        exit(CreateSAS(SigningKey, SignedVersion, SignedServices, SignedPermissions, SignedExpiry, OptionalParams));
    end;

    procedure CreateSAS(SigningKey: Text; SignedVersion: Enum "Storage Service API Version"; SignedServices: List of [Enum "Storage Service Type"]; SignedPermissions: List of [Enum "Storage Service Permission"]; SignedExpiry: DateTime; OptionalParams: Record "Stor. Serv. SAS Parameters"): Interface "Storage Service Authorization"
    var
        StorServAuthSAS: Codeunit "Stor. Serv. Auth. SAS";
    begin
        StorServAuthSAS.SetSigningKey(SigningKey);
        StorServAuthSAS.SetVersion(SignedVersion);
        StorServAuthSAS.SetSignedServices(SignedServices);
        StorServAuthSAS.SetSignedPermissions(SignedPermissions);
        StorServAuthSAS.SetSignedExpiry(SignedExpiry);

        // Set optional parameters
        StorServAuthSAS.SetVersion(OptionalParams.ApiVersion);

        if OptionalParams.SignedStart <> 0DT then
            StorServAuthSAS.SetSignedStart(OptionalParams.SignedStart);

        if OptionalParams.SignedIp <> '' then
            StorServAuthSAS.SetIPrange(OptionalParams.SignedIp);

        StorServAuthSAS.SetProtocol(Format(OptionalParams.SignedProtocol));

        exit(StorServAuthSAS);
    end;

    procedure SharedKey(SharedKey: Text; ApiVersion: Enum "Storage Service API Version"): Interface "Storage Service Authorization"
    var
        StorServAuthSharedKey: Codeunit "Stor. Serv. Auth. Shared Key";
    begin
        StorServAuthSharedKey.SetSharedKey(SharedKey);
        StorServAuthSharedKey.SetApiVersion(ApiVersion);

        exit(StorServAuthSharedKey);
    end;
}
