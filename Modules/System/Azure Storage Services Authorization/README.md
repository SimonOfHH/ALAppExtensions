This module exposes functionality to assist with Authentication against the [Azure Storage Services REST API](https://docs.microsoft.com/en-us/rest/api/storageservices/).

### Access Key / Shared Key
An access key is one possible way to authenticate requests against the API. See [Authorize with Shared Key](https://docs.microsoft.com/en-us/rest/api/storageservices/authorize-with-shared-key) for more information.

#### Examle

```
    procedure GetSharedKeyAuthorization(MySharedKey: Text): Interface "Storage Service Authorization"
    var
        StorageServiceAuthorization: Codeunit "Storage Service Authorization";
    begin
        exit(StorageServiceAuthorization.SharedKey(MySharedKey).AsStorageServiceAuthorization());
    end;
```

### SAS (Shared Access Signature)
A SAS (Shared Access Signature) is one possible way to authenticate requests against the API. See [Grant limited access to Azure Storage resources using shared access signatures (SAS)](https://docs.microsoft.com/en-us/azure/storage/common/storage-sas-overview) for more information.

#### Examle
```
    procedure GetSASAuthorization(MySharedKey: Text): Interface "Storage Service Authorization"
    var
        StorageServiceAuthorization: Codeunit "Storage Service Authorization";
    begin
        exit(StorageServiceAuthorization.SharedKey(MySharedKey).AsStorageServiceAuthorization());
    end;
```