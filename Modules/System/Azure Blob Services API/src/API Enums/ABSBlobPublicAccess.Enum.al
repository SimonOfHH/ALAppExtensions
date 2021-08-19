// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------

/// <summary>
/// Indicator of whether data in the container may be accessed publicly and the level of access.
/// </summary>
enum 9043 "ABS Blob Public Access"
{
    Access = Public;
    Extensible = false;

    /// <summary>
    ///  Indicates full public read access for container and blob data. Clients can enumerate blobs within the container via anonymous request, but cannot enumerate containers within the storage account.
    /// </summary>
    value(0; Container)
    {
        Caption = 'container', Locked = true;
    }

    /// <summary>
    ///Indicates public read access for blobs. Blob data within this container can be read via anonymous request, but container data is not available. Clients cannot enumerate blobs within the container via anonymous request.
    /// </summary>
    value(1; Blob)
    {
        Caption = 'blob', Locked = true;
    }
}