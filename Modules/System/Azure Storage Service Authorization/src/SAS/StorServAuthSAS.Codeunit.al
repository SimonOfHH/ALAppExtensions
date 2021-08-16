// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------

codeunit 9061 "Stor. Serv. Auth. SAS" implements "Storage Service Authorization"
{
    Access = Internal;

    procedure Authorize(var HttpRequest: HttpRequestMessage; StorageAccount: Text)
    begin
        // TODO finish
        // AddParameter('', GetSharedAccessSignature());
    end;

    procedure SetStorageAccountName(NewStorageAccountName: Text)
    begin
        StorageAccountName := NewStorageAccountName;
    end;

    [NonDebuggable]
    procedure SetSigningKey(NewSigningKey: Text)
    begin
        SigningKey := NewSigningKey;
    end;

    procedure SetSignedStart(SignedStart: DateTime)
    begin
        StartDate := SignedStart;
    end;

    procedure SetSignedExpiry(SignedExpiry: DateTime)
    begin
        EndDate := SignedExpiry;
    end;

    procedure SetIPrange(NewIPRange: Text)
    begin
        IPRange := NewIPRange;
    end;

    procedure SetVersion(NewAPIVersion: Enum "Storage Service API Version")
    begin
        ApiVersion := NewAPIVersion;
    end;

    procedure SetSignedServices(SignedServices: List of [Enum "Storage Service Type"])
    begin
        Services := SignedServices;
    end;

    procedure AddResource(ResourceType: Enum "Storage Service Resource Type")
    begin
        Resources.Add(ResourceType);
    end;

    procedure SetSignedPermissions(SignedPermissions: List of [Enum "Storage Service Permission"])
    begin
        Permissions := SignedPermissions;
    end;

    procedure SetProtocol(Protocol: Text)
    begin
        Protocols.Add(Protocol);
    end;

    procedure GetSharedAccessSignature(): Text
    var
        StringToSign: Text;
        Signature: Text;
        SharedAccessSignature: Text;
    begin
        StringToSign := CreateSharedAccessSignatureStringToSign(StorageAccountName, ApiVersion, StartDate, EndDate, Services, Resources, Permissions, Protocols, IPRange);
        Signature := AuthFormatHelper.GetAccessKeyHashCode(StringToSign, SigningKey);
        SharedAccessSignature := CreateSasUrlString(ApiVersion, StartDate, EndDate, Services, Resources, Permissions, Protocols, IPRange, Signature);
        exit(SharedAccessSignature);
    end;

    local procedure CreateSharedAccessSignatureStringToSign(AccountName: Text; ApiVersion: Enum "Storage Service API Version"; StartDate: DateTime; EndDate: DateTime; Services: List of [Enum "Storage Service Type"]; Resources: List of [Enum "Storage Service Resource Type"]; Permissions: List of [Enum "Storage Service Permission"]; Protocols: List of [Text]; IPRange: Text): Text
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

        if IPRange <> '' then begin
            Builder.Append('&');
            Builder.Append(StrSubstNo(KeyValueLbl, 'sip', IPRange));
        end;

        Builder.Append(StrSubstNo(KeyValueLbl, 'sig', Uri.EscapeDataString(Signature)));
        exit(Builder.ToText());
    end;

    local procedure VersionToString(ApiVersion: Enum "Storage Service API Version"): Text
    begin
        exit(Format(ApiVersion));
    end;

    local procedure DateToString(MyDateTime: DateTime): Text
    begin
        exit(AuthFormatHelper.GetIso8601DateTime(MyDateTime));
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

    local procedure NewLine(): Text
    begin
        exit(AuthFormatHelper.NewLine());
    end;

    var
        AuthFormatHelper: Codeunit "Auth. Format Helper";
        StorageAccountName: Text;
        [NonDebuggable]
        SigningKey: Text;
        StartDate: DateTime;
        EndDate: DateTime;
        ApiVersion: Enum "Storage Service API Version";
        Services: List of [Enum "Storage Service Type"];
        Resources: List of [Enum "Storage Service Resource Type"];
        Permissions: List of [Enum "Storage Service Permission"];
        Protocols: List of [Text];
        IPRange: Text;
}