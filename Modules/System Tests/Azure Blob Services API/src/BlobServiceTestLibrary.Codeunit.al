// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------

codeunit 88154 "Blob Service Test Library"
{
    Access = Internal;

    procedure ClearStorageAccount(TestContext: Codeunit "Blob Service API Test Context")
    var
        Container: Record "Container";
        OperationResponse: Codeunit "Blob API Operation Response";
    begin
        // [SCENARIO] This is a helper; it'll remove all containters from the Storage Account (assumes that some other functions are working)

        TestContext.SetSharedKeyAuth();

        ABSAccountClient.Initialize(TestContext.GetStorageAccountName(), TestContext.GetAuthType());
        OperationResponse := ABSAccountClient.ListContainers(Container);

        if not Container.Find('-') then
            exit;

        repeat
            ABSAccountClient.DeleteContainer(Container.Name);
            Assert.AreEqual(OperationResponse.GetHttpResponseIsSuccessStatusCode(), true, StrSubstNo(OperationFailedErr, 'Cleanup / Delete Container', OperationResponse.GetHttpResponseStatusCode()));
        until Container.Next() = 0;
    end;

    var
        ABSAccountClient: Codeunit "ABS Container Client";
        Assert: Codeunit "Library Assert";
        OperationFailedErr: Label 'Operation "%1" failed. Status Code: %2', Comment = '%1 = Operation, %2 = Status Code';
}