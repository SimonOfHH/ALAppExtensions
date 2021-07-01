// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------

/// <summary>
/// Defines the possible permissions for account SAS
/// More Information: https://docs.microsoft.com/en-us/rest/api/storageservices/create-account-sas#account-sas-permissions-by-operation
/// </summary>
enum 9064 "Storage Service Permission"
{
    Access = Public;
    Extensible = false;

    value(0; Read)
    {
        Caption = 'r', Locked = true;
    }
    value(1; Write)
    {
        Caption = 'w', Locked = true;
    }
    value(2; Delete)
    {
        Caption = 'd', Locked = true;
    }
    value(3; "Permanent Delete")
    {
        Caption = 'y', Locked = true;
    }
    value(4; List)
    {
        Caption = 'l', Locked = true;
    }
    value(5; Add)
    {
        Caption = 'a', Locked = true;
    }
    value(6; Create)
    {
        Caption = 'c', Locked = true;
    }
    value(7; Update)
    {
        Caption = 'u', Locked = true;
    }
    value(8; Process)
    {
        Caption = 'p', Locked = true;
    }
}