// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------

/// <summary>
/// Holder for the optional Azure Blob Storage HTTP headers and URL parameters.
/// </summary>
codeunit 9047 "ABS Optional Parameters"
{
    Access = Public;

    #region Headers
    /// <summary>
    /// Sets the value for 'x-ms-lease-id' HttpHeader for a request.
    /// </summary>
    /// <param name="Value">Guid value specifying the LeaseID</param>
    procedure LeaseId("Value": Guid)
    begin
        SetHeader('x-ms-lease-id', BlobAPIFormatHelper.RemoveCurlyBracketsFromString(Format("Value").ToLower()));
    end;

    /// <summary>
    /// Sets the value for 'x-ms-source-lease-id' HttpHeader for a request.
    /// </summary>
    /// <param name="Value">Text value specifying the source LeaseID</param>
    procedure SourceLeaseId("Value": Text)
    begin
        SetHeader('x-ms-source-lease-id', "Value");
    end;

    /// <summary>
    /// Sets the value for 'x-ms-lease-action' HttpHeader for a request.
    /// </summary>
    /// <param name="Value">Text value specifying the lease action</param>
    procedure LeaseAction("Value": Enum "Lease Action")
    begin
        SetHeader('x-ms-lease-action', Format("Value"));
    end;

    /// <summary>
    /// Sets the value for 'x-ms-lease-break-period' HttpHeader for a request.
    /// </summary>
    /// <param name="Value">Integer value specifying the duration in seconds before a break operation is actually executed</param>
    procedure LeaseBreakPeriod("Value": Integer)
    var
        LeaseActionValue: Enum "Lease Action";
    begin
        LeaseActionValue := LeaseAction();
        if LeaseActionValue <> LeaseActionValue::break then
            Error(InvalidCombinationErr, 'x-ms-lease-break-period', 'x-ms-lease-action', 'break');

        SetHeader('x-ms-lease-break-period', Format("Value"));
    end;

    /// <summary>
    /// Sets the value for 'x-ms-lease-duration' HttpHeader for a request.
    /// </summary>
    /// <param name="Value">Integer value specifying the duration in seconds of a lease. Can be -1 (infinite) or between 15 and 60 seconds.</param>
    procedure LeaseDuration("Value": Integer)
    var
        LeaseActionValue: Enum "Lease Action";
    begin
        LeaseActionValue := LeaseAction();
        if LeaseActionValue <> LeaseActionValue::acquire then
            Error(InvalidCombinationErr, 'x-ms-lease-duration', 'x-ms-lease-action', 'acquire');

        SetHeader('x-ms-lease-duration', Format("Value"));
    end;

    /// <summary>
    /// Sets the value for 'x-ms-proposed-lease-id' HttpHeader for a request.
    /// </summary>
    /// <param name="Value">Text value specifying proposed LeaseId</param>
    procedure ProposedLeaseId("Value": Text)
    var
        LeaseActionValue: Enum "Lease Action";
    begin
        LeaseActionValue := LeaseAction();
        if LeaseActionValue in [LeaseActionValue::acquire, LeaseActionValue::change] then
            Error(InvalidCombinationTwoValuesErr, 'x-ms-lease-break-period', 'x-ms-lease-action', 'acquire', 'change');

        SetHeader('x-ms-proposed-lease-id', "Value");
    end;

    /// <summary>
    /// Sets the value for 'Origin' HttpHeader for a request.
    /// </summary>
    /// <param name="Value">Text value specifying the HttpHeader value</param>
    procedure Origin("Value": Text)
    begin
        SetHeader('Origin', "Value");
    end;

    /// <summary>
    /// Sets the value for 'Access-Control-Request-Method' HttpHeader for a request.
    /// </summary>
    /// <param name="Value">Text value specifying the HttpHeader value</param>
    procedure AccessControlRequestMethod("Value": Enum "Http Request Type")
    begin
        SetHeader('Access-Control-Request-Method', Format("Value"));
    end;

    /// <summary>
    /// Sets the value for 'Access-Control-Request-Headers' HttpHeader for a request.
    /// </summary>
    /// <param name="Value">Text value specifying the HttpHeader value</param>
    procedure AccessControlRequestHeaders("Value": Text)
    begin
        SetHeader('Access-Control-Request-Headers', "Value");
    end;

    /// <summary>
    /// Sets the value for 'x-ms-client-request-id' HttpHeader for a request.
    /// </summary>
    /// <param name="Value">Text value specifying the HttpHeader value</param>
    procedure ClientRequestId("Value": Text)
    begin
        SetHeader('x-ms-client-request-id', "Value");
    end;

    /// <summary>
    /// Sets the value for 'x-ms-blob-public-access' HttpHeader for a request.
    /// </summary>
    /// <param name="Value">Enum "Blob Public Access" value specifying the HttpHeader value</param>
    procedure BlobPublicAccess("Value": Enum "Blob Public Access")
    begin
        SetHeader('x-ms-blob-public-access', Format("Value"));
    end;

    /// <summary>
    /// Sets the value for 'x-ms-meta-[MetaName]' HttpHeader for a request.
    /// </summary>
    /// <param name="MetaName">The name of the Metadata-value.</param>
    /// <param name="Value">Text value specifying the Metadata value</param>
    procedure Metadata(MetaName: Text; "Value": Text)
    var
        MetaKeyValuePairLbl: Label 'x-ms-meta-%1', Comment = '%1 = Key', Locked = true;
    begin
        SetHeader(StrSubstNo(MetaKeyValuePairLbl, MetaName), "Value");
    end;

    /// <summary>
    /// Sets the value for 'x-ms-tags' HttpHeader for a request.
    /// </summary>
    /// <param name="Value">Text value specifying the HttpHeader value</param>
    procedure TagsValue("Value": Text)
    begin
        SetHeader('x-ms-tags', "Value"); // Supported in version 2019-12-12 and newer.
    end;

    /// <summary>
    /// Sets the value for 'x-ms-source-if-modified-since' HttpHeader for a request.
    /// </summary>
    /// <param name="Value">DateTime value specifying the HttpHeader value</param>
    procedure SourceIfModifiedSince("Value": DateTime)
    begin
        SetHeader('x-ms-source-if-modified-since', Format("Value")); // TODO: Check DateTime-format for URI
    end;

    /// <summary>
    /// Sets the value for 'x-ms-source-if-unmodified-since' HttpHeader for a request.
    /// </summary>
    /// <param name="Value">DateTime value specifying the HttpHeader value</param>
    procedure SourceIfUnmodifiedSince("Value": DateTime)
    begin
        SetHeader('x-ms-source-if-unmodified-since', Format("Value")); // TODO: Check DateTime-format for URI
    end;

    /// <summary>
    /// Sets the value for 'x-ms-source-if-match' HttpHeader for a request.
    /// </summary>
    /// <param name="Value">Text value specifying the HttpHeader value</param>
    procedure SourceIfMatch("Value": Text)
    begin
        SetHeader('x-ms-source-if-match', "Value");
    end;

    /// <summary>
    /// Sets the value for 'x-ms-source-if-none-match' HttpHeader for a request.
    /// </summary>
    /// <param name="Value">Text value specifying the HttpHeader value</param>
    procedure SourceIfNoneMatch("Value": Text)
    begin
        SetHeader('x-ms-source-if-none-match', "Value");
    end;

    /// <summary>
    /// Sets the value for 'x-ms-copy-source' HttpHeader for a request.
    /// </summary>
    /// <param name="Value">Text value specifying the HttpHeader value</param>
    procedure CopySourceName("Value": Text)
    begin
        SetHeader('x-ms-copy-source', "Value");
    end;

    /// <summary>
    /// Sets the value for 'x-ms-rehydrate-priority' HttpHeader for a request.
    /// </summary>
    /// <param name="Value">Enum "Rehydrate Priority" value specifying the HttpHeader value</param>
    procedure RehydratePriority("Value": Enum "Rehydrate Priority")
    begin
        SetHeader('x-ms-rehydrate-priority', Format("Value"));
    end;

    /// <summary>
    /// Sets the value for 'x-ms-copy-action' HttpHeader for a request.
    /// </summary>
    /// <param name="Value">Enum "Copy Action" value specifying the HttpHeader value</param>
    procedure CopyAction("Value": Enum "Copy Action")
    begin
        SetHeader('x-ms-copy-action', Format("Value")); // Valid value is 'abort'
    end;

    /// <summary>
    /// Sets the value for 'x-ms-expiry-option' HttpHeader for a request.
    /// </summary>
    /// <param name="Value">Enum "Blob Expiry Option" value specifying the HttpHeader value</param>
    procedure BlobExpiryOption("Value": Enum "Blob Expiry Option")
    begin
        SetHeader('x-ms-expiry-option', Format("Value")); // Valid values are RelativeToCreation/RelativeToNow/Absolute/NeverExpire
    end;

    /// <summary>
    /// Sets the value for 'x-ms-expiry-time' HttpHeader for a request.
    /// </summary>
    /// <param name="Value">Integer value specifying the HttpHeader value</param>
    procedure BlobExpiryTime("Value": Integer)
    begin
        SetHeader('x-ms-expiry-time', Format("Value")); // Either an RFC 1123 datetime or miliseconds-value
    end;

    /// <summary>
    /// Sets the value for 'x-ms-expiry-time' HttpHeader for a request.
    /// </summary>
    /// <param name="Value">DateTime value specifying the HttpHeader value</param>
    procedure BlobExpiryTime("Value": DateTime)
    begin
        SetHeader('x-ms-expiry-time', BlobAPIFormatHelper.GetRfc1123DateTime(("Value"))); // Either an RFC 1123 datetime or miliseconds-value
    end;

    /// <summary>
    /// Sets the value for 'x-ms-access-tier' HttpHeader for a request.
    /// </summary>
    /// <param name="Value">Enum "Blob Access Tier" value specifying the HttpHeader value</param>
    procedure BlobAccessTier("Value": Enum "Blob Access Tier")
    begin
        SetHeader('x-ms-access-tier', Format("Value"));
    end;

    /// <summary>
    /// Sets the value for 'x-ms-page-write' HttpHeader for a request.
    /// </summary>
    /// <param name="Value">Enum "PageBlob Write Option" value specifying the HttpHeader value</param>
    procedure PageWriteOption("Value": Enum "PageBlob Write Option")
    begin
        SetHeader('x-ms-page-write', Format("Value"));
    end;

    /// <summary>
    /// Sets the value for 'x-ms-range' HttpHeader for a request.
    /// </summary>
    /// <param name="BytesStartValue">Integer value specifying the Bytes start range value</param>
    /// <param name="BytesEndValue">Integer value specifying the Bytes end range value</param>
    procedure Range(BytesStartValue: Integer; BytesEndValue: Integer)
    var
        RangeBytesLbl: Label 'bytes=%1-%2', Comment = '%1 = Start Range; %2 = End Range';
    begin
        SetHeader('x-ms-range', StrSubstNo(RangeBytesLbl, BytesStartValue, BytesEndValue));
    end;

    /// <summary>
    /// Sets the value for 'x-ms-source-range' HttpHeader for a request.
    /// </summary>
    /// <param name="BytesStartValue">Integer value specifying the Bytes start range value</param>
    /// <param name="BytesEndValue">Integer value specifying the Bytes end range value</param>
    procedure SourceRange(BytesStartValue: Integer; BytesEndValue: Integer)
    var
        RangeBytesLbl: Label 'bytes=%1-%2', Comment = '%1 = Start Range; %2 = End Range';
    begin
        SetHeader('x-ms-source-range', StrSubstNo(RangeBytesLbl, BytesStartValue, BytesEndValue));
    end;

    /// <summary>
    /// Sets the value for 'x-ms-requires-sync' HttpHeader for a request.
    /// </summary>
    /// <param name="Value">Boolean value specifying the HttpHeader value</param>
    procedure RequiresSync("Value": Boolean)
    var
        ValueText: Text;
    begin
        // Set as text, because otherwise it might give different formatted values based on language locale
        if "Value" then
            ValueText := 'true'
        else
            ValueText := 'false';

        SetHeader('x-ms-requires-sync', ValueText);
    end;

    local procedure LeaseAction(): Enum "Lease Action"
    var
        LeaseActionAsText: Text;
        LeaseActionValue: Enum "Lease Action";
    begin
        if not Headers.Get('x-ms-lease-action', LeaseActionAsText) then
            Error(NeedToSpecifyHeaderErr, 'x-ms-lease-action');

        Evaluate(LeaseActionValue, LeaseActionAsText);

        exit(LeaseActionValue);
    end;

    local procedure SetHeader(Header: Text; HeaderValue: Text)
    begin
        Headers.Remove(Header);
        Headers.Add(Header, HeaderValue);
    end;

    internal procedure GetHeaders(): Dictionary of [Text, Text]
    begin
        exit(Headers);
    end;

    #endregion

    #region Parameters

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

    #endregion

    var
        BlobAPIFormatHelper: Codeunit "Blob API Format Helper";
        Headers: Dictionary of [Text, Text];
        Parameters: Dictionary of [Text, Text];
        NeedToSpecifyHeaderErr: Label 'You need to specify the "%1"-Header to use this function.', Comment = '%1 = Header Name';
        InvalidCombinationErr: Label 'Invalid combination: "%1" can only be set if "%2" is "%3"', Comment = '%1 = Header Name, %2 = Lease Action Header Name, %3 = Lease Action';
        InvalidCombinationTwoValuesErr: Label 'Invalid combination: "%1" can only be set if "%2" is "%3" or "%4"', Comment = '%1 = Header Name, %2 = Lease Action Header Name, %3 = Lease Action, %4 = Lease Action 2';

}