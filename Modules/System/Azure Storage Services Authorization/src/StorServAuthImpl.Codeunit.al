// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------

codeunit 9063 "Stor. Serv. Auth. Impl."
{
    Access = Internal;

    [NonDebuggable]
    procedure CreateSAS(SigningKey: Text; SignedVersion: Enum "Storage Service API Version"; SignedServices: List of [Enum "Storage Service Type"]; SignedResources: List of [Enum "Storage Service Resource Type"]; SignedPermissions: List of [Enum "Storage Service Permission"]; SignedExpiry: DateTime): Interface "Storage Service Authorization"
    var
        OptionalParams: Record "Stor. Serv. SAS Parameters";
    begin
        OptionalParams.Init();
        exit(CreateSAS(SigningKey, SignedVersion, SignedServices, SignedResources, SignedPermissions, SignedExpiry, OptionalParams));
    end;

    [NonDebuggable]
    procedure CreateSAS(SigningKey: Text; SignedVersion: Enum "Storage Service API Version"; SignedServices: List of [Enum "Storage Service Type"]; SignedResources: List of [Enum "Storage Service Resource Type"]; SignedPermissions: List of [Enum "Storage Service Permission"]; SignedExpiry: DateTime; OptionalParams: Record "Stor. Serv. SAS Parameters"): Interface "Storage Service Authorization"
    var
        StorServAuthSAS: Codeunit "Stor. Serv. Auth. SAS";
    begin
        StorServAuthSAS.SetSigningKey(SigningKey);
        StorServAuthSAS.SetVersion(SignedVersion);
        StorServAuthSAS.SetSignedServices(SignedServices);
        StorServAuthSAS.SetResources(SignedResources);
        StorServAuthSAS.SetSignedPermissions(SignedPermissions);
        StorServAuthSAS.SetSignedExpiry(SignedExpiry);

        // Set optional parameters
        StorServAuthSAS.SetVersion(OptionalParams.ApiVersion);
        StorServAuthSAS.SetSignedStart(CurrentDateTime());
        StorServAuthSAS.SetIPrange(OptionalParams.SignedIp);
        StorServAuthSAS.SetProtocol(Format(OptionalParams.SignedProtocol));

        exit(StorServAuthSAS);
    end;

    [NonDebuggable]
    procedure SharedKey(SharedKey: Text; ApiVersion: Enum "Storage Service API Version"): Interface "Storage Service Authorization"
    var
        StorServAuthSharedKey: Codeunit "Stor. Serv. Auth. Shared Key";
    begin
        StorServAuthSharedKey.SetSharedKey(SharedKey);
        StorServAuthSharedKey.SetApiVersion(ApiVersion);

        exit(StorServAuthSharedKey);
    end;

    procedure GetDefaultAPIVersion(): Enum "Storage Service API Version"
    begin
        exit(Enum::"Storage Service API Version"::"2020-10-02");
    end;
}
