// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------

/// <summary>
/// Provides functionality to use operations on accounts in Azure BLOB Services.
/// </summary>
codeunit 9051 "ABS Account REST Client"
{
    Access = Public;

    /// <summary>
    /// Initializes the Azure BLOB Storage account client.
    /// </summary>
    /// <param name="StorageAccount">The name of Storage Account to use.</param>
    /// <param name="Authorization">The authorization to use.</param>
    procedure Initialize(StorageAccount: Text; Authorization: Interface "Storage Service Authorization")
    begin
        BlobServicesApiImpl.Initialize(StorageAccount, '', '', Authorization, Enum::"Storage Service API Version"::"2017-04-17"); // TODO figure out the default version
    end;

    /// <summary>
    /// Initializes the Azure BLOB Storage account client.
    /// </summary>
    /// <param name="StorageAccount">The name of Storage Account to use.</param>
    /// <param name="Authorization">The authorization to use.</param>
    /// <param name="APIVersion">The used API version to use.</param>
    procedure Initialize(StorageAccount: Text; Authorization: Interface "Storage Service Authorization"; APIVersion: Enum "Storage Service API Version")
    begin
        BlobServicesApiImpl.Initialize(StorageAccount, '', '', Authorization, APIVersion);
    end;

    /// <summary>
    /// List all containers in specific Storage Account.
    /// see: https://docs.microsoft.com/en-us/rest/api/storageservices/list-containers2
    /// </summary>
    /// <param name="Container">Collection of the result (temporary record).</param>
    procedure ListContainers(var Containers: Record "Container"): Codeunit "Blob API Operation Response"
    var
        Optionals: Codeunit "ABS REST Headers & Parameters";
    begin
        exit(BlobServicesApiImpl.ListContainers(Containers, Optionals));
    end;

    /// <summary>
    /// List all containers in specific Storage Account.
    /// see: https://docs.microsoft.com/en-us/rest/api/storageservices/list-containers2
    /// </summary>
    /// <param name="Container">Collection of the result (temporary record).</param>
    procedure ListContainers(var Containers: Record "Container"; Optionals: Codeunit "ABS REST Headers & Parameters"): Codeunit "Blob API Operation Response"
    begin
        exit(BlobServicesApiImpl.ListContainers(Containers, Optionals));
    end;

    /// <summary>
    /// Creates a new Container in the Storage Account
    /// see: https://docs.microsoft.com/en-us/rest/api/storageservices/create-container
    /// </summary>
    procedure CreateContainer(ContainerName: Text): Codeunit "Blob API Operation Response"
    var
        Optionals: Codeunit "ABS REST Headers & Parameters";
    begin
        exit(BlobServicesApiImpl.CreateContainer(ContainerName, Optionals));
    end;

    /// <summary>
    /// Creates a new Container in the Storage Account
    /// see: https://docs.microsoft.com/en-us/rest/api/storageservices/create-container
    /// </summary>
    procedure CreateContainer(ContainerName: Text; Optionals: Codeunit "ABS REST Headers & Parameters"): Codeunit "Blob API Operation Response"
    begin
        exit(BlobServicesApiImpl.CreateContainer(ContainerName, Optionals));
    end;

    /// <summary>
    /// Delete a Container in the Storage Account
    /// see: https://docs.microsoft.com/en-us/rest/api/storageservices/delete-container
    /// </summary>
    procedure DeleteContainer(ContainerName: Text): Codeunit "Blob API Operation Response"
    var
        Optionals: Codeunit "ABS REST Headers & Parameters";
    begin
        exit(BlobServicesApiImpl.DeleteContainer(ContainerName, Optionals));
    end;

    /// <summary>
    /// Delete a Container in the Storage Account
    /// see: https://docs.microsoft.com/en-us/rest/api/storageservices/delete-container
    /// </summary>
    procedure DeleteContainer(ContainerName: Text; Optionals: Codeunit "ABS REST Headers & Parameters"): Codeunit "Blob API Operation Response"
    begin
        exit(BlobServicesApiImpl.DeleteContainer(ContainerName, Optionals));
    end;


    var
        BlobServicesApiImpl: Codeunit "Blob Services API Impl.";
}