// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------

/// <summary>
/// Holder for the optional Azure Blob Storage URL parameters.
/// </summary>
codeunit 9039 "ABS Optional Parameters"
{
    Access = Public;

    /// <summary>
    /// Sets the optional timeout value for the request.
    /// </summary>
    /// <param name="Value">Timeout in seconds. Most operations have a max. limit of 30 seconds. For more Information see: https://docs.microsoft.com/en-us/rest/api/storageservices/setting-timeouts-for-blob-service-operations</param>
    procedure Timeout("Value": Integer)
    begin
        SetParameter('timeout', Format("Value"));
    end;

    /// <summary>
    /// The versionid parameter is an opaque DateTime value that, when present, specifies the Version of the blob to retrieve.
    /// </summary>
    /// <param name="Value">The DateTime identifying the version</param>
    procedure VersionId("Value": DateTime)
    begin
        SetParameter('versionid', Format("Value")); // TODO: Check DateTime-format for URI
    end;

    /// <summary>
    /// The snapshot parameter is an opaque DateTime value that, when present, specifies the blob snapshot to retrieve. 
    /// </summary>
    /// <param name="Value">The DateTime identifying the Snapshot</param>
    procedure Snapshot("Value": DateTime)
    begin
        SetParameter('snapshot', Format("Value")); // TODO: Check DateTime-format for URI
    end;

    /// <summary>
    /// The snapshot parameter is an opaque DateTime value that, when present, specifies the blob snapshot to retrieve. 
    /// </summary>
    /// <param name="Value">The DateTime identifying the Snapshot</param>
    procedure Snapshot("Value": Text)
    begin
        SetParameter('snapshot', "Value");
    end;

    /// <summary>
    /// Filters the results to return only blobs whose names begin with the specified prefix.
    /// </summary>
    /// <param name="Value">Prefix to search for</param>
    procedure Prefix("Value": Text)
    begin
        SetParameter('prefix', "Value");
    end;

    /// <summary>
    /// When the request includes this parameter, the operation returns a BlobPrefix element in the response body 
    /// that acts as a placeholder for all blobs whose names begin with the same substring up to the appearance of the delimiter character. 
    /// The delimiter may be a single character or a string.
    /// </summary>
    /// <param name="Value">Delimiting character/string</param>
    procedure Delimiter("Value": Text)
    begin
        SetParameter('delimiter', "Value");
    end;

    /// <summary>
    /// Specifies the maximum number of blobs to return
    /// </summary>
    /// <param name="Value">Max. number of results to return. Must be positive, must not be greater than 5000</param>
    procedure MaxResults("Value": Integer)
    begin
        SetParameter('maxresults', Format("Value"));
    end;

    /// <summary>
    /// Identifiers the ID of a Block in BlockBlob
    /// </summary>
    /// <param name="Value">A valid Base64 string value that identifies the block. Prior to encoding, the string must be less than or equal to 64 bytes in size</param>
    procedure BlockId("Value": Text)
    begin
        SetParameter('blockid', "Value");
    end;

    /// <summary>
    /// Specifies whether to return the list of committed blocks, the list of uncommitted blocks, or both lists together.
    /// </summary>
    /// <param name="Value">Valid values are committed, uncommitted, or all</param>
    procedure BlockListType("Value": Enum "Block List Type")
    begin
        SetParameter('blocklisttype', Format("Value"));
    end;

    local procedure SetParameter(Header: Text; HeaderValue: Text)
    begin
        Parameters.Remove(Header);
        Parameters.Add(Header, HeaderValue);
    end;

    internal procedure GetParameters(): Dictionary of [Text, Text]
    begin
        exit(Parameters);
    end;

    var
        Parameters: Dictionary of [Text, Text];
}