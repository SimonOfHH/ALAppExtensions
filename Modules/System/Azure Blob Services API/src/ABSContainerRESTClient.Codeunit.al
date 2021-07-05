// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------

/// <summary>
/// Provides functionality to use operations on containers in Azure BLOB Services.
/// </summary>
codeunit 9052 "ABS Container REST Client"
{
    Access = Public;

    /// <summary>
    /// Initializes the Azure BLOB Storage container client.
    /// </summary>
    /// <param name="StorageAccount">The name of Storage Account to use.</param>
    /// <param name="Container"></param>
    /// <param name="Authorization">The authorization to use.</param>
    procedure Initialize(StorageAccount: Text; Container: Text; Authorization: Interface "Storage Service Authorization")
    begin
        BlobServicesApiImpl.Initialize(StorageAccount, Container, '', Authorization, Enum::"Storage Service API Version"::"2017-04-17");
    end;

    /// <summary>
    /// Initializes the object to be used in an API operation
    /// </summary>
    /// <param name="StorageAccount">The Storage Account to use</param>
    /// <param name="NewContainerName">The name of the container in the Storage Account</param>
    /// <param name="NewBlobName">The Name of the Blob</param>
    /// <param name="ApiVersion">The used API version</param>
    procedure Initialize(StorageAccount: Text; Container: Text; Authorization: Interface "Storage Service Authorization"; ApiVersion: Enum "Storage Service API Version")
    begin
        BlobServicesApiImpl.Initialize(StorageAccount, Container, '', Authorization, ApiVersion);
    end;

    /// <summary>
    /// Creates a new Container in the Storage Account
    /// see: https://docs.microsoft.com/en-us/rest/api/storageservices/create-container
    /// </summary>
    procedure CreateContainer(Container: Text): Codeunit "Blob API Operation Response"
    begin
        exit(BlobServicesApiImpl.CreateContainer());
    end;

    /// <summary>
    /// Delete a Container in the Storage Account
    /// see: https://docs.microsoft.com/en-us/rest/api/storageservices/delete-container
    /// </summary>
    procedure DeleteContainer(): Codeunit "Blob API Operation Response"
    begin
        exit(BlobServicesApiImpl.DeleteContainer());
    end;

    /// <summary>
    /// Lists the Blobs in a specific container
    /// see: https://docs.microsoft.com/en-us/rest/api/storageservices/list-blobs
    /// </summary>    
    /// <param name="ContainerContent">Collection of the result (temporary record).</param>
    procedure ListBlobs(var ContainerContent: Record "Container Content"): Codeunit "Blob API Operation Response"
    begin
        exit(BlobServicesApiImpl.ListBlobs(ContainerContent));
    end;

    var
        BlobServicesApiImpl: Codeunit "Blob Services API Impl.";
}