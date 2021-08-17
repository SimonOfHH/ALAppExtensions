// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------

/// <summary>
/// Provides functionality to use operations on containers in Azure BLOB Services.
/// </summary>
codeunit 9052 "ABS Container Client"
{
    Access = Public;

    /// <summary>
    /// Initializes the Azure BLOB Storage container client.
    /// </summary>
    /// <param name="StorageAccount">The name of Storage Account to use.</param>
    /// <param name="Authorization">The authorization to use.</param>
    procedure Initialize(StorageAccount: Text; Authorization: Interface "Storage Service Authorization")
    var
        StorageServiceAuthorization: Codeunit "Storage Service Authorization";
    begin
        BlobServicesApiImpl.Initialize(StorageAccount, '', '', Authorization, StorageServiceAuthorization.GetDefaultAPIVersion());
    end;

    /// <summary>
    /// Initializes the Azure BLOB Storage container client.
    /// </summary>
    /// <param name="StorageAccount">The Storage Account to use.</param>
    /// <param name="ApiVersion">The API version to use.</param>
    procedure Initialize(StorageAccount: Text; Authorization: Interface "Storage Service Authorization"; ApiVersion: Enum "Storage Service API Version")
    begin
        BlobServicesApiImpl.Initialize(StorageAccount, '', '', Authorization, ApiVersion);
    end;

    /// <summary>
    /// List all containers in specific Storage Account.
    /// see: https://docs.microsoft.com/en-us/rest/api/storageservices/list-containers2
    /// </summary>
    /// <param name="Container">Collection of the result (temporary record).</param>
    procedure ListContainers(var Containers: Record "Container"): Codeunit "Blob API Operation Response"
    var
        OptionalParameters: Codeunit "ABS Optional Parameters";
    begin
        exit(BlobServicesApiImpl.ListContainers(Containers, OptionalParameters));
    end;

    /// <summary>
    /// List all containers in specific Storage Account.
    /// see: https://docs.microsoft.com/en-us/rest/api/storageservices/list-containers2
    /// </summary>
    /// <param name="Container">Collection of the result (temporary record).</param>
    procedure ListContainers(var Containers: Record "Container"; OptionalParameters: Codeunit "ABS Optional Parameters"): Codeunit "Blob API Operation Response"
    begin
        exit(BlobServicesApiImpl.ListContainers(Containers, OptionalParameters));
    end;

    /// <summary>
    /// Creates a new container in the Storage Account.
    /// see: https://docs.microsoft.com/en-us/rest/api/storageservices/create-container
    /// </summary>
    procedure CreateContainer(ContainerName: Text): Codeunit "Blob API Operation Response"
    var
        OptionalParameters: Codeunit "ABS Optional Parameters";
    begin
        exit(BlobServicesApiImpl.CreateContainer(ContainerName, OptionalParameters));
    end;

    /// <summary>
    /// Creates a new container in the Storage Account.
    /// see: https://docs.microsoft.com/en-us/rest/api/storageservices/create-container
    /// </summary>
    procedure CreateContainer(ContainerName: Text; OptionalParameters: Codeunit "ABS Optional Parameters"): Codeunit "Blob API Operation Response"
    begin
        exit(BlobServicesApiImpl.CreateContainer(ContainerName, OptionalParameters));
    end;

    /// <summary>
    /// Deletes a container from the Storage Account.
    /// see: https://docs.microsoft.com/en-us/rest/api/storageservices/delete-container
    /// </summary>
    procedure DeleteContainer(ContainerName: Text): Codeunit "Blob API Operation Response"
    var
        OptionalParameters: Codeunit "ABS Optional Parameters";
    begin
        exit(BlobServicesApiImpl.DeleteContainer(ContainerName, OptionalParameters));
    end;

    /// <summary>
    /// Deletes a container from the Storage Account.
    /// see: https://docs.microsoft.com/en-us/rest/api/storageservices/delete-container
    /// </summary>
    procedure DeleteContainer(ContainerName: Text; OptionalParameters: Codeunit "ABS Optional Parameters"): Codeunit "Blob API Operation Response"
    begin
        exit(BlobServicesApiImpl.DeleteContainer(ContainerName, OptionalParameters));
    end;

    /// <summary>
    /// Lists the blobs in a specific container.
    /// see: https://docs.microsoft.com/en-us/rest/api/storageservices/list-blobs
    /// </summary>
    /// <param name="ContainerName">The name of the container</param>    
    /// <param name="ContainerContent">Collection of the result (temporary record).</param>
    procedure ListBlobs(ContainerName: Text; var ContainerContent: Record "Container Content"): Codeunit "Blob API Operation Response"
    begin
        exit(BlobServicesApiImpl.ListBlobs(ContainerName, ContainerContent));
    end;

    var
        BlobServicesApiImpl: Codeunit "Blob Services API Impl.";
}