// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------

/// <summary>
/// Provides functionality to use operations on blobs in Azure BLOB Services.
/// </summary>
codeunit 9053 "ABS Blob REST Client"
{
    Access = Public;

    /// <summary>
    /// Uploads (PUT) a File as a BlockBlob (with File Selection Dialog)
    /// see: https://docs.microsoft.com/en-us/rest/api/storageservices/put-blob
    /// </summary>
    /// <param name="OperationPayload">A Request Object containing the necessary para#meters for the request.</param>    
    procedure PutBlobBlockBlobUI(): Codeunit "Blob API Operation Response"
    begin
        exit(BlobServicesApiImpl.PutBlobBlockBlobUI());
    end;

    /// <summary>
    /// Uploads the content of an InStream as a BlockBlob
    /// see: https://docs.microsoft.com/en-us/rest/api/storageservices/put-blob
    /// </summary>
    /// <param name="BlobName">The Name of the Blob to Upload.</param>
    /// <param name="SourceStream">The Content of the Blob as InStream.</param>
    procedure PutBlobBlockBlobStream(BlobName: Text; var SourceStream: InStream): Codeunit "Blob API Operation Response"
    begin
        exit(BlobServicesApiImpl.PutBlobBlockBlobStream(BlobName, SourceStream));
    end;

    /// <summary>
    /// Uploads (PUT) the content of a Text-Variable as a BlockBlob
    /// see: https://docs.microsoft.com/en-us/rest/api/storageservices/put-blob
    /// </summary>
    /// <param name="BlobName">The Name of the Blob to Upload.</param>
    /// <param name="SourceText">The Content of the Blob as Text.</param>
    procedure PutBlobBlockBlobText(BlobName: Text; SourceText: Text): Codeunit "Blob API Operation Response"
    begin
        exit(BlobServicesApiImpl.PutBlobBlockBlobText(BlobName, SourceText));
    end;

    /// <summary>
    /// Creates (PUT) a PageBlob
    /// see: https://docs.microsoft.com/en-us/rest/api/storageservices/put-blob
    /// </summary>
    /// <param name="BlobName">The Name of the Blob to Upload.</param>
    /// <param name="ContentType">Value for Content-Type HttpHeader (e.g. 'text/plain; charset=UTF-8')</param>
    procedure PutBlobPageBlob(ContentType: Text): Codeunit "Blob API Operation Response"
    begin
        exit(BlobServicesApiImpl.PutBlobPageBlob(ContentType));
    end;

    /// <summary>
    /// The Put Blob operation creates a new append blob
    /// see: https://docs.microsoft.com/en-us/rest/api/storageservices/put-blob
    /// Uses 'application/octet-stream' as Content-Type
    /// </summary>
    procedure PutBlobAppendBlobStream(): Codeunit "Blob API Operation Response"
    begin
        exit(PutBlobAppendBlob('application/octet-stream'));
    end;

    /// <summary>
    /// The Put Blob operation creates a new append blob
    /// see: https://docs.microsoft.com/en-us/rest/api/storageservices/put-blob
    /// Uses 'text/plain; charset=UTF-8' as Content-Type
    /// </summary>
    procedure PutBlobAppendBlobText(): Codeunit "Blob API Operation Response"
    begin
        exit(PutBlobAppendBlob('text/plain; charset=UTF-8'));
    end;
    /// <summary>
    /// The Put Blob operation creates a new append blob
    /// see: https://docs.microsoft.com/en-us/rest/api/storageservices/put-blob
    /// </summary>
    /// <param name="ContentType">Value for Content-Type HttpHeader (e.g. 'text/plain; charset=UTF-8')</param>
    procedure PutBlobAppendBlob(ContentType: Text): Codeunit "Blob API Operation Response"
    begin
        exit(BlobServicesApiImpl.PutBlobAppendBlob(ContentType));
    end;

    /// <summary>
    /// The Append Block operation commits a new block of data to the end of an existing append blob.
    /// see: https://docs.microsoft.com/en-us/rest/api/storageservices/append-block
    /// Uses 'text/plain; charset=UTF-8' as Content-Type
    /// </summary>
    /// <param name="ContentAsText">Text-variable containing the content that should be added to the Blob</param>
    procedure AppendBlockText(ContentAsText: Text): Codeunit "Blob API Operation Response"
    begin
        exit(AppendBlockText(ContentAsText, 'text/plain; charset=UTF-8'));
    end;

    /// <summary>
    /// The Append Block operation commits a new block of data to the end of an existing append blob.
    /// see: https://docs.microsoft.com/en-us/rest/api/storageservices/append-block
    /// </summary>
    /// <param name="ContentAsText">Text-variable containing the content that should be added to the Blob</param>
    /// <param name="ContentType">Value for Content-Type HttpHeader (e.g. 'text/plain; charset=UTF-8')</param>
    procedure AppendBlockText(ContentAsText: Text; ContentType: Text): Codeunit "Blob API Operation Response"
    begin
        exit(AppendBlock(ContentType, ContentAsText));
    end;

    /// <summary>
    /// The Append Block operation commits a new block of data to the end of an existing append blob.
    /// see: https://docs.microsoft.com/en-us/rest/api/storageservices/append-block
    /// Uses 'application/octet-stream' as Content-Type
    /// </summary>
    /// <param name="ContentAsStream">InStream containing the content that should be added to the Blob</param>
    procedure AppendBlockStream(ContentAsStream: InStream): Codeunit "Blob API Operation Response"
    begin
        exit(AppendBlockStream(ContentAsStream, 'application/octet-stream'));
    end;

    /// <summary>
    /// The Append Block operation commits a new block of data to the end of an existing append blob.
    /// see: https://docs.microsoft.com/en-us/rest/api/storageservices/append-block
    /// </summary>
    /// <param name="ContentAsStream">InStream containing the content that should be added to the Blob</param>
    /// <param name="ContentType">Value for Content-Type HttpHeader (e.g. 'text/plain; charset=UTF-8')</param>
    procedure AppendBlockStream(ContentAsStream: InStream; ContentType: Text): Codeunit "Blob API Operation Response"
    begin
        exit(AppendBlock(ContentType, ContentAsStream));
    end;

    /// <summary>
    /// The Append Block operation commits a new block of data to the end of an existing append blob.
    /// see: https://docs.microsoft.com/en-us/rest/api/storageservices/append-block
    /// </summary>
    /// <param name="ContentType">Value for Content-Type HttpHeader (e.g. 'text/plain; charset=UTF-8')</param>
    /// <param name="SourceContent">Variant containing the content that should be added to the Blob</param>
    procedure AppendBlock(ContentType: Text; SourceContent: Variant): Codeunit "Blob API Operation Response"
    begin
        exit(BlobServicesApiImpl.AppendBlock(ContentType, SourceContent));
    end;

    /// <summary>
    /// The Append Block From URL operation commits a new block of data to the end of an existing append blob.
    /// see: https://docs.microsoft.com/en-us/rest/api/storageservices/append-block-from-url
    /// </summary>
    /// <param name="SourceUri">Specifies the name of the source blob.</param>
    procedure AppendBlockFromURL(SourceUri: Text): Codeunit "Blob API Operation Response"
    begin
        exit(BlobServicesApiImpl.AppendBlockFromURL(SourceUri));
    end;

    /// <summary>
    /// Receives (GET) a Blob as a File from a Container
    /// see: https://docs.microsoft.com/en-us/rest/api/storageservices/get-blob
    /// </summary>
    procedure GetBlobAsFile(): Codeunit "Blob API Operation Response"
    begin
        exit(BlobServicesApiImpl.GetBlobAsFile());
    end;

    /// <summary>
    /// Receives (GET) a Blob as a InStream from a Container
    /// see: https://docs.microsoft.com/en-us/rest/api/storageservices/get-blob
    /// </summary>
    /// <param name="TargetStream">The result InStream containg the content of the Blob.</param>
    procedure GetBlobAsStream(var TargetStream: InStream): Codeunit "Blob API Operation Response"
    begin
        exit(BlobServicesApiImpl.GetBlobAsStream(TargetStream));
    end;

    /// <summary>
    /// Receives (GET) a Blob as Text from a Container
    /// see: https://docs.microsoft.com/en-us/rest/api/storageservices/get-blob
    /// </summary>
    /// <param name="TargetText">The result Text containg the content of the Blob.</param>
    procedure GetBlobAsText(var TargetText: Text): Codeunit "Blob API Operation Response"
    begin
        exit(BlobServicesApiImpl.GetBlobAsText(TargetText));
    end;
    // #endregion Get Blob

    // #region Set Blob Expiry
    /// <summary>
    /// The Set Blob Expiry operation sets an expiry time on an existing blob. This operation is only allowed on Hierarchical Namespace enabled accounts
    /// Sets the expiry time relative to the file creation time, x-ms-expiry-time must be specified as the number of milliseconds to elapse from creation time.
    /// see: https://docs.microsoft.com/en-us/rest/api/storageservices/set-blob-expiry
    /// </summary>    
    /// <param name="ExpiryTime">Number if miliseconds (Integer) until the expiration.</param>
    procedure SetBlobExpiryRelativeToCreation(ExpiryTime: Integer): Codeunit "Blob API Operation Response"
    begin
        exit(BlobServicesApiImpl.SetBlobExpiryRelativeToCreation(ExpiryTime));
    end;

    /// <summary>
    /// The Set Blob Expiry operation sets an expiry time on an existing blob. This operation is only allowed on Hierarchical Namespace enabled accounts
    /// Sets the expiry relative to the current time, x-ms-expiry-time must be specified as the number of milliseconds to elapse from now.
    /// see: https://docs.microsoft.com/en-us/rest/api/storageservices/set-blob-expiry
    /// </summary>    
    /// <param name="ExpiryTime">Number if miliseconds (Integer) until the expiration.</param>
    procedure SetBlobExpiryRelativeToNow(ExpiryTime: Integer): Codeunit "Blob API Operation Response"
    begin
        exit(BlobServicesApiImpl.SetBlobExpiryRelativeToNow(ExpiryTime));
    end;

    /// <summary>
    /// The Set Blob Expiry operation sets an expiry time on an existing blob. This operation is only allowed on Hierarchical Namespace enabled accounts
    /// Sets the expiry to an absolute DateTime
    /// see: https://docs.microsoft.com/en-us/rest/api/storageservices/set-blob-expiry
    /// </summary>    
    /// <param name="ExpiryTime">Absolute DateTime for the expiration.</param>
    procedure SetBlobExpiryAbsolute(ExpiryTime: DateTime): Codeunit "Blob API Operation Response"
    begin
        exit(BlobServicesApiImpl.SetBlobExpiryAbsolute(ExpiryTime));
    end;

    /// <summary>
    /// The Set Blob Expiry operation sets an expiry time on an existing blob. This operation is only allowed on Hierarchical Namespace enabled accounts
    /// Sets the file to never expire or removes the current expiry time, x-ms-expiry-time must not to be specified.
    /// see: https://docs.microsoft.com/en-us/rest/api/storageservices/set-blob-expiry
    /// </summary>    
    procedure SetBlobExpiryNever(): Codeunit "Blob API Operation Response"
    begin
        exit(BlobServicesApiImpl.SetBlobExpiryNever());
    end;

    /// <summary>
    /// The Set Blob Expiry operation sets an expiry time on an existing blob. This operation is only allowed on Hierarchical Namespace enabled accounts
    /// see: https://docs.microsoft.com/en-us/rest/api/storageservices/set-blob-expiry
    /// </summary>    
    /// <param name="ExpiryOption">The type of expiration that should be set.</param>
    /// <param name="ExpiryTime">Variant containing Nothing, number if miliseconds (Integer) or the absolute DateTime for the expiration.</param>
    /// <param name="OperationNotSuccessfulErr">The error message that should be thrown when the request fails.</param>
    procedure SetBlobExpiry(ExpiryOption: Enum "Blob Expiry Option"; ExpiryTime: Variant;
                                                OperationNotSuccessfulErr: Text): Codeunit "Blob API Operation Response"
    begin
        exit(BlobServicesApiImpl.SetBlobExpiry(ExpiryOption, ExpiryTime, OperationNotSuccessfulErr));
    end;
    // #endregion Set Blob Expiry


    // #region Get Blob Tags
    /// <summary>
    /// The Get Blob Tags operation returns all user-defined tags for the specified blob, version, or snapshot.
    /// see: https://docs.microsoft.com/en-us/rest/api/storageservices/get-blob-tags
    /// </summary>    
    /// <param name="BlobTags">A XmlDocument which contains the Tags currently set on the Blob.</param>    
    procedure GetBlobTags(var BlobTags: XmlDocument): Codeunit "Blob API Operation Response"
    begin
        exit(BlobServicesApiImpl.GetBlobTags(BlobTags));
    end;

    // #region Set Blob Tags
    /// <summary>
    /// The Set Blob Tags operation sets user-defined tags for the specified blob as one or more key-value pairs.
    /// see: https://docs.microsoft.com/en-us/rest/api/storageservices/set-blob-tags
    /// </summary>    
    /// <param name="Tags">A Dictionary of [Text, Text] which contains the Tags you want to set.</param>    
    procedure SetBlobTags(Tags: Dictionary of [Text, Text]): Codeunit "Blob API Operation Response"
    begin
        exit(BlobServicesApiImpl.SetBlobTags(Tags));
    end;

    /// <summary>
    /// The Set Blob Tags operation sets user-defined tags for the specified blob as one or more key-value pairs.
    /// see: https://docs.microsoft.com/en-us/rest/api/storageservices/set-blob-tags
    /// </summary>    
    /// <param name="Tags">A Dictionary of [Text, Text] which contains the Tags you want to set.</param>    
    procedure SetBlobTags(Tags: XmlDocument): Codeunit "Blob API Operation Response"
    begin
        exit(BlobServicesApiImpl.SetBlobTags(Tags));
    end;
    // #endregion Set Blob Tags

    // #region Find Blob by Tags
    /// <summary>
    /// The Find Blobs by Tags operation finds all blobs in the storage account whose tags match a given search expression.
    /// see: https://docs.microsoft.com/en-us/rest/api/storageservices/find-blobs-by-tags
    /// </summary>
    /// <param name="SearchTags">A Dictionary of [Text, Text] containing the necessary tags to search for.</param>
    /// <param name="FoundBlobs">XmlDocument containing the enumeration of found blobs</param>
    procedure FindBlobsByTags(SearchTags: Dictionary of [Text, Text]; var FoundBlobs: XmlDocument): Codeunit "Blob API Operation Response"
    begin
        exit(BlobServicesApiImpl.FindBlobsByTags(SearchTags, FoundBlobs));
    end;

    /// <summary>
    /// The Find Blobs by Tags operation finds all blobs in the storage account whose tags match a given search expression.
    /// see: https://docs.microsoft.com/en-us/rest/api/storageservices/find-blobs-by-tags
    /// </summary>
    /// <param name="SearchExpression">A search expression to find blobs by.</param>
    /// <param name="FoundBlobs">XmlDocument containing the enumeration of found blobs</param>
    procedure FindBlobsByTags(SearchExpression: Text; var FoundBlobs: XmlDocument): Codeunit "Blob API Operation Response"
    begin
        exit(BlobServicesApiImpl.FindBlobsByTags(SearchExpression, FoundBlobs));
    end;
    // #endregion Find Blob by Tags

    // #region Delete Blob
    /// <summary>
    /// The Delete Blob operation marks the specified blob or snapshot for deletion. The blob is later deleted during garbage collection.
    /// see: https://docs.microsoft.com/en-us/rest/api/storageservices/delete-blob
    /// </summary>
    procedure DeleteBlob(): Codeunit "Blob API Operation Response"
    begin
        exit(BlobServicesApiImpl.DeleteBlob());
    end;
    // #endregion Delete Blob

    // #region Undelete Blob
    /// <summary>
    /// The Undelete Blob operation restores the contents and metadata of a soft deleted blob and any associated soft deleted snapshots (version 2017-07-29 or later)
    /// see: https://docs.microsoft.com/en-us/rest/api/storageservices/undelete-blob
    /// </summary>
    procedure UndeleteBlob(): Codeunit "Blob API Operation Response"
    begin
        exit(BlobServicesApiImpl.UndeleteBlob());
    end;
    // #endregion Undelete Blob

    // #region Copy Blob
    /// <summary>
    /// The Copy Blob operation copies a blob to a destination within the storage account.
    /// see: https://docs.microsoft.com/en-us/rest/api/storageservices/copy-blob
    /// </summary>
    /// <param name="SourceName">Specifies the name of the source blob or file.</param>
    procedure CopyBlob(SourceName: Text): Codeunit "Blob API Operation Response"
    var
        LeaseId: Guid;
    begin
        exit(CopyBlob(SourceName, LeaseId));
    end;

    /// <summary>
    /// The Copy Blob operation copies a blob to a destination within the storage account.
    /// see: https://docs.microsoft.com/en-us/rest/api/storageservices/copy-blob
    /// </summary>
    /// <param name="SourceName">Specifies the name of the source blob or file.</param>
    /// <param name="LeaseId">Required if the destination blob has an active lease. The lease ID specified must match the lease ID of the destination blob.</param>
    procedure CopyBlob(SourceName: Text; LeaseId: Guid): Codeunit "Blob API Operation Response"
    begin
        exit(BlobServicesApiImpl.CopyBlob(SourceName, LeaseId));
    end;
    // #endregion Copy Blob

    // #region Copy Blob from URL
    /// <summary>
    /// The Copy Blob From URL operation copies a blob to a destination within the storage account synchronously for source blob sizes up to 256 MiB
    /// see: https://docs.microsoft.com/en-us/rest/api/storageservices/copy-blob-from-url
    /// </summary>
    /// <param name="SourceUri">Specifies the URL of the source blob.</param>
    procedure CopyBlobFromURL(SourceUri: Text): Codeunit "Blob API Operation Response"
    begin
        exit(BlobServicesApiImpl.CopyBlobFromURL(SourceUri));
    end;
    // #endregion Copy Blob from URL

    // #region Put Block
    /// <summary>
    /// The Put Block operation creates a new block to be committed as part of a blob.
    /// see: https://docs.microsoft.com/en-us/rest/api/storageservices/put-block
    /// </summary>
    /// <param name="SourceContent">Variant containing the content that should be added to the page</param>
    procedure PutBlock(SourceContent: Variant): Codeunit "Blob API Operation Response"
    begin
        exit(BlobServicesApiImpl.PutBlock(SourceContent));
    end;
    /// <summary>
    /// The Put Block operation creates a new block to be committed as part of a blob.
    /// see: https://docs.microsoft.com/en-us/rest/api/storageservices/put-block
    /// </summary>
    /// <param name="SourceContent">Variant containing the content that should be added to the page</param>
    /// <param name="BlockId">A valid Base64 string value that identifies the block</param>
    procedure PutBlock(SourceContent: Variant; BlockId: Text): Codeunit "Blob API Operation Response"
    begin
        exit(BlobServicesApiImpl.PutBlock(SourceContent, BlockId));
    end;
    // #endregion Put Block

    // #region Get Block List
    /// <summary>
    /// The Get Block List operation retrieves the list of blocks that have been uploaded as part of a block blob.
    /// see: https://docs.microsoft.com/en-us/rest/api/storageservices/get-block-list
    /// </summary>
    /// <param name="BlockListType">Specifies whether to return the list of committed blocks, the list of uncommitted blocks, or both lists together.</param>
    /// <param name="CommitedBlocks">Dictionary of [Text, Integer] containing the list of commited blocks (BLockId and Size)</param>
    /// <param name="UncommitedBlocks">Dictionary of [Text, Integer] containing the list of uncommited blocks (BLockId and Size)</param>
    procedure GetBlockList(BlockListType: Enum "Block List Type"; var CommitedBlocks: Dictionary of [Text, Integer]; var UncommitedBlocks: Dictionary of [Text, Integer]): Codeunit "Blob API Operation Response"
    begin
        exit(BlobServicesApiImpl.GetBlockList(BlockListType, CommitedBlocks, UncommitedBlocks));
    end;

    /// <summary>
    /// The Get Block List operation retrieves the list of blocks that have been uploaded as part of a block blob.
    /// see: https://docs.microsoft.com/en-us/rest/api/storageservices/get-block-list
    /// </summary>
    /// <param name="BlockList">XmlDocument containing the Block List.</param>
    procedure GetBlockList(var BlockList: XmlDocument): Codeunit "Blob API Operation Response"
    var
        BlockListType: Enum "Block List Type";
    begin
        exit(GetBlockList(BlockListType::committed, BlockList)); // default API value is "committed"
    end;

    /// <summary>
    /// The Get Block List operation retrieves the list of blocks that have been uploaded as part of a block blob.
    /// see: https://docs.microsoft.com/en-us/rest/api/storageservices/get-block-list
    /// </summary>
    /// <param name="BlockListType">Specifies whether to return the list of committed blocks, the list of uncommitted blocks, or both lists together.</param>
    /// <param name="BlockList">XmlDocument containing the Block List.</param>
    procedure GetBlockList(BlockListType: Enum "Block List Type"; var BlockList: XmlDocument): Codeunit "Blob API Operation Response"
    begin
        exit(BlobServicesApiImpl.GetBlockList(BlockListType, BlockList));
    end;
    // #endregion Get Block List

    // #region Put Block List
    /// <summary>
    /// The Put Block List operation writes a blob by specifying the list of block IDs that make up the blob.
    /// see: https://docs.microsoft.com/en-us/rest/api/storageservices/put-block-list
    /// </summary>
    /// <param name="CommitedBlocks">Dictionary of [Text, Integer] containing the list of commited blocks that should be put to the Blob</param>
    /// <param name="UncommitedBlocks">Dictionary of [Text, Integer] containing the list of uncommited blocks that should be put to the Blob</param>
    procedure PutBlockList(CommitedBlocks: Dictionary of [Text, Integer]; UncommitedBlocks: Dictionary of [Text, Integer]): Codeunit "Blob API Operation Response"
    begin
        exit(BlobServicesApiImpl.PutBlockList(CommitedBlocks, UncommitedBlocks));
    end;
    /// <summary>
    /// The Put Block List operation writes a blob by specifying the list of block IDs that make up the blob.
    /// see: https://docs.microsoft.com/en-us/rest/api/storageservices/put-block-list
    /// </summary>
    procedure PutBlockList(BlockList: XmlDocument): Codeunit "Blob API Operation Response"
    begin
        exit(BlobServicesApiImpl.PutBlockList(BlockList));
    end;
    // #endregion Put Block List

    // #region Put Block From URL
    /// <summary>
    /// The Put Block From URL operation creates a new block to be committed as part of a blob where the contents are read from a URL.
    /// see: https://docs.microsoft.com/en-us/rest/api/storageservices/put-block-from-url
    /// </summary>
    /// <param name="SourceUri">Specifies the name of the source block blob.</param>
    /// <param name="BlockId">Specifies the BlockId that should be put.</param>
    procedure PutBlockFromURL(SourceUri: Text; BlockId: Text): Codeunit "Blob API Operation Response"
    begin
        exit(BlobServicesApiImpl.PutBlockFromURL(SourceUri, BlockId));
    end;

    var
        BlobServicesApiImpl: Codeunit "Blob Services API Impl.";
}