// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------

codeunit 132917 "Stor. Serv. Shared Key Test"
{
    Subtype = Test;

    [Test]
    procedure SharedKeyAuthorizationNoHeadersTest()
    var
        SharedKeyAuthorization: Interface "Storage Service Authorization";
        Headers: HttpHeaders;
        Uri: Text;
        AuthorizationValue: array[10] of Text;
    begin
        // [Given] A storage account and an HTTP request with random URI
        StorageAccount := Any.AlphanumericText(15);
        Uri := GenerateRandomUri(StorageAccount);
        HttpRequest.SetRequestUri(Uri);
        HttpRequest.Method('GET');

        // [When] Authorizing the HTTP request using Shared Key authorization
        SharedKeyAuthorization := StorageServiceAuthorization.CreateSharedKey(Any.AlphabeticText(10));
        SharedKeyAuthorization.Authorize(HttpRequest, StorageAccount);

        // [Then] The Authorization header is present on the HTTP request and nothing else has changed
        Assert.AreEqual(Uri, HttpRequest.GetRequestUri(), 'The HTTP URI should not have changed');
        Assert.AreEqual('GET', HttpRequest.Method(), 'The HTTP request method should not have changed');

        HttpRequest.GetHeaders(Headers);
        Assert.IsTrue(Headers.Contains('Authorization'), 'The HTTP request should contain Authorization header');

        Headers.GetValues('Authorization', AuthorizationValue);
        Assert.IsTrue(StrPos(AuthorizationValue[1], StrSubstNo('SharedKey %1:', StorageAccount)) = 1, 'Authorizarion header is not in the right format');
    end;

    local procedure GenerateRandomUri(StorageAccount: Text): Text
    begin
        exit(StrSubstNo('%1.%2.com/%3=%4&%5', StorageAccount, Any.AlphabeticText(10), Any.AlphanumericText(10), Any.AlphanumericText(10), Any.AlphanumericText(10)));
    end;

    var
        Assert: Codeunit "Library Assert";
        Any: Codeunit Any;
        StorageServiceAuthorization: Codeunit "Storage Service Authorization";
        HttpRequest: HttpRequestMessage;
        StorageAccount: Text;
}