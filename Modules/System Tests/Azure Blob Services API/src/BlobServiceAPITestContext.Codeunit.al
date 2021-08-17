// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------

codeunit 88155 "Blob Service API Test Context"
{
    Access = Internal;

    procedure SetSharedKeyAuth()
    var
        StorageServiceAuthorization: Codeunit "Storage Service Authorization";
    begin
        SetAuthType(StorageServiceAuthorization.CreateSharedKey(HelperLibrary.GetAccessKey()));
    end;

    procedure SetSasTokenAuth()
    // var
    //     StorageServiceAuthorization: Codeunit "Storage Service Authorization";
    begin
        //SetAuthType(StorageServiceAuthorization.SAS(SasToken).AsStorageServiceAuthorization());
    end;

    procedure SetAuthType(NewAuthType: Interface "Storage Service Authorization")
    begin
        AuthType := NewAuthType;
    end;

    procedure GetAuthType(): Interface "Storage Service Authorization"
    begin
        exit(AuthType);
    end;

    procedure SetApiVersion(NewApiVersion: Enum "Storage Service API Version")
    begin
        ApiVersion := NewApiVersion;
    end;

    procedure GetApiVersion(): Enum "Storage Service API Version"
    begin
        exit(ApiVersion);
    end;

    procedure SetAccessKey(NewAccessKey: Text)
    begin
        AccessKey := NewAccessKey;
    end;

    procedure GetAccessKey(): Text
    begin
        exit(AccessKey);
    end;

    procedure SetSasToken(NewSasToken: Text)
    begin
        SasToken := NewSasToken;
    end;

    procedure GetSasToken(): Text
    begin
        exit(SasToken);
    end;

    procedure SetStorageAccountName(NewStorageAccountName: Text)
    begin
        StorageAccountName := NewStorageAccountName;
    end;

    procedure GetStorageAccountName(): Text
    begin
        exit(StorageAccountName);
    end;

    procedure InitializeContextSharedKeyVersion20200210()
    begin
        InitializeContextSharedKeyVersion20200210('');
    end;

    procedure InitializeContextSharedKeyVersion20200210(NewStorageAccountName: Text)
    begin
        ClearAll();
        SetSharedKeyAuth();
        SetApiVersion(ApiVersion::"2020-02-10");
        if NewStorageAccountName = '' then
            NewStorageAccountName := HelperLibrary.GetStorageAccountName();
        StorageAccountName := NewStorageAccountName;
        AccessKey := HelperLibrary.GetAccessKey();
    end;

    var
        HelperLibrary: Codeunit "ABS Test Library";
        AuthType: Interface "Storage Service Authorization";
        ApiVersion: Enum "Storage Service API Version";
        StorageAccountName: Text;
        AccessKey: Text;
        SasToken: Text;
}