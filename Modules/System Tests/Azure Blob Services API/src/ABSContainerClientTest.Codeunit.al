// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------

codeunit 132919 "ABS Container Client Test"
{
    Subtype = Test;

    [Test]
    procedure CreateContainerSharedKeyTest()
    var
        Response: Codeunit "Blob API Operation Response";
        ContainerName: Text;
    begin
        // [Scenario] CreateContainer contains a container when using Shared Key authorization
        SharedKeyAuthorization := StorageServiceAuthorization.CreateSharedKey(ABSTestLibrary.GetAccessKey());

        ABSContainerClient.Initialize(ABSTestLibrary.GetStorageAccountName(), SharedKeyAuthorization);

        ContainerName := ABSTestLibrary.GetContainerName();
        Response := ABSContainerClient.CreateContainer(ContainerName);

        Assert.IsTrue(Response.GetHttpResponseIsSuccessStatusCode(), 'Operation CreateContainer failed');

        Response := ABSContainerClient.DeleteContainer(ContainerName);
        Assert.IsTrue(Response.GetHttpResponseIsSuccessStatusCode(), 'Operation DeleteContainer failed');
    end;

    //[Test]
    procedure CreateContainerSASTest()
    var
        Response: Codeunit "Blob API Operation Response";
        ContainerName: Text;
    begin
        // TODO initialize the SAS authorization
        // SharedKeyAuthorization := StorageServiceAuthorization.CreateAccountSAS(Helper.GetSasToken());

        ABSContainerClient.Initialize(ABSTestLibrary.GetStorageAccountName(), SharedKeyAuthorization);

        ContainerName := ABSTestLibrary.GetContainerName();
        Response := ABSContainerClient.CreateContainer(ContainerName);

        Assert.IsTrue(Response.GetHttpResponseIsSuccessStatusCode(), 'Operation CreateContainer failed');

        Response := ABSContainerClient.DeleteContainer(ContainerName);
        Assert.IsTrue(Response.GetHttpResponseIsSuccessStatusCode(), 'Operation DeleteContainer failed');
    end;

    [Test]
    procedure CreateContainerFailedTest()
    var
        Response: Codeunit "Blob API Operation Response";
        ContainerName: Text;
    begin
        // [Scenario] Cannot create the same container twice
        SharedKeyAuthorization := StorageServiceAuthorization.CreateSharedKey(ABSTestLibrary.GetAccessKey());

        ABSContainerClient.Initialize(ABSTestLibrary.GetStorageAccountName(), SharedKeyAuthorization);

        ContainerName := ABSTestLibrary.GetContainerName();
        Response := ABSContainerClient.CreateContainer(ContainerName);
        Assert.IsTrue(Response.GetHttpResponseIsSuccessStatusCode(), 'Operation CreateContainer failed');

        asserterror ABSContainerClient.CreateContainer(ContainerName);
        Assert.ExpectedError('Could not create container ' + ContainerName);

        Response := ABSContainerClient.DeleteContainer(ContainerName);
        Assert.IsTrue(Response.GetHttpResponseIsSuccessStatusCode(), 'Operation DeleteContainer failed');
    end;

    [Test]
    procedure ListContainersTest()
    var
        Containers: Record Container;
        Response: Codeunit "Blob API Operation Response";
        ContainerNames: List of [Text];
        ContainerName: Text;
    begin
        SharedKeyAuthorization := StorageServiceAuthorization.CreateSharedKey(ABSTestLibrary.GetAccessKey());

        ABSContainerClient.Initialize(ABSTestLibrary.GetStorageAccountName(), SharedKeyAuthorization);

        ABSTestLibrary.GetListOfContainerNames(ContainerNames);

        foreach ContainerName in ContainerNames do begin
            Response := ABSContainerClient.CreateContainer(ContainerName);
            Assert.IsTrue(Response.GetHttpResponseIsSuccessStatusCode(), 'Operation CreateContainer failed');
        end;

        Response := ABSContainerClient.ListContainers(Containers);
        Assert.IsTrue(Response.GetHttpResponseIsSuccessStatusCode(), 'Operation ListContainers failed');

        Assert.AreEqual(ContainerNames.Count(), Containers.Count(), 'Number of created containers mismatch');

        foreach ContainerName in ContainerNames do
            Assert.IsTrue(Containers.Get(ContainerName), 'Could not find container ' + ContainerName);
    end;

    var
        Assert: Codeunit "Library Assert";
        ABSContainerClient: Codeunit "ABS Container Client";
        StorageServiceAuthorization: Codeunit "Storage Service Authorization";
        ABSTestLibrary: Codeunit "ABS Test Library";
        SharedKeyAuthorization: Interface "Storage Service Authorization";
}