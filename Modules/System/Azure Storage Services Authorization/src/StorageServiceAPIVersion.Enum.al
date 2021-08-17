// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------

/// <summary>
/// Defines the available API versions.
/// See: https://docs.microsoft.com/en-us/rest/api/storageservices/previous-azure-storage-service-versions
/// </summary>
enum 9060 "Storage Service API Version"
{
    Access = Public;
    Extensible = false;

    value(24; "2020-10-02")
    {
        Caption = '2020-10-02', Locked = true;
    }
}