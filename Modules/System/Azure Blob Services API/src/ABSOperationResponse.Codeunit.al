// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------

/// <summary>
/// Holder object for holding for ABS client operations result.
/// </summary>
codeunit 9050 "ABS Operation Response"
{
    Access = Public;

    /// <summary>
    /// Gets the result of a ABS client operation as text, 
    /// </summary>
    /// <returns>The content of the response.</returns>
    [TryFunction]
    procedure GetResultAsText(var Result: Text);
    begin
        Response.Content.ReadAs(Result);
    end;

    /// <summary>
    /// Gets the result of a ABS client operation as stream, 
    /// </summary>
    /// <returns>The content of the response.</returns>
    [TryFunction]
    procedure GetResultAsStream(var Result: InStream)
    begin
        Response.Content.ReadAs(Result);
    end;

    /// <summary>
    /// Checks whether the operation was successful.
    /// </summary>    
    /// <returns>True if the operation was successful; otherwise - false.</returns>
    procedure IsSuccessful(): Boolean
    begin
        exit(Response.IsSuccessStatusCode);
    end;

    /// <summary>
    /// Gets the SKU name.
    /// </summary>    
    /// <returns>Text containing the value of HttpHeader 'x-ms-sku-name' of the underlying HttpResponseMessage. Returns empty string if HttpHeader does not exist.</returns>
    procedure GetSkuName(): Text
    var
        ReturnValue: Text;
    begin
        ReturnValue := GetHeaderValueFromResponseHeaders('x-ms-sku-name');
        exit(ReturnValue);
    end;

    /// <summary>
    /// Gets account kind.
    /// </summary>    
    /// <returns>Text containing the value of HttpHeader 'x-ms-sku-name' of the underlying HttpResponseMessage. Returns empty string if HttpHeader does not exist</returns>
    procedure GetAccountKind(): Text
    var
        ReturnValue: Text;
    begin
        ReturnValue := GetHeaderValueFromResponseHeaders('x-ms-account-kind');
        exit(ReturnValue);
    end;

    /// <summary>
    /// Gets copy ID.
    /// </summary>    
    /// <returns>Text containing the value of HttpHeader 'x-ms-copy-id' of the underlying HttpResponseMessage. Returns empty string if HttpHeader does not exist</returns>
    procedure GetCopyId(): Text
    var
        ReturnValue: Text;
    begin
        ReturnValue := GetHeaderValueFromResponseHeaders('x-ms-copy-id');
        exit(ReturnValue);
    end;

    /// <summary>
    /// Gets snapshot.
    /// </summary>    
    /// <returns>Text containing the value of HttpHeader 'x-ms-snapshot' of the underlying HttpResponseMessage. Returns empty string if HttpHeader does not exist</returns>
    procedure GetSnapshot(): Text
    var
        ReturnValue: Text;
    begin
        ReturnValue := GetHeaderValueFromResponseHeaders('x-ms-snapshot');
        exit(ReturnValue);
    end;

    /// <summary>
    /// Gets metadata value.
    /// </summary>    
    /// <param name="MetaName">The name of the Metadata-value.</param>
    /// <returns>Text containing the value of HttpHeader 'x-ms-meta-[MetaName]' of the underlying HttpResponseMessage. Returns empty string if HttpHeader does not exist</returns>
    procedure GetMetaValue(MetaName: Text): Text
    var
        ReturnValue: Text;
        MetaKeyValuePairLbl: Label 'x-ms-meta-%1', Comment = '%1 = Key';
    begin
        ReturnValue := GetHeaderValueFromResponseHeaders(StrSubstNo(MetaKeyValuePairLbl, MetaName));
        exit(ReturnValue);
    end;


    internal procedure SetHttpResponse(NewResponse: HttpResponseMessage)
    begin
        Response := NewResponse;
    end;


    internal procedure GetHttpResponseHeaders(): HttpHeaders
    begin
        exit(Response.Headers);
    end;

    internal procedure GetHttpResponse(): HttpResponseMessage
    begin
        exit(Response);
    end;

    internal procedure GetHeaderValueFromResponseHeaders(HeaderName: Text): Text
    var
        Headers: HttpHeaders;
        Values: array[100] of Text;
    begin
        Headers := GetHttpResponseHeaders();
        if not Headers.GetValues(HeaderName, Values) then
            exit('');

        exit(Values[1]);
    end;

    var
        Response: HttpResponseMessage;
}